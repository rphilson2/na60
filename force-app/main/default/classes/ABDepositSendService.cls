global without sharing class ABDepositSendService extends nFUSE.SendService {
    
    public class ABSendServiceException extends Exception {}
    
    @testVisible
    private ABConfiguration configuration = new ABConfiguration();
    @testVisible
    private IABOrchestrator orchestrator = new ABOrchestrator();
    
    @testVisible
    private ABUtility utility = new ABUtility();
    
    public ABDepositSendService(){
        super();
    }
    
    //use this to set headers
    public override Object preSendRequest(Object request, nFUSE.AMiddlewareMessage msg){
        if (!(request instanceof HttpRequest)) {
			throw new ABSendServiceException(System.Label.ABHttpRequestExpected);
		}
        if(request instanceof HttpRequest){
            
            HttpRequest httpReq = (HttpRequest)request;
            
            //boiler plate
            //always make sure the content type is set to json
            utility.UpdateOrAddHeader(httpReq, 'Content-Type', 'application/json');
            utility.UpdateOrAddHeader(httpReq, 'Accept', 'application/json');
            
            //enforce we are on the correct action
            if(msg.messageHeader.action != ABConfiguration.DEPOSITBOOKACTION){
                throw new ABSendServiceException(String.format(System.Label.ABSendServiceException, 
                    new String[]{
                        msg.messageHeader.action
                    }));
            }
            
            //else we are ok to continue
            
            String translatedUrlKey = configuration.GetTranslatedKey(System.Label.DEPOSIT_ONBOARDING_URL);
            String endpointToUse = configuration.GetPropertyByKey(translatedUrlKey);
            
            String translatedAuthTypeKey = configuration.GetTranslatedKey(System.Label.AUTHENTICATION_TYPE);
            String endpointAuthorizationType = configuration.GetPropertyByKey(translatedAuthTypeKey);
            
            String translatedAuthUsernameKey = configuration.GetTranslatedKey(System.Label.BASIC_AUTH_USERNAME);
            String endpointAuthorizationUsername = configuration.GetPropertyByKey(translatedAuthUsernameKey);
            
            String translatedAuthPasswordKey = configuration.GetTranslatedKey(System.Label.BASIC_AUTH_PASSWORD);
            String endpointAuthorizationPassword = configuration.GetPropertyByKey(translatedAuthPasswordKey);
            
            //build a list of error messages (concat System.Label.ABServiceRequiredFieldBlankException where {0} is the translated property)
            if(endpointAuthorizationType.toLowerCase() == 'basic'){
                if(String.isBlank(endpointAuthorizationUsername) || String.isBlank(endpointAuthorizationPassword)){
                    String message = '';
                    if(String.isBlank(endpointAuthorizationUsername)){
                        message += String.format(System.Label.BasicAuthenticationMissingField, new String[]{
                            System.Label.BASIC_AUTH_USERNAME
                        });
                    }
                    if(String.isBlank(endpointAuthorizationPassword)){
                        message += String.format(System.Label.BasicAuthenticationMissingField, new String[]{
                            System.Label.BASIC_AUTH_PASSWORD
                        });
                    }
                    throw new ABSendServiceException(message);
                }else{
                    utility.UpdateOrAddHeader(httpReq, 'Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(endpointAuthorizationUsername + ':' + endpointAuthorizationPassword)));
                }
            }else{
                //remove the value of the authorization header because nothing is meant to be configured
                
                // BEGIN FNNI Customization (commented out)
                //utility.UpdateOrAddHeader(httpReq, 'Authorization', '');
                // END FNNI Customization
            }
            
            //error handling for endpoint being blank if not set
            if(String.isBlank(endpointToUse)){
                throw new ABSendServiceException(String.format(System.Label.MissingField, new String[]{
                        System.Label.DEPOSIT_ONBOARDING_URL
                    }));
            }
            //SETS THE ENDPOINT
            httpReq.setEndpoint(endpointToUse);
            
            //override the authorization header if Basic
            
            //if a custom timeout to be used, add it here
            //example: httpReq.setTimeout(60000); //timeout after 60 seconds
            //if a certificate is intended to be used, add it here (the name should probably be in the plugin configuration)
            //example: httpReq.setClientCertificateName(certNamefromPluginConfiguration);
            
            // Begin FNNI Customization for OAuth Headers

			httpReq.setTimeout(120000);  // Two minutes
            
            FNNI_B2BOAuth oAuth = new FNNI_B2BOAuth();
            if(oAuth.isActive()){
                
                String method = msg.method;
                Url endpointUrl = new url(httpReq.getEndpoint());
                String resource = endpointUrl.getPath();
                
                DateTime ufDt = System.now();
                String contentType = httpReq.getHeader('Content-Type');
                String requestId = oAuth.getRequestId();
                String payload = httpReq.getBody();
                String authorization = oAuth.getAuthorization();
                String signature = oAuth.getSignature(method, resource, ufDt, contentType, requestId, payload);
                String rFC1123Date = oAuth.getRFC1123Date(ufDt);
                
                utility.UpdateOrAddHeader(httpReq, 'Authorization', authorization);
                utility.UpdateOrAddHeader(httpReq, 'X-Request-ID', requestId);
                utility.UpdateOrAddHeader(httpReq, 'X-Authorization-SHA256', signature);
                utility.UpdateOrAddHeader(httpReq, 'Date',rFC1123Date);
                
            }
            // End FNNI Customization for OAuth Headers


        }
        return request;
    }
    
    public override nFUSE.AMiddlewareMessage preSendSeam(nFUSE.AMiddlewareMessage message) {

        //NOTE: This is where the custom handling of the response takes place.     
        nFUSE.AMiddlewareMessage m = super.preSendSeam(message);

        Map<String,String> properties = configuration.GetAllProperties(true);
        for (String key : properties.keySet())
        {
            if(!ABConfiguration.KEYS_TO_OMIT_FROM_MESSAGES.contains(key))
                m.properties.put(key, properties.get(key));
        }
        
        //this will override any existing keys if they already exists in the message properties
        Map<String,String> messageConstants = orchestrator.GetMessageConstants();
        if(messageConstants != null && !messageConstants.isEmpty()){
            for (String key : messageConstants.keySet())
            {
                m.properties.put(key, messageConstants.get(key));
            }
        }
        //now take the session id override if it was provided and shove it in the messageheader
        String overrideSessionId = String.valueof(m.properties.get('salesforce_session_id'));
        
        if(!String.isBlank(overrideSessionId))
        {
            m.messageHeader.userSalesforceSessionId = overrideSessionId;
        }
        
        //if a different verb is intended to be used set it here
        //example: m.method = 'GET';
        
    	return m;
    
    }
    
    public override nFUSE.AMiddlewareMessage postSendSeam(nFUSE.AMiddlewareMessage message) {
         
        HttpResponse resp = message.httpResponse;
        
        Boolean useAsync = nFORCE.SystemProperties.getInstance().getPropertyAsBoolean(
			ABConfiguration.PLUGIN_CATEGORY_NAME,
			System.Label.USE_ASYNCHRONOUS_REQUESTS,
			true
		);
        
        //get the setting for async requests
        String transactionLogExternalId = message.messageHeader.transactionId;
        
        //NOTE: This is where the custom handling of the response takes place.     
        if(!useAsync){
 
            
		    //handle syncronous response
		    //only work with successful responses
            if(String.valueOf(resp.getStatusCode()).startsWithIgnoreCase('2')) {
                
                orchestrator.QueueBatchUpdateTransactionLog(transactionLogExternalId, ABConfiguration.DEPOSIT_COMPLETE_STATUS, resp.getBody(), ABConfiguration.DEPOSIT_COMPLETE);
                
            }
            else {
                //create a transaction log indicating failure of what happened
                throw new ABSendServiceException(String.format(System.Label.SendServiceAsyncResponseFailureMessage, new String[]{
                    '2xx',
                    String.valueOf(resp.getStatusCode())
                }));
            }
		    
		}
		
        return message;
    }

   
}