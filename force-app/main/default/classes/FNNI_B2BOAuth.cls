global without sharing class FNNI_B2BOAuth {
    public class FNNI_B2BOAuth_Exception extends Exception {}
 	
    public FNNI_PluginConfig config {get; set;}
    
    public FNNI_B2BOAuth(){
        config = new FNNI_PluginConfig(PLUGIN_NAME, PLUGIN_VERSION);
    }
    
    public Boolean isActive(){
        nFORCE.SystemProperties props = nFORCE.SystemProperties.getInstance();
        return props.getPropertyAsBoolean(PLUGIN_NAME, PLUGIN_ACTIVE_KEY, false);
    }

    public String getAuthorization(){
        return 'Bearer ' + FNNI_B2BOCache.getAccessToken();
    }

    public String getRequestId(){
        return FNNI_B2BOCache.getRequestId();
    }
    
    public String getRFC1123Date(DateTime ufDt){
        return FNNI_B2BOCache.getRFC1123Date(ufDt);
    }
    
    public String getSignature(String method, String resource, DateTime ufDt, String contentType, String requestId, String payload){
        return FNNI_B2BOCache.getSignature(method, resource, ufDt, contentType, requestId, payload, FNNI_B2BOCache.getSecret(config, CONSUMER_SECRET));
    }

    
	// BEGIN: Payload structure expected in the response body
    
    public class OAuthResponse {
		public String refresh_token_expires_in;
  		public String api_product_list;
		public List<String> api_product_list_json;
		public String organization_name;
		public Developer developer;
		public String token_type;
		public String issued_at;
		public String client_id;
		public String access_token;
		public String application_name;
		public String scope;
		public String expires_in;
		public String refresh_count;
        public String status;
    }
    
    public class Developer {
        public String email;
    }

	// END: Payload structure expected in the response body

    public FNNI_B2BOAuth.OAuthResponse retrieveOAuthResponse(){
        FNNI_B2BOAuth.OAuthResponse oAuthResp;
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String method = 'POST';
        String userName = config.getPluginConfig(CONSUMER_KEY);
        String passWord = config.getPluginConfig(CONSUMER_SECRET);
        String params = config.getPluginConfig(PARAMS);
        String urlendPoint = config.getPluginConfig(URLENDPOINT_KEY);
        req.setEndpoint(urlendPoint);
        req.setMethod(method);
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' +  EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
		req.setbody(params);
        HTTPResponse res = http.send(req);

        // If the status code returned is a 2xx message then deserialize the return message.
        if(String.valueof(res.getStatusCode()).startsWith('2')){
            String responseBody = res.getBody();
            // Deserialize the return payload using the FNNI_B2BOAuth.OAuthResponse class.
            oAuthResp = (FNNI_B2BOAuth.OAuthResponse) JSON.deserialize(responseBody,FNNI_B2BOAuth.OAuthResponse.Class);
        } else { 
            oAuthResp = new FNNI_B2BOAuth.OAuthResponse();
            oAuthResp.status = 'Error: ' + String.valueof(res.getStatusCode()) + ' ' + res.getStatus();
            throw new FNNI_B2BOAuth_Exception('Error: ' + String.valueof(res.getStatusCode()) + ' ' + res.getStatus());
        }
        return oAuthResp;
    }


    // The following class is used to activate and deactivate this plugin.
    global with sharing class Activator implements nFUSE.IPluginActivator {
        
        private nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
 
        public void onActivate() {
 
            // Build a custom configuration setting that will be displayed in the UI under "nCino Administration -> Quick Links -> Plugin Configuration -> FNNI_B2BOAuth"
            nFUSE.PluginConfigurationManager.PluginConfiguration configUrl = new nFUSE.PluginConfigurationManager.PluginConfiguration();
            configUrl.pluginName = PLUGIN_NAME;
            configUrl.pluginVersion = PLUGIN_VERSION;
            configUrl.category = PLUGIN_NAME;
            configUrl.key = URLENDPOINT_KEY;
            configUrl.valueDataType = 'String';
            configUrl.isEncrypted = false;
            configUrl.description = 'OAuth Gateway URL';
            
            nFUSE.PluginConfigurationManager.PluginConfiguration configKey = new nFUSE.PluginConfigurationManager.PluginConfiguration();
            configKey.pluginName = PLUGIN_NAME;
            configKey.pluginVersion = PLUGIN_VERSION;
            configKey.category = PLUGIN_NAME;
            configKey.key = CONSUMER_KEY;
            configKey.valueDataType = 'String';
            configKey.isEncrypted = false;
            configKey.description = CONSUMER_KEY;
            
            nFUSE.PluginConfigurationManager.PluginConfiguration configSecret = new nFUSE.PluginConfigurationManager.PluginConfiguration();
            configSecret.pluginName = PLUGIN_NAME;
            configSecret.pluginVersion = PLUGIN_VERSION;
            configSecret.category = PLUGIN_NAME;
            configSecret.key = CONSUMER_SECRET;
            configSecret.valueDataType = 'String';
            configSecret.isEncrypted = true;
            configSecret.description = CONSUMER_SECRET;

            nFUSE.PluginConfigurationManager.PluginConfiguration configPARAMS = new nFUSE.PluginConfigurationManager.PluginConfiguration();
            configPARAMS.pluginName = PLUGIN_NAME;
            configPARAMS.pluginVersion = PLUGIN_VERSION;
            configPARAMS.category = PLUGIN_NAME;
            configPARAMS.key = PARAMS;
            configPARAMS.valueDataType = 'String';
            configPARAMS.isEncrypted = false;
            configPARAMS.description = PARAMS;
            
            List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs = new List<nFUSE.PluginConfigurationManager.PluginConfiguration>{configUrl, configKey, configSecret, configPARAMS};
                new nFUSE.PluginConfigurationManager(PLUGIN_NAME, PLUGIN_VERSION).softInsertConfigurations(configs);
            
            nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);
            locator.register(request, nFUSE.SendService.class, FNNI_B2BOAuth.FNNI_B2BOAuthSendService.class);
            
            // Setup a property to indicate if this plugin is active
            nFORCE.SystemProperties props = nFORCE.SystemProperties.getInstance();
            if(props.getPropertyAsBoolean(PLUGIN_NAME, PLUGIN_ACTIVE_KEY) == null){
                createProperty(PLUGIN_ACTIVE_KEY, 'true');
            } else {
                updateProperty(PLUGIN_ACTIVE_KEY, 'true');
            }
            
        }
        
        public void onDeactivate() {
            nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);
            locator.deregister(request, nFUSE.SendService.class);
            // Set plugin as inactive on custom property.
            updateProperty(PLUGIN_ACTIVE_KEY, 'false');

        }

        private void createProperty(String key, String value){
            Boolean updated = false;
            nFORCE__System_Properties__c sp = new nFORCE__System_Properties__c();
            sp.name = PLUGIN_NAME + '_' + key;
            sp.nFORCE__Category_Name__c = PLUGIN_NAME;
            sp.nFORCE__Description__c = '';
            sp.nFORCE__Key__c = key;
            sp.nFUSE__Is_Encrypted__c = false;
            sp.nFORCE__Value__c = value;
            sp.nFORCE__Is_Active__c = true;
			insert sp;
        }
        
        @testVisible
        private Boolean updateProperty(String key, String value){
            Boolean updated = false;
            List<nFORCE__System_Properties__c> prop = [
                SELECT
                nFORCE__Value__c
                FROM
                nFORCE__System_Properties__c
                WHERE
                nFORCE__Category_Name__c =: PLUGIN_NAME
                AND
                nFORCE__Key__c =: key
            ];
            system.debug(prop);
            if(prop.size() > 0){
                prop[0].nFORCE__Value__c = value;
                update prop;
                updated = true;
            }
            return updated;
        }

    }
 
    public static final String
        PLUGIN_NAME = 'FNNI_B2BOAuth',
        PLUGIN_VERSION = '1.0',
        PLUGIN_HELP_TEXT = 'OAuth HMAC Plugin',
        PLUGIN_METHOD = 'POST',
        URLENDPOINT_KEY = 'URL Endpoint',
        CONSUMER_KEY = 'Consumer Key',
        CONSUMER_SECRET = 'Consumer Secret',
        PARAMS = 'URL Parameters',
        PLUGIN_ACTIVE_KEY = 'IsActive';

}