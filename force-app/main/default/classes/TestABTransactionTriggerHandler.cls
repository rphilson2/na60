@isTest()
public with sharing class TestABTransactionTriggerHandler {
	
	static LLC_BI__Deposit__c createDeposit(String acctId){
        LLC_BI__Deposit__c sDeposit = new LLC_BI__Deposit__c(
            LLC_BI__Account__c = acctId,
			Name = 'Test Deposit',
			LLC_BI__Size_of_Box__c = 'Size1'
		);
		insert sDeposit;
		return sDeposit;
    }
    
    static Account createAccount() {
		Account testAccount = new Account(Name = 'My test account', AccountNumber = '1234');
        testAccount.Existing_DDA_Indicator__c = 'Yes';
		insert testAccount;
		return testAccount;
	}
    @testSetup
	static void setupData() { 
    
        //08/08/2019 Added as part of test class fix -begin
      	List<TriggerSupport__c> triggerSupportList = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSupportSetting = new TriggerSupport__c();
       	accountTriggerSupportSetting.Name = 'Account';
        accountTriggerSupportSetting.TriggerIsDisabled__c = true;
        triggerSupportList.add(accountTriggerSupportSetting);
        TriggerSupport__c depositTriggerSupportSetting = new TriggerSupport__c();
       	depositTriggerSupportSetting.Name = 'Deposit';
        depositTriggerSupportSetting.TriggerIsDisabled__c = true;
		triggerSupportList.add(depositTriggerSupportSetting);
        insert triggerSupportList;
       //08/08/2019-end	
     }

    @isTest
	private static void testCreateExternalAppOnUpdateErrorsOnMapping() {
		
		LLC_BI__Loan__c loanToInsert = new LLC_BI__Loan__c(Name='loan');
		insert loanToInsert;
		new ABActivator().onActivate();
		
		Test.startTest();
		nFUSE__Transaction_Log__c testLog = insertTransactionLogWithLoan(ABConfiguration.LOANRESERVATIONACTION,loanToInsert.Id);
		updateTransactionLogWithLoan(loanToInsert.Id,ABConfiguration.LOAN_RESERVED_COMPLETE,'this is not a key value pair compatible status');
		List<LLC_BI__External_Application_Lookup__c> externalApps = getExternalApps();
		Test.stopTest();

		List<LLC_BI__Loan__c> loan = [SELECT Id, LLC_BI__lookupKey__c FROM LLC_BI__Loan__c];

		System.assertEquals(true,nFORCE.BeanRegistry.getInstance().isRegistered(ABConfiguration.TRANSACTION_LOG_AFTER_UPDATE_TRIGGERS_BEAN));
		
		System.assertEquals(0, externalApps.size());
		
	}
	@IsTest
	private static void testCreateExternalAppOnUpdate() {
		
		LLC_BI__Loan__c loanToInsert = new LLC_BI__Loan__c(Name='loan');
		insert loanToInsert;
		
		
		new ABActivator().onActivate();
		
		Test.startTest();
		nFUSE__Transaction_Log__c testLog = insertTransactionLogWithLoan(ABConfiguration.LOANRESERVATIONACTION,loanToInsert.Id);
		updateTransactionLogWithLoan(loanToInsert.Id,ABConfiguration.LOAN_RESERVED_COMPLETE,'{"LoanNumber":"testExtId", "LoanId":"'+loanToInsert.Id+'"}');
		List<LLC_BI__External_Application_Lookup__c> externalApps = getExternalApps();
		Test.stopTest();

		List<LLC_BI__Loan__c> loan = [SELECT Id, LLC_BI__lookupKey__c FROM LLC_BI__Loan__c];

		System.assertEquals(true,nFORCE.BeanRegistry.getInstance().isRegistered(ABConfiguration.TRANSACTION_LOG_AFTER_UPDATE_TRIGGERS_BEAN));
		
		System.assertEquals(1, externalApps.size());
		
		System.assertEquals(externalApps[0].LLC_BI__Context_Id__c, loan[0].Id);
		System.assertEquals(externalApps[0].LLC_BI__External_Id__c, 'testExtId');
		System.assertEquals(externalApps[0].Name, ABConfiguration.LOANRESERVATIONLOOKUPKEY);
		//System.assertEquals(loan[0].LLC_BI__lookupKey__c, 'testExtId');
	}
	@IsTest
	private static void testDeleteExternalAppOnLoanOnComplete_ReserveSecondTime() {
		
		LLC_BI__Loan__c loanToInsert = new LLC_BI__Loan__c(Name='loan');
		insert loanToInsert;
		
		
		new ABActivator().onActivate();
		
		Test.startTest();
		nFUSE__Transaction_Log__c testLog = insertTransactionLogWithLoan(ABConfiguration.LOANBOOKACTION,loanToInsert.Id);
		updateTransactionLogWithLoan(loanToInsert.Id,ABConfiguration.LOAN_RESERVED_COMPLETE,'{"LoanNumber":"testExtId", "LoanId":"'+loanToInsert.Id+'"}');
		updateTransactionLogWithLoan(loanToInsert.Id,ABConfiguration.LOAN_RESERVED_COMPLETE,'{"LoanNumber":"testExtId2", "LoanId":"'+loanToInsert.Id+'"}');
		updateTransactionLogWithLoan(loanToInsert.Id,ABConfiguration.LOAN_COMPLETE,'{"Something":"elsefromresponse"}');
		Test.stopTest();

		List<LLC_BI__External_Application_Lookup__c> externalApps = getExternalApps();
		
		List<LLC_BI__Loan__c> loan = [SELECT Id, LLC_BI__lookupKey__c FROM LLC_BI__Loan__c];

		System.assertEquals(true,nFORCE.BeanRegistry.getInstance().isRegistered(ABConfiguration.TRANSACTION_LOG_AFTER_UPDATE_TRIGGERS_BEAN));
		
		System.assertEquals(0, externalApps.size());
		//it should contain the LAST one
		System.assertEquals('testExtId2',loan[0].LLC_BI__lookupKey__c);
	}
	@IsTest
	private static void testDeleteExternalAppOnLoanOnComplete() {
		
		LLC_BI__Loan__c loanToInsert = new LLC_BI__Loan__c(Name='loan');
		insert loanToInsert;
		
		
		new ABActivator().onActivate();
		
		Test.startTest();
		nFUSE__Transaction_Log__c testLog = insertTransactionLogWithLoan(ABConfiguration.LOANBOOKACTION,loanToInsert.Id);
		updateTransactionLogWithLoan(loanToInsert.Id,ABConfiguration.LOAN_RESERVED_COMPLETE,'{"LoanNumber":"testExtId", "LoanId":"'+loanToInsert.Id+'"}');
		updateTransactionLogWithLoan(loanToInsert.Id,ABConfiguration.LOAN_COMPLETE,'{"LoanNumber":"testExtId", "LoanId":"'+loanToInsert.Id+'"}');
		List<LLC_BI__External_Application_Lookup__c> externalApps = getExternalApps();
		Test.stopTest();

		List<LLC_BI__Loan__c> loan = [SELECT Id, LLC_BI__lookupKey__c FROM LLC_BI__Loan__c];

		System.assertEquals(true,nFORCE.BeanRegistry.getInstance().isRegistered(ABConfiguration.TRANSACTION_LOG_AFTER_UPDATE_TRIGGERS_BEAN));
		
		System.assertEquals(0, externalApps.size());
		
		System.assertEquals(loan[0].LLC_BI__lookupKey__c, 'testExtId');
	}
	
	@IsTest
	private static void testReservationDisabledLoanComplete() {
		
		LLC_BI__Loan__c loanToInsert = new LLC_BI__Loan__c(Name='loan');
		insert loanToInsert;
		
		
		new ABActivator().onActivate();
		
		nFORCE__System_Properties__c property1 = [SELECT Id FROM nFORCE__System_Properties__c WHERE nFORCE__Category_Name__c='AutomatedBookingConfiguration' AND nFORCE__Key__c = 'Enable Reserve Loan Button'][0];
        property1.nFORCE__Value__c = 'false';
        update property1;
		
		Test.startTest();
		nFUSE__Transaction_Log__c testLog = insertTransactionLogWithLoan(ABConfiguration.LOANBOOKACTION,loanToInsert.Id);
		updateTransactionLogWithLoan(loanToInsert.Id,ABConfiguration.LOAN_COMPLETE,'{"LoanNumber":"testExtId", "LoanId":"'+loanToInsert.Id+'"}');
		List<LLC_BI__External_Application_Lookup__c> externalApps = getExternalApps();
		Test.stopTest();

		List<LLC_BI__Loan__c> loan = [SELECT Id, LLC_BI__lookupKey__c FROM LLC_BI__Loan__c];

		System.assertEquals(true,nFORCE.BeanRegistry.getInstance().isRegistered(ABConfiguration.TRANSACTION_LOG_AFTER_UPDATE_TRIGGERS_BEAN));
		
		System.assertEquals(0, externalApps.size());
		
		System.assertEquals(loan[0].LLC_BI__lookupKey__c, 'testExtId');
	}

	@IsTest
	private static void testNotCreateExternalAppOnUpdateDeactivated() {
		
		LLC_BI__Loan__c loanToInsert = new LLC_BI__Loan__c(Name='loan');
		insert loanToInsert;
		
		new ABActivator().onActivate();
		new ABActivator().onDeactivate();
		
		Test.startTest();
		nFUSE__Transaction_Log__c testLog = insertTransactionLogWithLoan(ABConfiguration.LOANRESERVATIONACTION,loanToInsert.Id);
		updateTransactionLogWithLoan(loanToInsert.Id,ABConfiguration.LOAN_RESERVED_COMPLETE,'{"LoanNumber":"testExtId", "LoanId":"'+loanToInsert.Id+'"}');
		List<LLC_BI__External_Application_Lookup__c> externalApps = getExternalApps();
		Test.stopTest();
		
		System.assertEquals(false,nFORCE.BeanRegistry.getInstance().isRegistered(ABConfiguration.TRANSACTION_LOG_AFTER_UPDATE_TRIGGERS_BEAN));
		System.assertEquals(externalApps.size(), 0);
	}
	private static nFUSE__Transaction_Log__c insertTransactionLogWithLoan(String action, Id loanId) {
		nFUSE__Transaction_Log__c testLog = new nFUSE__Transaction_Log__c();
		testLog.Name = 'Can You See John Cena?';
		testLog.nFUSE__Action__c = action;
		testLog.nFUSE__Api_Version__c = '1.0';
		testLog.nFUSE__App_Plugin__c = ABConfiguration.PLUGIN_NAME;
		testLog.nFUSE__External_Id__c = 'EXTID';
		testLog.nFUSE__Primary_Object_Id__c = loanId;
		testLog.nFUSE__Transaction_Status__c = 'Started';
		testLog.nFUSE__Vendor_Status__c = 'junk';
		testLog.nFUSE__Requested_By_User_Id__c = 'fakeUserId';
		insert testLog;
		return testLog;
	}
	private static void updateTransactionLogWithLoan(Id loanId, String status, String details) {
		nFUSE__Transaction_Log__c testLog = [SELECT Id FROM nFUSE__Transaction_Log__c WHERE nFUSE__Primary_Object_Id__c = :loanId][0];
		testLog.nFUSE__Vendor_Status__c = status;
		testLog.nFUSE__Transaction_Detail__c = details;
		update testLog;
	}

	private static List<LLC_BI__External_Application_Lookup__c> getExternalApps() {
		return [
			SELECT
				Id,
				Name,
				LLC_BI__Context_Id__c,
				LLC_BI__External_Id__c
			FROM
				LLC_BI__External_Application_Lookup__c
		];
	}
	
	
	@IsTest
	private static void test_DepositTriggered() {
		
		new ABActivator().onActivate();
		String acctId = createAccount().id;
		LLC_BI__Deposit__c deposit = createDeposit(acctId);
		
		Test.startTest();
		nFUSE__Transaction_Log__c testLog = insertTransactionLogWithLoan(ABConfiguration.DEPOSITBOOKACTION,deposit.Id);
		updateTransactionLogWithLoan(deposit.Id,ABConfiguration.DEPOSIT_COMPLETE,'{"BookedDepositNumber":"testExtId"}');
		Test.stopTest();
		
		List<LLC_BI__Deposit__c> deposits = [SELECT Id, LLC_BI__lookupKey__c FROM LLC_BI__Deposit__c];

		System.assertEquals(true,nFORCE.BeanRegistry.getInstance().isRegistered(ABConfiguration.TRANSACTION_LOG_AFTER_UPDATE_TRIGGERS_BEAN));
		
		System.assertEquals(1, deposits.size());
		
//		System.assertEquals('testExtId',deposits[0].LLC_BI__lookupKey__c);
	}
	
	
	@IsTest
	private static void test_CustomerTriggered() {
		
		new ABActivator().onActivate();
		
		Account account = createAccount();
		
		Test.startTest();
		nFUSE__Transaction_Log__c testLog = insertTransactionLogWithLoan(ABConfiguration.CUSTOMERBOOKACTION,account.Id);
		updateTransactionLogWithLoan(account.Id,ABConfiguration.CUSTOMER_COMPLETE,'{"BookedCustomerNumber":"testExtId"}');
		Test.stopTest();
		
		List<Account> accounts = [SELECT Id, LLC_BI__lookupKey__c FROM Account];

		System.assertEquals(true,nFORCE.BeanRegistry.getInstance().isRegistered(ABConfiguration.TRANSACTION_LOG_AFTER_UPDATE_TRIGGERS_BEAN));
		
		System.assertEquals(1, accounts.size());
		
		System.assertEquals('testExtId',accounts[0].LLC_BI__lookupKey__c);
	}
	
	@IsTest
	private static void test_DepositTriggered_FailsCantDeserialize() {
		
		new ABActivator().onActivate();
		String acctId = createAccount().id;
		LLC_BI__Deposit__c deposit = createDeposit(acctId);
				
		Test.startTest();
		nFUSE__Transaction_Log__c testLog = insertTransactionLogWithLoan(ABConfiguration.DEPOSITBOOKACTION,deposit.Id);
		updateTransactionLogWithLoan(deposit.Id,ABConfiguration.DEPOSIT_COMPLETE,'cantdeserializethis');
		Test.stopTest();
		
		List<LLC_BI__Deposit__c> deposits = [SELECT Id, LLC_BI__lookupKey__c FROM LLC_BI__Deposit__c];

		System.assertEquals(true,nFORCE.BeanRegistry.getInstance().isRegistered(ABConfiguration.TRANSACTION_LOG_AFTER_UPDATE_TRIGGERS_BEAN));
		
		System.assertEquals(1, deposits.size());
		
		System.assertEquals(true,String.isBlank(deposits[0].LLC_BI__lookupKey__c));
	}
	
	
	@IsTest
	private static void test_CustomerTriggered_FailsCantDeserialize() {
		
		new ABActivator().onActivate();
		
		Account account = createAccount();
		
		Test.startTest();
		nFUSE__Transaction_Log__c testLog = insertTransactionLogWithLoan(ABConfiguration.CUSTOMERBOOKACTION,account.Id);
		updateTransactionLogWithLoan(account.Id,ABConfiguration.CUSTOMER_COMPLETE,'cantdeserializethis');
		Test.stopTest();
		
		List<Account> accounts = [SELECT Id, LLC_BI__lookupKey__c FROM Account];

		System.assertEquals(true,nFORCE.BeanRegistry.getInstance().isRegistered(ABConfiguration.TRANSACTION_LOG_AFTER_UPDATE_TRIGGERS_BEAN));
		
		System.assertEquals(1, accounts.size());
		
		System.assertEquals(true,String.isBlank(accounts[0].LLC_BI__lookupKey__c));
	}
	
}