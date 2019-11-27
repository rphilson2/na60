@IsTest
private class HoganBatchUpdaterTest {

    @isTest 
    static void testUpdateSalesforceBookSuccessEnrollmentSuccess() {
        Boolean bookAccountSuccessful = true;
        Boolean failedEnrollment = false;
        String oldFederatedId = 'test@gmail.com';
        String updatedFederatedId = '12345@fnbo.com';
        testUpdateSalesforce(bookAccountSuccessful, failedEnrollment, oldFederatedId, updatedFederatedId, false);
    }

    @isTest 
    static void testUpdateSalesforceBookSuccessEnrollmentFail() {
        Boolean bookAccountSuccessful = true;
        Boolean failedEnrollment = true;
        String oldFederatedId = 'test@gmail.com';
        String updatedFederatedId = 'test@gmail.com';
        testUpdateSalesforce(bookAccountSuccessful, failedEnrollment, oldFederatedId, updatedFederatedId, false);
    }
    
    @isTest 
    static void testUpdateSalesforceBookFail() {
        Boolean bookAccountSuccessful = false;
        Boolean failedEnrollment = false;
        String oldFederatedId = 'test@gmail.com';
        String updatedFederatedId = 'test@gmail.com';
        testUpdateSalesforce(bookAccountSuccessful, failedEnrollment, oldFederatedId, updatedFederatedId, false);
    }
    
    @isTest 
    static void testUpdateSalesforceDuplicateDepositLookupKey() {
        Boolean bookAccountSuccessful = true;
        Boolean failedEnrollment = false;
        String oldFederatedId = 'test@gmail.com';
        String updatedFederatedId = '12345@fnbo.com';
        testUpdateSalesforce(bookAccountSuccessful, failedEnrollment, oldFederatedId, updatedFederatedId, true);
    }
   
    static void testUpdateSalesforce(Boolean bookAccountSuccessful, Boolean failedEnrollment, 
		String oldFederatedId, String updatedFederatedId, Boolean duplicateAccountToken) {
        
        // Set values for updates / inserts
		String accountType = 'CHECKING';
        String accountToken = 'BDD8807252CD524A68D6480B7AD891A71D3E2037504D92CC505FF30A468F5FB8';
        List<String> infoMessages = new List<String>();
        infoMessages.add('test info message');
        infoMessages.add('test2 info message');
       
        // handle duplicate lookup key in deposit object
        String createAccountToken = null;
		if (duplicateAccountToken) {
			createAccountToken = accountToken;
		}
            
        // create test records
        Id applicationId = createTestRecords(oldFederatedId, createAccountToken);
        
        // setup the request and use relative path to his the web service so 
        // it isn't hard coded to a specific instance of the sandbox
        RestRequest request = new RestRequest();
        request.requestUri =
            '/services/apexrest/applications/'
            + applicationId;
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        RestContext.request = request;
        
        // setup test customer
        List<HoganBatchUpdater.Customer> customers = new List<HoganBatchUpdater.Customer>();
        HoganBatchUpdater.Customer customer = new HoganBatchUpdater.Customer();
        customer.failedEnrollment = failedEnrollment;
        customer.oldFederatedId = oldFederatedId;
        customer.updatedFederatedId = updatedFederatedId;
        customers.add(customer);
        
        // run the Web Service - do the updates / inserts to Salesforce
        HoganBatchUpdater.updateSalesforce(bookAccountSuccessful, 
    		accountType, accountToken, infoMessages, customers);
            
        // do assertions to make sure web service worked as designed
        doAssertions(applicationId, accountToken, duplicateAccountToken, 
			bookAccountSuccessful, failedEnrollment, oldFederatedId, updatedFederatedId);
    }
    
    private static void doAssertions(Id applicationId, String accountToken, Boolean duplicateAccountToken, 
		Boolean bookAccountSuccessful, Boolean failedEnrollment, String oldFederatedId, String updatedFederatedId) {
        
        // Verify deposit record was updated as expected
        if (duplicateAccountToken) {
        	// if duplicate account token, deposit should NOT be updated for application ID
            System.assert(! isDepositUpdated(applicationId, accountToken));
        } else {
        	// all other tests should have the deposit updated with a valid lookup key
			System.assert(isDepositUpdated(applicationId, accountToken));
        }
        
        nPortal__Context__c ctxRecord = selectSalesforceContext(applicationId);
        
        // Verify account record was updated as expected
		if (failedEnrollment || ! bookAccountSuccessful) {
			System.assert(ctxRecord.nPortal__User__r.Account.FNB_System_of_record_id__c == null);
		} else {
			String updatedFnbSystemOfRecordId = updatedFederatedId.substring(0,updatedFederatedId.indexOf('@fnbo.com'));
			System.assert(ctxRecord.nPortal__User__r.Account.FNB_System_of_record_id__c == updatedFnbSystemOfRecordId);
        }
            
        // Verify context record was updated as expected
		if (failedEnrollment) {
			System.assert(ctxRecord.Account_Booking_Status__c == 'EnrollmentFailed');
		} else {
            if (bookAccountSuccessful) {
				System.assert(ctxRecord.Account_Booking_Status__c == 'Success');
            } else {
				System.assert(ctxRecord.Account_Booking_Status__c == 'Failure');
            }
		}        
    }
    
    private static Boolean isDepositUpdated(Id applicationId, String accountToken) {
	
        Boolean depositLookupKeyUpdated = false;
        
        // Lookup the deposit id from the application id and return the lookup key value
		String lookupKey = [
                SELECT 
                    LLC_BI__lookupKey__c
                FROM LLC_BI__Deposit__c
                WHERE LLC_BI__Application__c = :applicationId
                LIMIT 1
			].LLC_BI__lookupKey__c;
        
        // update deposit if list is not empty (should not happen)
        if (lookupKey == accountToken) {
            depositLookupKeyUpdated = true;
     	}
        
        return depositLookupKeyUpdated;
    }
    
    private static nPortal__Context__c selectSalesforceContext(Id applicationId) {
	
        // Lookup information from context, user, and account based on application id
		nPortal__Context__c ctxRecord = [
			SELECT 
				nPortal__User__c
                , nPortal__User__r.FederationIdentifier 
                , nPortal__User__r.AccountId
				, nPortal__User__r.Account.FNB_System_of_record_id__c
            	, Account_Booking_Status__c
			FROM nPortal__Context__c
			WHERE nPortal__Application__c = :applicationId
		];
        
        return ctxRecord;
    }
    
    @TestSetup
    private static void setupData() {
        
        // turn off accountTrigger while this is running
        List<TriggerSupport__c> triggerSupportSettings = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSetting = new TriggerSupport__c();
        accountTriggerSetting.Name = 'Account';
        accountTriggerSetting.TriggerIsDisabled__c = true;
        
        triggerSupportSettings.add(accountTriggerSetting);
        
        insert triggerSupportSettings;
    }
    
    // Setup objects for test
    static Id createTestRecords(String federationIdentifier, String accountToken) {
        
        new nFUSE.DataInstaller().onInstall(null);
        String firstName = 'New';
        String lastName = 'User-' + generateRandomString('abcdefghijklmnopqrstuvwxyz', 8) ;
        String email = generateRandomString('abcdefghijklmnopqrstuvwxyz', 8) + '@fnni.com';
        String userName = email;
        String customerTier = '0';

        Account acct = createAccount(firstName, lastName, customerTier, '');
        
        createUser(username, firstName, lastName, acct, federationIdentifier);
        
        Id applicationId;
        System.runas(getPortalUserId()){
            LLC_BI__Application__c testApplication = createApplication('', 'In-Progress');
            applicationId = testApplication.Id;
            LLC_BI__Deposit__c testDeposit = createDeposit(testApplication.Id, acct.Id, '', '');
            testApplication.nPortal__Artifact_Id__c = testDeposit.id;
            update testApplication;
            nPortal__Context__c testContext = createContext(testApplication.id, UserInfo.getUserId(), '127.0.0.1');
            // create an extra deposit record with an account token to cause an exception on the update of deposit
            if (accountToken != null) {
                createDeposit(testApplication.Id, acct.Id, '', accountToken);
            }
        }
        
		return applicationId;
    }
    
    
    private static User getPortalUserId(){
        return [SELECT Id FROM User WHERE Alias = 'portal'];
    }    
    
    private static Account createAccount(String firstName, String lastName, String customerTier, String fnbSystemOfRecordId) {
        
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
            FNB_System_of_record_id__c = fnbSystemOfRecordId,
            Customer_Tier__c = customerTier,
            OwnerId = [SELECT Id FROM User 
                       	WHERE nPortal__Has_Reached_Ownership_Limit__c = false 
                       	AND IsActive = true 
                       	AND nPortal__Is_Customer_Portal_Account_Owner_User__c = true].id                      
        );
        
        insert testAccount;
        
        Account acct = [SELECT Id, PersonContactId FROM Account WHERE Id = :testAccount.id];
        return acct;
    }
    
    private static void createUser(String username, String firstName, String lastName, Account acct, String federationIdentifier) {
        
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
                FederationIdentifier = federationIdentifier
            );
            insert portalUser;            
        }
    }
    
    private static LLC_BI__Application__c createApplication(String depositId, String status) {
        LLC_BI__Application__c app = new LLC_BI__Application__c(
            nPortal__Artifact_Id__c = depositId,
            nPortal__Status__c = status
        );
        
        insert app;
        return app;
    }
    
    private static LLC_BI__Deposit__c createDeposit(String applicationId, String acctId, String message, String accountToken) {
        LLC_BI__Deposit__c deposit = new LLC_BI__Deposit__c(
            LLC_BI__Application__c = applicationId,
            LLC_BI__Account__c = acctId,
            Online_Application_Booking_Errors__c = message,
            LLC_BI__lookupKey__c = accountToken
        );
        
        insert deposit;
        return deposit;
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
    
    private static String generateRandomString(final String charset, Integer length) {
        String randString = '';
        while (randString.length() < length) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), charset.length());
            randString += charset.substring(idx, idx + 1);
        }
        return randString;
    }

    static Id getPersonAccountRecordType(){
        return Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    }
}