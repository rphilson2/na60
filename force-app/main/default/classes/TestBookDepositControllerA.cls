@isTest
public class TestBookDepositControllerA {

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

    @TestSetup
    private static Void setupData(){
        
        // turn off accountTrigger while this is running
        List<TriggerSupport__c> triggerSupportSettings = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSetting = new TriggerSupport__c();
        accountTriggerSetting.Name = 'Account';
        accountTriggerSetting.TriggerIsDisabled__c = true;
        
        triggerSupportSettings.add(accountTriggerSetting);
        
        insert triggerSupportSettings;

        new nFUSE.DataInstaller().onInstall(null);
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
                FederationIdentifier = username
            );
            insert portalUser;            
        }
        
        System.runas(getPortalUserId()){
            LLC_BI__Application__c testApplication = createApplication('', 'In-Progress');
            LLC_BI__Deposit__c testDeposit = createDeposit(testApplication.Id, acct.Id, '');
            testApplication.nPortal__Artifact_Id__c = testDeposit.id;
            update testApplication;
            nPortal__Context__c testContext = createContext(testApplication.id, UserInfo.getUserId(), '127.0.0.1');

        }

    }
    
    private static User getPortalUserId(){
        return [SELECT Id FROM User WHERE Alias = 'portal'];
    }    
    
    @isTest
    static void TestSendRequestSuccess() {
        System.runas(getPortalUserId()){
            nPortal__Context__c testContext = [SELECT Id, nPortal__Application__c, nPortal__User__c, SourceIP__c FROM nPortal__Context__c WHERE SourceIP__c = '127.0.0.1' LIMIT 1];
            Test.startTest();
            BookDepositController.ReturnDetails result = BookDepositController.sendRequest(testContext.nPortal__Application__c, BookDepositController.SUCCESS);
            Test.stopTest();
            System.assertEquals(BookDepositController.SUCCESS, result.status);
        }
    }
    
    @isTest
    static void TestSendRequestPendingBatch() {
        System.runas(getPortalUserId()){
            nPortal__Context__c testContext = [SELECT Id, nPortal__Application__c, nPortal__User__c, SourceIP__c FROM nPortal__Context__c WHERE SourceIP__c = '127.0.0.1' LIMIT 1];
            Test.startTest();
            BookDepositController.ReturnDetails result = BookDepositController.sendRequest(testContext.nPortal__Application__c, BookDepositController.PENDING);
            Test.stopTest();
            System.assertEquals(BookDepositController.PENDING, result.status);
        }
    }
    
    @isTest
    static void TestSendRequestFail() {
        System.runas(getPortalUserId()){
            nPortal__Context__c testContext = [SELECT Id, nPortal__Application__c, nPortal__User__c, SourceIP__c FROM nPortal__Context__c WHERE SourceIP__c = '127.0.0.1' LIMIT 1];
            Test.startTest();
            BookDepositController.ReturnDetails result = BookDepositController.sendRequest(testContext.nPortal__Application__c, BookDepositController.FAIL);
            Test.stopTest();
            System.assertEquals(BookDepositController.FAIL, result.status);
        }
    }

    @isTest
    static void TestSendRequestError() {
        System.runas(getPortalUserId()){
            nPortal__Context__c testContext = [SELECT Id, nPortal__Application__c, nPortal__User__c, SourceIP__c FROM nPortal__Context__c WHERE SourceIP__c = '127.0.0.1' LIMIT 1];
            Test.startTest();
            BookDepositController.ReturnDetails result = BookDepositController.sendRequest(testContext.nPortal__Application__c, BookDepositController.ERROR);
            Test.stopTest();
            System.assert(result.status.startsWith('Cause:'));
        }
    }

    
    @isTest
    static void TestSendRequestErrorBadApplicationId() {
        System.runas(getPortalUserId()){
            nPortal__Context__c testContext = [SELECT Id, nPortal__Application__c, nPortal__User__c, SourceIP__c FROM nPortal__Context__c WHERE SourceIP__c = '127.0.0.1' LIMIT 1];
            Test.startTest();
            BookDepositController.ReturnDetails result = BookDepositController.sendRequest(testContext.Id);
            Test.stopTest();
            System.assertEquals(System.Label.InvalidApplicationID, result.status);
        }
    }

    @isTest
    static void TestSendRequestErrorNoContext() {
        System.runas(getPortalUserId()){
            nPortal__Context__c testContext = [SELECT Id, nPortal__Application__c, nPortal__User__c, SourceIP__c FROM nPortal__Context__c WHERE SourceIP__c = '127.0.0.1' LIMIT 1];
            Id applicationId = testContext.nPortal__Application__c;
            delete testContext;
            Test.startTest();
            BookDepositController.ReturnDetails result = BookDepositController.sendRequest(applicationId, BookDepositController.SUCCESS);
            Test.stopTest();
            System.assertEquals(System.Label.NoRelatedContext, result.status);
        }
    }
    
    @isTest
    static void TestSendRequestErrorNotDeposit() {
        System.runas(getPortalUserId()){
            nPortal__Context__c testContext = [SELECT Id, nPortal__Application__c, nPortal__User__c, SourceIP__c, nPortal__Application__r.nPortal__Artifact_Id__c FROM nPortal__Context__c WHERE SourceIP__c = '127.0.0.1' LIMIT 1];
            Id applicationId = testContext.nPortal__Application__c;
            update new LLC_BI__Application__c(Id = applicationId, nPortal__Artifact_Id__c = null);
            Test.startTest();
            BookDepositController.ReturnDetails result = BookDepositController.sendRequest(applicationId, BookDepositController.SUCCESS);
            Test.stopTest();
            System.assertEquals(System.Label.NotDepositArtifact, result.status);
        }
    }
    
    @isTest
    static void TestSendRequestErrorApplicationFailed() {
        System.runas(getPortalUserId()){
            nPortal__Context__c testContext = [SELECT Id, nPortal__Application__c, nPortal__User__c, SourceIP__c, nPortal__Application__r.nPortal__Artifact_Id__c FROM nPortal__Context__c WHERE SourceIP__c = '127.0.0.1' LIMIT 1];
            Id applicationId = testContext.nPortal__Application__c;
            update new LLC_BI__Application__c(Id = applicationId, nPortal__Status__c = BookDepositController.ID_VERIFICATION_DEPOSIT_FAIL_STATUS);
            Test.startTest();
            BookDepositController.ReturnDetails result = BookDepositController.sendRequest(applicationId, BookDepositController.SUCCESS);
            Test.stopTest();
            System.assertEquals(System.Label.ApplicationFailed, result.status);
        }
    }
    
    @isTest
    static void TestSendRequestErrorBookingError() {
        System.runas(getPortalUserId()){
            nPortal__Context__c testContext = [SELECT Id, nPortal__Application__c, nPortal__User__c, SourceIP__c, nPortal__Application__r.nPortal__Artifact_Id__c FROM nPortal__Context__c WHERE SourceIP__c = '127.0.0.1' LIMIT 1];
            Id applicationId = testContext.nPortal__Application__c;
            Id depositId = testContext.nPortal__Application__r.nPortal__Artifact_Id__c;
            update new LLC_BI__Deposit__c(Id = depositId, Online_Application_Booking_Errors__c = BookDepositController.FAIL);
            Test.startTest();
            BookDepositController.ReturnDetails result = BookDepositController.sendRequest(applicationId, BookDepositController.SUCCESS);
            Test.stopTest();
            System.assertEquals(BookDepositController.FAIL, result.status);
        }
    }
}