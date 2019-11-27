public class FNNI_B2BOCache {
    public static final String OAUTH_CACHE_NAME = 'local.OauthCache.AccessToken';    

    public static String calculateHMAC(String signatureData, String secretKey) {
        String HmacSHA256 = 'hmacSHA256';
        Blob data = Crypto.GenerateMac(HmacSHA256, Blob.valueOf(signatureData), Blob.valueOf(secretKey));
        String signature = EncodingUtil.base64Encode(data);
        return signature;
    }
    
    public static String getRFC1123Date(DateTime ufDt){
        return ufDt.formatGMT('EEE, dd MMM yyyy HH:mm:ss') + ' GMT';
    }

    public static String getSignature(String verb, String resource, DateTime ufDt, String contentType, String requestId, String content, String secretKey){
        String s = '\n';
        String dt = getRFC1123Date(ufDt);
        String dataToSign = verb + s + resource + s + dt + s + contentType + s + requestId + s + content;
        String signature = calculateHMAC(dataToSign, secretKey);
        return signature;
    }

    public static String getSecret(FNNI_PluginConfig config, String consumerSecret){
        return config.getPluginConfig(consumerSecret);
    }

    public static String getRequestId(){
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        return guid;
    } 

    @testVisible    
    public static String getAccessToken() {
        String accessToken = (String) Cache.Org.get(OAUTH_CACHE_NAME);
        if(accessToken == null) {
            FNNI_B2BOAuth b2bo = new FNNI_B2BOAuth();
            FNNI_B2BOAuth.OAuthResponse resp = b2bo.retrieveOAuthResponse();
            accessToken = resp.access_token;
            Integer ttl = setTTL(resp.expires_in);
            if(ttl == 0)
                Cache.Org.remove(OAUTH_CACHE_NAME);
            else 
                Cache.Org.put(OAUTH_CACHE_NAME, accessToken, ttl);      
        }
        return accessToken;
    }
    
    @testVisible
    private static Integer setTTL(String expires_in){
        Integer ttl = 0;
        Integer ttlVariance = (HTTP_SESSION_TIMEOUT/1000) + 1; // Maximum Timeout plus 1 Second for latency (121 seconds)
        Integer defaultExpiration = FNNI_DEFAULT_TIMEOUT;
        if(expires_in != null && String.isNotEmpty(expires_in) && expires_in.isNumeric()){
            defaultExpiration = (integer) Integer.valueOf(expires_in);
        } 
        ttl = (defaultExpiration - ttlVariance);
        if(ttl > MAX_SESSION_CACHE) ttl = MAX_SESSION_CACHE;
        if(ttl < MIN_SESSION_CACHE) ttl = 0;
        return ttl;
    }
    
    private static final Integer FNNI_DEFAULT_TIMEOUT = 3599; 
    private static final Integer HTTP_SESSION_TIMEOUT = 120000; // milliseconds (2 minutes) set by Salesforce.
    private static final Integer MAX_SESSION_CACHE = 172800; // seconds (48 hours) set by Salesforce.
    private static final Integer MIN_SESSION_CACHE = 300; // seconds (5 minutes) set by Salesforce.
}