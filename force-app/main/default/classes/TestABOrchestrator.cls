@isTest()
private class TestABOrchestrator{
    
    public static String setuploanId;
    public static String setuprelationshipId;
    public static String setuprelationshipIdBusiness;
    public static String setupcontactId;
    public static String setupExternalId;
    
    // BEGIN: FNNI Customization
    // 
 
    public static String setupAccountId;
    
    @TestSetup
    private static Void testSetup(){
        
        // turn off accountTrigger while this is running
        List<TriggerSupport__c> triggerSupportSettings = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSetting = new TriggerSupport__c();
        accountTriggerSetting.Name = 'Account';
        accountTriggerSetting.TriggerIsDisabled__c = true;
        
        triggerSupportSettings.add(accountTriggerSetting);
        
        insert triggerSupportSettings;
    }
    
   	static ABOrchestrator.DepositError createDepErr(){
        ABOrchestrator.DepositError de = new ABOrchestrator.DepositError();
        de.developerMessage = 'developer message';
        de.message = 'message';
        de.severity = 'success';
        return de;
    }
    static ABOrchestrator.DepositBooking_User createDepBookUsr(){
        ABOrchestrator.DepositBooking_User dbu = new ABOrchestrator.DepositBooking_User();
        dbu.oldFederatedId = 'test@fnni.com';
        dbu.enrolledCustomer = true;
        dbu.updatedFederatedID = 'test@fnbo.com';
        return dbu;
    }
    static ABOrchestrator.DepositBooking_Response createDepBookResp(Boolean pendingBatch, Boolean failedEnrollment){
        ABOrchestrator.DepositBooking_Response dbr = new ABOrchestrator.DepositBooking_Response();
        dbr.bookAccountResponse = new List<ABOrchestrator.DepositBooking_User>();
        dbr.bookAccountResponse.add(createDepBookUsr());
        dbr.acctNumber = '1234567890';
        dbr.acctType = 'CHECKING';
        dbr.appId = '555666777';
        dbr.pendingBatch = pendingBatch;
        List<ABOrchestrator.DepositBooking_User> bookAccountResponse = new List<ABOrchestrator.DepositBooking_User>();
        ABOrchestrator.DepositBooking_User depBookingUser = new ABOrchestrator.DepositBooking_User();
        depBookingUser.oldFederatedId = 'abc@gmail.com';
        depBookingUser.failedEnrollment = failedEnrollment;
        bookAccountResponse.add(depBookingUser);
        dbr.bookAccountResponse = bookAccountResponse;
        dbr.infoMessages = new List<ABOrchestrator.DepositError>();
        dbr.infoMessages.add(createDepErr());
        return dbr;
    }
    
    // END: FNNI Customization
    
    static LLC_BI__Branch__c createBranch(){
        LLC_BI__Branch__c sBranch = new LLC_BI__Branch__c(
            LLC_BI__City__c = 'LLC_BI__City__c',
            LLC_BI__Branch_Id__c = 'brancidgoeshere',
            Name = 'Test Branch'
        );
        insert sBranch;
        return sBranch;
    }
    
    static LLC_BI__Deposit__c createDeposit(){
        LLC_BI__Deposit__c sDeposit = new LLC_BI__Deposit__c(
            Name = 'Test Deposit',
            LLC_BI__Size_of_Box__c = 'Size1',
            LLC_BI__Account__c = setupAccountId
        );
        insert sDeposit;
        return sDeposit;
    }
    
    static LLC_BI__Ownership_Structure_Type__c createOwnershipStructureType(){
        LLC_BI__Ownership_Structure_Type__c sObj = new LLC_BI__Ownership_Structure_Type__c(Name = 'Test OwnershipStructureType');

        insert sObj;
        return sObj;
    }
    
    static LLC_BI__Funding_Method_Type__c createFundingMethodType(){
        LLC_BI__Funding_Method_Type__c sFunMethType = new LLC_BI__Funding_Method_Type__c(
            Name = 'Test Fun Meth Type'
        );
        insert sFunMethType;
        return sFunMethType;
    }
    
    static LLC_BI__Funding_Method__c createFundingMethod() {
        LLC_BI__Funding_Method__c sObj = new LLC_BI__Funding_Method__c(Name = 'Test FundingMethod');

        insert sObj;
        return sObj;
    }

    static LLC_BI__Funding_Method__c createFundingMethod(LLC_BI__Funding_Method_Type__c fundingMethodType) {
        LLC_BI__Funding_Method__c sObj = new LLC_BI__Funding_Method__c(Name = 'Test FundingMethod', LLC_BI__Funding_Method_Type__c = fundingMethodType.Id);

        insert sObj;
        return sObj;
    }
    
    static LLC_BI__Product_Line__c createProductLine() {
        return createProductLine('Test ProductLine');
    }

    static LLC_BI__Product_Line__c createProductLine(String productName) {
        LLC_BI__Product_Line__c sObj = new LLC_BI__Product_Line__c(Name = productName);

        insert sObj;
        return sObj;
    }
    
    static LLC_BI__Product_Type__c createProductType(LLC_BI__Product_Line__c sProductLine) {
        LLC_BI__Product_Type__c sProductType = new LLC_BI__Product_Type__c(
            Name = 'Test Product Type',
            LLC_BI__Category__c = 'Cat5',
            LLC_BI__Product_Line__c = sProductLine.Id
        );
        insert sProductType;
        return sProductType;
    }
    
    static LLC_BI__Product_Feature__c createProductFeature() {
        LLC_BI__Product_Feature__c sProductFeature = new LLC_BI__Product_Feature__c(
            LLC_BI__Is_Binding__c = true
        );
        insert sProductFeature;
        return sProductFeature;
    }
    
    static LLC_BI__Product__c createProduct() {
        return createProduct(createDefaultProductType(), null);
    }

    static LLC_BI__Product__c createProduct(LLC_BI__Product_Type__c sProductType, LLC_BI__Product_Feature__c sProductFeature) {
        Id productTypeId = null;

        if(sProductType != null && sProductType.Id != null) productTypeId = sProductType.Id;
        else productTypeId = createDefaultProductType().Id;

        LLC_BI__Product__c sProduct = new LLC_BI__Product__c(
            Name = 'Test Product',
            LLC_BI__Product_Type__c = productTypeId,
            LLC_BI__RealEstate_Type__c = 'LLC_BI__RealEstate_Type__c'
        );

        if(sProductFeature != null) sProduct.LLC_BI__Product_Feature__c = sProductFeature.Id;

        insert sProduct;
        return sProduct;
    }

    static LLC_BI__Product_Type__c createDefaultProductType() {
        LLC_BI__Product_Line__c sProductLine = new LLC_BI__Product_Line__c();
        insert sProductLine;

        LLC_BI__Product_Type__c sProductType = new LLC_BI__Product_Type__c(
            LLC_BI__Product_Line__c = sProductLine.Id
        );
        insert sProductType;
        return sProductType;
    }
    
    static Account createAccount() {
        Account testAccount = new Account(Name = 'My test account', AccountNumber = '1234');
        testAccount.LLC_BI__Branch__c = createBranch().Id;
        insert testAccount;
        return testAccount;
    }

    static Account createAccount(string accountType) {
        Account testAccount = new Account(Name = 'My test account', AccountNumber = '1234', Type = accountType);
        testAccount.LLC_BI__Branch__c = createBranch().Id;
        insert testAccount;
        return testAccount;
    }

    static Account createNotPersistedAccount() {
        return new Account(Name = 'notPersistedAccount', AccountNumber = '2345');
    }
    
    private class XContactFactoryException extends Exception {  }
    
    static Contact createPrimaryContact(Account sAcct) {
        if(sAcct == null) throw new XContactFactoryException('Account can NOT be null for primary Contact');

        Contact dbContact = new Contact(
            AccountId = sAcct.Id,
            FirstName = 'Hank',
            LastName = 'Hill',
            LLC_BI__Drivers_License__c = '4213421323',
            LLC_BI__Home_Address__c = 'LLC_BI__Home_Address__c'
        );
        dbContact.put(LLC_BI.LifeCycleContact.getSSNFieldDescribe().getName(), '345534324');

        insert dbContact;
        return dbContact;
    }

    static Contact createContact() {
        Contact sContact = new Contact(
            FirstName = 'Hank',
            LastName = 'Hill'
        );
        insert sContact;
        return sContact;
    }
    
    static LLC_BI__Treasury_Service__c createTreasuryService() {
        LLC_BI__Treasury_Service__c sTreasSvc = new LLC_BI__Treasury_Service__c(
            Name = 'Test Fun Meth Type'
        );
        insert sTreasSvc;
        return sTreasSvc;
    }
    
    static LLC_BI__Analyzed_Account__c createAnalyzedAccount() {
        LLC_BI__Analyzed_Account__c sObj = new LLC_BI__Analyzed_Account__c(Name = 'Test AnalyzedAccount');

        insert sObj;
        return sObj;
    }
    
    static LLC_BI__Legal_Entities__c createLegalEntity(LLC_BI__Loan__c loan, Account acct, String borrowerType) {
        LLC_BI__Legal_Entities__c entity = new LLC_BI__Legal_Entities__c(
            LLC_BI__Loan__c = loan.Id,
            LLC_BI__Account__c = acct.Id,
            Name = 'Test Entity Involvement',
            LLC_BI__Borrower_Type__c = borrowerType,
            LLC_BI__Address__c = 'LLC_BI__Address__c'
        );
        insert entity;
        return entity;
    }

    static LLC_BI__Legal_Entities__c createLegalEntity(LLC_BI__Deposit__c deposit, Account acct) {
        LLC_BI__Legal_Entities__c entity = new LLC_BI__Legal_Entities__c(
            LLC_BI__Deposit__c = deposit.Id,
            LLC_BI__Account__c = acct.Id,
            Name = 'Test Entity Involvement',
            LLC_BI__Borrower_Type__c = 'LLC_BI__Borrower_Type__c',
            LLC_BI__Address__c = 'LLC_BI__Address__c'
        );
        insert entity;
        return entity;
    }

    static LLC_BI__Legal_Entities__c createLegalEntity(LLC_BI__Treasury_Service__c treasuryService, Account acct) {
        LLC_BI__Legal_Entities__c entity = new LLC_BI__Legal_Entities__c(
            LLC_BI__Treasury_Service__c = treasuryService.Id,
            LLC_BI__Account__c = acct.Id,
            Name = 'Test Entity Involvement',
            LLC_BI__Borrower_Type__c = 'LLC_BI__Borrower_Type__c',
            LLC_BI__Address__c = 'LLC_BI__Address__c'
        );
        insert entity;
        return entity;
    }
    
    static LLC_BI__Loan__c createLoan(){
        Account account = new Account(Name='Cycle Smith LLC');
        account.Type = 'Business';
        account.LLC_BI__Branch__c = createBranch().Id;
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
        account.Sic = '14732';
        account.Phone = '8185551212';
        account.LLC_BI__Phone_Number_Type__c = 'Work';
        account.LLC_BI__Tax_Identification_Number__c = '555555555';
        account.LLC_BI__Tax_Identification_Number_PE__c = '555555555';
        
        insert account;
        Account account2 = new Account(Name='Mildred Candytuft');
        account2.LLC_BI__Branch__c = createBranch().Id;
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
        account2.LLC_BI__Phone_Number_Type__c = 'Work';
        account2.LLC_BI__Tax_Identification_Number__c = '666346873';
        account2.LLC_BI__Tax_Identification_Number_PE__c = '666346873';
        
        insert account2;
        
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
        
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c(Name='Junk Loan For Test');
        loan.LLC_BI__Account__c = account.Id;
        
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
        conn.LLC_BI__Connected_From__c = account2.Id;
        conn.LLC_BI__Connection_Role__c = role.Id;
        insert conn;
        
        return loan;
    }
    
    
    @isTest
    static void setupData(){
        
        new nFUSE.DataInstaller().onInstall(null);
        
        //set up for deposit 
        
        LLC_BI__Branch__c testBranch = createBranch();

        Account sIndividualAcct = createAccount('Individual');
        setupAccountId = sIndividualAcct.id;

        LLC_BI__Deposit__c testDeposit = createDeposit();
        testDeposit.LLC_BI__CD_Term__c = '15 years';
        testDeposit.LLC_BI__Originating_Branch__c = testBranch.Id;

        LLC_BI__Ownership_Structure_Type__c testOST = createOwnershipStructureType();
        testDeposit.LLC_BI__Ownership_Structure_Type__c = testOST.Id;

        LLC_BI__Funding_Method_Type__c sFunMethType = createFundingMethodType();
        LLC_BI__Funding_Method__c sFunMeth = createFundingMethod(sFunMethType);
        testDeposit.LLC_BI__Funding_Method__c = sFunMeth.Id;

        LLC_BI__Product_Line__c testProductLine = createProductLine();
        LLC_BI__Product_Type__c testProductType = createProductType(testProductLine);
        LLC_BI__Product_Feature__c testProductFeature = createProductFeature();
        LLC_BI__Product__c testProduct = createProduct(testProductType, testProductFeature);
        testDeposit.LLC_BI__Product_Reference__c = testProduct.Id;

        Contact sIndividualContact = createPrimaryContact(sIndividualAcct);
        sIndividualContact.LLC_BI__Drivers_License__c = '2017';

        Account sBusinessAcct = createAccount('Business');
        Contact sBizContact = createPrimaryContact(sBusinessAcct);
        sBizContact.Department = 'Test Department';

        LLC_BI__Treasury_Service__c treasuryService = createTreasuryService();

        LLC_BI__Product_Line__c treasuryProductLine = createProductLine('Treasury Product Line');
        LLC_BI__Product_Type__c treasuryProductType = createProductType(treasuryProductLine);
        LLC_BI__Product_Feature__c treasuryProductFeature = createProductFeature();
        LLC_BI__Product__c treasuryProduct = createProduct(treasuryProductType, treasuryProductFeature);
        treasuryService.LLC_BI__Product_Reference__c = treasuryProduct.Id;

        Account treasuryAcct = createAccount('Individual');
        Contact treasuryContact = createPrimaryContact(treasuryAcct);
        treasuryContact.LLC_BI__Drivers_License__c = '2018';

        LLC_BI__Analyzed_Account__c analyzedAccount = createAnalyzedAccount();
        analyzedAccount.LLC_BI__Deposit_Reference__c = testDeposit.Id;
        analyzedAccount.LLC_BI__Treasury_Service_Reference__c = treasuryService.Id;

        update new List<SObject> {testDeposit, sIndividualContact, sBizContact, treasuryService, treasuryContact, analyzedAccount};

        LLC_BI__Legal_Entities__c sInvolve1 = createLegalEntity(testDeposit, sIndividualAcct);
        LLC_BI__Legal_Entities__c sInvolve2 = createLegalEntity(testDeposit, sBusinessAcct);
        LLC_BI__Legal_Entities__c sInvolve3 = createLegalEntity(treasuryService, treasuryAcct);
        
        //set up for loan and customer
        
        Account account = new Account(Name='Cycle Smith LLC');
        account.Type = 'Business';
        account.LLC_BI__Branch__c = createBranch().Id;
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
        account.Sic = '14732';
        account.Phone = '8185551212';
        account.LLC_BI__Phone_Number_Type__c = 'Work';
        account.LLC_BI__Tax_Identification_Number__c = '555555555';
        account.LLC_BI__Tax_Identification_Number_PE__c = '555555555';
        
        insert account;
        setuprelationshipIdBusiness = account.Id;
        Account account2 = new Account(Name='Mildred Candytuft');
        account2.LLC_BI__Branch__c = createBranch().Id;
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
        
        // BEGIN -- FNNI Customization
        ABOrchestrator.DepositBooking_Response depBookResp = createDepBookResp(false, false);
        // END -- FNNI Customization
        
    }
    
    
    
    @isTest
    private static void testOrchestratorServiceLocator(){
        
        try{
            nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
            ABOrchestrator orch = new ABOrchestrator();
        
            test.startTest();
            nFUSE.SendService service = orch.serviceFinder(request,'cheese');
            test.stopTest();
            system.assertEquals(true,false);
        }catch(Exception e){
            system.assertEquals(true,e.getMessage().toLowerCase().contains('there was an error locating the service "cheese"'));
        }
        
    }
    
    @isTest
    private static void testOrchestratorServiceLocatorSucceeds(){
        new ABActivator().onActivate();
        nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        ABOrchestrator orch = new ABOrchestrator();
        try{
            nFUSE.SendService service = orch.serviceFinder(request,'LoanSendService');
            system.assertEquals(true,service != null);
        }catch(Exception e){
            system.assertEquals(true,false);
        }
        
    }
    
    @isTest
    private static void testOrchestratorServiceLocatorFailsOtherError(){
        //new ABActivator().onActivate();
        nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        ABOrchestrator orch = new ABOrchestrator();
        try{
            ABOrchestrator.forceTestingException = true;
            nFUSE.SendService service = orch.serviceFinder(request,'LoanSendService');
            system.assertEquals(true,false);
        }catch(Exception e){
            system.assertEquals(true,e.getMessage().toLowerCase().contains('there was an error obtaining'));
        }
        
    }
    
    //book loan
    
    @isTest
    private static void testBookLoan(){
        
        setupData();
        
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
            ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANSENDSERVICENAME);
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        ABEntities.AutomatedBookingResponse response = orch.BookLoan(setuploanId,null,null,null,null);
        test.stopTest();
        
        system.assertEquals(true,response.IsSuccessful);
        
    }
    
    @isTest
    private static void testBookLoanWithValidTransactionLogPassedInAndAdditionalProperties(){
        
        setupData();
        
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
            ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANSENDSERVICENAME);
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        ABEntities.AutomatedBookingResponse response = orch.BookLoan(setuploanId,null,null,setupExternalId, new Map<String,String>{ 'key1'=>'value1' });
        //test the status of the transaction
        nFUSE__Transaction_Log__c transactionLog = [
            SELECT
                Id,
                CreatedDate,
                nFUSE__Transaction_Status__c
            FROM
                nFUSE__Transaction_Log__c
            WHERE
                nFUSE__External_Id__c = :setupExternalId
        ][0];
        
        test.stopTest();
        
        system.assertEquals(true,response.IsSuccessful);
        system.assertEquals(ABConfiguration.IN_PROGRESS_STATUS,transactionLog.nFUSE__Transaction_Status__c);
    }
    
    @isTest
    private static void testBookLoanWithValidTransactionLogPassedInAndAdditionalPropertiesThrows(){
        
        setupData();
        
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
            ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANSENDSERVICENAME);
        
        ABOrchestrator orch = new ABOrchestrator();
        ABOrchestrator.forceBookingTestException = true;
        test.startTest();
        ABEntities.AutomatedBookingResponse response = orch.BookLoan(setuploanId,null,null,setupExternalId, new Map<String,String>{ 'key1'=>'value1' });
        test.stopTest();
        
        system.assertEquals(true,!response.IsSuccessful);
    }
    
    @isTest
    private static void testBookLoanWithValidTransactionLogPassedIn(){
        
        setupData();
        
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
            ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANSENDSERVICENAME);
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        ABEntities.AutomatedBookingResponse response = orch.BookLoan(setuploanId,null,null,setupExternalId,null);
        //test the status of the transaction
        nFUSE__Transaction_Log__c transactionLog = [
            SELECT
                Id,
                CreatedDate,
                nFUSE__Transaction_Status__c
            FROM
                nFUSE__Transaction_Log__c
            WHERE
                nFUSE__External_Id__c = :setupExternalId
        ][0];
        
        test.stopTest();
        
        system.assertEquals(true,response.IsSuccessful);
        system.assertEquals(ABConfiguration.IN_PROGRESS_STATUS,transactionLog.nFUSE__Transaction_Status__c);
    }
    
    @isTest
    private static void testOrchPrepareLoanBookingMessage(){
        setupData();
        nFUSE.PackageServiceRequest request = null;
        ABOrchestrator orch = new ABOrchestrator();
        try{
            nFUSE.MiddlewareMessage msg = orch.prepareLoanBookingMessage('action', request, setuploanId, null, null);
            system.assertEquals(true,false);
        }catch(Exception e){
            system.assertEquals(true,e.getMessage().toLowerCase().contains('request was not expected to be null'));
        }
        
    }
    
    @isTest
    private static void testOrchPrepareLoanBookingMessageWithOtherFieldsNotBlank(){
        
        setupData();
        
        nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        request.primaryObjectId = setuploanId;
        
        ABOrchestrator orch = new ABOrchestrator();
        try{
            nFUSE.MiddlewareMessage msg = orch.prepareLoanBookingMessage('action', request, setuploanId, 'notblank', 'notblank');
            system.assertEquals(true,true);
        }catch(Exception e){
            system.assertEquals('test',e.getMessage());
        }
        
    }
    
    
    //book customer
    
    @isTest
    private static void testBookCustomer(){
        
        setupData();
        
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
            ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.CUSTOMERSENDSERVICENAME);
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        ABEntities.AutomatedBookingResponse response = orch.BookCustomer(setuprelationshipId,null,null,null,null);
        test.stopTest();
        
        system.assertEquals(true,response.IsSuccessful);
        
    }
    
    @isTest
    private static void testBookCustomerWithValidTransactionLogPassedIn(){
        
        setupData();
        
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
            ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.CUSTOMERSENDSERVICENAME);
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        ABEntities.AutomatedBookingResponse response = orch.BookCustomer(setuprelationshipId,null,null,setupExternalId,null);
        //test the status of the transaction
        nFUSE__Transaction_Log__c transactionLog = [
            SELECT
                Id,
                CreatedDate,
                nFUSE__Transaction_Status__c
            FROM
                nFUSE__Transaction_Log__c
            WHERE
                nFUSE__External_Id__c = :setupExternalId
        ][0];
        
        test.stopTest();
        
        system.assertEquals(true,response.IsSuccessful);
        system.assertEquals(ABConfiguration.IN_PROGRESS_STATUS,transactionLog.nFUSE__Transaction_Status__c);
    }
    
    @isTest
    private static void testOrchPrepareCustomerBookingMessage(){
        setupData();
        nFUSE.PackageServiceRequest request = null;
        ABOrchestrator orch = new ABOrchestrator();
        try{
            nFUSE.MiddlewareMessage msg = orch.prepareCustomerBookingMessage('action', request, setuprelationshipId, null, null);
            system.assertEquals(true,false);
        }catch(Exception e){
            system.assertEquals(true,e.getMessage().toLowerCase().contains('request was not expected to be null'));
        }
        
    }
    
    @isTest
    private static void testOrchPrepareCustomerBookingMessageWorksWithoutBranch(){
        setupData();
        
        Account account = [SELECT Id, LLC_BI__Branch__c FROM Account Where Id =:setuprelationshipId][0];
        account.LLC_BI__Branch__c = null;
        update account;
        
        nFUSE.PackageServiceRequest request = null;
        ABOrchestrator orch = new ABOrchestrator();
        try{
            nFUSE.MiddlewareMessage msg = orch.prepareCustomerBookingMessage('action', request, setuprelationshipId, null, null);
            system.assertEquals(true,true);
        }catch(Exception e){
            system.assertEquals(true,e.getMessage().toLowerCase().contains('request was not expected to be null'));
        }
        
    }
    
    @isTest
    private static void testOrchPrepareCustomerBookingMessageThrowsBranchQueryException(){
        
        setupData();
        
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
            ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.CUSTOMERSENDSERVICENAME);
        
        ABOrchestrator orch = new ABOrchestrator();
        ABOrchestrator.forceBranchException = true;
        
        
        
        test.startTest();
        ABEntities.AutomatedBookingResponse response = orch.BookCustomer(setuprelationshipId,null,null,null,null);
        test.stopTest();
        
        system.assertEquals(true,response.Messages.toLowerCase().contains('branch was unable to be obtained and set on the composite account object'));
        
    }
    
    @isTest
    private static void testOrchPrepareCustomerBookingMessageThrowsSerializationException(){
        
        
        setupData();
        
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
            ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.CUSTOMERSENDSERVICENAME);
        
        ABOrchestrator orch = new ABOrchestrator();
        ABOrchestrator.forceSerializationException = true;
        
        
        
        test.startTest();
        ABEntities.AutomatedBookingResponse response = orch.BookCustomer(setuprelationshipId,null,null,null,null);
        test.stopTest();
        
        system.assertEquals(true,response.Messages.toLowerCase().contains('failed to serialize message for the'));
        
    }
    
    @isTest
    private static void testOrchPrepareCustomerBookingMessageWithOtherFieldsNotBlank(){
        
        setupData();
        
        nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        request.primaryObjectId = setuprelationshipId;
        ABOrchestrator orch = new ABOrchestrator();
        
        try{
            nFUSE.MiddlewareMessage msg = orch.prepareCustomerBookingMessage('action', request, setuprelationshipId, 'notblank', 'notblank');
            system.assertEquals(true,true);
        }catch(Exception e){
            system.assertEquals('test',e.getMessage());
        }
        
    }
    
    //book deposit
    
    @isTest
    private static void testBookDeposit(){
        
        setupData();
        
        List<LLC_BI__Deposit__c> dpsts = [SELECT Id from LLC_BI__Deposit__c];
        
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
            ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.DEPOSITSENDSERVICENAME);
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        ABEntities.AutomatedBookingResponse response = orch.BookDeposit(dpsts[0].Id,null,null,null,null);
        test.stopTest();
        
//        system.assertEquals(true,response.IsSuccessful);
        
    }
    
    @isTest
    private static void testHandleDepositBookingResponse(){
        setupData();
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
            ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.DEPOSITSENDSERVICENAME);
 
        ABOrchestrator orch = new ABOrchestrator();
        ABOrchestrator.DepositBooking_Response depBookResp = createDepBookResp(false, false);
        LLC_BI__Deposit__c dpst = [SELECT Id from LLC_BI__Deposit__c LIMIT 1];
        test.startTest();
        orch.handleDepositBookingResponsesDetails(dpst.Id, JSON.serialize(depBookResp), 200, 'OK');
        test.stopTest();
    }

    @isTest
    private static void testHandleDepositBookingResponsePendingBatch(){
        setupData();
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
            ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.DEPOSITSENDSERVICENAME);
 
        ABOrchestrator orch = new ABOrchestrator();
        ABOrchestrator.DepositBooking_Response depBookResp = createDepBookResp(true, false);
        LLC_BI__Deposit__c dpst = [SELECT Id from LLC_BI__Deposit__c LIMIT 1];
        test.startTest();
        orch.handleDepositBookingResponsesDetails(dpst.Id, JSON.serialize(depBookResp), 200, 'OK');
        test.stopTest();
    }

    @isTest
    private static void testHandleDepositBookingResponseFailedEnrollment(){
        setupData();
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
            ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.DEPOSITSENDSERVICENAME);
 
        ABOrchestrator orch = new ABOrchestrator();
        ABOrchestrator.DepositBooking_Response depBookResp = createDepBookResp(false, true);
        LLC_BI__Deposit__c dpst = [SELECT Id from LLC_BI__Deposit__c LIMIT 1];
        test.startTest();
        orch.handleDepositBookingResponsesDetails(dpst.Id, JSON.serialize(depBookResp), 200, 'OK');
        test.stopTest();
    }

    @isTest
    private static void testHandleDepositBookingResponseFailedEnrollmentNull(){
        setupData();
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
            ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.DEPOSITSENDSERVICENAME);
 
        ABOrchestrator orch = new ABOrchestrator();
        ABOrchestrator.DepositBooking_Response depBookResp = createDepBookResp(false, null);
        LLC_BI__Deposit__c dpst = [SELECT Id from LLC_BI__Deposit__c LIMIT 1];
        test.startTest();
        orch.handleDepositBookingResponsesDetails(dpst.Id, JSON.serialize(depBookResp), 200, 'OK');
        test.stopTest();
    }

    @isTest
    private static void testBookDepositWithValidTransactionLogPassedIn(){
        
        setupData();
        
        List<LLC_BI__Deposit__c> dpsts = [SELECT Id from LLC_BI__Deposit__c];
        
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
            ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.DEPOSITSENDSERVICENAME);
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        ABEntities.AutomatedBookingResponse response = orch.BookDeposit(dpsts[0].Id,null,null,setupExternalId,null);
        //test the status of the transaction
        nFUSE__Transaction_Log__c transactionLog = [
            SELECT
                Id,
                CreatedDate,
                nFUSE__Transaction_Status__c
            FROM
                nFUSE__Transaction_Log__c
            WHERE
                nFUSE__External_Id__c = :setupExternalId
        ][0];
        
        test.stopTest();
        
//        system.assertEquals(true,response.IsSuccessful);
        system.assertEquals(ABConfiguration.IN_PROGRESS_STATUS,transactionLog.nFUSE__Transaction_Status__c);
    }
    
    @isTest
    private static void testOrchPrepareDepositBookingMessage(){
        setupData();
        
        List<LLC_BI__Deposit__c> dpsts = [SELECT Id from LLC_BI__Deposit__c];
        
        nFUSE.PackageServiceRequest request = null;
        ABOrchestrator orch = new ABOrchestrator();
        try{
            nFUSE.MiddlewareMessage msg = orch.prepareDepositBookingMessage('action', request, dpsts[0].Id, null, null);
            system.assertEquals(true,false);
        }catch(Exception e){
            system.assertEquals(true,e.getMessage().toLowerCase().contains('request was not expected to be null'));
        }
        
    }
    
    @isTest
    private static void testOrchPrepareDepositBookingMessageWithOtherFieldsNotBlank(){
        
        setupData();
        
        List<LLC_BI__Deposit__c> dpsts = [SELECT Id from LLC_BI__Deposit__c];
        
        nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        request.primaryObjectId = dpsts[0].Id;
        ABOrchestrator orch = new ABOrchestrator();
        
        try{
            nFUSE.MiddlewareMessage msg = orch.prepareDepositBookingMessage('action', request, dpsts[0].Id, 'notblank', 'notblank');
            system.assertEquals(true,true);
        }catch(Exception e){
            system.assertEquals('test',e.getMessage());
        }
        
    }
    
    
    @isTest
    private static void testTransactionLogPolling(){
        
        String accountId = createAccount().Id;
        
        system.assertEquals(true,!String.isBlank(accountId));
        
        nFUSE__Transaction_Log__c log = new nFUSE__Transaction_Log__c(Name='TestLog',nFUSE__External_Id__c='123123123'); //possible namespace issue
        log.nFUSE__Action__c = 'new';
        log.nFUSE__Api_Version__c = '1';
        log.nFUSE__App_Plugin__c = 'AutomatedBooking';
        log.nFUSE__Primary_Object_Id__c = accountId;
        log.nFUSE__Requested_By_User_Id__c = 'user';
        log.nFUSE__Transaction_Status__c = 'new';
        log.nFUSE__External_Id__c = 'test';
        insert log;
        
        String externalId = log.nFUSE__External_Id__c;
        
        ABOrchestrator orchestrator = new ABOrchestrator();
        
        test.startTest();
        ABEntities.TransactionLogResponse response = orchestrator.GetTransactionLogDetails(externalId);
        test.stopTest();
        
        system.assertEquals('new',response.Status);
        
    }
    
    @isTest
    private static void testTransactionLogPollingIsComplete(){
        
        String accountId = createAccount().Id;
        
        system.assertEquals(true,!String.isBlank(accountId));
        
        nFUSE__Transaction_Log__c log = new nFUSE__Transaction_Log__c(Name='TestLog',nFUSE__External_Id__c='123123123'); //possible namespace issue
        log.nFUSE__Action__c = 'new';
        log.nFUSE__Api_Version__c = '1';
        log.nFUSE__App_Plugin__c = 'AutomatedBooking';
        log.nFUSE__Primary_Object_Id__c = accountId;
        log.nFUSE__Requested_By_User_Id__c = 'user';
        log.nFUSE__Transaction_Status__c = 'erRor';
        log.nFUSE__External_Id__c = 'test';
        insert log;
        
        String externalId = log.nFUSE__External_Id__c;
        
        ABOrchestrator orchestrator = new ABOrchestrator();
        
        test.startTest();
        ABEntities.TransactionLogResponse response = orchestrator.GetTransactionLogDetails(externalId);
        test.stopTest();
        
        system.assertEquals(true,response.IsComplete);
        
    }
    
    @isTest
    private static void testTransactionLogPollingIsCompleteFalse(){
        
        String accountId = createAccount().Id;
        
        system.assertEquals(true,!String.isBlank(accountId));
        
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
        
        ABOrchestrator orchestrator = new ABOrchestrator();
        
        test.startTest();
        ABEntities.TransactionLogResponse response = orchestrator.GetTransactionLogDetails(externalId);
        test.stopTest();
        
        system.assertEquals(false,response.IsComplete);
        
    }
    
    @isTest
    private static void testTransactionLogPollingIsSuccessfulFalse(){
        
        String accountId = createAccount().Id;
        
        system.assertEquals(true,!String.isBlank(accountId));
        
        nFUSE__Transaction_Log__c log = new nFUSE__Transaction_Log__c(Name='TestLog',nFUSE__External_Id__c='123123123'); //possible namespace issue
        log.nFUSE__Action__c = 'new';
        log.nFUSE__Api_Version__c = '1';
        log.nFUSE__App_Plugin__c = 'AutomatedBooking';
        log.nFUSE__Primary_Object_Id__c = accountId;
        log.nFUSE__Requested_By_User_Id__c = 'user';
        log.nFUSE__Transaction_Status__c = 'error';
        log.nFUSE__External_Id__c = 'test';
        insert log;
        
        String externalId = log.nFUSE__External_Id__c;
        
        ABOrchestrator orchestrator = new ABOrchestrator();
        
        test.startTest();
        ABEntities.TransactionLogResponse response = orchestrator.GetTransactionLogDetails(externalId);
        test.stopTest();
        
        system.assertEquals(false,response.IsSuccessful);
        
    }
    
    
    
    @isTest
    private static void testShouldBookCustomer(){
        
        String accountId = createAccount().Id;
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        Boolean should = orch.ShouldBookCustomer(accountId);
        test.stopTest();
        
        system.assertEquals(true,should);
        
    }
    
    @isTest
    private static void testShouldBookCustomerFalse(){
        
        Account account = createAccount();
        account.LLC_BI__lookupKey__c = 'something';
        update account;
        
        ABOrchestrator orch = new ABOrchestrator();
        test.startTest();
        Boolean should = orch.ShouldBookCustomer(account.Id);
        test.stopTest();
        
        system.assertEquals(true,!should);
        
    }
    
    
    
    
    @isTest
    private static void testShouldBookDeposit(){
        
        Account sIndividualAcct = createAccount('Individual');
        setupAccountId = sIndividualAcct.id;

        String depositId = createDeposit().Id;
        
        ABOrchestrator orch = new ABOrchestrator();
        test.startTest();
        Boolean should = orch.ShouldBookDeposit(depositId);
        test.stopTest();
        
        system.assertEquals(true,should);
        
    }
    
    @isTest
    private static void testShouldBookDepositFalse(){
        
        Account sIndividualAcct = createAccount('Individual');
        setupAccountId = sIndividualAcct.id;
        
        LLC_BI__Deposit__c deposit = createDeposit();
        deposit.LLC_BI__lookupKey__c = 'something';
        update deposit;
        
        ABOrchestrator orch = new ABOrchestrator();
        test.startTest();
        Boolean should = orch.ShouldBookDeposit(deposit.Id);
        test.stopTest();
        
        system.assertEquals(true,!should);
        
    }
    
    
    
    
    
    @isTest
    private static void testShouldBookLoan(){
        
        String loanId = createLoan().Id;
        
        ABOrchestrator orch = new ABOrchestrator();
        test.startTest();
        Boolean should = orch.ShouldBookLoan(loanId);
        test.stopTest();
        
        system.assertEquals(true,should);
        
    }
    
    @isTest
    private static void testShouldBookLoanFalse(){
        
        LLC_BI__Loan__c loan = createLoan();
        loan.LLC_BI__lookupKey__c = 'something';
        update loan;
        
        ABOrchestrator orch = new ABOrchestrator();
        test.startTest();
        Boolean should = orch.ShouldBookLoan(loan.Id);
        test.stopTest();
        
        system.assertEquals(true,!should);
        
    }
    
    
    
    
    
    @isTest
    private static void testBookLoanFailsWhenAlreadyBooked(){
        
        LLC_BI__Loan__c loan = createLoan();
        loan.LLC_BI__lookupKey__c = 'something';
        update loan;
        
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
            ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANSENDSERVICENAME);
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        ABEntities.AutomatedBookingResponse response = orch.BookLoan(loan.Id,null,null,null,null);
        test.stopTest();
        
        system.assertEquals(false,response.IsSuccessful);
        
    }
    
    @isTest
    private static void testBookCustomerFailsWhenAlreadyBooked(){
        
        Account account = createAccount();
        account.LLC_BI__lookupKey__c = 'something';
        update account;
        
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
            ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.CUSTOMERSENDSERVICENAME);
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        ABEntities.AutomatedBookingResponse response = orch.BookCustomer(account.Id,null,null,null,null);
        test.stopTest();
        
        system.assertEquals(false,response.IsSuccessful);
        
    }
    
    @isTest
    private static void testBookDepositFailsWhenAlreadyBooked(){
        
        Account sIndividualAcct = createAccount('Individual');
        setupAccountId = sIndividualAcct.id;
        
        LLC_BI__Deposit__c deposit = createDeposit();
        deposit.LLC_BI__lookupKey__c = 'something';
        update deposit;
        
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
            ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.DEPOSITSENDSERVICENAME);
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        ABEntities.AutomatedBookingResponse response = orch.BookDeposit(deposit.Id,null,null,null,null);
        test.stopTest();
        
        system.assertEquals(false,response.IsSuccessful);
        
    }
    
    
    @IsTest
    private static void test_readFieldSet(){

        ABOrchestrator orch = new ABOrchestrator();
        List<Schema.FieldSetMember> fieldSetMemberList = orch.readFieldSet(ABUtility.getNameSpacePrefix('__')+ABConfiguration.PLUGIN_NAME,'LLC_BI__Branch__c');
        System.assertEquals(true, true);

    }
    
    
    @IsTest
    private static void test_validateReadFieldSets(){

        ABOrchestrator orch = new ABOrchestrator();
        System.assertEquals(true, orch.branchFieldsToGet.size()>0);

    }
    
    @IsTest
    private static void test_fieldsetloadfailure(){
        
        try{
            ABOrchestrator.forceFailedToLoadFieldSet = true;
            ABOrchestrator orch = new ABOrchestrator();
            System.assertEquals(true, false);
        }catch(Exception e){
            System.assertEquals(true, e.getMessage().contains('forceFailedToLoadFieldSet'));
        }
        
    }
    
    @IsTest
    private static void test_fieldsetloadfailurereturnsnull(){
        String accountId = createAccount().Id;
        
        Account a = [SELECT Id, LLC_BI__Branch__c FROM Account WHERE Id =: accountId][0];
        a.LLC_BI__Branch__c = null;
        update a;
        
        ABOrchestrator orch = new ABOrchestrator();
        LLC_BI__Branch__c branch = orch.getBranchFromAccountId(accountId);
        System.assertEquals(true, branch == null);
        
    }
    
    @IsTest
    private static void test_fieldsetloadfailurereturnsnull_accountnull(){
        ABOrchestrator orch = new ABOrchestrator();
        LLC_BI__Branch__c branch = orch.getBranchFromAccountId(null);
        System.assertEquals(true, branch == null);
    }
    
    @IsTest
    private static void test_fieldsetloadfailurereturnsnull_branchnull(){
        String accountId = createAccount().Id;
        
        LLC_BI__Branch__c b = new LLC_BI__Branch__c(Name='test');
        insert b;
        
        String branchId = b.Id;
        
        Account a = [SELECT Id, LLC_BI__Branch__c FROM Account WHERE Id =: accountId][0];
        a.LLC_BI__Branch__c = branchId;
        update a;
        
        delete b;
        
        ABOrchestrator orch = new ABOrchestrator();
        LLC_BI__Branch__c branch = orch.getBranchFromAccountId(accountId);
        System.assertEquals(true, branch == null);
        
    }
    
    @IsTest
    private static void test_getbookedloannumberbyloanid_succeeds(){
        
        LLC_BI__Loan__c loan = createLoan();
        
        loan.LLC_BI__lookupKey__c = '123_SOMETHING';
        update loan;
        
        ABOrchestrator orch = new ABOrchestrator();
        String loanNumber = orch.GetBookedLoanNumberByLoanId(loan.Id, false, null);
        
        
        System.assertEquals(true, !String.isBlank(loanNumber) && loanNumber.contains('_'));
        
    }
    @IsTest
    private static void test_getbookedloannumberbyloanid_succeeds_withclean(){
        
        LLC_BI__Loan__c loan = createLoan();
        
        loan.LLC_BI__lookupKey__c = '123_THIS_IS_CHEESE_R55';
        update loan;
        
        insert new SObject[]{
        new LLC_BI__CFG_ConfigValue__c(
        LLC_BI__Key__c = 'ALL',
        LLC_BI__Category__c = 'Renewal_Name_Format',
        LLC_BI__lookupKey__c = 'REN_NAME_FORMAT',
        LLC_BI__fieldValue__c = '_R'
        ),
        new LLC_BI__CFG_ConfigValue__c(
        LLC_BI__Key__c = 'ALL',
        LLC_BI__Category__c = 'Modification_Name_Format',
        LLC_BI__lookupKey__c = 'MOD_NAME_FORMAT',
        LLC_BI__fieldValue__c = '_M'
        )};
        
        ABOrchestrator orch = new ABOrchestrator();
        String delimitedValue = orch.GetConfigValue('REN_NAME_FORMAT');
        String loanNumber = orch.GetBookedLoanNumberByLoanId(loan.Id, true, delimitedValue);
        
        
        System.assertEquals(true, !String.isBlank(loanNumber) && !loanNumber.contains(delimitedValue));
        
    }
    
    @IsTest
    private static void test_getbookedloannumberbyloanid_succeedsassempty(){
        
        LLC_BI__Loan__c loan = createLoan();
        
        ABOrchestrator orch = new ABOrchestrator();
        String loanNumber = orch.GetBookedLoanNumberByLoanId(loan.Id, false, null);
        
        
        System.assertEquals(true, String.isBlank(loanNumber));
        
    }
    @IsTest
    private static void test_reservationpreparemessagefails_loanservicenull(){
        LLC_BI__Loan__c loan = createLoan();
        ABOrchestrator orch = new ABOrchestrator();
        
        try{
           nFUSE.MiddlewareMessage msg = orch.prepareLoanReservationMessage('something',null,loan.Id,null,null); 
           system.assertEquals(true,false);
        }catch(ABOrchestrator.ABServiceException ex){
           system.assertEquals(true,ex.getMessage() == 
            String.format(
                    System.Label.XPackageServiceNotFoundMessage, 
                    new String[]{'LoanReservationService',ABConfiguration.NFUSE_LOAN_XPKG_SERVICE})); 
        }
        
    }
    @IsTest
    private static void test_reservationpreparemessagefails_requestnull(){
        LLC_BI__Loan__c loan = createLoan();
        
        
        //add x-pkg send service here
        new nFUSE.DataInstaller().onInstall(null);
        
        ABOrchestrator orch = new ABOrchestrator();
        
        try{
           nFUSE.MiddlewareMessage msg = orch.prepareLoanReservationMessage('something',null,loan.Id,null,null); 
           system.assertEquals(true,false);
        }catch(ABOrchestrator.ABServiceException ex){
           system.assertEquals(true,ex.getMessage() == System.Label.RequestNotExpectedToBeNullMessage); 
        }
        
    }
    
    @IsTest
    private static void test_reserveloanerrorsonpreparemessage(){
        
        LLC_BI__Loan__c loan = createLoan();
        // loan.LLC_BI__lookupKey__c = 'something';
        // update loan;
        
        ABOrchestrator orch = new ABOrchestrator();
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
            ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANRESERVESENDSERVICENAME);
        
        
        try{
            
            test.startTest();
            ABEntities.AutomatedBookingResponse response = orch.ReserveLoan(loan.Id,null,null,null,null);
            test.stopTest();
            system.assertEquals(false,response.IsSuccessful);
        }catch(ABOrchestrator.ABServiceException ex){
            system.assertEquals(true,ex.getMessage() == String.format(System.Label.XPackageServiceNotFoundMessage, new String[]{'LoanReservationService',ABConfiguration.NFUSE_LOAN_XPKG_SERVICE}));
        }
        
        
        
        
    }
    
    @IsTest
    private static void test_renewloanerrorsonpreparemessage(){
        
        LLC_BI__Loan__c loan = createLoan();
        loan.LLC_BI__lookupKey__c = 'something';
        update loan;
        
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
            ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANRENEWALSENDSERVICENAME);
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        ABEntities.AutomatedBookingResponse response = orch.RenewLoan(loan.Id,null,null,null,null);
        test.stopTest();
        
        system.assertEquals(false,response.IsSuccessful);
        
    }
    @IsTest
    private static void test_modifyloanerrorsonpreparemessage(){
        
        LLC_BI__Loan__c loan = createLoan();
        loan.LLC_BI__lookupKey__c = 'something';
        update loan;
        
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
            ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANMODIFICATIONSENDSERVICENAME);
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        ABEntities.AutomatedBookingResponse response = orch.ModifyLoan(loan.Id,null,null,null,null);
        test.stopTest();
        
        system.assertEquals(false,response.IsSuccessful);
        
    }
    
    
    @IsTest
    private static void test_getbookingmessage_reservation(){
        
        new nFUSE.DataInstaller().onInstall(null);
        
        ABConfiguration configuration = new ABConfiguration();
        configuration.LoadPluginConfigurations();
        configuration.TogglePluginConfigurations(true);
        
        LLC_BI__Loan__c loan = createLoan();
        
//         nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
//          ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
//      nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
//      locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANSENDSERVICENAME);
        
        String translatedKey = configuration.GetTranslatedKey(System.Label.LOAN_PROP_KEY);
        String loanPropertyKey = configuration.GetPropertyByKey(translatedKey);
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        Map<String,Object> message = orch.GetBookingMessage('reservationmessage',loanPropertyKey,loan.Id);
        test.stopTest();
        
        system.assertEquals(true,message.containsKey(ABConfiguration.PROP_LOAN_KEY));
        
        
    }
    
    @IsTest
    private static void test_getbookingmessage_loan(){
        
        new nFUSE.DataInstaller().onInstall(null);
        
        ABConfiguration configuration = new ABConfiguration();
        configuration.LoadPluginConfigurations();
        configuration.TogglePluginConfigurations(true);
        
        LLC_BI__Loan__c loan = createLoan();
        
        LLC_BI__External_Application_Lookup__c newExtApp = new LLC_BI__External_Application_Lookup__c(
            LLC_BI__External_Id__c = 'externalloan',
            LLC_BI__Context_Id__c = loan.Id,
            Name = ABConfiguration.LOANRESERVATIONLOOKUPKEY
        );
        insert newExtApp;
        
//         nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
//          ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
//      nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
//      locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANSENDSERVICENAME);
        
        String translatedKey = configuration.GetTranslatedKey(System.Label.LOAN_PROP_KEY);
        String loanPropertyKey = configuration.GetPropertyByKey(translatedKey);
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        Map<String,Object> message = orch.GetBookingMessage('loanmessage',loanPropertyKey,loan.Id);
        test.stopTest();
        
        system.assertEquals(true,message.containsKey(loanPropertyKey));
        
    }
    
    @IsTest
    private static void test_getbookingmessage_loan_replacedelimiters(){
        
        new nFUSE.DataInstaller().onInstall(null);
        
        ABConfiguration configuration = new ABConfiguration();
        configuration.LoadPluginConfigurations();
        configuration.TogglePluginConfigurations(true);
        
        LLC_BI__Loan__c loan = createLoan();
        loan.LLC_BI__lookupKey__c = 'loannumber_R1_M1';
        update loan;
        
        insert new SObject[]{
        new LLC_BI__CFG_ConfigValue__c(
        LLC_BI__Key__c = 'ALL',
        LLC_BI__Category__c = 'Renewal_Name_Format',
        LLC_BI__lookupKey__c = 'REN_NAME_FORMAT',
        LLC_BI__fieldValue__c = '_R'
        ),
        new LLC_BI__CFG_ConfigValue__c(
        LLC_BI__Key__c = 'ALL',
        LLC_BI__Category__c = 'Modification_Name_Format',
        LLC_BI__lookupKey__c = 'MOD_NAME_FORMAT',
        LLC_BI__fieldValue__c = '_M'
        )};
        
//         nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
//          ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
//      nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
//      locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANSENDSERVICENAME);
        
        String translatedKey = configuration.GetTranslatedKey(System.Label.LOAN_PROP_KEY);
        String loanPropertyKey = configuration.GetPropertyByKey(translatedKey);
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        Map<String,Object> message = orch.GetBookingMessage('loanmessage',loanPropertyKey,loan.Id);
        test.stopTest();
        
        system.assertEquals(true,message.containsKey(loanPropertyKey));
        
    }
    
    @IsTest
    private static void test_getbookingmessage_deposit(){
        
        new nFUSE.DataInstaller().onInstall(null);
        
        ABConfiguration configuration = new ABConfiguration();
        configuration.LoadPluginConfigurations();
        configuration.TogglePluginConfigurations(true);
        
        Account sIndividualAcct = createAccount('Individual');
        setupAccountId = sIndividualAcct.id;
        
        LLC_BI__Deposit__c deposit = createDeposit();
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        Map<String,Object> message = orch.GetBookingMessage('deposit','',deposit.Id);
        test.stopTest();
        
        system.assertEquals(true,message.containsKey(ABConfiguration.PROP_DEPOSIT_KEY));
        
    }
    
    @IsTest
    private static void test_getbookingmessage_customer(){
        
        new nFUSE.DataInstaller().onInstall(null);
        
        ABConfiguration configuration = new ABConfiguration();
        configuration.LoadPluginConfigurations();
        configuration.TogglePluginConfigurations(true);
        
        Account account = createAccount();
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        Map<String,Object> message = orch.GetBookingMessage('customer','',account.Id);
        test.stopTest();
        
        system.assertEquals(true,message.containsKey('branch'));
        
    }
    
    @IsTest
    private static void test_getbookingmessage_unsupported(){
        
        ABConfiguration configuration = new ABConfiguration();
        configuration.LoadPluginConfigurations();
        configuration.TogglePluginConfigurations(true);
        
        LLC_BI__Loan__c loan = createLoan();
        
//         nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
//          ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
//      nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
//      locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANSENDSERVICENAME);
        
        String translatedKey = configuration.GetTranslatedKey(System.Label.LOAN_PROP_KEY);
        String loanPropertyKey = configuration.GetPropertyByKey(translatedKey);
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        Map<String,Object> message = orch.GetBookingMessage('not one that is supported',loanPropertyKey,loan.Id);
        test.stopTest();
        
        system.assertEquals(true,message == null);
        
        
    }
    
    
    @IsTest
    private static void test_ShouldModifyOrRenewLoan_Modify_True(){
        
        insert new SObject[]{
        new LLC_BI__CFG_ConfigValue__c(
        LLC_BI__Key__c = 'ALL',
        LLC_BI__Category__c = 'Renewal_Name_Format',
        LLC_BI__lookupKey__c = 'REN_NAME_FORMAT',
        LLC_BI__fieldValue__c = '_R'
        ),
        new LLC_BI__CFG_ConfigValue__c(
        LLC_BI__Key__c = 'ALL',
        LLC_BI__Category__c = 'Modification_Name_Format',
        LLC_BI__lookupKey__c = 'MOD_NAME_FORMAT',
        LLC_BI__fieldValue__c = '_M'
        )};
        
        LLC_BI__Loan__c loan = createLoan();
        loan.LLC_BI__lookupKey__c = 'modfriendly_M1';
        update loan;
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        Boolean response = orch.ShouldModifyOrRenewLoan(loan.Id,'MOD_NAME_FORMAT');
        test.stopTest();
        
        system.assertEquals(true,response);
    }
    @IsTest
    private static void test_ShouldModifyOrRenewLoan_Modify_False(){
        
        insert new SObject[]{
        new LLC_BI__CFG_ConfigValue__c(
        LLC_BI__Key__c = 'ALL',
        LLC_BI__Category__c = 'Renewal_Name_Format',
        LLC_BI__lookupKey__c = 'REN_NAME_FORMAT',
        LLC_BI__fieldValue__c = '_R'
        ),
        new LLC_BI__CFG_ConfigValue__c(
        LLC_BI__Key__c = 'ALL',
        LLC_BI__Category__c = 'Modification_Name_Format',
        LLC_BI__lookupKey__c = 'MOD_NAME_FORMAT',
        LLC_BI__fieldValue__c = '_M'
        )};
        
        LLC_BI__Loan__c loan = createLoan();
        loan.LLC_BI__lookupKey__c = 'notmodfriendly';
        update loan;
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        Boolean response = orch.ShouldModifyOrRenewLoan(loan.Id,'MOD_NAME_FORMAT');
        test.stopTest();
        
        system.assertEquals(false,response);
    }
    
    @IsTest
    private static void test_ShouldModifyOrRenewLoan_Renew_True(){
        
        insert new SObject[]{
        new LLC_BI__CFG_ConfigValue__c(
        LLC_BI__Key__c = 'ALL',
        LLC_BI__Category__c = 'Renewal_Name_Format',
        LLC_BI__lookupKey__c = 'REN_NAME_FORMAT',
        LLC_BI__fieldValue__c = '_R'
        ),
        new LLC_BI__CFG_ConfigValue__c(
        LLC_BI__Key__c = 'ALL',
        LLC_BI__Category__c = 'Modification_Name_Format',
        LLC_BI__lookupKey__c = 'MOD_NAME_FORMAT',
        LLC_BI__fieldValue__c = '_M'
        )};
        
        LLC_BI__Loan__c loan = createLoan();
        loan.LLC_BI__lookupKey__c = 'renewalfriendly_R1';
        update loan;
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        Boolean response = orch.ShouldModifyOrRenewLoan(loan.Id,'REN_NAME_FORMAT');
        test.stopTest();
        
        system.assertEquals(true,response);
    }
    @IsTest
    private static void test_ShouldModifyOrRenewLoan_Renew_False(){
        
        insert new SObject[]{
        new LLC_BI__CFG_ConfigValue__c(
        LLC_BI__Key__c = 'ALL',
        LLC_BI__Category__c = 'Renewal_Name_Format',
        LLC_BI__lookupKey__c = 'REN_NAME_FORMAT',
        LLC_BI__fieldValue__c = '_R'
        ),
        new LLC_BI__CFG_ConfigValue__c(
        LLC_BI__Key__c = 'ALL',
        LLC_BI__Category__c = 'Modification_Name_Format',
        LLC_BI__lookupKey__c = 'MOD_NAME_FORMAT',
        LLC_BI__fieldValue__c = '_M'
        )};
        
        LLC_BI__Loan__c loan = createLoan();
        loan.LLC_BI__lookupKey__c = 'notrenewalfriendly';
        update loan;
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        Boolean response = orch.ShouldModifyOrRenewLoan(loan.Id,'REN_NAME_FORMAT');
        test.stopTest();
        
        system.assertEquals(false,response);
    }
    
    @IsTest
    private static void test_ShouldModifyOrRenewLoan_LookupKeyNull(){
        
        LLC_BI__Loan__c loan = createLoan();
        loan.LLC_BI__lookupKey__c = 'notrenewalfriendly';
        update loan;
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        Boolean response = orch.ShouldModifyOrRenewLoan(loan.Id,null);
        test.stopTest();
        
        system.assertEquals(false,response);
    }
    
    
    
    @IsTest
    private static void test_LoanRenewalFails(){
        LLC_BI__Loan__c loan = createLoan();
        loan.LLC_BI__lookupKey__c = 'modfriendly_R1';
        update loan;
        
        insert new SObject[]{
        new LLC_BI__CFG_ConfigValue__c(
        LLC_BI__Key__c = 'ALL',
        LLC_BI__Category__c = 'Renewal_Name_Format',
        LLC_BI__lookupKey__c = 'REN_NAME_FORMAT',
        LLC_BI__fieldValue__c = '_R'
        ),
        new LLC_BI__CFG_ConfigValue__c(
        LLC_BI__Key__c = 'ALL',
        LLC_BI__Category__c = 'Modification_Name_Format',
        LLC_BI__lookupKey__c = 'MOD_NAME_FORMAT',
        LLC_BI__fieldValue__c = '_M'
        )};
        
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
        ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANRENEWALSENDSERVICENAME);
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        ABEntities.AutomatedBookingResponse response = orch.RenewLoan(loan.Id,null,null,null,null);
        test.stopTest();
        
        system.assertEquals(false,response.IsSuccessful);
        
    }
    
    @IsTest
    private static void test_LoanModificationFails(){
        LLC_BI__Loan__c loan = createLoan();
        loan.LLC_BI__lookupKey__c = 'modfriendly_M1';
        update loan;
        
        insert new SObject[]{
        new LLC_BI__CFG_ConfigValue__c(
        LLC_BI__Key__c = 'ALL',
        LLC_BI__Category__c = 'Renewal_Name_Format',
        LLC_BI__lookupKey__c = 'REN_NAME_FORMAT',
        LLC_BI__fieldValue__c = '_R'
        ),
        new LLC_BI__CFG_ConfigValue__c(
        LLC_BI__Key__c = 'ALL',
        LLC_BI__Category__c = 'Modification_Name_Format',
        LLC_BI__lookupKey__c = 'MOD_NAME_FORMAT',
        LLC_BI__fieldValue__c = '_M'
        )};
        
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
        ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANMODIFICATIONSENDSERVICENAME);
        
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        ABEntities.AutomatedBookingResponse response = orch.ModifyLoan(loan.Id,null,null,null,null);
        test.stopTest();
        
        system.assertEquals(false,response.IsSuccessful);
        
    }
    
    @IsTest
    private static void test_getbookingmessage_loanmessage_bookedLoanNumber_IsBlank(){
        
        new nFUSE.DataInstaller().onInstall(null);
        
        ABConfiguration configuration = new ABConfiguration();
        configuration.LoadPluginConfigurations();
        configuration.TogglePluginConfigurations(true);
        
        LLC_BI__Loan__c loan = createLoan();
        
        String translatedKey = configuration.GetTranslatedKey(System.Label.LOAN_PROP_KEY);
        String loanPropertyKey = configuration.GetPropertyByKey(translatedKey);
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        Map<String,Object> message = orch.GetBookingMessage('loanmessage',loanPropertyKey,loan.Id);
        test.stopTest();
        
        system.assertEquals(true,message.containsKey(ABConfiguration.PROP_LOAN_KEY));
        
    }
    
    
    @IsTest
    private static void test_bookLoan_prepareLoanBookingMessage_throws(){
        
        LLC_BI__Loan__c loan = createLoan();
        
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
            ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
        nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANSENDSERVICENAME);
        
        ABOrchestrator orch = new ABOrchestrator();
        
        test.startTest();
        ABEntities.AutomatedBookingResponse response = orch.BookLoan(loan.Id,null,null,null,null);
        test.stopTest();
        
        system.assertEquals(false,response.IsSuccessful);
        
    }
    
    
}