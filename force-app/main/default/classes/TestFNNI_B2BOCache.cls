@IsTest
public class TestFNNI_B2BOCache {

    @TestSetup
    private static Void setup(){ 
        new nFUSE.DataInstaller().onInstall(null);
    }
    
    @isTest
    private static void testGetSecret(){
        String mySecret = 'mySecret';
        FNNI_B2BOAuth oAuth = new FNNI_B2BOAuth();
        oAuth.config.pluginConfigMap.put(FNNI_B2BOAuth.CONSUMER_SECRET, mySecret);
		System.assertEquals(mySecret, FNNI_B2BOCache.getSecret(oAuth.config, FNNI_B2BOAuth.CONSUMER_SECRET));
    }

    @isTest
    private static void testcalculateHMAC(){
        String signatureData = 'Test';
        String secretKey = 'Test';
        String HmacSHA256 = 'hmacSHA256';
        Blob data = Crypto.GenerateMac(HmacSHA256, Blob.valueOf(signatureData), Blob.valueOf(secretKey));
        String signature = EncodingUtil.base64Encode(data);
        Test.startTest();
        System.assertEquals(signature, FNNI_B2BOCache.calculateHMAC(signatureData, secretKey));
        Test.stopTest();
    }

    @isTest
    private static void testRFC1123Date(){
        DateTime currentDT = System.Datetime.newInstanceGmt(2018, 9, 15, 8, 10, 44);
        String myUFDT = currentDT.formatGMT('EEE, dd MMM yyyy HH:mm:ss') + ' GMT';
        Test.startTest();
        System.assertEquals(myUFDT, FNNI_B2BOCache.getRFC1123Date(currentDT));
        Test.stopTest();
    }

    @isTest
    private static void testGetSignature(){
        String s = '\n';
        String verb = 'POST';
        String resource = '/Test';
        DateTime ufDt = System.Datetime.newInstanceGmt(2018, 9, 15, 8, 10, 44);
        String dt = FNNI_B2BOCache.getRFC1123Date(ufDt);
        String contentType = 'json/application';
        String requestId = FNNI_B2BOCache.getRequestId();
        String content = '{testpayload}';
        String dataToSign = verb + s + resource + s + dt + s + contentType + s + requestId + s + content;
		String secretKey = 'TEST';
        Test.startTest();
        Blob data = Crypto.GenerateMac('hmacSHA256', Blob.valueOf(dataToSign), Blob.valueOf(secretKey));
        String signature = EncodingUtil.base64Encode(data);
        Test.stopTest();
        System.assertEquals(signature, FNNI_B2BOCache.calculateHMAC(dataToSign, secretKey));
    }
    
    @isTest
    private static void testGetAccessToken(){
        String testAccessToken = 'accessToken';
        Cache.Org.put(FNNI_B2BOCache.OAUTH_CACHE_NAME, testAccessToken, 300);
        System.assertEquals(testAccessToken, FNNI_B2BOCache.getAccessToken());
    }
    
    @isTest
    private static void testsetTTL(){
        System.assertEquals(0,FNNI_B2BOCache.setTTL('1'));
        System.assertEquals(172800,FNNI_B2BOCache.setTTL('172800001'));
        System.assertEquals(301,FNNI_B2BOCache.setTTL('422'));
    }
    
    
}