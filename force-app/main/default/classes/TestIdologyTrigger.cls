@isTest
public class TestIdologyTrigger {
   @TestSetup
    private static Void setupData(){
        String firstName = 'New';
        String lastName = 'User-' + generateRandomString('abcdefghijklmnopqrstuvwxyz', 8) ;
        String email = generateRandomString('abcdefghijklmnopqrstuvwxyz', 8) + '@fnni.com';
        String userName = email;
        String customerTier = '0';

       //08/08/2019 Added as part of test class fix -begin
      	List<TriggerSupport__c> triggerSupportList = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSupportSetting = new TriggerSupport__c();
       	accountTriggerSupportSetting.Name = 'Account';
        accountTriggerSupportSetting.TriggerIsDisabled__c = true;
        triggerSupportList.add(accountTriggerSupportSetting);
        insert triggerSupportList;
       //08/08/2019-end
        Account testAccount = new Account(
            AccountNumber = '1234', 
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
    private static Id getPersonAccountRecordType(){
        return Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    }
    
    private static User getPortalUserId(){
        return [SELECT Id FROM User WHERE Alias = 'portal'];
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


    @isTest
    public static void testTransactionLogUpdatefromIdology(){
        nPortal__Context__c testContext = [SELECT Id, nPortal__Application__r.nPortal__Artifact_Id__c, nPortal__User__c, nPortal__User__r.AccountID, SourceIP__c FROM nPortal__Context__c WHERE SourceIP__c = '127.0.0.1' LIMIT 1];
        Id accountId = testContext.nPortal__User__r.AccountID;
        nFUSE__Transaction_Log__c tl = insertTransactionLogWithAccount('Verification',accountId); 
        System.assert( accountId != null);
    }

    private static nFUSE__Transaction_Log__c insertTransactionLogWithAccount(String action, Id accountId) {
        nFUSE__Transaction_Log__c testLog = new nFUSE__Transaction_Log__c();
        testLog.Name = 'Can You See John Cena?';
        testLog.nFUSE__Action__c = action;
        testLog.nFUSE__Api_Version__c = '1.0';
        testLog.nFUSE__App_Plugin__c = 'Idology_Verification';
        testLog.nFUSE__External_Id__c = 'EXTID';
        testLog.nFUSE__Primary_Object_Id__c = accountId;
        testLog.nFUSE__Transaction_Status__c = 'Started';
        testLog.nFUSE__Vendor_Status__c = 'junk';
        testLog.nFUSE__Requested_By_User_Id__c = 'fakeUserId';
        insert testLog;
        return testLog;
    }

}