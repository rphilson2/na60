@isTest
global class TestFNNI_B2BOAuth {

    @TestSetup
    private static void setup(){
        
        
    }
    
    @isTest
    public static void testCalloutWCache() {
        String secret = 'mySecret';
        new FNNI_B2BOAuth.Activator().onActivate();
        new FNNI_B2BOAuth.Activator().updateProperty(FNNI_B2BOAuth.CONSUMER_SECRET, secret);
        
        Test.setMock(HttpCalloutMock.class, new TestFNNI_MockHttpRespGen());
        Test.startTest();
        DateTime currentDT = System.Datetime.newInstanceGmt(2018, 9, 15, 8, 10, 44);
        
        Cache.Org.put(FNNI_B2BOCache.OAUTH_CACHE_NAME, 'TestaccessToken'); 
        FNNI_B2BOAuth oAuth = new FNNI_B2BOAuth();
       	oAuth.config.pluginConfigMap.put(FNNI_B2BOAuth.CONSUMER_KEY, 'userName');
       	oAuth.config.pluginConfigMap.put(FNNI_B2BOAuth.CONSUMER_SECRET, 'passWord');
       	oAuth.config.pluginConfigMap.put(FNNI_B2BOAuth.PARAMS, 'grant_type=stuff');
       	oAuth.config.pluginConfigMap.put(FNNI_B2BOAuth.URLENDPOINT_KEY,'http://example.com/example/test');        
        
        String requestId = oAuth.getRequestId();
        Boolean isActive = oAuth.isActive();
        String authorization = oAuth.getAuthorization();
        String method = 'POST';
        String resource = '\Test';
        String contentType = 'application/json';
        String payload = '{}';
        String signature = oAuth.getSignature(method, resource, currentDT, contentType, requestId, payload);
        
        FNNI_B2BOAuth.OAuthResponse resp = oAuth.retrieveOAuthResponse();
        
        Test.stopTest();
        
    }

    @isTest
    private static void testSendExtension(){
		ExpID_BusinessProcess bp = new ExpID_BusinessProcess();
        ExpID_BusinessProcess.ExpId_SendService ess = new ExpID_BusinessProcess.ExpId_SendService();
        ess.endPoint = 'http://www.ncino.com';
		ess.sendRequest = new HTTPRequest();
        ExpID_BusinessProcess.ExpId_MiddlewareMessage message = new ExpID_BusinessProcess.ExpId_MiddlewareMessage();
        Object o = ess.preSendRequest(ess.sendRequest, message);
    }

    @isTest
    private static void testFNNI_B2BOAuthServiceLocatorSucceeds(){
        new FNNI_B2BOAuth.Activator().onActivate();
        new FNNI_B2BOAuth.Activator().onDeActivate();
    }
    
    @isTest
    private static void testFNNI_B2BOAuthStuff(){
        FNNI_B2BOAuth oAuth = new FNNI_B2BOAuth();
        oAuth.config.pluginConfigMap.put(FNNI_B2BOAuth.CONSUMER_SECRET, 'mySecret');
        DateTime ufdt = System.Datetime.newInstanceGmt(2018, 10, 23, 5, 25, 30);
        String dtStr = 'Tue, 23 Oct 2018 05:25:30 GMT';
        system.assertEquals(dtStr, oAuth.getRFC1123Date(ufDt));
        
    }
    
}