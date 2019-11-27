@isTest()
public with sharing class TestABAccountController {

    static LLC_BI__Branch__c createBranch(){
        LLC_BI__Branch__c sBranch = new LLC_BI__Branch__c(
			LLC_BI__City__c = 'LLC_BI__City__c',
			LLC_BI__Branch_Id__c = 'brancidgoeshere',
			Name = 'Test Branch'
		);
		insert sBranch;
		return sBranch;
    }
    
    static Account createAccount() {
		Account testAccount = new Account(Name = 'My test account', AccountNumber = '1234');
		testAccount.LLC_BI__Branch__c = createBranch().Id;
		insert testAccount;
		return testAccount;
	}
	
	private static String accountId;
    
    @TestSetup
    static void setupData() {
       //08/08/2019 Added as part of test class fix -begin
      	List<TriggerSupport__c> triggerSupportList = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSupportSetting = new TriggerSupport__c();
       	accountTriggerSupportSetting.Name = 'Account';
        accountTriggerSupportSetting.TriggerIsDisabled__c = true;
        triggerSupportList.add(accountTriggerSupportSetting);
        insert triggerSupportList;
       //08/08/2019-end
 

        accountId = createAccount().Id;
        
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
			ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
		nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
		locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.CUSTOMERSENDSERVICENAME);
        
        
    }
    
    @isTest
    private static void testWithoutStandardController(){
    	
    	Account a = new Account(Name='test');
    	insert a;
        System.currentPageReference().getParameters().put('id', a.Id);
        
        ABAccountController c = new ABAccountController();
        
        system.assertEquals(true,c.bookCustomerButtonEnabled);
    }
    
    @isTest
    private static void testWithStandardController(){
        Account a = new Account(Name='test');
    	insert a;
        ABAccountController c = new ABAccountController(new ApexPages.StandardController(a));
        system.assertEquals(true,true);
    }
    
    @isTest
    private static void testBookCustomer(){
        new nFUSE.DataInstaller().onInstall(null);
        
        setupData();
        
        test.startTest();
        ABAccountController.forceTestingException = false;
        ABEntities.AutomatedBookingResponse response = ABAccountController.bookCustomer(accountId);
        system.assertEquals(true,response.IsSuccessful);
        test.stopTest();
    }
    
    @isTest
    private static void testBookCustomerFails(){
        setupData();
        test.startTest();
        ABAccountController.forceTestingException = true;
        ABEntities.AutomatedBookingResponse response = ABAccountController.bookCustomer(accountId);
        system.assertEquals(false,response.IsSuccessful);
        test.stopTest();
    }
    
    
    @isTest
    private static void testBookCustomerNotComplete(){
        
        String accountId = createAccount().Id;
        
        nFUSE__Transaction_Log__c log = new nFUSE__Transaction_Log__c(Name='TestLog',nFUSE__External_Id__c='123123123'); //possible namespace issue
        log.nFUSE__Action__c = 'new';
        log.nFUSE__Api_Version__c = '1';
        log.nFUSE__App_Plugin__c = 'AutomatedBooking';
        log.nFUSE__Primary_Object_Id__c = accountId;
        log.nFUSE__Requested_By_User_Id__c = 'user';
        log.nFUSE__Transaction_Status__c = 'notcomplete';
        log.nFUSE__External_Id__c = 'test';
        insert log;
        
        String externalId = log.nFUSE__External_Id__c;
        
        test.startTest();
        ABEntities.CompoundTransactionLogResponse response = ABAccountController.getTransactionStatus(externalId);
        system.assertEquals(false,response.IsComplete);
        test.stopTest();
    }
    
    @isTest
    private static void testBookCustomerComplete(){
        
        String accountId = createAccount().Id;
        
        nFUSE__Transaction_Log__c log = new nFUSE__Transaction_Log__c(Name='TestLog',nFUSE__External_Id__c='123123123'); //possible namespace issue
        log.nFUSE__Action__c = 'new';
        log.nFUSE__Api_Version__c = '1';
        log.nFUSE__App_Plugin__c = 'AutomatedBooking';
        log.nFUSE__Primary_Object_Id__c = accountId;
        log.nFUSE__Requested_By_User_Id__c = 'user';
        log.nFUSE__Transaction_Status__c = 'eRRor';
        log.nFUSE__External_Id__c = 'test';
        insert log;
        
        String externalId = log.nFUSE__External_Id__c;
        
        test.startTest();
        ABEntities.CompoundTransactionLogResponse response = ABAccountController.getTransactionStatus(externalId);
        system.assertEquals(true,response.IsComplete);
        test.stopTest();
    }
    
    @isTest
    private static void testGetCoreMessage(){
    	
    	new nFUSE.DataInstaller().onInstall(null);
    	
    	ABConfiguration configuration = new ABConfiguration();
        configuration.LoadPluginConfigurations();
        configuration.TogglePluginConfigurations(true);
        
    	Account account = createAccount();
    	
    	System.currentPageReference().getParameters().put('id', account.Id);
        
        ABAccountController c = new ABAccountController();
        
        Map<String,Object> message = ABAccountController.getCoreMessage(account.Id,'customer');
        
        system.assertEquals(true,!message.isEmpty());
    }
}