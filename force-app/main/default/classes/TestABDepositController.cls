@isTest()
public with sharing class TestABDepositController {
    
    public static String setupExternalId;
    
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
	
	private static String depositId;
	
	
    @testSetup
    static void setupData() {
        List<TriggerSupport__c> triggerSupportList = new List<TriggerSupport__c>();
     	TriggerSupport__c accountTriggerSupportSetting = new TriggerSupport__c();
     	accountTriggerSupportSetting.Name = 'Account';
     	accountTriggerSupportSetting.TriggerIsDisabled__c = true;
     	triggerSupportList.add(accountTriggerSupportSetting);
     	insert triggerSupportList; 
        
        String accountId = createAccount().Id;
        depositId = createDeposit(accountId).Id;
        
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
			ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
		nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
		locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.DEPOSITSENDSERVICENAME);
       
    }
    
    @isTest
    private static void testWithoutStandardController(){
    	
        String accountId = createAccount().Id;
    	LLC_BI__Deposit__c deposit = createDeposit(accountId);
        System.currentPageReference().getParameters().put('id', deposit.Id);
        
        ABDepositController c = new ABDepositController();
        
        system.assertEquals(true,c.bookDepositButtonEnabled);
    }
    
    @isTest
    private static void testWithStandardController(){
        String accountId = createAccount().Id;
    	LLC_BI__Deposit__c deposit = createDeposit(accountId);
        System.currentPageReference().getParameters().put('id', deposit.Id);

        ABDepositController c = new ABDepositController(new ApexPages.StandardController(deposit));
        system.assertEquals(true,c.bookDepositButtonEnabled);
    }
    
    @isTest
    private static void testBookDeposit(){
        new nFUSE.DataInstaller().onInstall(null);
        
        setupData();
        String accountId = createAccount().Id;
       nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        ABDepositController c = new ABDepositController();
        nFUSE__Transaction_Log__c log = new nFUSE__Transaction_Log__c(Name='TestLog',nFUSE__External_Id__c='123123123'); //possible namespace issue
        log.nFUSE__Action__c = 'new';
        log.nFUSE__Api_Version__c = '1';
        log.nFUSE__App_Plugin__c = 'AutomatedBooking';
        log.nFUSE__Primary_Object_Id__c = accountId;
        log.nFUSE__Requested_By_User_Id__c = 'user';
        log.nFUSE__Transaction_Status__c = 'new';
        log.nFUSE__External_Id__c = 'test';
        insert log;
        setupExternalId = log.nFUSE__External_Id__c;        
        String depositId = createDeposit(accountId).Id;
        ABOrchestrator orch = new ABOrchestrator();

        test.startTest();
        Boolean should = orch.ShouldBookDeposit(depositId);
        ABDepositController.forceTestingException = false;
        
        try {
        ABEntities.AutomatedBookingResponse responseDep = ABDepositController.bookDeposit(depositId);
          system.debug(responseDep);
          system.assertNotEquals(null, responseDep); 
        } catch(Exception e){
            system.assertEquals(true,e.getMessage().toLowerCase().contains('There was an error'));
        }
        test.stopTest();
        //To prove that the underlying call to ABOrchestartor with a parameter works fine. 
/*        ABEntities.AutomatedBookingResponse response = orch.BookDeposit(depositId,null,null,setupExternalId,null);
            nFUSE__Transaction_Log__c transactionLog = [
            SELECT
                Id,
                CreatedDate,
                nFUSE__Transaction_Status__c
            FROM
                nFUSE__Transaction_Log__c
            WHERE
                nFUSE__External_Id__c = :setupExternalId
        ][0];*/
        //to prove that depositId exists
        //system.assertEquals(true,should);
        
        //system.assertEquals(true,response.IsSuccessful);
        //To prove that the underlying call to ABOrchestartor with a parameter works fine. 
        //system.assertEquals(ABConfiguration.IN_PROGRESS_STATUS,transactionLog.nFUSE__Transaction_Status__c);
        
    }
    
    @isTest
    private static void testBookDepositFails(){
        setupData();
        test.startTest();
        ABDepositController.forceTestingException = true;
        ABEntities.AutomatedBookingResponse response = ABDepositController.bookDeposit(depositId);
        system.assertEquals(false,response.IsSuccessful);
        test.stopTest();
    }
    
    
    @isTest
    private static void testBookDepositNotComplete(){
        
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
        ABEntities.CompoundTransactionLogResponse response = ABDepositController.getTransactionStatus(externalId);
        system.assertEquals(false,response.IsComplete);
        test.stopTest();
    }
    
    @isTest
    private static void testBookDepositComplete(){
        
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
        ABEntities.CompoundTransactionLogResponse response = ABDepositController.getTransactionStatus(externalId);
        system.assertEquals(true,response.IsComplete);
        test.stopTest();
    }
    
    @isTest
    private static void testGetCoreMessage(){
    	
    	new nFUSE.DataInstaller().onInstall(null);
    	
    	ABConfiguration configuration = new ABConfiguration();
        configuration.LoadPluginConfigurations();
        configuration.TogglePluginConfigurations(true);
         String accountId = createAccount().Id;
    	LLC_BI__Deposit__c deposit = createDeposit(accountId);
    	
    	System.currentPageReference().getParameters().put('id', deposit.Id);
        
        ABDepositController c = new ABDepositController();
        
        Map<String,Object> message = ABDepositController.getCoreMessage(deposit.Id,'deposit');
        
        system.assertEquals(true,!message.isEmpty());
    }
    
}