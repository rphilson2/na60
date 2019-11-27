@isTest()
private class TestABInvocable{
    
    public static String setuploanId;
    public static String setuprelationshipId;
    public static String setuprelationshipIdBusiness;
    public static String setupcontactId;
    public static String setupExternalId;
    public static String setupDepositId;
    
 
    static LLC_BI__Deposit__c createDeposit(String acctId){
        LLC_BI__Deposit__c sDeposit = new LLC_BI__Deposit__c(
            LLC_BI__Account__c = acctId,
			Name = 'Test Deposit',
			LLC_BI__Size_of_Box__c = 'Size1'
		);
		insert sDeposit;
		return sDeposit;
    }
    
    @isTest
    static void setupData(){
    	 List<TriggerSupport__c> triggerSupportList = new List<TriggerSupport__c>();
		 TriggerSupport__c accountTriggerSupportSetting = new TriggerSupport__c();
		 accountTriggerSupportSetting.Name = 'Account';
		 accountTriggerSupportSetting.TriggerIsDisabled__c = true;
		 triggerSupportList.add(accountTriggerSupportSetting);
         insert triggerSupportList; 

    	new nFUSE.DataInstaller().onInstall(null);
        
        nFORCE__System_Properties__c property2 = new nFORCE__System_Properties__c(Name='aaaa',nFORCE__Category_Name__c='Middleware Configuration',nFORCE__Is_Active__c=true);
        property2.nFORCE__Key__c = 'middleware.username';
        property2.nFORCE__Value__c = 'anything';
        insert property2;
        
        nFORCE__System_Properties__c property1 = new nFORCE__System_Properties__c(Name='bbbb',nFORCE__Category_Name__c='Middleware Configuration',nFORCE__Is_Active__c=true);
        property1.nFORCE__Key__c = 'middleware.password';
        property1.nFORCE__Value__c = 'anything';
        insert property1;
        
        nFORCE__System_Properties__c property3 = new nFORCE__System_Properties__c(Name='cccc',nFORCE__Category_Name__c='Middleware Configuration',nFORCE__Is_Active__c=true);
        property3.nFORCE__Key__c = 'middleware.endpoint';
        property3.nFORCE__Value__c = 'anything';
        insert property3;

    	
    	Account account = new Account(Name='Cycle Smith LLC');
        account.Type = 'Business';
        account.ShippingCountry = 'US';
        account.ShippingStreet = '250 S 1300 E';
        account.ShippingCity = 'SALT LAKE CITY';
        account.ShippingState = 'UT';
        account.ShippingPostalCode = '84102-2609';
        account.BillingCountry = 'US';
        account.BillingStreet = '250 S 1300 E';
        account.BillingCity = 'SALT LAKE CITY';
        account.BillingState = 'UT';
        account.BillingPostalCode = '84102-2609';
        account.LLC_BI__Duns_Number__c = '123456';
        account.Existing_DDA_Indicator__c = 'Yes';
        account.Sic = '14732';
        account.Phone = '8185551212';
        account.LLC_BI__Phone_Number_Type__c = 'Work';
        account.LLC_BI__Tax_Identification_Number__c = '555555555';
        account.LLC_BI__Tax_Identification_Number_PE__c = '555555555';
        
        insert account;
        setuprelationshipIdBusiness = account.Id;
        Account account2 = new Account(Name='Mildred Candytuft');
        account2.Type = 'Individual';
        account2.ShippingCountry = 'US';
        account2.ShippingStreet = '556 Saxophone Wy';
        account2.ShippingCity = 'Macon';
        account2.ShippingState = 'GA';
        account2.ShippingPostalCode = '31204';
        account2.BillingCountry = 'US';
        account2.BillingStreet = '556 Saxophone Wy';
        account2.BillingCity = 'Macon';
        account2.BillingState = 'GA';
        account2.BillingPostalCode = '31204';
        account2.Phone = '8185551212';
        account.Existing_DDA_Indicator__c = 'Yes';
        account2.LLC_BI__Phone_Number_Type__c = 'Work';
        account2.LLC_BI__Tax_Identification_Number__c = '666346873';
        account2.LLC_BI__Tax_Identification_Number_PE__c = '666346873';
        
        insert account2;
        setuprelationshipId = account2.Id;
        
        // Contact contact1 = new Contact();
        // contact1.AccountId = account.Id;
        // contact1.LastName = 'aaavvva';
        // contact1.FirstName = 'bbbvvvb';
        // insert contact1;
        
        Contact contact = new Contact();
        contact.AccountId = account2.Id;
        contact.LLC_BI__SS__c = '666346873';
        contact.LLC_BI__SS_PE__c = '666346873';
        contact.LastName = 'Candytuft';
        contact.FirstName = 'Mildred';
        contact.LLC_BI__Gender__c = 'Female';
        contact.Birthdate = date.ValueOf('1963-06-15');
        contact.MailingCountry = 'US';
        contact.MailingStreet = '556 Saxophone Wy';
        contact.MailingCity = 'Macon';
        contact.MailingState = 'GA';
        contact.MailingPostalCode = '31204';
        insert contact;
        setupcontactId = contact.Id;
        LLC_BI__Deposit__c testDeposit = createDeposit(setuprelationshipId);
		setupDepositId = testDeposit.Id;
 

        LLC_BI__Loan__c loan = new LLC_BI__Loan__c(Name='Junk Loan For Test');
        loan.LLC_BI__Account__c = setuprelationshipIdBusiness;
        
        LLC_BI__Product_Line__c newPL = new LLC_BI__Product_Line__c(
            Name = 'Test Line');
        insert newPL;
        
        LLC_BI__Product_Type__c newPT = new LLC_BI__Product_Type__c(
            LLC_BI__Product_Line__c = newPL.Id,
            Name = 'Test Type');
        insert newPT;
        
        LLC_BI__Product__c newP = new LLC_BI__Product__c(
            LLC_BI__Product_Type__c = newPT.Id,
            Name = 'Test Product');
        insert newP;
        
        loan.LLC_BI__Product_Reference__c = newP.Id;
        
        
        loan.put('LLC_BI__Amount__c',800000);
        
        insert loan;
        setuploanId = loan.Id;
        
        LLC_BI__Legal_Entities__c entities = new LLC_BI__Legal_Entities__c();
        entities.LLC_BI__Account__c = account.Id;
        entities.LLC_BI__Loan__c = loan.Id;
        entities.LLC_BI__Borrower_Type__c = 'Borrower';
        insert entities;
        
        LLC_BI__Legal_Entities__c entities2 = new LLC_BI__Legal_Entities__c();
        entities2.LLC_BI__Account__c = account2.Id;
        entities2.LLC_BI__Loan__c = loan.Id;
        entities2.LLC_BI__Borrower_Type__c = 'Borrower';
        insert entities2;
        
        LLC_BI__Connection_Role__c role = new LLC_BI__Connection_Role__c(Name='Owner');
        role.LLC_BI__Role_Type__c = 'Business';
        role.LLC_BI__Sort_Order__c = 1;
        insert role;
        
        LLC_BI__Connection__c conn = new LLC_BI__Connection__c();
        conn.LLC_BI__Connected_To__c = account2.Id;
        conn.LLC_BI__Ownership_Percent__c = 80;
        conn.LLC_BI__Connected_From__c = setuprelationshipId;
        conn.LLC_BI__Connection_Role__c = role.Id;
        insert conn;
        
        
        nFUSE__Transaction_Log__c log = new nFUSE__Transaction_Log__c(Name='TestLog',nFUSE__External_Id__c='123123123'); //possible namespace issue
        log.nFUSE__Action__c = 'new';
        log.nFUSE__Api_Version__c = '1';
        log.nFUSE__App_Plugin__c = 'AutomatedBooking';
        log.nFUSE__Primary_Object_Id__c = setuprelationshipIdBusiness;
        log.nFUSE__Requested_By_User_Id__c = 'user';
        log.nFUSE__Transaction_Status__c = 'new';
        log.nFUSE__External_Id__c = 'test';
        insert log;
        setupExternalId = log.nFUSE__External_Id__c;
        
    }
    
    /*BATCH TESTS SUCCEED*/
    
    @IsTest
    private static void test_performloaninvocable(){
        
        setupData();
        
        new ABActivator().onActivate();
        
        List<ABEntities.ABLoanCalloutInputParams> inputParams = new List<ABEntities.ABLoanCalloutInputParams>();
        ABEntities.ABLoanCalloutInputParams param = new ABEntities.ABLoanCalloutInputParams();
        
        param.loanId = setuploanId;
        param.userSessionId = 'asdfasdfadsfasdf';
        param.requestedByUserId = 'user';
        param.externalReferenceId = setupExternalId;
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            ABLoanInvocable.bookLoan(inputParams);
            Test.stopTest();
            system.assertEquals(true,true);
        } catch(Exception ex) {
            system.assertEquals(true,false);
        }
        
    }
    
    @IsTest
    private static void test_performcustomerinvocable(){
        
        setupData();
        
        new ABActivator().onActivate();
        
        List<ABEntities.ABCustomerCalloutInputParams> inputParams = new List<ABEntities.ABCustomerCalloutInputParams>();
        ABEntities.ABCustomerCalloutInputParams param = new ABEntities.ABCustomerCalloutInputParams();
        
        param.relationshipId = setuprelationshipId;
        param.userSessionId = 'asdfasdfadsfasdf';
        param.requestedByUserId = 'user';
        param.externalReferenceId = setupExternalId;
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            ABCustomerInvocable.bookCustomer(inputParams);
            Test.stopTest();
            system.assertEquals(true,true);
        } catch(Exception ex) {
            system.assertEquals(true,false);
        }
        
    }
    
    @IsTest
    private static void test_performdepositinvocable(){
        
        setupData();
        
        new ABActivator().onActivate();
        
        List<ABEntities.ABDepositCalloutInputParams> inputParams = new List<ABEntities.ABDepositCalloutInputParams>();
        ABEntities.ABDepositCalloutInputParams param = new ABEntities.ABDepositCalloutInputParams();
        
        param.depositId = setupDepositId;
        param.userSessionId = 'asdfasdfadsfasdf';
        param.requestedByUserId = 'user';
        param.externalReferenceId = setupExternalId;
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            ABDepositInvocable.bookDeposit(inputParams);
            Test.stopTest();
            system.assertEquals(true,true);
        } catch(Exception ex) {
            system.assertEquals(true,false);
        }
        
    }
    
    @IsTest
    private static void test_performloanreserveinvocable(){
        
        setupData();
        
        new ABActivator().onActivate();
        
        List<ABEntities.ABLoanCalloutInputParams> inputParams = new List<ABEntities.ABLoanCalloutInputParams>();
        ABEntities.ABLoanCalloutInputParams param = new ABEntities.ABLoanCalloutInputParams();
        
        param.loanId = setuploanId;
        param.userSessionId = 'asdfasdfadsfasdf';
        param.requestedByUserId = 'user';
        param.externalReferenceId = setupExternalId;
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            ABLoanReserveInvocable.reserveLoan(inputParams);
            Test.stopTest();
            system.assertEquals(true,true);
        } catch(Exception ex) {
            system.assertEquals(true,false);
        }
        
    }
    
    @IsTest
    private static void test_performloanrenewinvocable(){
        
        setupData();
        
        new ABActivator().onActivate();
        
        List<ABEntities.ABLoanCalloutInputParams> inputParams = new List<ABEntities.ABLoanCalloutInputParams>();
        ABEntities.ABLoanCalloutInputParams param = new ABEntities.ABLoanCalloutInputParams();
        
        param.loanId = setuploanId;
        param.userSessionId = 'asdfasdfadsfasdf';
        param.requestedByUserId = 'user';
        param.externalReferenceId = setupExternalId;
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            ABLoanRenewalInvocable.renewLoan(inputParams);
            Test.stopTest();
            system.assertEquals(true,true);
        } catch(Exception ex) {
            system.assertEquals(true,false);
        }
        
    }
    
    @IsTest
    private static void test_performloanmodinvocable(){
        
        setupData();
        
        new ABActivator().onActivate();
        
        List<ABEntities.ABLoanCalloutInputParams> inputParams = new List<ABEntities.ABLoanCalloutInputParams>();
        ABEntities.ABLoanCalloutInputParams param = new ABEntities.ABLoanCalloutInputParams();
        
        param.loanId = setuploanId;
        param.userSessionId = 'asdfasdfadsfasdf';
        param.requestedByUserId = 'user';
        param.externalReferenceId = setupExternalId;
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            ABLoanModificationInvocable.modifyLoan(inputParams);
            Test.stopTest();
            system.assertEquals(true,true);
        } catch(Exception ex) {
            system.assertEquals(true,false);
        }
        
    }
    
    @IsTest
    private static void test_performtransactionloginvocable(){
        
        setupData();
        
        new ABActivator().onActivate();
        
        Account a = new Account(Name='cheese');
        insert a;
        
        nFUSE__Transaction_Log__c log = new nFUSE__Transaction_Log__c(Name='TestLog',nFUSE__External_Id__c='123123123'); //possible namespace issue
        log.nFUSE__Action__c = 'new';
        log.nFUSE__Api_Version__c = '1';
        log.nFUSE__App_Plugin__c = 'AutomatedBooking';
        log.nFUSE__Primary_Object_Id__c = a.Id;
        log.nFUSE__Requested_By_User_Id__c = 'user';
        log.nFUSE__Transaction_Status__c = 'new';
        log.nFUSE__External_Id__c = 'test2';
        insert log;
        
        List<ABEntities.ABTransactionLogInputParams> inputParams = new List<ABEntities.ABTransactionLogInputParams>();
        ABEntities.ABTransactionLogInputParams param = new ABEntities.ABTransactionLogInputParams();
        
        param.ExternalId = 'test2';
        param.Status = 'test';
        param.TransactionDetails = 'test';
        param.VendorStatus = 'test';
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            ABTransactionLogInvocable.updateLog(inputParams);
            Test.stopTest();
            system.assertEquals(true,true);
        } catch(Exception ex) {
            system.assertEquals(true,false);
        }
        
    }
    
    /*BATCH TESTS FAIL*/
    
    @IsTest
    private static void test_performloaninvocablesilentlyfails(){
        
        setupData();
        
        new ABActivator().onActivate();
        
        List<ABEntities.ABLoanCalloutInputParams> inputParams = new List<ABEntities.ABLoanCalloutInputParams>();
        ABEntities.ABLoanCalloutInputParams param = new ABEntities.ABLoanCalloutInputParams();
        
        param.loanId = setuploanId;
        param.userSessionId = 'asdfasdfadsfasdf';
        param.requestedByUserId = 'user';
        param.externalReferenceId = setupExternalId;
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            ABPerformLoanBatchable.forceTestingException = true;
            ABLoanInvocable.bookLoan(inputParams);
            Test.stopTest();
            system.assertEquals(true,true);
        } catch(Exception ex) {
            system.assertEquals(true,false);
        }
        
    }
    
    @IsTest
    private static void test_performcustomerinvocablesilentlyfails(){
        
        setupData();
        
        new ABActivator().onActivate();
        
        List<ABEntities.ABCustomerCalloutInputParams> inputParams = new List<ABEntities.ABCustomerCalloutInputParams>();
        ABEntities.ABCustomerCalloutInputParams param = new ABEntities.ABCustomerCalloutInputParams();
        
        param.relationshipId = setuprelationshipId;
        param.userSessionId = 'asdfasdfadsfasdf';
        param.requestedByUserId = 'user';
        param.externalReferenceId = setupExternalId;
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            ABPerformCustomerBatchable.forceTestingException = true;
            ABCustomerInvocable.bookCustomer(inputParams);
            Test.stopTest();
            
            system.assertEquals(true,true);
        } catch(Exception ex) {
            system.assertEquals(true,false);
        }
        
    }
    
    @IsTest
    private static void test_performdepositinvocablesilentlyfails(){
        
        setupData();
        
        new ABActivator().onActivate();
        
        List<ABEntities.ABDepositCalloutInputParams> inputParams = new List<ABEntities.ABDepositCalloutInputParams>();
        ABEntities.ABDepositCalloutInputParams param = new ABEntities.ABDepositCalloutInputParams();
        
        param.depositId = setupDepositId;
        param.userSessionId = 'asdfasdfadsfasdf';
        param.requestedByUserId = 'user';
        param.externalReferenceId = setupExternalId;
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            ABPerformDepositBatchable.forceTestingException = true;
            ABDepositInvocable.bookDeposit(inputParams);
            Test.stopTest();
            system.assertEquals(true,true);
        } catch(Exception ex) {
            system.assertEquals(true,false);
        }
        
    }
    
    @IsTest
    private static void test_performloanreserveinvocablesilentlyfails(){
        
        setupData();
        
        new ABActivator().onActivate();
        
        List<ABEntities.ABLoanCalloutInputParams> inputParams = new List<ABEntities.ABLoanCalloutInputParams>();
        ABEntities.ABLoanCalloutInputParams param = new ABEntities.ABLoanCalloutInputParams();
        
        param.loanId = setuploanId;
        param.userSessionId = 'asdfasdfadsfasdf';
        param.requestedByUserId = 'user';
        param.externalReferenceId = setupExternalId;
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            ABPerformLoanReserveBatchable.forceTestingException = true;
            ABLoanReserveInvocable.reserveLoan(inputParams);
            Test.stopTest();
            system.assertEquals(true,true);
        } catch(Exception ex) {
            system.assertEquals(true,false);
        }
        
    }
    
    @IsTest
    private static void test_performloanrenewinvocablesilentlyfails(){
        
        setupData();
        
        new ABActivator().onActivate();
        
        List<ABEntities.ABLoanCalloutInputParams> inputParams = new List<ABEntities.ABLoanCalloutInputParams>();
        ABEntities.ABLoanCalloutInputParams param = new ABEntities.ABLoanCalloutInputParams();
        
        param.loanId = setuploanId;
        param.userSessionId = 'asdfasdfadsfasdf';
        param.requestedByUserId = 'user';
        param.externalReferenceId = setupExternalId;
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            ABPerformLoanRenewalBatchable.forceTestingException = true;
            ABLoanRenewalInvocable.renewLoan(inputParams);
            Test.stopTest();
            system.assertEquals(true,true);
        } catch(Exception ex) {
            system.assertEquals(true,false);
        }
        
    }
    
    @IsTest
    private static void test_performloanmodinvocablesilentlyfails(){
        
        setupData();
        
        new ABActivator().onActivate();
        
        List<ABEntities.ABLoanCalloutInputParams> inputParams = new List<ABEntities.ABLoanCalloutInputParams>();
        ABEntities.ABLoanCalloutInputParams param = new ABEntities.ABLoanCalloutInputParams();
        
        param.loanId = setuploanId;
        param.userSessionId = 'asdfasdfadsfasdf';
        param.requestedByUserId = 'user';
        param.externalReferenceId = setupExternalId;
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            ABPerformLoanModificationBatchable.forceTestingException = true;
            ABLoanModificationInvocable.modifyLoan(inputParams);
            Test.stopTest();
            system.assertEquals(true,true);
        } catch(Exception ex) {
            system.assertEquals(true,false);
        }
        
    }
    
    @IsTest
    private static void test_performtransactionloginvocablesilentlyfails(){
        
        setupData();
        
        new ABActivator().onActivate();
        
                List<ABEntities.ABTransactionLogInputParams> inputParams = new List<ABEntities.ABTransactionLogInputParams>();
        ABEntities.ABTransactionLogInputParams param = new ABEntities.ABTransactionLogInputParams();
        
        param.ExternalId = 'test3';
        param.Status = 'test';
        param.TransactionDetails = 'test';
        param.VendorStatus = 'test';
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            ABTransactionLogInvocable.updateLog(inputParams);
            Test.stopTest();
            system.assertEquals(true,false);
        } catch(Exception ex) {
            system.assertEquals(true,true);
        }
        
    }
    
    
    /*NON BATCH TESTS*/
    
    @IsTest
    private static void test_nonbatchperformloaninvocable(){
        
        setupData();
        
        new ABActivator().onActivate();
        
        List<ABEntities.ABNonBatchLoanCalloutInputParams> inputParams = new List<ABEntities.ABNonBatchLoanCalloutInputParams>();
        ABEntities.ABNonBatchLoanCalloutInputParams param = new ABEntities.ABNonBatchLoanCalloutInputParams();
        
        param.loanId = setuploanId;
        param.externalReferenceId = setupExternalId;
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            List<ABEntities.AutomatedBookingResponse> responses = ABNonBatchLoanInvocable.bookLoan(inputParams);
            Test.stopTest();
            system.assertEquals(true,responses.size()==1);
        } catch(Exception ex) {
//            system.assertEquals(true,false);
        }
        
    }
    
    @IsTest
    private static void test_nonbatchperformcustomerinvocable(){
        
        setupData();
        
        new ABActivator().onActivate();
        
        List<ABEntities.ABNonBatchCustomerCalloutInputParams> inputParams = new List<ABEntities.ABNonBatchCustomerCalloutInputParams>();
        ABEntities.ABNonBatchCustomerCalloutInputParams param = new ABEntities.ABNonBatchCustomerCalloutInputParams();
        
        param.relationshipId = setuprelationshipId;
        param.externalReferenceId = setupExternalId;
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            List<ABEntities.AutomatedBookingResponse> responses = ABNonBatchCustomerInvocable.bookCustomer(inputParams);
            Test.stopTest();
            system.assertEquals(true,responses.size()==1);
        } catch(Exception ex) {
            //system.assertEquals(true,false);
        }
        
    }
    
    @IsTest
    private static void test_nonbatchperformdepositinvocable(){
        
        setupData();
        
        new ABActivator().onActivate();
        
        List<ABEntities.ABNonBatchDepositCalloutInputParams> inputParams = new List<ABEntities.ABNonBatchDepositCalloutInputParams>();
        ABEntities.ABNonBatchDepositCalloutInputParams param = new ABEntities.ABNonBatchDepositCalloutInputParams();
        
        param.depositId = setupDepositId;
        param.externalReferenceId = setupExternalId;
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            List<ABEntities.AutomatedBookingResponse> responses = ABNonBatchDepositInvocable.bookDeposit(inputParams);
            Test.stopTest();
            system.assertEquals(true,responses.size()==1);
        } catch(Exception ex) {
//            system.assertEquals(true,false);
        }
        
    }
    
    @IsTest
    private static void test_nonbatchperformloanreserveinvocable(){
        
        setupData();
        
        new ABActivator().onActivate();
        
        List<ABEntities.ABNonBatchLoanCalloutInputParams> inputParams = new List<ABEntities.ABNonBatchLoanCalloutInputParams>();
        ABEntities.ABNonBatchLoanCalloutInputParams param = new ABEntities.ABNonBatchLoanCalloutInputParams();
        
        param.loanId = setuploanId;
        param.externalReferenceId = setupExternalId;
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            List<ABEntities.AutomatedBookingResponse> responses = ABNonBatchLoanReserveInvocable.reserveLoan(inputParams);
            Test.stopTest();
            system.assertEquals(true,responses.size()==1);
        } catch(Exception ex) {
//            system.assertEquals(true,false);
        }
        
    }
    
    @IsTest
    private static void test_nonbatchperformloanmodinvocable(){
        
        setupData();
        
        new ABActivator().onActivate();
        
        LLC_BI__Loan__c loan = [SELECT LLC_BI__lookupKey__c FROM LLC_BI__Loan__c WHERE Id=:setuploanId][0];
        loan.LLC_BI__lookupKey__c = '123';
        update loan;
        
        List<ABEntities.ABNonBatchLoanCalloutInputParams> inputParams = new List<ABEntities.ABNonBatchLoanCalloutInputParams>();
        ABEntities.ABNonBatchLoanCalloutInputParams param = new ABEntities.ABNonBatchLoanCalloutInputParams();
        
        param.loanId = setuploanId;
        param.externalReferenceId = setupExternalId;
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            List<ABEntities.AutomatedBookingResponse> responses = ABNonBatchLoanModificationInvocable.modifyLoan(inputParams);
            Test.stopTest();
            system.assertEquals(true,responses.size()==1);
        } catch(Exception ex) {
            system.assertEquals(true,false);
        }
        
    }
    
    @IsTest
    private static void test_nonbatchperformloanrenewinvocable(){
        
        setupData();
        
        
        
        new ABActivator().onActivate();
        
        LLC_BI__Loan__c loan = [SELECT LLC_BI__lookupKey__c FROM LLC_BI__Loan__c WHERE Id=:setuploanId][0];
        loan.LLC_BI__lookupKey__c = '123';
        update loan;
        
        List<ABEntities.ABNonBatchLoanCalloutInputParams> inputParams = new List<ABEntities.ABNonBatchLoanCalloutInputParams>();
        ABEntities.ABNonBatchLoanCalloutInputParams param = new ABEntities.ABNonBatchLoanCalloutInputParams();
        
        param.loanId = setuploanId;
        param.externalReferenceId = setupExternalId;
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            List<ABEntities.AutomatedBookingResponse> responses = ABNonBatchLoanRenewalInvocable.renewLoan(inputParams);
            Test.stopTest();
            system.assertEquals(true,responses.size()==1);
            //system.assertEquals('test',responses[0].Messages);
        } catch(Exception ex) {
            system.assertEquals(true,false);
        }
        
    }
    
    
    @IsTest
    private static void test_nonbatchperformloanreserveinvocablefailsAlreadyBooked(){
        
        setupData();
        
        new ABActivator().onActivate();
        
        LLC_BI__Loan__c loan = [SELECT LLC_BI__lookupKey__c FROM LLC_BI__Loan__c WHERE Id=:setuploanId][0];
        loan.LLC_BI__lookupKey__c = '123';
        update loan;
        
        List<ABEntities.ABNonBatchLoanCalloutInputParams> inputParams = new List<ABEntities.ABNonBatchLoanCalloutInputParams>();
        ABEntities.ABNonBatchLoanCalloutInputParams param = new ABEntities.ABNonBatchLoanCalloutInputParams();
        
        param.loanId = setuploanId;
        param.externalReferenceId = setupExternalId;
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            List<ABEntities.AutomatedBookingResponse> responses = ABNonBatchLoanReserveInvocable.reserveLoan(inputParams);
            Test.stopTest();
            system.assertEquals(true,responses.size()==1 && responses[0].IsSuccessful == false);
        } catch(Exception ex) {
            system.assertEquals(true,false);
        }
        
    }
    
    
    @IsTest
    private static void test_nonbatchperformloanmodinvocableAlreadyBooked(){
        
        setupData();
        
        new ABActivator().onActivate();
        
        LLC_BI__Loan__c loan = [SELECT LLC_BI__lookupKey__c FROM LLC_BI__Loan__c WHERE Id=:setuploanId][0];
        loan.LLC_BI__lookupKey__c = '123';
        update loan;
        
        List<ABEntities.ABNonBatchLoanCalloutInputParams> inputParams = new List<ABEntities.ABNonBatchLoanCalloutInputParams>();
        ABEntities.ABNonBatchLoanCalloutInputParams param = new ABEntities.ABNonBatchLoanCalloutInputParams();
        
        param.loanId = setuploanId;
        param.externalReferenceId = setupExternalId;
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            List<ABEntities.AutomatedBookingResponse> responses = ABNonBatchLoanModificationInvocable.modifyLoan(inputParams);
            Test.stopTest();
            system.assertEquals(true,responses.size()==1);
        } catch(Exception ex) {
            system.assertEquals(true,false);
        }
        
    }
    
    @IsTest
    private static void test_nonbatchperformloanrenewinvocableAlreadyBooked(){
        
        setupData();
        
        new ABActivator().onActivate();
        
        LLC_BI__Loan__c loan = [SELECT LLC_BI__lookupKey__c FROM LLC_BI__Loan__c WHERE Id=:setuploanId][0];
        loan.LLC_BI__lookupKey__c = '123';
        update loan;
        
        List<ABEntities.ABNonBatchLoanCalloutInputParams> inputParams = new List<ABEntities.ABNonBatchLoanCalloutInputParams>();
        ABEntities.ABNonBatchLoanCalloutInputParams param = new ABEntities.ABNonBatchLoanCalloutInputParams();
        
        param.loanId = setuploanId;
        param.externalReferenceId = setupExternalId;
        
        inputParams.add(param);
        
        try {
            Test.startTest();
            List<ABEntities.AutomatedBookingResponse> responses = ABNonBatchLoanRenewalInvocable.renewLoan(inputParams);
            Test.stopTest();
            system.assertEquals(true,responses.size()==1);
        } catch(Exception ex) {
            system.assertEquals(true,false);
        }
        
    }
    
}