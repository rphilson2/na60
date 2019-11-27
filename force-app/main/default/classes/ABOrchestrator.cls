public without sharing class ABOrchestrator implements IABOrchestrator{
    
    public class ABOrchestratorServiceFinderException extends Exception {}
    public class ABServiceException extends Exception {}
    
    @testVisible
    protected List<String> branchFieldsToGet = new List<String>();
    
    @testVisible
    private static Boolean forceFailedToLoadFieldSet = false;
    @testVisible
    private static Boolean forceSerializationException = false;
    @testVisible
    private static Boolean forceBranchException = false;
    @testVisible
    private static Boolean forceTestingException = false;
    @testVisible
    private static Boolean forceBookingTestException = false;
    
    public ABOrchestrator(){
        LoadFields();
    }
    
    @TestVisible
    private void LoadFields(){
        try{
            
            if(forceFailedToLoadFieldSet)
                throw new ABServiceException('forceFailedToLoadFieldSet');
            
            branchFieldsToGet = new List<String>();
            
            LoadFields(branchFieldsToGet, ABUtility.getNameSpacePrefix('__') + ABConfiguration.PLUGIN_NAME, 'LLC_BI__Branch__c');
            
        }catch(Exception e){
            
            throw new ABServiceException(
                String.format(System.Label.FailedToLoadFieldSet,new List<String>{
                    'LLC_BI__Branch__c',
                    e.getMessage(),
                    String.valueOf(e.getLineNumber())
                })
            );
        }
    }

    @TestVisible
    private void LoadFields(List<String> fieldsByRef, String fieldSetFullName, String sObjectName){
        List<Schema.FieldSetMember> fieldSetMemberList =  readFieldSet(fieldSetFullName,sObjectName);
        for(Schema.FieldSetMember fieldSetMemberObj : fieldSetMemberList)
        {
            fieldsByRef.add(fieldSetMemberObj.getFieldPath());
        }
    }
    
    @TestVisible
    private List<Schema.FieldSetMember> readFieldSet(String fieldSetName, String ObjectName){
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe();
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        return fieldSetObj.getFields();
    }
    
    public ABEntities.TransactionLogResponse GetTransactionLogDetails(String externalId){
        ABEntities.TransactionLogResponse response = new ABEntities.TransactionLogResponse();
        nFUSE__Transaction_Log__c transactionLog = [
            SELECT
                Id,
                nFUSE__Primary_Object_Id__c,
                nFUSE__Vendor_Status__c,
                nFUSE__Transaction_Status__c,
                nFUSE__Transaction_Detail__c,
                nFUSE__External_Id__c
            FROM
                nFUSE__Transaction_Log__c
            WHERE
                nFUSE__External_Id__c = :externalId
        ][0];
        response.VendorStatus = transactionLog.nFUSE__Vendor_Status__c;
        response.Status = transactionLog.nFUSE__Transaction_Status__c;
        response.Details = transactionLog.nFUSE__Transaction_Detail__c;
        response.ExternalId = transactionLog.nFUSE__External_Id__c;
        response.IsComplete = false;
        response.IsSuccessful = true;
        response.ObjectId = transactionLog.nFUSE__Primary_Object_Id__c;
        if(ABConfiguration.TRANSACTION_STATUS_ERROR_STRINGS.contains(response.Status.toUpperCase())){
            response.IsSuccessful = false;
        }
        
        if(ABConfiguration.TRANSACTION_STATUS_COMPLETION_STRINGS.contains(response.Status.toUpperCase())){
            response.IsComplete = true;
        }
        
        return response;
    }
    
    public nFUSE.SendService serviceFinder(nFUSE.PackageServiceRequest request, String sendServiceName){
        
        nFUSE.SendService service = null;
        try{
            
            if(forceTestingException)
                throw new ABOrchestratorServiceFinderException('forceTestingException');
                
            nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
            service = (nFUSE.SendService)locator.locate(
                    request,
                    nFUSE.SendService.class,
                    sendServiceName
            );
        }
        catch(Exception e){
            if(e.getMessage().toLowerCase().contains('unable to locate service for')){
                
                throw new ABOrchestratorServiceFinderException(String.format(System.Label.ServiceLocatorException, 
                    new String[]{
                        sendServiceName,
                        e.getMessage(),
                        String.valueof(e.getLineNumber())
                    }));
                
            }
            else{
                throw new ABOrchestratorServiceFinderException(String.format(System.Label.ServiceLocatorGeneralException, 
                    new String[]{
                        sendServiceName,
                        e.getMessage(),
                        String.valueof(e.getLineNumber())
                    }));
            }
        }
        return service;
    }
    
    public ABEntities.AutomatedBookingResponse ReserveLoan(String loanId, String overrideUserId, String overrideUserSessionId, String overrideTransactionLogExternalId, Map<String,String> additionalProperties){
        ABEntities.AutomatedBookingResponse resp = new ABEntities.AutomatedBookingResponse();
        resp.IsSuccessful = true;
        
        if(!ShouldBookLoan(loanId)){
            resp.IsSuccessful = false;
            resp.Messages = String.format(System.Label.BookedPreviously, 
                    new String[]{
                        System.Label.LoanReserveBooking
                    });
            return resp;
        }
        
        System.debug('will call reserve loan!');
        
        nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, !String.IsBlank(overrideTransactionLogExternalId) ? overrideTransactionLogExternalId : null);
        
        nFUSE.SendService service = serviceFinder(request, ABConfiguration.LOANRESERVESENDSERVICENAME);
        //since an error was not thrown we have located the service successfully
        
        request.primaryObjectId = loanId;
        
        nFUSE.MiddlewareMessage message = null;
        
        try{
            
            System.debug('preparing the message');
            message = prepareLoanReservationMessage(ABConfiguration.LOANRESERVATIONACTION, request, loanId, overrideUserId, overrideUserSessionId);
            
        }catch(Exception e){
            System.debug('issue preparing the message');
            resp.IsSuccessful = false;
            resp.Messages = String.format(System.Label.OrchestrationGeneralException, 
                    new String[]{
                        System.Label.LoanReserveBooking,
                        e.getMessage(),
                        String.valueof(e.getLineNumber())
                    });
            return resp;
            
        }
        
        System.debug('calling book with the updated message with reservation context');
        return this.Book(System.Label.OrchestrationGeneralException, System.Label.LoanReserveBooking, resp, message, request, service, additionalProperties);
    }
    public ABEntities.AutomatedBookingResponse BookLoan(String loanId, String overrideUserId, String overrideUserSessionId, String overrideTransactionLogExternalId, Map<String,String> additionalProperties){
        ABEntities.AutomatedBookingResponse resp = new ABEntities.AutomatedBookingResponse();
        resp.IsSuccessful = true;
        
        if(!ShouldBookLoan(loanId)){
            resp.IsSuccessful = false;
            resp.Messages = String.format(System.Label.BookedPreviously, 
                    new String[]{
                        System.Label.LoanBooking
                    });
            return resp;
        }
        
        System.debug('will call book loan');
        
        nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, !String.IsBlank(overrideTransactionLogExternalId) ? overrideTransactionLogExternalId : null);
        
        nFUSE.SendService service = serviceFinder(request, ABConfiguration.LOANSENDSERVICENAME);
        //since an error was not thrown we have located the service successfully
        
        request.primaryObjectId = loanId;
        
        nFUSE.MiddlewareMessage message = null;
        
        try{
            
            message = prepareLoanBookingMessage(ABConfiguration.LOANBOOKACTION, request, loanId, overrideUserId, overrideUserSessionId);
            
        }catch(Exception e){
            
            resp.IsSuccessful = false;
            resp.Messages = String.format(System.Label.OrchestrationGeneralException, 
                    new String[]{
                        System.Label.LoanBooking,
                        e.getMessage(),
                        String.valueof(e.getLineNumber())
                    });
            return resp;
            
        }
        
        return this.Book(System.Label.OrchestrationGeneralException, System.Label.LoanBooking, resp, message, request, service, additionalProperties);
    }
    public ABEntities.AutomatedBookingResponse RenewLoan(String loanId, String overrideUserId, String overrideUserSessionId, String overrideTransactionLogExternalId, Map<String,String> additionalProperties){
        
        ABEntities.AutomatedBookingResponse resp = new ABEntities.AutomatedBookingResponse();
        resp.IsSuccessful = true;
        
        if(!ShouldModifyOrRenewLoan(loanId,'REN_NAME_FORMAT')){
            resp.IsSuccessful = false;
            resp.Messages = String.format(System.Label.NotValidForRenewal, 
                    new String[]{
                        System.Label.LoanRenewal
                    });
            return resp;
        }
        
        System.debug('will call renew loan');
        
        nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, !String.IsBlank(overrideTransactionLogExternalId) ? overrideTransactionLogExternalId : null);
        
        nFUSE.SendService service = serviceFinder(request, ABConfiguration.LOANRENEWALSENDSERVICENAME);
        //since an error was not thrown we have located the service successfully
        
        request.primaryObjectId = loanId;
        
        nFUSE.MiddlewareMessage message = null;
        
        try{
            
            message = prepareLoanBookingMessage(ABConfiguration.LOANRENEWALACTION, request, loanId, overrideUserId, overrideUserSessionId);
            
        }catch(Exception e){
            
            resp.IsSuccessful = false;
            resp.Messages = String.format(System.Label.OrchestrationGeneralException, 
                    new String[]{
                        System.Label.LoanRenewal,
                        e.getMessage(),
                        String.valueof(e.getLineNumber())
                    });
            return resp;
            
        }
        
        return this.Book(System.Label.OrchestrationGeneralException, System.Label.LoanRenewal, resp, message, request, service, additionalProperties);
    }
    public ABEntities.AutomatedBookingResponse ModifyLoan(String loanId, String overrideUserId, String overrideUserSessionId, String overrideTransactionLogExternalId, Map<String,String> additionalProperties){
        ABEntities.AutomatedBookingResponse resp = new ABEntities.AutomatedBookingResponse();
        resp.IsSuccessful = true;
        
        if(!ShouldModifyOrRenewLoan(loanId, 'MOD_NAME_FORMAT')){
            resp.IsSuccessful = false;
            resp.Messages = String.format(System.Label.NotValidForModification, 
                    new String[]{
                        System.Label.LoanModification
                    });
            return resp;
        }
        
        System.debug('will call modify loan');
        
        nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, !String.IsBlank(overrideTransactionLogExternalId) ? overrideTransactionLogExternalId : null);
        
        nFUSE.SendService service = serviceFinder(request, ABConfiguration.LOANMODIFICATIONSENDSERVICENAME);
        //since an error was not thrown we have located the service successfully
        
        request.primaryObjectId = loanId;
        
        nFUSE.MiddlewareMessage message = null;
        
        try{
            
            message = prepareLoanBookingMessage(ABConfiguration.LOANMODIFICATIONACTION, request, loanId, overrideUserId, overrideUserSessionId);
            
        }catch(Exception e){
            
            resp.IsSuccessful = false;
            resp.Messages = String.format(System.Label.OrchestrationGeneralException, 
                    new String[]{
                        System.Label.LoanModification,
                        e.getMessage(),
                        String.valueof(e.getLineNumber())
                    });
            return resp;
            
        }
        
        return this.Book(System.Label.OrchestrationGeneralException, System.Label.LoanModification, resp, message, request, service, additionalProperties);
    }
    
    public ABEntities.AutomatedBookingResponse BookCustomer(String relationshipId, String overrideUserId, String overrideUserSessionId, String overrideTransactionLogExternalId, Map<String,String> additionalProperties){
        ABEntities.AutomatedBookingResponse resp = new ABEntities.AutomatedBookingResponse();
        resp.IsSuccessful = true;
        
        if(!ShouldBookCustomer(relationshipId)){
            resp.IsSuccessful = false;
            resp.Messages = String.format(System.Label.BookedPreviously, 
                    new String[]{
                        System.Label.CustomerBooking
                    });
            return resp;
        }
        
        System.debug('will call book customer');
        
        nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, !String.IsBlank(overrideTransactionLogExternalId) ? overrideTransactionLogExternalId : null);
        
        nFUSE.SendService service = serviceFinder(request, ABConfiguration.CUSTOMERSENDSERVICENAME);
        //since an error was not thrown we have located the service successfully
        
        request.primaryObjectId = relationshipId;
        
        nFUSE.MiddlewareMessage message = null;
        
        try{
            
            message = prepareCustomerBookingMessage(ABConfiguration.CUSTOMERBOOKACTION, request, relationshipId, overrideUserId, overrideUserSessionId);
            
        }catch(Exception e){
            
            resp.IsSuccessful = false;
            resp.Messages = String.format(System.Label.OrchestrationGeneralException, 
                    new String[]{
                        System.Label.CustomerBooking,
                        e.getMessage(),
                        String.valueof(e.getLineNumber())
                    });
            return resp;
            
        }
        
        return this.Book(System.Label.OrchestrationGeneralException, System.Label.CustomerBooking, resp, message, request, service, additionalProperties);
    }
    public ABEntities.AutomatedBookingResponse BookDeposit(String depositId, String overrideUserId, String overrideUserSessionId, String overrideTransactionLogExternalId, Map<String,String> additionalProperties){
        
        ABEntities.AutomatedBookingResponse resp = new ABEntities.AutomatedBookingResponse();
        resp.IsSuccessful = true;
        
        if(!ShouldBookDeposit(depositId)){
            resp.IsSuccessful = false;
            resp.Messages = String.format(System.Label.BookedPreviously, 
                    new String[]{
                        System.Label.DepositBooking
                    });
            return resp;
        }
        
        System.debug('will call book deposit');
        
        nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, !String.IsBlank(overrideTransactionLogExternalId) ? overrideTransactionLogExternalId : null);
        
        nFUSE.SendService service = serviceFinder(request, ABConfiguration.DEPOSITSENDSERVICENAME);
        //since an error was not thrown we have located the service successfully
        
        request.primaryObjectId = depositId;
        
        
        nFUSE.MiddlewareMessage message = null;
        
        try{
            
            message = prepareDepositBookingMessage(ABConfiguration.DEPOSITBOOKACTION, request, depositId, overrideUserId, overrideUserSessionId);
            
        }catch(Exception e){
            
            resp.IsSuccessful = false;
            resp.Messages = String.format(System.Label.OrchestrationGeneralException, 
                    new String[]{
                        System.Label.DepositBooking,
                        e.getMessage(),
                        String.valueof(e.getLineNumber())
                    });
            return resp;
        }

        ABEntities.AutomatedBookingResponse bookResp = this.Book(System.Label.OrchestrationGeneralException, System.Label.DepositBooking, resp, message, request, service, additionalProperties);

        return bookResp;
    }
    
    
    @testVisible
    private ABEntities.AutomatedBookingResponse Book(String exceptionLabel, String errorMessageLabel, ABEntities.AutomatedBookingResponse resp, nFUSE.MiddlewareMessage message, nFUSE.PackageServiceRequest request, nFUSE.SendService service, Map<String,String> additionalProperties){
        
        try{
            
            if(forceBookingTestException)
                throw new ABOrchestratorServiceFinderException('forceBookingTestException');
            
            if(message != null && additionalProperties != null && additionalProperties.size()>0){
                //add additional properties here using keyvalue approach to message.properties
                for(String key : additionalProperties.keySet()){
                    
                    message.properties.put(key,additionalProperties.get(key));
                    
                }
            }
            
            system.debug('attempting to call send');
            service.send(request, message);
// BEGIN: FNNI Customization
            if(((Id)request.primaryObjectId).getSObjectType().getDescribe().getName() == 'LLC_BI__Deposit__c') {
                DepositBooking_Response depBookResp = handleDepositBookingResponses(message);
                resp.pendingBatch = depBookResp.pendingBatch;
                if (depBookResp.bookAccountResponse != null) {
                 	List<String> enrollmentStatuses = new List<String>();
                    for (DepositBooking_User user : depBookResp.bookAccountResponse) {
                        enrollmentStatuses.add(user.oldFederatedId + ',' + user.failedEnrollment);
                    }
					resp.enrollmentStatuses = enrollmentStatuses;
                }
            }
// END: FNNI Customization
            
            updateTransactionLog(message);
            
            resp.TransactionLogExternalId = message.messageHeader.transactionId;
            resp.IsSuccessful = true;
            
        }catch(Exception e){
            
            resp.IsSuccessful = false;

            resp.Messages = String.format(exceptionLabel, 
                    new String[]{
                        errorMessageLabel,
                        e.getMessage(),
                        String.valueof(e.getLineNumber() == null ? 0 : e.getLineNumber())
                    });

            // BEGIN: FNNI Customization
            if(((Id)request.primaryObjectId).getSObjectType().getDescribe().getName() == 'LLC_BI__Deposit__c')
                handleDepositBookingErrorResp(message, resp.Messages);

            // Normally the error would get logged in the response.  This adds an extra log entry with the detailed response body returned.
            updateTransactionLog(message);
            // END: FNNI Customization
            
        }
        return resp;
        
    }
    
    public void handleDepositBookingErrorResp(nFuse.MiddlewareMessage message, String errorMsg){
        List<LLC_BI__Deposit__c> depositsToUpdate = new List<LLC_BI__Deposit__c>();
        Id depositId = (Id) message.properties.get('primary_object_id');
            LLC_BI__Deposit__c tempDeposit = new LLC_BI__Deposit__c(Id = depositId);
            tempDeposit.Online_Application_Booking_Errors__c = errorMsg;
            depositsToUpdate.add(tempDeposit);

        if(depositsToUpdate.size()>0) nFORCE.DmlUtility.updateObj(depositsToUpdate);
    }
    
    
    // BEGIN: FNNI Customization
 
    public DepositBooking_Response handleDepositBookingResponses(nFuse.MiddlewareMessage message){
        Id depositId = (Id) message.properties.get('primary_object_id');
        String responseBody = message.httpResponse.getBody();
        Integer responseStatusCode = message.httpResponse.getStatusCode();
        String responseStatus = message.httpResponse.getStatus();
        return handleDepositBookingResponsesDetails(depositId, responseBody, responseStatusCode, responseStatus);
    }
 
    @testVisible
    public DepositBooking_Response handleDepositBookingResponsesDetails(Id depositId, String responseBody, Integer responseStatusCode, String responseStatus){
        
        DepositBooking_Response depBookResp;

        if(depositId.getSobjectType() == LLC_BI__Deposit__c.sObjectType) {
        
            String infoMsg = '';
            String externalIdField = ABConfiguration.EXTERNAL_APP_ID_FIELD;
            
            List<LLC_BI__Deposit__c> depositsToUpdate = new List<LLC_BI__Deposit__c>();
            List<User> userToUpdate = new List<User>();
            List<Account> acctToUpdate = new List<Account>();
            List<DepositError> depBookErrList;
            
            // Message processes successfully.
            if(String.valueof(responseStatusCode).startsWith('2')){
                
                try {
                    depBookResp = (DepositBooking_Response) JSON.deserialize(responseBody, DepositBooking_Response.Class);
                   if (depBookResp.pendingBatch == null) {
                    	depBookResp.pendingBatch = false;
                    }
                } catch(JSONException je){
                    throw new ABServiceException('Error: Unable to deserialize the returned message. Contact a System Administrator.');
                }
                
                if(depBookResp != null){
                    // Handle non-fatal reported errors.
                    if(depBookResp.infoMessages != null){
                        for(DepositError de : depBookResp.infoMessages){
                            infoMsg += System.Datetime.now().formatGMT('yyyy/MM/dd HH:mm:ss') + ' ' 
                                + de.severity== null ? '' : de.severity + ': ' 
                                    + de.message == null ? '' : de.message + '\n';
                        }
                    }
                    
                    // if NOT pending batch, proceed with the following book account logic
                    if (! depBookResp.pendingBatch) {
                   // Prepare the Deposit record updates.
	                    LLC_BI__Deposit__c tempDeposit = new LLC_BI__Deposit__c(Id = depositId);
	                    tempDeposit.put(externalIdField, depBookResp.acctNumber);
	                    tempDeposit.Online_Application_Booking_Errors__c = infoMsg;
	                    depositsToUpdate.add(tempDeposit);
	                    
	                    // Prepare the User record Updates.
	                    Map<String, DepositBooking_User> oldFedIdMap = new Map<String, DepositBooking_User>();
	                    for(DepositBooking_User userItem : depBookResp.bookAccountResponse){
	                        if(userItem.oldFederatedId != userItem.updatedFederatedID && userItem.updatedFederatedID != null) {
	                            oldFedIdMap.put(userItem.oldFederatedId, userItem);
	                        }
	                  		if (userItem.failedEnrollment == null) {
                    			userItem.failedEnrollment = false;
                    		}
	                    }
	                    //the oldFedIdMap has all the oldFederatedIDs as the keys mapped to the DepositBooking_User objects which
	                    //have the updatedFederatedIDs.
	                    Set<String> federatedIdSet = oldFedIdMap.keySet();
	                    
	                    //filter users on set of oldFedIDs
	                    List<User> userList = new List<User>([
	                        SELECT
	                        ID, FederationIdentifier, AccountID, Account.FNB_System_of_record_id__c
	                        FROM User
	                        WHERE FederationIdentifier IN :federatedIdSet
	                          AND isPortalEnabled = true
	                          AND isActive  = true 
	                    ]);

	                    //now assign all the updated Federated IDs from the oldFedId map to each user's updated Federated ID field
	                    for(User userItem : userList){
	                        String federationId = oldFedIdMap.get(userItem.FederationIdentifier).updatedFederatedID;
	                        User newUsr = new User();
	                        newUsr.Id = userItem.Id;
	                        newUsr.FederationIdentifier = federationId;
	                        userToUpdate.add(newUsr);

	                        String externalId = '';
	                        Integer pos = federationId.indexOf('@');
	                        if(pos == -1) externalId = federationId;
	                        else externalId = federationId.left(pos);
	                        
	                        // Only update the Account SOR if it is empty.
	                        if(userItem.Account.FNB_System_of_record_id__c == null){
	                            Account acc = new Account();
	                            acc.Id = userItem.AccountId;
	                            acc.FNB_System_of_record_id__c = externalId;
	                            acctToUpdate.add(acc);
	                        }
	                    }
                    }
                }

                if(depositsToUpdate.size()>0) nFORCE.DmlUtility.updateObj(depositsToUpdate);
                if(acctToUpdate.size()>0) nFORCE.DmlUtility.updateObj(acctToUpdate);
                if(userToUpdate.size()>0) nFORCE.DmlUtility.updateObj(userToUpdate,true);
                
                
            } else if(String.valueof(responseStatusCode).startsWith('4')){
                
                try {
                    depBookErrList = (List<DepositError>) JSON.deserialize(responseBody, List<DepositError>.Class);
                } catch(JSONException je){
                    throw new ABServiceException('Error: Unable to deserialize the returned message. Contact a System Administrator.');
                }
                
                if(depBookErrList != null){
                    for(DepositError de : depBookErrList){
                        infoMsg += System.Datetime.now().formatGMT('yyyy/MM/dd HH:mm:ss') + ' ' 
                            + de.severity== null ? '' : de.severity + ': ' 
                                + de.message == null ? '' : de.message + ': ' 
                                    + de.developerMessage == null ? '' : de.developerMessage + '\n';
                    }
                }
                // Prepare the Deposit record updates.
                LLC_BI__Deposit__c tempDeposit = new LLC_BI__Deposit__c(Id = depositId);
                tempDeposit.Online_Application_Booking_Errors__c = infoMsg;
                depositsToUpdate.add(tempDeposit);
                
                if(depositsToUpdate.size()>0) nFORCE.DmlUtility.updateObj(depositsToUpdate);
                throw new ABServiceException('Error: ' + String.valueof(responseStatusCode) + ' ' + responseStatus + ' ' + infoMsg);
                
            } else { 
                // Prepare the Deposit record updates.
                LLC_BI__Deposit__c tempDeposit = new LLC_BI__Deposit__c(Id = depositId);
                tempDeposit.Online_Application_Booking_Errors__c = 'Error: ' + String.valueof(responseStatusCode) + ' ' + responseStatus;
                depositsToUpdate.add(tempDeposit);
                if(depositsToUpdate.size()>0) nFORCE.DmlUtility.updateObj(depositsToUpdate);
                
                throw new ABServiceException('Error: ' + String.valueof(responseStatusCode) + ' ' + responseStatus);
            }            
        }

        return depBookResp;
    }
    
    @testVisible
    public class DepositBooking_Response{
        @testVisible
        List<DepositBooking_User> bookAccountResponse;
        @testVisible
        String appId;
        @testVisible
        String acctNumber;
        @testVisible
        String acctType;
        @testVisible
        Boolean pendingBatch;
        @testVisible
        List<DepositError> infoMessages;
    }

    @testVisible
    public class DepositError{
        @testVisible
        String severity;
        @testVisible
        String message;
        @testVisible
        String developerMessage;
    }
    
    @testVisible
    public class DepositBooking_User{
        @testVisible
        String oldFederatedId;
        @testVisible
        Boolean enrolledCustomer;
        @testVisible
        String updatedFederatedID;
        @testVisible
        Boolean failedEnrollment;
    }
 
// END: FNNI Customization   
    
    public Map<String,Object> GetBookingMessage(String type, String loanPropertyKey, Id objectId){
        nFUSE.MiddlewareMessage message = new nFUSE.MiddlewareMessage();
        nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        request.primaryObjectId = objectId;
        Map<String,Object> newMap = new Map<String,Object>();
        if(type.toLowerCase()=='reservationmessage'){
            message = prepareLoanReservationMessage(null, request, objectId, null, null);
            newMap.put(ABConfiguration.PROP_LOAN_KEY,message.properties.get(ABConfiguration.PROP_LOAN_KEY));
        }else if(type.toLowerCase()=='loanmessage'){
            //this is used when first booking the loan
            String overrideLoanId = this.GetReservedLoanNumberByLoanId(objectId);
            if(String.isBlank(overrideLoanId)){
                //this will be used for loan modifications
                String modDelimiter = this.GetConfigValue('MOD_NAME_FORMAT');
                String renDelimiter = this.GetConfigValue('REN_NAME_FORMAT');
                
                overrideLoanId = this.GetBookedLoanNumberByLoanId(objectId,true,modDelimiter);
                if(String.isBlank(overrideLoanId)){
                    //this will be used for loan renewal
                    overrideLoanId = this.GetBookedLoanNumberByLoanId(objectId,true,renDelimiter);
                }
                
                //try to clean it out finally shotgun approach
                if(!String.isBlank(modDelimiter) && !String.isBlank(overrideLoanId)){
                    overrideLoanId = overrideLoanId.substringBefore(modDelimiter);
                }
                if(!String.isBlank(renDelimiter) && !String.isBlank(overrideLoanId)){
                    overrideLoanId = overrideLoanId.substringBefore(renDelimiter);
                }
            }
            System.debug('overrideLoanId='+ overrideLoanId);
            message = prepareLoanBookingMessage(null, request, objectId, null, null);
            newMap.put(ABConfiguration.PROP_LOAN_KEY,message.properties.get(ABConfiguration.PROP_LOAN_KEY));
            if(!String.isBlank(overrideLoanId)){
                newMap.put(loanPropertyKey,overrideLoanId);
            }
        }else if(type.toLowerCase()=='deposit'){
            message = prepareDepositBookingMessage(null, request, objectId, null, null);
            newMap.put(ABConfiguration.PROP_DEPOSIT_KEY,message.properties.get(ABConfiguration.PROP_DEPOSIT_KEY));
        }else if(type.toLowerCase()=='customer'){
            message = prepareCustomerBookingMessage(null, request, objectId, null, null);
            newMap.put(ABConfiguration.PROP_RELATIONSHIP_KEY,message.properties.get(ABConfiguration.PROP_RELATIONSHIP_KEY));
            newMap.put('branch',message.properties.get('branch'));
        }else{
            return null;
        }
        
        //this will override any existing keys if they already exists in the message properties
        Map<String,String> messageConstants = this.GetMessageConstants();
        if(messageConstants != null && !messageConstants.isEmpty()){
            for (String key : messageConstants.keySet())
            {
                newMap.put(key, messageConstants.get(key));
            }
        }
        
        
        return newMap;//(new nFUSE.IntegrationClassTypeProvider()).serialize(newMap);
    }
    
    
    @testVisible
    private nFUSE.MiddlewareMessage prepareLoanBookingMessage(String action, nFUSE.PackageServiceRequest request, Id objectId, String overrideUserId, String overrideUserSessionId) {
        nFUSE.MiddlewareMessage message = new nFUSE.MiddlewareMessage();
        message.messageHeader.action = action;
        
        if (objectId != null) {
            
            nFORCE.ACrossPackageService loanService = (nFORCE.ACrossPackageService) nFORCE.BeanFactory.getInstance().getBeanByUniqueName(ABConfiguration.NFUSE_LOAN_XPKG_SERVICE);
            
            if(loanService == null)
                throw new ABServiceException(String.format(System.Label.XPackageServiceNotFoundMessage, new String[]{'LoanService',ABConfiguration.NFUSE_LOAN_XPKG_SERVICE}));
                
            if(request == null)
                throw new ABServiceException(System.Label.RequestNotExpectedToBeNullMessage);
            
            loanService.setInputParameter(
                'request',
                new nFUSE.IntegrationClassTypeProvider().serialize(request)
            );
            loanService.setInputParameter(
                'loan_ids',
                new Set<Id>{ request.primaryObjectId }
            );
            
            loanService.executeService();

            List<nFORCE.IForce> fLoans = (List<nFORCE.IForce>) loanService.getOutputParameter('loans');
            message.properties.put(ABConfiguration.PROP_LOAN_KEY, fLoans[0]);
            
            if(!String.isBlank(overrideUserId)){
                message.properties.put('salesforce_user_id', overrideUserId);
            }
            if(!String.isBlank(overrideUserSessionId)){
                message.properties.put('salesforce_session_id', overrideUserSessionId);
            }
            
            message.properties.put('primary_object_id', request.primaryObjectId);
            
            
        }

        return message;
    }
    @testVisible
    private nFUSE.MiddlewareMessage prepareLoanReservationMessage(String action, nFUSE.PackageServiceRequest request, Id objectId, String overrideUserId, String overrideUserSessionId) {
        nFUSE.MiddlewareMessage message = new nFUSE.MiddlewareMessage();
        message.messageHeader.action = action;
        
        if (objectId != null) {
            
            nFORCE.ACrossPackageService loanService = (nFORCE.ACrossPackageService) nFORCE.BeanFactory.getInstance().getBeanByUniqueName(ABConfiguration.NFUSE_LOAN_XPKG_SERVICE);
            
            if(loanService == null)
                throw new ABServiceException(String.format(System.Label.XPackageServiceNotFoundMessage, new String[]{'LoanReservationService',ABConfiguration.NFUSE_LOAN_XPKG_SERVICE}));
                
            if(request == null)
                throw new ABServiceException(System.Label.RequestNotExpectedToBeNullMessage);
            
            loanService.setInputParameter(
                'request',
                new nFUSE.IntegrationClassTypeProvider().serialize(request)
            );
            loanService.setInputParameter(
                'loan_ids',
                new Set<Id>{ request.primaryObjectId }
            );

            loanService.executeService();

            List<nFORCE.IForce> fLoans = (List<nFORCE.IForce>) loanService.getOutputParameter('loans');
            message.properties.put('loan', fLoans[0]);
            
            if(!String.isBlank(overrideUserId)){
                message.properties.put('salesforce_user_id', overrideUserId);
            }
            if(!String.isBlank(overrideUserSessionId)){
                message.properties.put('salesforce_session_id', overrideUserSessionId);
            }
            
            message.properties.put('primary_object_id', request.primaryObjectId);
            
        }

        return message;
    }
    @testVisible
    private nFUSE.MiddlewareMessage prepareCustomerBookingMessage(String action, nFUSE.PackageServiceRequest request, Id objectId, String overrideUserId, String overrideUserSessionId) {
        nFUSE.MiddlewareMessage message = new nFUSE.MiddlewareMessage();
        message.messageHeader.action = action;
        
        if (objectId != null) {
            
            nFORCE.ACrossPackageService relationshipService = (nFORCE.ACrossPackageService) nFORCE.BeanFactory.getInstance().getBeanByUniqueName(ABConfiguration.NFUSE_RELATIONSHIP_XPKG_SERVICE);
            
            if(relationshipService == null)
                throw new ABServiceException(String.format(System.Label.XPackageServiceNotFoundMessage, new String[]{'RelationshipService',ABConfiguration.NFUSE_RELATIONSHIP_XPKG_SERVICE}));
                
            if(request == null)
                throw new ABServiceException(System.Label.RequestNotExpectedToBeNullMessage);
            
            relationshipService.setInputParameter(
                'request',
                new nFUSE.IntegrationClassTypeProvider().serialize(request)
            );
            
            relationshipService.setInputParameter('relationship_ids', 
                JSON.serialize(new Set<Id>{ request.primaryObjectId })
            );

            relationshipService.executeService();

            List<nFORCE.IForce> fRelationships = (List<nFORCE.IForce>) relationshipService.getOutputParameter('relationships');
            
            /*
            
            START SPECIAL HANDLING
            
            The following allows the branch to be send in the outbound message. 
            In the future, the relationship service will provide this natively and 
            this can be removed but will require the implementing application to take on a breaking change*/
            
            LLC_BI__Branch__c branch = null;
            
            try{
                
                if(forceBranchException)
                    throw new ABServiceException('forceBranchException');
                
                branch = getBranchFromAccountId(request.primaryObjectId);
                
            }catch(Exception e){
                throw new ABServiceException(String.format(System.Label.BranchObtainException, new List<String>{
                    String.valueOf(e.getLineNumber()),
                    e.getMessage()
                }));
            }
            
            try{
                if(forceSerializationException)
                    throw new ABServiceException('forceSerializationException');
                if(branch != null){ 
                    message.properties.put('branch', JSON.serialize(branch));
                }
            }catch(Exception e){
                throw new ABServiceException(String.format(System.Label.TypeProviderSerializationException, new List<String>{
                    'Customer',
                    e.getMessage(),
                    String.valueOf(e.getLineNumber())
                }));
            }
            
            /*
            
            END SPECIAL HANDLING
            
            */
            
            message.properties.put(ABConfiguration.PROP_RELATIONSHIP_KEY, fRelationships[0]);
            
            if(!String.isBlank(overrideUserId)){
                message.properties.put('salesforce_user_id', overrideUserId);
            }
            if(!String.isBlank(overrideUserSessionId)){
                message.properties.put('salesforce_session_id', overrideUserSessionId);
            }
            
            message.properties.put('primary_object_id', request.primaryObjectId);
            
        }

        return message;
    }
    @testVisible
    private nFUSE.MiddlewareMessage prepareDepositBookingMessage(String action, nFUSE.PackageServiceRequest request, Id objectId, String overrideUserId, String overrideUserSessionId) {
        nFUSE.MiddlewareMessage message = new nFUSE.MiddlewareMessage();
        message.messageHeader.action = action;
        
        if (objectId != null) {
            
            nFORCE.ACrossPackageService depositService = (nFORCE.ACrossPackageService) nFORCE.BeanFactory.getInstance().getBeanByUniqueName(ABConfiguration.NFUSE_DEPOSIT_XPKG_SERVICE);
            
            if(depositService == null)
                throw new ABServiceException(String.format(System.Label.XPackageServiceNotFoundMessage, new String[]{'DepositService',ABConfiguration.NFUSE_DEPOSIT_XPKG_SERVICE}));
                
            if(request == null)
                throw new ABServiceException(System.Label.RequestNotExpectedToBeNullMessage);
            
            depositService.setInputParameter(
                'request',
                new nFUSE.IntegrationClassTypeProvider().serialize(request)
            );
            
            depositService.setInputParameter('deposit_ids', 
                new Set<Id>{ request.primaryObjectId }
            );
            
            depositService.executeService();

            List<nFORCE.IForce> fDeposits = (List<nFORCE.IForce>) depositService.getOutputParameter('deposits');
            
            message.properties.put(ABConfiguration.PROP_DEPOSIT_KEY, fDeposits[0]);
            
            if(!String.isBlank(overrideUserId)){
                message.properties.put('salesforce_user_id', overrideUserId);
            }
            if(!String.isBlank(overrideUserSessionId)){
                message.properties.put('salesforce_session_id', overrideUserSessionId);
            }
            
            message.properties.put('primary_object_id', request.primaryObjectId);
            
            /* Begin Customization for FNNI. */
            
            List<nPortal__Context__c> contextList = new List<nPortal__Context__c>([
                SELECT 
                  nPortal__Context_Type__c
                , QualifileReferenceNumber__c 
                , nPortal__User__c
                , nPortal__User__r.Name
                , nPortal__User__r.FederationIdentifier 
                , nPortal__User__r.AccountID
                , nPortal__User__r.ContactID
                , nPortal__User__r.username
                , SourceIP__c
                FROM nPortal__Context__c 
                WHERE nPortal__Application__c IN 
                    (SELECT 
                        LLC_BI__Application__c 
                     FROM LLC_BI__Deposit__c 
                     WHERE Id = :request.primaryObjectId)
            ]);
            
            List<FederationUser> fuList = new List<FederationUser>();
            if(contextList.size() > 0) {
                for(nPortal__Context__c contextItem : contextList){
                    FederationUser fu = new FederationUser();
                    fu.contextType = contextItem.nPortal__Context_Type__c;
                    fu.userId = contextItem.nPortal__User__c;
                    fu.name = contextItem.nPortal__User__r.Name;
                    fu.federationIdentifier = contextItem.nPortal__User__r.FederationIdentifier;
                    fu.accountId = contextItem.nPortal__User__r.AccountID;
                    fu.contactId = contextItem.nPortal__User__r.ContactID;
                    fu.userName = contextItem.nPortal__User__r.username;
                    fu.qualifileReportId = contextItem.QualifileReferenceNumber__c;
                    fu.sourceIP = contextItem.SourceIP__c;
                    fuList.add(fu);
                }
                message.properties.put('federationIds',fuList);
            }


            System.Debug('properties: ' + message.properties);
        }

        return message;
    }
    
    public class FederationUser {
        String contextType;
        String userId;
        String name;
        String accountId;
        String contactId;
        String userName;
        String federationIdentifier;
        String qualifileReportId;
        String sourceIP;
    }
            /* End Customization for FNNI. */
    
    
    @testVisible
    private LLC_BI__Branch__c getBranchFromAccountId(String accountId){
        if(String.isBlank(accountId)){
            return null;
        }
        Id convertedId = Id.valueOf(accountId);
        Account account = [SELECT Id, LLC_BI__Branch__c FROM Account WHERE Id =: convertedId][0];
        //only do work if the branch was set
        String branchId = String.valueOf(account.get('LLC_BI__Branch__c'));
        
        if(!String.isBlank(branchId)){
            Id convertedBranchId = Id.valueOf(branchId);
            String dbQuery = 'SELECT ' + String.join(this.branchFieldsToGet,',') + ' FROM LLC_BI__Branch__c WHERE Id = :convertedBranchId';
            List<LLC_BI__Branch__c> branches = Database.query(dbQuery);
            if(!branches.isEmpty()) return branches[0];
        }
        
        return null;
        
    }
    
    
    @testVisible
    private nFUSE__Transaction_Log__c updateTransactionLog(nFUSE.AMiddlewareMessage message){
        List<nFUSE__Transaction_Log__c> tlList = new List<nFUSE__Transaction_Log__c>([
            SELECT
                Id,
                CreatedDate
            FROM
                nFUSE__Transaction_Log__c
            WHERE
                nFUSE__External_Id__c = :message.messageHeader.transactionId            
        ]);
        
        if(tlList.size()>0){
            nFUSE__Transaction_Log__c transactionLog = tlList[0];

            transactionLog.nFUSE__Vendor_Status__c = message.messageHeader.action;
            //this fixes a bug where the action is not set by the orchestration happening with the message - TransactionUnitOfWork sets that
            transactionLog.nFUSE__Action__c = message.messageHeader.action;
            
            // BEGIN FNNI Customization
            // 
            // This is to add error messages to the response for tracing.
            // 
            if(!String.valueof(message.httpResponse.getStatusCode()).startsWith('2')){
                String errMsg = 'Error: ' + String.valueof(message.httpResponse.getStatusCode()) + ' ' + message.httpResponse.getStatus() + '\n' +  message.httpResponse.getBody();
                transactionLog.nFUSE__Transaction_Detail__c = errMsg;
            }
            // END FNNI Customization
            
            transactionLog.nFUSE__Transaction_Status__c = ABConfiguration.IN_PROGRESS_STATUS;
            update transactionLog;
            return transactionLog;
        } else {
            return null;
        }
    }
    
    @testVisible
    private Boolean ShouldBookCustomer(String accountId){
        Account account = [
            SELECT
                Id,
                LLC_BI__lookupKey__c
            FROM
                Account
            WHERE
                Id = :accountId
        ][0];
        return String.isBlank(account.LLC_BI__lookupKey__c);
    }
    
    @testVisible
    private Boolean ShouldBookLoan(String loanId){
        String bookedLoanNumber = GetBookedLoanNumberByLoanId(loanId,false,null);
        return String.isBlank(bookedLoanNumber);
    }
    
    @testVisible
    private Boolean ShouldModifyOrRenewLoan(String loanId, String lookupKey){
        String bookedLoanNumber = GetBookedLoanNumberByLoanId(loanId,false,null);
        Boolean bookedLoanNumberContainsValue = true;
        if(!String.isBlank(lookupKey)){
            bookedLoanNumberContainsValue = StringContainsConfigValue(bookedLoanNumber, lookupKey);
            return !String.isBlank(bookedLoanNumber) && bookedLoanNumberContainsValue;
        }
        return false;
    }
    
    public String GetConfigValue(String configLookupKey){
        if(String.isBlank(configLookupKey)) return null;
        List<LLC_BI__CFG_ConfigValue__c> configValues = [SELECT LLC_BI__fieldValue__c FROM LLC_BI__CFG_ConfigValue__c WHERE LLC_BI__lookupKey__c = :configLookupKey];
        if(configValues.isEmpty()) return null;
        return configValues[0].LLC_BI__fieldValue__c;
    }
    
    public Boolean StringContainsConfigValue(String stringToTest, String configLookupKey){
        if(String.isBlank(stringToTest)) return false;
        String delimiter = this.GetConfigValue(configLookupKey);
        if(String.isBlank(delimiter)) return false;
        return stringToTest.contains(delimiter);
    }
    
    @testVisible
    private Boolean ShouldBookDeposit(String depositId){
        LLC_BI__Deposit__c deposit = [
            SELECT
                Id,
                LLC_BI__lookupKey__c
            FROM
                LLC_BI__Deposit__c
            WHERE
                Id = :depositId
        ][0];
        return String.isBlank(deposit.LLC_BI__lookupKey__c);
    }
    
    public String GetReservedLoanNumberByLoanId(String loanId){
        Id convertedId = Id.valueOf(loanId);
        String reservedLoanNumber = null;
        List<LLC_BI__External_Application_Lookup__c> exAppLookup = [
            SELECT
                LLC_BI__External_Id__c
            FROM
                LLC_BI__External_Application_Lookup__c
            WHERE
                LLC_BI__Context_Id__c = :convertedId
            AND
                Name = :ABConfiguration.LOANRESERVATIONLOOKUPKEY
        ];
        System.Debug('exAppLookup = '+ JSON.serialize(exAppLookup) );
        if(!exAppLookup.isEmpty()){
            //assume only one?
            reservedLoanNumber = exAppLookup[0].LLC_BI__External_Id__c;
        }
        return reservedLoanNumber;
    }
    
    public String GetBookedLoanNumberByLoanId(String loanId, Boolean clean, String delimiter){
        Id convertedId = Id.valueOf(loanId);
        String bookedLoanNumber = null;
        String soql = 'SELECT ' +ABConfiguration.EXTERNAL_APP_ID_FIELD+ ' FROM LLC_BI__Loan__c WHERE Id = :convertedId';
        List<LLC_BI__Loan__c> loans = Database.query(soql);
        if(!loans.isEmpty()){
            //assume only one?
            bookedLoanNumber = String.valueOf(loans[0].get(ABConfiguration.EXTERNAL_APP_ID_FIELD));
            
            if(!String.isBlank(bookedLoanNumber) && clean && !String.isBlank(delimiter)){
                //clean out any junk before the delimiter
                bookedLoanNumber = bookedLoanNumber.substringBefore(delimiter);
            }
            
        }
        return bookedLoanNumber;
    }
    
    public Boolean PerformBatchUpdateTransactionLog(String transactionLogExternalId, String status, String transactionDetail, String vendorStatus){
        try{
                
            nFUSE__Transaction_Log__c log = [SELECT Id, nFUSE__Transaction_Detail__c, nFUSE__Transaction_Status__c, nFUSE__Vendor_Status__c FROM nFUSE__Transaction_Log__c WHERE nFUSE__External_Id__c = :transactionLogExternalId][0];
            if(!String.isBlank(transactionDetail))
                log.nFUSE__Transaction_Detail__c = transactionDetail;
            if(!String.isBlank(status))
                log.nFUSE__Transaction_Status__c = status;
            if(!String.isBlank(vendorStatus))
                log.nFUSE__Vendor_Status__c = vendorStatus;
            if(!String.isBlank(transactionDetail) || !String.isBlank(status) || !String.isBlank(vendorStatus))
                update log;
                //else do nothing
            return true;
        } catch(Exception ex) {
            throw new ABServiceException(ex.getMessage());
        }
    }
    
    public Boolean QueueBatchUpdateTransactionLog(String transactionLogExternalId, String status, String transactionDetail, String vendorStatus){
        List<ABEntities.ABTransactionLogInputParams> params = new List<ABEntities.ABTransactionLogInputParams>();
        ABEntities.ABTransactionLogInputParams param = new ABEntities.ABTransactionLogInputParams();
        param.ExternalId = transactionLogExternalId;
        param.TransactionDetails = transactionDetail;
        param.Status = status;
        param.VendorStatus = vendorStatus;
        params.add(param);
        
        //this never fails - batch will swallow the error
        ABTransactionLogInvocable.updateLog(params);
        
        return true;
    }
    
    public Map<String,String> GetMessageConstants(){
        List<nFUSE__Plugin_Constants__mdt> constants = [SELECT nFUSE__Key__c, nFUSE__Value__c, nFUSE__Translation__c FROM nFUSE__Plugin_Constants__mdt WHERE nFUSE__App_Plugin__c=:ABConfiguration.PLUGIN_CATEGORY_NAME];
        if(constants.isEmpty()) return null;
        //else convert to map string/string
        Map<String,String> constantsMap = new Map<String,String>();
        for (nFUSE__Plugin_Constants__mdt item : constants)
        {
            if(!constantsMap.containsKey(item.nFUSE__Key__c))
                constantsMap.put(item.nFUSE__Key__c, String.isBlank(item.nFUSE__Translation__c) ? item.nFUSE__Value__c : item.nFUSE__Translation__c);
        }
        return constantsMap;
    }

}