global without sharing class ExpID_BusinessProcess {

	// BEGIN: Payload structure expected in the response body
    
    @TestVisible
    public class IdentityServiceResponse {
        public Boolean preciseIdDecision;
        public String preciseIdReferenceNumber;
        public Boolean qualifileDecision;
        public String qualifileReferenceNumber;
        public BusinessMessage businessDecision;
    }
    
    @TestVisible
    public class BusinessMessage {
        public String developerMessage;
        public String message;
        public String severity;
    }
    
    // END: Payload structure expected in the response body
     
	public class ExpId_Exception extends Exception {}

    @TestVisible
	private nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
	
    @TestVisible
    private nFUSE.SendService sender;
        
    @testVisible
    private String mockResponseBodyStr {get; set;}
    @testVisible
    private String mockResponseStatus {get; set;}
    @testVisible
    private Integer mockResponseStatusCode {get; set;}
    @testVisible
    private String mockTransactionId {get; set;} 
    
	private nFUSE.PackageServiceRequest initServiceRequest(){
		return new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);
	}

	private nFUSE.SendService getPluginSendService(nFUSE.PackageServiceRequest request){
		if(this.sender == null){
			this.sender = (nFUSE.SendService) this.locator.tryLocate(request, ExpID_BusinessProcess.ExpId_SendService.class);
		}
		return sender;
	}
    
    // Expecting an LLC_BI__Application__c.Id as the applicationId.
    public string sendRequest(Id applicationId, String ip, Id userId) {
 		string respMsg = SUCCESS;
        
        // Get the context Id from the application and current user....
        String strObjAPIName = ((Id)applicationId).getSObjectType().getDescribe().getName();
        if(strObjAPIName != 'LLC_BI__Application__c'){
            throw new ExpId_Exception('Invalid Application ID passed to integration.');
        }
        
        // Find the context record to update when the integration completes.
		List<nPortal__Context__c> ctxList = new List<nPortal__Context__c>([
            SELECT 
              Id
            , nPortal__User__c
            , nPortal__User__r.AccountID
            , nPortal__User__r.Account.Existing_DDA_Indicator__c
            , nPortal__User__r.ContactID
            , nPortal__User__r.FederationIdentifier 
            , SourceIP__c 
            , Error_Message__c
            , nPortal__Application__r.nPortal__Artifact_Id__c
            FROM nPortal__Context__c
            WHERE nPortal__User__c = :userId
              AND nPortal__Application__c = :applicationId
            ORDER BY nPortal__Context_Start__c DESC NULLS LAST 
            LIMIT 1
        ]);
		
        if(ctxList.size() > 0){
            nPortal__Context__c ctxItem = ctxList[0];
            Boolean existingCustomer = (ctxItem.nPortal__User__r.Account.Existing_DDA_Indicator__c == 'Yes'); 
            if(!existingCustomer) {
                
                nFUSE.PackageServiceRequest request = this.initServiceRequest();
                ExpId_MiddlewareMessage message = new ExpId_MiddlewareMessage();
                request.primaryObjectId = ctxItem.Id;
                
                if (applicationId != null) {
                    Id depositId = ctxItem.nPortal__Application__r.nPortal__Artifact_Id__c;
                    String bankNumber = '';
                    
                    if((depositId).getSObjectType().getDescribe().getName() == 'LLC_BI__Deposit__c'){
                        List<LLC_BI__Deposit__c> depositList = new List<LLC_BI__Deposit__c>([SELECT ID, Bank_Number__c FROM LLC_BI__Deposit__c WHERE id = :depositId LIMIT 1]);
                        if(depositList.Size()>0) bankNumber = depositList[0].Bank_Number__c;
                    } else {
                        depositId = null;
                    }
                    
                    /*
                    // Get the payload data.
                    nFORCE.ACrossPackageService depositService = (nFORCE.ACrossPackageService) nFORCE.BeanFactory.getInstance().getBeanByUniqueName(NFUSE_DEPOSIT_XPKG_SERVICE);
                    if(depositService == null)
                    throw new ExpId_Exception(String.format(System.Label.XPackageServiceNotFoundMessage, new String[]{'DepositService',NFUSE_DEPOSIT_XPKG_SERVICE}));
                    if(request == null)
                    throw new ExpId_Exception(System.Label.RequestNotExpectedToBeNullMessage);
                    depositService.setInputParameter('request', new nFUSE.IntegrationClassTypeProvider().serialize(request));
                    if(ctxItem.nPortal__User__r.AccountID == null)
                    throw new ExpId_Exception(System.Label.RelationshipNotExpectedToBeNullMessage);
                    depositService.setInputParameter('dsposit_ids', JSON.serialize(new Set<Id>{ depositId }));
                    depositService.executeService();
                    List<nFORCE.IForce> fDeposits = (List<nFORCE.IForce>) depositService.getOutputParameter('deposits');
                    */
                    
                    // Get the payload data.
                    nFORCE.ACrossPackageService relationshipService = (nFORCE.ACrossPackageService) nFORCE.BeanFactory.getInstance().getBeanByUniqueName(NFUSE_RELATIONSHIP_XPKG_SERVICE);
                    if(relationshipService == null)
                        throw new ExpId_Exception(String.format(System.Label.XPackageServiceNotFoundMessage, new String[]{'RelationshipService',NFUSE_RELATIONSHIP_XPKG_SERVICE}));
                    if(request == null)
                        throw new ExpId_Exception(System.Label.RequestNotExpectedToBeNullMessage);
                    relationshipService.setInputParameter('request', new nFUSE.IntegrationClassTypeProvider().serialize(request));
                    if(ctxItem.nPortal__User__r.AccountID == null)
                        throw new ExpId_Exception(System.Label.RelationshipNotExpectedToBeNullMessage);
                    relationshipService.setInputParameter('relationship_ids', JSON.serialize(new Set<Id>{ ctxItem.nPortal__User__r.AccountID }));
                    relationshipService.executeService();
                    List<nFORCE.IForce> fRelationships = (List<nFORCE.IForce>) relationshipService.getOutputParameter('relationships');
                    
                    // Create the SendService and set all of the properties for the outbound payload.
                    nFUSE.SendService service = this.getPluginSendService(request);
                    
                    message.method = PLUGIN_METHOD;
                    message.messageHeader.action = PLUGIN_ACTION;
                    message.properties.put(PROP_RELATIONSHIP_KEY, fRelationships[0]);
                    //message.properties.put(PROP_DEPOSIT_KEY, fDeposits[0]);
                    message.properties.put('primary_object_id', request.primaryObjectId);
                    message.properties.put('federationId', ctxItem.nPortal__User__r.FederationIdentifier);
                    message.properties.put('applicationId', applicationId);
                    message.properties.put('bank_Number', bankNumber);
                    
                    // Execute the callout.
                    String responseBody;
                    Integer statusCode;
                    String status;

                    if(Test.isRunningTest()){
                        responseBody = mockResponseBodyStr;
                        statusCode = mockResponseStatusCode;
                        status = mockResponseStatus;
                        message.messageHeader.transactionId = mockTransactionId;
                    } else {
                        service.send(request, message);
                        responseBody = message.httpResponse.getBody();
                    	statusCode = message.httpResponse.getStatusCode();
                    	status = message.httpResponse.getStatus();
                    }
                    
                    // If the status code returned is a 2xx message then deserialize the return message.
                    if(String.valueof(statusCode).startsWith('2')){
                        updateTransactionLog(message, ExpId_BusinessProcess.IN_PROGRESS_STATUS, responseBody);
                        
                        // Deserialize the return payload using the IdentityServiceResponse class.
                        ExpID_BusinessProcess.IdentityServiceResponse expIdResp = (IdentityServiceResponse) JSON.deserialize(responseBody,ExpID_BusinessProcess.IdentityServiceResponse.Class);
                        
                        // Save the data from the return payload.
                        ctxItem.SourceIP__c = ip; // from method parameter.
                        ctxItem.QualifileDecision__c = expIdResp.qualifileDecision;
                        ctxItem.QualifileReferenceNumber__c = expIdResp.qualifileReferenceNumber;
                        ctxItem.PreciseIdDecision__c = expIdResp.preciseIdDecision;
                        ctxItem.PreciseIdReferenceNumber__c = expIdResp.preciseIdReferenceNumber;
                        // If either Decision comes back false, this is a failure...
                        if(expIdResp.qualifileDecision == false || expIdResp.preciseIdDecision == false){
                            ctxItem.nPortal__Identity_Verification_Status__c = ID_VERIFICATION_FAIL_MESSAGE;
                            ctxItem.nPortal__Identity_Verification_Date__c = System.Datetime.now();
                            respMsg = ID_VERIFICATION_FAIL_MESSAGE;
                        }
                        nFORCE.DmlUtility.updateObj(ctxItem);
                        
                        // If either Decision comes back false, this is a failure...
                        if(expIdResp.qualifileDecision == false || expIdResp.preciseIdDecision == false)
                            setFailureState(applicationId);
                        
                    } else { 
                        String errMsg = 'Error: ' + String.valueof(statusCode) + ' ' + status + '\n' + responseBody;
                        updateTransactionLog(message, ExpId_BusinessProcess.ERROR_STATUS, errMsg);
                        List<ExpID_BusinessProcess.BusinessMessage> bmList = (List<ExpID_BusinessProcess.BusinessMessage>) JSON.deserialize(responseBody,List<ExpID_BusinessProcess.BusinessMessage>.Class);
                        
                        String busMessage = '';
                        for(BusinessMessage bmItem : bmList){
                            busMessage += ((bmItem.severity == null ? '' : (bmItem.severity + ': ')) + 
                                           (bmItem.message == null ? '' : (bmItem.message  + ' ')) + 
                                           (bmItem.developerMessage == null ? '' : bmItem.developerMessage));
                        }
                        
                        ctxItem.SourceIP__c = ip; // from method parameter.
                        ctxItem.Error_Message__c += (DateTime.Now().formatGmt('yyyy-MM-dd HH:mm:ss.SSS')+'\n' + busMessage);
                        ctxItem.nPortal__Identity_Verification_Status__c = ID_VERIFICATION_FAIL_MESSAGE;
                        ctxItem.nPortal__Identity_Verification_Date__c = System.Datetime.now();
                        nFORCE.DmlUtility.updateObj(ctxItem);
                        
                        throw new ExpId_Exception('Error: ' + String.valueof(statusCode) + ' ' + status + '\n' + busMessage);
                    }
                }
            }
        }
        return respMsg;
	}
    
    @testVisible
    private static void setFailureState(Id applicationId) {
/*        
        LLC_BI__Application__c app = [
			SELECT
				Id,
				nPortal__Status__c,
				nPortal__Artifact_Id__c 
			FROM
				LLC_BI__Application__c 
			WHERE
				Id = :applicationId
		][0];
*/
        LLC_BI__Application__c app = new LLC_BI__Application__c();
        app.id = applicationId;
		app.nPortal__Status__c = ID_VERIFICATION_APP_FAIL_STATUS;
		nFORCE.DmlUtility.updateObj(app);
/*
		SObjectType artifactType = Id.valueOf(app.nPortal__Artifact_Id__c).getSObjectType();
		SObject artifact = artifactType.newSObject(app.nPortal__Artifact_Id__c);
		if (artifactType == LLC_BI__Deposit__c.getSObjectType()) {
			artifact.put(DEPOSIT_STATUS_FIELD, ID_VERIFICATION_DEPOSIT_FAIL_STATUS);
			artifact.put(DEPOSIT_STAGE_FIELD, ID_VERIFICATION_DEPOSIT_FAIL_STAGE);
		}
		nFORCE.DmlUtility.updateObj(artifact);
*/
	}

	@testVisible
	private nFUSE__Transaction_Log__c updateTransactionLog(ExpId_MiddlewareMessage message, String status, String details){
		nFUSE__Transaction_Log__c transactionLog = [
			SELECT
				Id,
				CreatedDate
			FROM
				nFUSE__Transaction_Log__c
			WHERE
				nFUSE__External_Id__c = :message.messageHeader.transactionId
		][0];
		transactionLog.nFUSE__Vendor_Status__c = message.messageHeader.action;
		transactionLog.nFUSE__Action__c = message.messageHeader.action;
		transactionLog.nFUSE__Transaction_Status__c = status;
        transactionLog.nFUSE__Transaction_Detail__c = details;
		update transactionLog;
		return transactionLog;
	}
    
    // The following class is used to activate and deactivate this plugin.
    global with sharing class Activator implements nFUSE.IPluginActivator {
        
        private nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
 
        public void onActivate() {
 
            // Build a custom configuration setting that will be displayed in the UI under "nCino Administration -> Quick Links -> Plugin Configuration -> ExpID_BusinessProcess"
            nFUSE.PluginConfigurationManager.PluginConfiguration configUrl = new nFUSE.PluginConfigurationManager.PluginConfiguration();
            configUrl.pluginName = PLUGIN_NAME;
            configUrl.pluginVersion = PLUGIN_VERSION;
            configUrl.category = PLUGIN_NAME;
            configUrl.key = URLENDPOINT_KEY;
            configUrl.valueDataType = 'String';
            configUrl.isEncrypted = false;
            configUrl.description = 'Experian ID / Qualifile ID URL Endpoint';
            
            List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs = new List<nFUSE.PluginConfigurationManager.PluginConfiguration>{configUrl};
                new nFUSE.PluginConfigurationManager(PLUGIN_NAME, PLUGIN_VERSION).softInsertConfigurations(configs);
            
            nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);
            locator.register(request, nFUSE.SendService.class, ExpID_BusinessProcess.ExpIdSendService.class);
        }
        
        public void onDeactivate() {
            nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);
            locator.deregister(request, nFUSE.SendService.class);
        }
    }
  
    global class ExpId_MiddlewareMessage extends nFUSE.MiddlewareMessage {}

    // We are extending the send service with some custom attributes and overrides.
	global class ExpId_SendService extends nFUSE.SendService {
        
        @testVisible
        String endPoint {get; set;}
        
        @testVisible
        HttpRequest sendRequest {get; set;}
        
        @testVisible
        public protected override Object preSendRequest(Object request, nFUSE.AMiddlewareMessage message) {
            if(request instanceof HttpRequest){
                sendRequest = (HttpRequest) request;
                String confEndPoint = sendRequest.getEndpoint();
                
                List<nFUSE__App_Plugin__mdt> appPluginList = new List<nFUSE__App_Plugin__mdt>(
                    [SELECT 
                        nFUSE__Timeout__c
                      , nFUSE__Middleware_Endpoint__c 
                     FROM nFUSE__App_Plugin__mdt 
                     WHERE DeveloperName = :PLUGIN_NAME
                    ]);
                if(appPluginList.size() > 0){
                    if( appPluginList[0].nFUSE__Middleware_Endpoint__c != null){
                        confEndPoint = appPluginList[0].nFUSE__Middleware_Endpoint__c;
                    }
                    if(appPluginList[0].nFUSE__Timeout__c != null){
                        sendRequest.setTimeout((Integer)appPluginList[0].nFUSE__Timeout__c);
                    }
                } 
                
                List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs = new nFUSE.PluginConfigurationManager(PLUGIN_NAME, PLUGIN_VERSION).getConfigurations();
                for(nFUSE.PluginConfigurationManager.PluginConfiguration config : configs){
					if(config.key == URLENDPOINT_KEY)
                    	confEndPoint = config.value;
                }
                
                if(this.endPoint != null){
                    confEndPoint = this.endpoint;
                }
                sendRequest.setTimeout(CALLOUT_TIMEOUT);
                sendRequest.setEndpoint(confEndPoint);
    			sendRequest.setMethod(PLUGIN_METHOD);
                //sendRequest.setHeader('CONTENT-TYPE', PLUGIN_CONTENT_TYPE);
                
				FNNI_B2BOAuth oAuth = new FNNI_B2BOAuth();
                if(oAuth.isActive()){
                    
                    String method = PLUGIN_METHOD;
                    Url endpointUrl = new url(sendRequest.getEndpoint());
                    String resource = endpointUrl.getPath();
                    
                    DateTime ufDt = System.now();
                    String contentType = PLUGIN_CONTENT_TYPE;
                    String payload = sendRequest.getBody();
                    String requestId = oAuth.getRequestId();
                    String authorization = oAuth.getAuthorization();
                    String signature = oAuth.getSignature(method, resource, ufDt, contentType, requestId, payload);
                    String rFC1123Date = oAuth.getRFC1123Date(ufDt);
                    
                    sendRequest.setHeader('Authorization', authorization);
                    sendRequest.setHeader('X-Request-ID', requestId);
                    sendRequest.setHeader('X-Authorization-SHA256', signature);
                    sendRequest.setHeader('Date', rFC1123Date);
                }
                
                return sendRequest;
                
            } else {
                return request;
            }
        }
    }
    
    public static final Integer
        CALLOUT_TIMEOUT = 120000;
 
    public static final String
        PLUGIN_NAME = 'ExpID_BusinessProcess',
        PLUGIN_VERSION = '1.0',
        PLUGIN_HELP_TEXT = 'Experian ID (Custom) Identify Verification Plugin',
        PLUGIN_METHOD = 'POST',
        PLUGIN_ACTION = 'Verification',
        PLUGIN_CONTENT_TYPE = 'application/json',
        PROP_RELATIONSHIP_KEY = 'relationship',
        PROP_DEPOSIT_KEY = '',
        NFUSE_RELATIONSHIP_XPKG_SERVICE = 'nFUSE.RelationshipGetXPkg',
        NFUSE_DEPOSIT_XPKG_SERVICE = 'nFUSE.DepositGetXPkg',
        URLENDPOINT_KEY = 'URL Endpoint',
        IN_PROGRESS_STATUS = 'In Progress',
        ERROR_STATUS = 'Error',
        SUCCESS = 'Success',
        ID_VERIFICATION_FAIL_MESSAGE = 'ID Verification Failure',
        ID_VERIFICATION_APP_FAIL_STATUS = 'Complete',
        ID_VERIFICATION_DEPOSIT_FAIL_STATUS = 'Declined',
        ID_VERIFICATION_DEPOSIT_FAIL_STAGE = 'Qualification',
        DEPOSIT_STATUS_FIELD = 'LLC_BI__Status__c',
        DEPOSIT_STAGE_FIELD = 'LLC_BI__Stage__c',
        EXISTING_CUSTOMER_FI_SUFFIX = System.Label.ExistingCustomerFISuffix;    
}