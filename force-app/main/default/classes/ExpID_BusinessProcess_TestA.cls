@IsTest
public class ExpID_BusinessProcess_TestA {

    public static String setupapplicationId;
    public static String setupip;
    public static User setupUser;
    public static nPortal__Context__c setupcontext;
    
    public static nPortal__Context__c ctx;

    static List<ExpID_BusinessProcess.BusinessMessage> createBusMsgList(){
        List<ExpID_BusinessProcess.BusinessMessage> bmList = new List<ExpID_BusinessProcess.BusinessMessage>();
        bmList.add(createBusMsg());
        return bmList;
    }

    
    static ExpID_BusinessProcess.BusinessMessage createBusMsg(){
        ExpID_BusinessProcess.BusinessMessage bm = new ExpID_BusinessProcess.BusinessMessage();
        bm.developerMessage = 'developer message';
        bm.message = 'message';
        bm.severity = 'SUCCESS';
        return bm;
    }

    static ExpID_BusinessProcess.IdentityServiceResponse createExpIDRespPASS(){
        ExpID_BusinessProcess.IdentityServiceResponse dbr = new ExpID_BusinessProcess.IdentityServiceResponse();
        dbr.preciseIdDecision = true;
        dbr.preciseIdReferenceNumber = '23412313';
        dbr.qualifileDecision = true;
        dbr.qualifileReferenceNumber = '33232322';
        dbr.businessDecision = createBusMsg();
        return dbr;
    }

    static ExpID_BusinessProcess.IdentityServiceResponse createExpIDRespFAILPrecise(){
        ExpID_BusinessProcess.IdentityServiceResponse dbr = new ExpID_BusinessProcess.IdentityServiceResponse();
        dbr.preciseIdDecision = false;
        dbr.preciseIdReferenceNumber = '23412313';
        dbr.qualifileDecision = true;
        dbr.qualifileReferenceNumber = '33232322';
        dbr.businessDecision = createBusMsg();
        return dbr;
    }

    static ExpID_BusinessProcess.IdentityServiceResponse createExpIDRespFAILQualifile(){
        ExpID_BusinessProcess.IdentityServiceResponse dbr = new ExpID_BusinessProcess.IdentityServiceResponse();
        dbr.preciseIdDecision = true;
        dbr.preciseIdReferenceNumber = '23412313';
        dbr.qualifileDecision = false;
        dbr.qualifileReferenceNumber = '33232322';
        dbr.businessDecision = createBusMsg();
        return dbr;
    }

    
    static Id getPersonAccountRecordType(){
        return Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    }
    
    private static LLC_BI__Application__c createApplication(String depositId, String status) {
        LLC_BI__Application__c app = new LLC_BI__Application__c(
            nPortal__Artifact_Id__c = depositId,
            nPortal__Status__c = status
        );
        
        insert app;
        return app;
    }

    private static nPortal__Context__c createContext(String applicationId, String userId, String sourceIP) {
        nPortal__Context__c context = new nPortal__Context__c(
            nPortal__Application__c = applicationId,
            nPortal__User__c = userId,
            SourceIP__c = sourceIP,
            nPortal__Context_Start__c = DateTime.now()
        );
        
        insert context;
        return context;
    }
    
    private static LLC_BI__Deposit__c createDeposit(String applicationId, String acctId, String message) {
        LLC_BI__Deposit__c deposit = new LLC_BI__Deposit__c(
            LLC_BI__Application__c = applicationId,
            LLC_BI__Account__c = acctId,
            Online_Application_Booking_Errors__c = message
        );
        
        insert deposit;
        return deposit;
    }
    
    private static String generateRandomString(final String charset, Integer length) {
        String randString = '';
        while (randString.length() < length) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), charset.length());
            randString += charset.substring(idx, idx + 1);
        }
        return randString;
    }

    private static nFUSE__Transaction_Log__c createTransactionLog(String externalId, Id primaryID, Id userId){
        nFUSE__Transaction_Log__c tl = new nFUSE__Transaction_Log__c(
            nFUSE__External_Id__c = externalId,
            nFUSE__Action__c = ExpID_BusinessProcess.PLUGIN_ACTION, 
            nFUSE__Api_Version__c = ExpID_BusinessProcess.PLUGIN_VERSION, 
            nFUSE__App_Plugin__c = ExpID_BusinessProcess.PLUGIN_NAME, 
            nFUSE__Primary_Object_Id__c = primaryID, 
            nFUSE__Requested_By_User_Id__c = userId, 
            nFUSE__Transaction_Status__c = 'New'
        );
        insert tl;
        return tl;
    }

 
    @TestSetup
    private static Void setupData(){
          
        // turn off accountTrigger while this is running
        List<TriggerSupport__c> triggerSupportSettings = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSetting = new TriggerSupport__c();
        accountTriggerSetting.Name = 'Account';
        accountTriggerSetting.TriggerIsDisabled__c = true;
        
        triggerSupportSettings.add(accountTriggerSetting);
        
        insert triggerSupportSettings;
              
        String firstName = 'New';
        String lastName = 'User-' + generateRandomString('abcdefghijklmnopqrstuvwxyz', 8) ;
        String email = generateRandomString('abcdefghijklmnopqrstuvwxyz', 8) + '@fnni.com';
        String userName = email;
        String customerTier = '0';

        Account testAccount = new Account(
            AccountNumber = '1234', 
            RecordTypeId = getPersonAccountRecordType(), 
            FirstName = firstName,
            LastName = lastName,
            BillingCountry = 'US',
            BillingStreet = '250 S 1300 E',
            BillingCity = 'SALT LAKE CITY',
            BillingState = 'UT',
            BillingPostalCode = '84102-2609',
            Phone = '8185551212',
            LLC_BI__Phone_Number_Type__c = 'Work',
            LLC_BI__Tax_Identification_Number__c = '555555555',
            LLC_BI__Tax_Identification_Number_PE__c = '555555555',
            Customer_Tier__c = customerTier,
            OwnerId = [SELECT Id FROM User WHERE nPortal__Has_Reached_Ownership_Limit__c = false AND IsActive = true AND nPortal__Is_Customer_Portal_Account_Owner_User__c = true].id                      
        );
        insert testAccount;
        Account acct = [SELECT Id, PersonContactId FROM Account WHERE Id = :testAccount.id];
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser){
            User portalUser = new User(
                Alias = 'portal',
                Email = username,
                EmailEncodingKey = 'UTF-8',
                FirstName = firstName,
                LastName = lastName,
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = [SELECT Id FROM Profile WHERE Name =: 'nCino Community User'].Id,
                TimeZoneSidKey = 'America/New_York',
                UserName = username,
                UserRoleId = [SELECT ID FROM UserRole WHERE DeveloperName = 'UserACustomerPersonAccount'].Id,
                IsActive = true,
                ContactId = acct.PersonContactId,
                Bank_Number__c = '999-9999'
            );
            insert portalUser;
        }
        
        System.runas(getPortalUserId()){
            LLC_BI__Application__c testApplication = createApplication('', 'In-Progress');
            LLC_BI__Deposit__c testDeposit = createDeposit(testApplication.Id, acct.Id, '2342323234');
            testApplication.nPortal__Artifact_Id__c = testDeposit.id;
            update testApplication;
            nPortal__Context__c testContext = createContext(testApplication.id, UserInfo.getUserId(), '127.0.0.1');

        }

    }
    
    private static User getPortalUserId(){
        return [SELECT Id FROM User WHERE Alias = 'portal'];
    }

    @isTest
    private static void testExpQualsendRequestSuccess(){
        test.startTest();
        new nFUSE.DataInstaller().onInstall(null);
        nPortal__Context__c testContext = [SELECT Id, nPortal__Application__c, nPortal__User__c, SourceIP__c FROM nPortal__Context__c WHERE SourceIP__c = '127.0.0.1' LIMIT 1];
        nFUSE__Transaction_Log__c txn = createTransactionLog(EncodingUtil.base64Encode(Crypto.generateAesKey(256)).right(40), testContext.Id, testContext.nPortal__User__c);
        ExpQual.ReturnDetails retDet = ExpQual.sendRequest(testContext.nPortal__Application__c, ExpQual.SUCCESS);
        test.stopTest();
        
        system.assertEquals(ExpQual.SUCCESS, retDet.status);
        system.assertEquals(ExpQual.INTEGRATION_SUCCESS_MESSAGE, retDet.message);
        system.assertEquals('', retDet.error);
    }

    @isTest
    private static void testExpQualsendRequestIDFailure(){
        test.startTest();
        new nFUSE.DataInstaller().onInstall(null);
        nPortal__Context__c testContext = [SELECT Id, nPortal__Application__c, nPortal__User__c, SourceIP__c FROM nPortal__Context__c WHERE SourceIP__c = '127.0.0.1' LIMIT 1];
        nFUSE__Transaction_Log__c txn = createTransactionLog(EncodingUtil.base64Encode(Crypto.generateAesKey(256)).right(40), testContext.Id, testContext.nPortal__User__c);
        ExpQual.ReturnDetails retDet = ExpQual.sendRequest(testContext.nPortal__Application__c, ExpQual.ID_VERIFICATION_FAILURE);
        test.stopTest();
        
        system.assertEquals(ExpQual.FAILURE, retDet.status);
        system.assertEquals(ExpQual.INTEGRATION_ERROR_MESSAGE, retDet.message);
        system.assertEquals('', retDet.error);
    }

    @isTest
    private static void testExpQualsendRequestError(){
        test.startTest();
        new nFUSE.DataInstaller().onInstall(null);
        nPortal__Context__c testContext = [SELECT Id, nPortal__Application__c, nPortal__User__c, SourceIP__c FROM nPortal__Context__c WHERE SourceIP__c = '127.0.0.1' LIMIT 1];
        nFUSE__Transaction_Log__c txn = createTransactionLog(EncodingUtil.base64Encode(Crypto.generateAesKey(256)).right(40), testContext.Id, testContext.nPortal__User__c);
        ExpQual.ReturnDetails retDet = ExpQual.sendRequest(testContext.nPortal__Application__c, ExpQual.ERROR);
        test.stopTest();
        
        system.assertEquals(ExpQual.ERROR, retDet.status);
    }

    
    @isTest
    private static void testSendExtension(){
        test.startTest();
        new nFUSE.DataInstaller().onInstall(null);
        ExpID_BusinessProcess bp = new ExpID_BusinessProcess();
        ExpID_BusinessProcess.ExpId_SendService ess = new ExpID_BusinessProcess.ExpId_SendService();
        ess.endPoint = 'http://www.ncino.com';
        ess.sendRequest = new HTTPRequest();
        ExpID_BusinessProcess.ExpId_MiddlewareMessage message = new ExpID_BusinessProcess.ExpId_MiddlewareMessage();
        Object o = ess.preSendRequest(ess.sendRequest, message);
        test.stopTest();
    }

    
    @isTest
    private static void testsendRequestSuccess(){
        test.startTest();
        new nFUSE.DataInstaller().onInstall(null);
        nPortal__Context__c testContext = [SELECT Id, nPortal__Application__c, nPortal__User__c, SourceIP__c FROM nPortal__Context__c WHERE SourceIP__c = '127.0.0.1' LIMIT 1];
        String txnID = EncodingUtil.base64Encode(Crypto.generateAesKey(256)).right(40);
        nFUSE__Transaction_Log__c txn = createTransactionLog(txnID, testContext.Id, testContext.nPortal__User__c);
        ExpID_BusinessProcess bp = new ExpID_BusinessProcess();
        bp.mockResponseBodyStr = JSON.serialize(createExpIDRespPASS());
        bp.mockResponseStatus = 'OK';
        bp.mockResponseStatusCode = 200;
        bp.mockTransactionId = txnId;
        
        String response = bp.sendRequest(testContext.nPortal__Application__c, testContext.SourceIP__c, testContext.nPortal__User__c);
        test.stopTest();
        
        system.assertEquals(ExpID_BusinessProcess.SUCCESS, response);
    }

   @isTest
    private static void testsendRequestFail500(){
        test.startTest();
        new nFUSE.DataInstaller().onInstall(null);
        nPortal__Context__c testContext = [SELECT Id, nPortal__Application__c, nPortal__User__c, SourceIP__c FROM nPortal__Context__c WHERE SourceIP__c = '127.0.0.1' LIMIT 1];
        String txnID = EncodingUtil.base64Encode(Crypto.generateAesKey(256)).right(40);
        nFUSE__Transaction_Log__c txn = createTransactionLog(txnID, testContext.Id, testContext.nPortal__User__c);
        ExpID_BusinessProcess bp = new ExpID_BusinessProcess();
        bp.mockResponseBodyStr = JSON.serialize(createBusMsgList());
        bp.mockResponseStatus = 'Internal Server Error';
        bp.mockResponseStatusCode = 500;
        bp.mockTransactionId = txnId;
        
        try {
            // expected to fail
        String response = bp.sendRequest(testContext.nPortal__Application__c, testContext.SourceIP__c, testContext.nPortal__User__c);
            System.assert(false);
        } catch (Exception ex){
            System.assert(ex.getMessage().contains('Error: 500 Internal Server Error'));          
        }
        test.stopTest();
    }    

   @isTest
    private static void testsendRequestFailId1(){
        test.startTest();
        new nFUSE.DataInstaller().onInstall(null);
        nPortal__Context__c testContext = [SELECT Id, nPortal__Application__c, nPortal__User__c, SourceIP__c FROM nPortal__Context__c WHERE SourceIP__c = '127.0.0.1' LIMIT 1];
        String txnID = EncodingUtil.base64Encode(Crypto.generateAesKey(256)).right(40);
        nFUSE__Transaction_Log__c txn = createTransactionLog(txnID, testContext.Id, testContext.nPortal__User__c);
        ExpID_BusinessProcess bp = new ExpID_BusinessProcess();
        bp.mockResponseBodyStr = JSON.serialize(createExpIDRespFAILPrecise());
        bp.mockResponseStatus = 'OK';
        bp.mockResponseStatusCode = 200;
        bp.mockTransactionId = txnId;
        
        String response = bp.sendRequest(testContext.nPortal__Application__c, testContext.SourceIP__c, testContext.nPortal__User__c);
        test.stopTest();
        
        system.assertEquals(ExpID_BusinessProcess.ID_VERIFICATION_FAIL_MESSAGE, response);
    }    

   @isTest
    private static void testsendRequestFailId2(){
        test.startTest();
        new nFUSE.DataInstaller().onInstall(null);
        nPortal__Context__c testContext = [SELECT Id, nPortal__Application__c, nPortal__User__c, SourceIP__c FROM nPortal__Context__c WHERE SourceIP__c = '127.0.0.1' LIMIT 1];
        String txnID = EncodingUtil.base64Encode(Crypto.generateAesKey(256)).right(40);
        nFUSE__Transaction_Log__c txn = createTransactionLog(txnID, testContext.Id, testContext.nPortal__User__c);
        ExpID_BusinessProcess bp = new ExpID_BusinessProcess();
        bp.mockResponseBodyStr = JSON.serialize(createExpIDRespFAILQualifile());
        bp.mockResponseStatus = 'OK';
        bp.mockResponseStatusCode = 200;
        bp.mockTransactionId = txnId;
        
        String response = bp.sendRequest(testContext.nPortal__Application__c, testContext.SourceIP__c, testContext.nPortal__User__c);
        test.stopTest();
        
        system.assertEquals(ExpID_BusinessProcess.ID_VERIFICATION_FAIL_MESSAGE, response);
    }    
    
    
    @isTest
    private static void testExpID_BusinessProcessServiceLocator(){
        
        try{
            test.startTest();
            new nFUSE.DataInstaller().onInstall(null);
            nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(ExpID_BusinessProcess.PLUGIN_NAME, ExpID_BusinessProcess.PLUGIN_VERSION, null);
            ExpID_BusinessProcess hdt = new ExpID_BusinessProcess();
        
            
            nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
            nFUSE.SendService service = (nFUSE.SendService)locator.locate(request, nFUSE.SendService.class, 'ExpID-Verification');

            test.stopTest();
            system.assertEquals(true,false);
        }catch(Exception e){
            system.assertNotEquals(null, e);
        }
        
    }
    
    @isTest
    private static void testExpID_BusinessProcessServiceLocatorSucceeds(){
        test.startTest();
        new nFUSE.DataInstaller().onInstall(null);
        new ExpID_BusinessProcess.Activator().onActivate();
        nFUSE.PackageServiceRequest req = new nFUSE.PackageServiceRequest(ExpID_BusinessProcess.PLUGIN_NAME, ExpID_BusinessProcess.PLUGIN_VERSION, null);
        ExpID_BusinessProcess hdt = new ExpID_BusinessProcess();
        try{
            nFUSE.SendService service = (nFUSE.SendService) new nFUSE.ServiceLocator().tryLocate(req, ExpID_BusinessProcess.ExpIdSendService.class);
            system.assertNotEquals(null, service);
        }catch(Exception e){
            system.assertNotEquals(null, e);
        }
        new ExpID_BusinessProcess.Activator().onDeActivate();
        test.stopTest();
    }  
    
    @isTest
    private static void testGetNextRouteHelper(){
        Account testAccount = new Account(
            AccountNumber = '4321', 
            RecordTypeId = getPersonAccountRecordType(), 
            FirstName = 'TEST',
            LastName = 'GetNextRoute',
            BillingCountry = 'US',
            BillingStreet = '250 S 1300 E',
            BillingCity = 'SALT LAKE CITY',
            BillingState = 'UT',
            BillingPostalCode = '84102-2609',
            Phone = '8185551211',
            LLC_BI__Phone_Number_Type__c = 'Work',
            LLC_BI__Tax_Identification_Number__c = '555555555',
            LLC_BI__Tax_Identification_Number_PE__c = '555555555',
            Customer_Tier__c = '0',
            OwnerId = [SELECT Id FROM User WHERE nPortal__Has_Reached_Ownership_Limit__c = false AND IsActive = true AND nPortal__Is_Customer_Portal_Account_Owner_User__c = true].id                      
        );
        insert testAccount;
        
        LLC_BI__Application__c newApp = new LLC_BI__Application__c(
        	Product_Name__c = 'Free Checking',
            nPORTAL__Account__c = testAccount.Id,
            nPORTAL__Status__c = 'In-Progress'
        );
        insert newApp;
        
        nFORCE__Group__c UIgroup = new nFORCE__Group__c(
        	nFORCE__App__c = 'test-group-app',
            Name='TEST PORTAL GROUP',
            nPortal__Is_Portal_Enabled__c=true
        );
        insert UIgroup;
        
        nFORCE__Route__c route = new nFORCE__Route__c(
        	Name='TEST PORTAL ROUTE',
            nFORCE__Body__c='c__Exp_Qual_ID',
            nFORCE__App__c='test-portal-route-app',
            nFORCE__Topbar__c='NPORTAL__LoanTopbar',
            nFORCE__Navigation__c='NPORTAL__ApplicationNavigation'
        );
        insert route;
        
        nFORCE__Route_Group__c rGroup = new nFORCE__Route_Group__c(
        	nFORCE__Group__c = UIgroup.Id,
            nFORCE__Route__c = route.Id,
            nFORCE__Order__c = 50,
            nPortal__Is_Portal_Enabled__c=true
        );
        insert rGroup;
        
        nFORCE__Route_Group__c nextRGroup = new nFORCE__Route_Group__c(
        	nFORCE__Group__c = UIgroup.Id,
            nFORCE__Route__c = route.Id,
            nFORCE__Order__c = 60,
            nPortal__Is_Portal_Enabled__c=true
        );
        insert nextRGroup;
        
        nFORCE__Session__c session = new nFORCE__Session__c(
        	nFORCE__Route_Group__c = rGroup.Id
        );
        insert session;
        
        nPortal__Context__c context = new nPortal__Context__c(
        	nPortal__Application__c = newApp.Id,
            nPortal__Session__c = session.Id,
            nPortal__Context_Start__c = Datetime.newInstance(2019, 1, 1)
        );
        insert context;
        
        String app = ExpQual.getNextRouteHelper(newApp.Id);
        System.assertEquals(app, route.nFORCE__App__c);
    }
        
    @TestVisible
    private static final String 
        UNIQUE_FEDERAL_IDENTIFIER = 'test_sso_id';
}