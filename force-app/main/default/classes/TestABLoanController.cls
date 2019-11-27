@isTest()
public with sharing class TestABLoanController {
    
 //   static Account createAccount() {
	// 	Account testAccount = new Account(Name = 'My test account', AccountNumber = '1234');
	// 	insert testAccount;
	// 	return testAccount;
	// }
	
 //   public static LLC_BI__Loan__c createLoan() {
	// 	return createLoan(null, null, null, null, null);
	// }

	// public static LLC_BI__Loan__c createLoan(LLC_BI__Application__c application) {
	// 	return createLoan(application, null, null, null, null);
	// }

	// public static LLC_BI__Loan__c createLoan(
	// 	LLC_BI__Application__c application,
	// 	LLC_BI__Branch__c branch,
	// 	LLC_BI__Product__c sProduct,
	// 	User sProcessor,
	// 	User sOfficer) {

	// 	LLC_BI__Loan__c loan = new LLC_BI__Loan__c(
	// 		Name = 'Test Loan',
	// 		LLC_BI__Amount__c = 10000
	// 	);

	// 	if(branch != null) loan.LLC_BI__Branch__c = branch.Id;
	// 	if(application != null) loan.LLC_BI__Application__c = application.Id;
	// 	if(sProduct != null) loan.LLC_BI__Product__c = sProduct.Name;
	// 	if(sProcessor != null) loan.LLC_BI__Processor_Name__c = sProcessor.Id;
	// 	if(sOfficer != null) loan.LLC_BI__Loan_Officer__c = sOfficer.Id;

	// 	insert loan;
	// 	return loan;
	// }

	// public static LLC_BI__Loan__c createLoan(LLC_BI__Branch__c branch) {
	// 	return createLoan(null, branch, null, null, null);
	// }

	// public static LLC_BI__Legal_Entities__c createLegalEntity(
	// 	LLC_BI__Loan__c loan,
	// 	Account acct) {
	// 	LLC_BI__Legal_Entities__c entity = new LLC_BI__Legal_Entities__c(
	// 		LLC_BI__Loan__c = loan.Id,
	// 		LLC_BI__Account__c = acct.Id
	// 	);
	// 	insert entity;
	// 	return entity;
	// }

	// public static LLC_BI__Collateral__c createCollateral(LLC_BI__Collateral_Type__c ct) {
	// 	return createCollateral('TestCollateralFactory', ct, null);
	// }

	// public static LLC_BI__Collateral__c createCollateral(String collateralName, LLC_BI__Collateral_Type__c ct, LLC_BI__Collateral__c parentCollateral) {
	// 	LLC_BI__Collateral__c coll = new LLC_BI__Collateral__c(
	// 		LLC_BI__Collateral_Name__c = collateralName,
	// 		LLC_BI__Description__c = 'TestCollateralFactory testing',
	// 		LLC_BI__Collateral_Type__c = ct.id,
	// 		LLC_BI__CUSIP_Number__c = '1234567'
	// 	);

	// 	if(parentCollateral != null) {
	// 		coll.LLC_BI__Highest__c = parentCollateral.LLC_BI__Highest__c == null ? parentCollateral.Id : parentCollateral.LLC_BI__Highest__c;
	// 		coll.LLC_BI__Parent_Collateral__c = parentCollateral.Id;
	// 	}

	// 	insert coll;
	// 	return coll;
	// }

	// public static LLC_BI__Loan_Collateral__c createCollateralLoan(LLC_BI__Loan__c loan, String name) {
	// 	LLC_BI__Loan_Collateral__c colloan = new LLC_BI__Loan_Collateral__c(
	// 		LLC_BI__Vessel_Name__c = name,
	// 		LLC_BI__Number_of_Shares__c = 100,
	// 		LLC_BI__Loan__c = loan.Id
	// 	);
	// 	insert colloan;
	// 	return colloan;
	// }

	// public static LLC_BI__Loan_Collateral2__c createCollateral2Loan(LLC_BI__Collateral__c coll, LLC_BI__Loan__c loan, LLC_BI__Loan_Collateral_Aggregate__c collaggreate) {
	// 	LLC_BI__Loan_Collateral2__c colloan = new LLC_BI__Loan_Collateral2__c(
	// 		LLC_BI__Collateral__c = coll.Id,
	// 		LLC_BI__Loan__c = loan.Id,
	// 		LLC_BI__Loan_Collateral_Aggregate__c = collaggreate.Id
	// 	);
	// 	insert colloan;
	// 	return colloan;
	// }

	// public static LLC_BI__Account_Collateral__c createCollateralAccount(LLC_BI__Collateral__c coll, Account account) {
	// 	LLC_BI__Account_Collateral__c colloan = new LLC_BI__Account_Collateral__c(
	// 		LLC_BI__Collateral__c = coll.Id,
	// 		LLC_BI__Account__c = account.Id
	// 		//LLC_BI__Loan_Collateral_Aggregate__c = collaggreate.Id
	// 	);
	// 	insert colloan;
	// 	return colloan;
	// }

	// public static LLC_BI__Collateral_Type__c createCollateralType() {
	// 	return createCollateralType(20);
	// }

	// public static LLC_BI__Collateral_Type__c createCollateralType(Decimal advanceRate) {
	// 	return createCollateralType(advanceRate, null);
	// }

	// public static LLC_BI__Collateral_Type__c createCollateralType(Decimal advanceRate, LLC_BI__Collateral_Type__c parentType) {
	// 	LLC_BI__Collateral_Type__c ct = new LLC_BI__Collateral_Type__c(
	// 		Name = 'test',
	// 		LLC_BI__Subtype__c = 'test subtype',
	// 		LLC_BI__Advance_Rate__c = advanceRate
	// 	);

	// 	if(parentType != null) {
	// 		ct.LLC_BI__Highest_Type__c = parentType.LLC_BI__Highest_Type__c == null ? parentType.Id : parentType.LLC_BI__Highest_Type__c;
	// 		ct.LLC_BI__Parent_Type__c = parentType.Id;
	// 	}

	// 	insert ct;
	// 	return ct;
	// }

	// public static LLC_BI__Loan_Collateral_Aggregate__c createCollateralaggregate() {
	// 	LLC_BI__Loan_Collateral_Aggregate__c colloan = new LLC_BI__Loan_Collateral_Aggregate__c(
	// 		Name = '111'
	// 	);
	// 	insert colloan;
	// 	return colloan;
	// }

	// public static LLC_BI__Lien__c createLien(LLC_BI__Collateral__c coll, LLC_BI__Loan__c loan) {
	// 	LLC_BI__Lien__c lien = new LLC_BI__Lien__c(
	// 		LLC_BI__Collateral__c = coll.Id,
	// 		LLC_BI__Loan__c = loan.Id
	// 	);
	// 	insert lien;
	// 	return lien;
	// }
	
	// private static String loanId;

 //   @isTest
 //   static void setupData() {
    	
 //   	loanId = createLoan().Id;
        
        
 //       nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
	// 		ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
	// 	nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
	// 	locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANSENDSERVICENAME);
        
        
        
 //   }
    
 //   @isTest
 //   private static void testWithStandardController(){
 //   	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
 //   	insert loan;
 //       ABLoanController c = new ABLoanController(new ApexPages.StandardController(loan));
 //       system.assertEquals(true,true);
 //   }
    
 //   @isTest
 //   private static void testWithoutStandardController(){
    	
 //   	ABConfiguration configuration = new ABConfiguration();
 //       configuration.LoadPluginConfigurations();
 //       configuration.TogglePluginConfigurations(true);
        
 //       insert new SObject[]{
 //       new LLC_BI__CFG_ConfigValue__c(
 //       LLC_BI__Key__c = 'ALL',
 //       LLC_BI__Category__c = 'Renewal_Name_Format',
 //       LLC_BI__lookupKey__c = 'REN_NAME_FORMAT',
 //       LLC_BI__fieldValue__c = '_R'
 //       ),
 //       new LLC_BI__CFG_ConfigValue__c(
 //       LLC_BI__Key__c = 'ALL',
 //       LLC_BI__Category__c = 'Modification_Name_Format',
 //       LLC_BI__lookupKey__c = 'MOD_NAME_FORMAT',
 //       LLC_BI__fieldValue__c = '_M'
 //       )};
        
 //   	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
 //   	insert loan;
        
 //       System.currentPageReference().getParameters().put('id', loan.Id);
        
 //       ABLoanController c = new ABLoanController();
        
 //       system.assertEquals(true,c.reserveLoanButtonEnabled);
 //   }

 //   @isTest
 //   private static void testBookLoan(){
 //       new nFUSE.DataInstaller().onInstall(null);
    	
 //       setupData();
 //       test.startTest();
 //       ABLoanController.forceTestingException = false;
 //       ABEntities.AutomatedBookingResponse response = ABLoanController.bookLoan(loanId);
 //       system.assertEquals(true,response.IsSuccessful);
 //       test.stopTest();
 //   }
    
 //   @isTest
 //   private static void testBookLoanFails(){
 //       setupData();
 //       test.startTest();
 //       ABLoanController.forceTestingException = true;
 //       ABEntities.AutomatedBookingResponse response = ABLoanController.bookLoan(loanId);
 //       system.assertEquals(false,response.IsSuccessful);
 //       test.stopTest();
 //   }
    
    
 //   @isTest
 //   private static void testBookLoanNotComplete(){
        
 //       String accountId = createAccount().Id;
        
 //       nFUSE__Transaction_Log__c log = new nFUSE__Transaction_Log__c(Name='TestLog',nFUSE__External_Id__c='123123123'); //possible namespace issue
 //       log.nFUSE__Action__c = 'new';
 //       log.nFUSE__Api_Version__c = '1';
 //       log.nFUSE__App_Plugin__c = 'AutomatedBooking';
 //       log.nFUSE__Primary_Object_Id__c = accountId;
 //       log.nFUSE__Requested_By_User_Id__c = 'user';
 //       log.nFUSE__Transaction_Status__c = 'notcomplete';
 //       log.nFUSE__External_Id__c = 'test';
 //       insert log;
        
 //       String externalId = log.nFUSE__External_Id__c;
        
 //       test.startTest();
 //       ABEntities.CompoundTransactionLogResponse response = ABLoanController.getTransactionStatus(externalId);
 //       system.assertEquals(false,response.IsComplete);
 //       test.stopTest();
 //   }
    
 //   @isTest
 //   private static void testBookLoanComplete(){
        
 //       String accountId = createAccount().Id;
        
 //       nFUSE__Transaction_Log__c log = new nFUSE__Transaction_Log__c(Name='TestLog',nFUSE__External_Id__c='123123123'); //possible namespace issue
 //       log.nFUSE__Action__c = 'new';
 //       log.nFUSE__Api_Version__c = '1';
 //       log.nFUSE__App_Plugin__c = 'AutomatedBooking';
 //       log.nFUSE__Primary_Object_Id__c = accountId;
 //       log.nFUSE__Requested_By_User_Id__c = 'user';
 //       log.nFUSE__Transaction_Status__c = 'eRRor';
 //       log.nFUSE__External_Id__c = 'test';
 //       insert log;
        
 //       String externalId = log.nFUSE__External_Id__c;
        
 //       test.startTest();
 //       ABEntities.CompoundTransactionLogResponse response = ABLoanController.getTransactionStatus(externalId);
 //       system.assertEquals(true,response.IsComplete);
 //       test.stopTest();
 //   }
    
    
 //   @isTest
 //   private static void testBookLoanWithReservedLoanNumber(){
 //       new nFUSE.DataInstaller().onInstall(null);
    	
 //       setupData();
        
 //       //add reserved loan number here
 //       LLC_BI__External_Application_Lookup__c newExtApp = new LLC_BI__External_Application_Lookup__c(
	// 				LLC_BI__External_Id__c = '12345',
	// 				LLC_BI__Context_Id__c = loanId,
	// 				Name = ABConfiguration.LOANRESERVATIONLOOKUPKEY
	// 			);
 //       insert newExtApp;
        
 //       test.startTest();
 //       ABLoanController.forceTestingException = false;
 //       ABEntities.AutomatedBookingResponse response = ABLoanController.bookLoan(loanId);
 //       system.assertEquals(true,response.IsSuccessful);
 //       test.stopTest();
 //   }
 
 
 
	static Account createAccount() {
		Account testAccount = new Account(Name = 'My test account', AccountNumber = '1234');
		insert testAccount;
		return testAccount;
	}
	
    public static LLC_BI__Loan__c createLoan() {
		return createLoan(null, null, null, null, null);
	}

	public static LLC_BI__Loan__c createLoan(LLC_BI__Application__c application) {
		return createLoan(application, null, null, null, null);
	}

	public static LLC_BI__Loan__c createLoan(
		LLC_BI__Application__c application,
		LLC_BI__Branch__c branch,
		LLC_BI__Product__c sProduct,
		User sProcessor,
		User sOfficer) {

		LLC_BI__Loan__c loan = new LLC_BI__Loan__c(
			Name = 'Test Loan',
			LLC_BI__Amount__c = 10000
		);

		if(branch != null) loan.LLC_BI__Branch__c = branch.Id;
		if(application != null) loan.LLC_BI__Application__c = application.Id;
		if(sProduct != null) loan.LLC_BI__Product__c = sProduct.Name;
		if(sProcessor != null) loan.LLC_BI__Processor_Name__c = sProcessor.Id;
		if(sOfficer != null) loan.LLC_BI__Loan_Officer__c = sOfficer.Id;

		insert loan;
		return loan;
	}

	public static LLC_BI__Loan__c createLoan(LLC_BI__Branch__c branch) {
		return createLoan(null, branch, null, null, null);
	}

	public static LLC_BI__Legal_Entities__c createLegalEntity(
		LLC_BI__Loan__c loan,
		Account acct) {
		LLC_BI__Legal_Entities__c entity = new LLC_BI__Legal_Entities__c(
			LLC_BI__Loan__c = loan.Id,
			LLC_BI__Account__c = acct.Id
		);
		insert entity;
		return entity;
	}

	public static LLC_BI__Collateral__c createCollateral(LLC_BI__Collateral_Type__c ct) {
		return createCollateral('TestCollateralFactory', ct, null);
	}

	public static LLC_BI__Collateral__c createCollateral(String collateralName, LLC_BI__Collateral_Type__c ct, LLC_BI__Collateral__c parentCollateral) {
		LLC_BI__Collateral__c coll = new LLC_BI__Collateral__c(
			LLC_BI__Collateral_Name__c = collateralName,
			LLC_BI__Description__c = 'TestCollateralFactory testing',
			LLC_BI__Collateral_Type__c = ct.id,
			LLC_BI__CUSIP_Number__c = '1234567'
		);

		if(parentCollateral != null) {
			coll.LLC_BI__Highest__c = parentCollateral.LLC_BI__Highest__c == null ? parentCollateral.Id : parentCollateral.LLC_BI__Highest__c;
			coll.LLC_BI__Parent_Collateral__c = parentCollateral.Id;
		}

		insert coll;
		return coll;
	}

	public static LLC_BI__Loan_Collateral__c createCollateralLoan(LLC_BI__Loan__c loan, String name) {
		LLC_BI__Loan_Collateral__c colloan = new LLC_BI__Loan_Collateral__c(
			LLC_BI__Vessel_Name__c = name,
			LLC_BI__Number_of_Shares__c = 100,
			LLC_BI__Loan__c = loan.Id
		);
		insert colloan;
		return colloan;
	}

	public static LLC_BI__Loan_Collateral2__c createCollateral2Loan(LLC_BI__Collateral__c coll, LLC_BI__Loan__c loan, LLC_BI__Loan_Collateral_Aggregate__c collaggreate) {
		LLC_BI__Loan_Collateral2__c colloan = new LLC_BI__Loan_Collateral2__c(
			LLC_BI__Collateral__c = coll.Id,
			LLC_BI__Loan__c = loan.Id,
			LLC_BI__Loan_Collateral_Aggregate__c = collaggreate.Id
		);
		insert colloan;
		return colloan;
	}

	public static LLC_BI__Account_Collateral__c createCollateralAccount(LLC_BI__Collateral__c coll, Account account) {
		LLC_BI__Account_Collateral__c colloan = new LLC_BI__Account_Collateral__c(
			LLC_BI__Collateral__c = coll.Id,
			LLC_BI__Account__c = account.Id
			//LLC_BI__Loan_Collateral_Aggregate__c = collaggreate.Id
		);
		insert colloan;
		return colloan;
	}

	public static LLC_BI__Collateral_Type__c createCollateralType() {
		return createCollateralType(20);
	}

	public static LLC_BI__Collateral_Type__c createCollateralType(Decimal advanceRate) {
		return createCollateralType(advanceRate, null);
	}

	public static LLC_BI__Collateral_Type__c createCollateralType(Decimal advanceRate, LLC_BI__Collateral_Type__c parentType) {
		LLC_BI__Collateral_Type__c ct = new LLC_BI__Collateral_Type__c(
			Name = 'test',
			LLC_BI__Subtype__c = 'test subtype',
			LLC_BI__Advance_Rate__c = advanceRate
		);

		if(parentType != null) {
			ct.LLC_BI__Highest_Type__c = parentType.LLC_BI__Highest_Type__c == null ? parentType.Id : parentType.LLC_BI__Highest_Type__c;
			ct.LLC_BI__Parent_Type__c = parentType.Id;
		}

		insert ct;
		return ct;
	}

	public static LLC_BI__Loan_Collateral_Aggregate__c createCollateralaggregate() {
		LLC_BI__Loan_Collateral_Aggregate__c colloan = new LLC_BI__Loan_Collateral_Aggregate__c(
			Name = '111'
		);
		insert colloan;
		return colloan;
	}

	public static LLC_BI__Lien__c createLien(LLC_BI__Collateral__c coll, LLC_BI__Loan__c loan) {
		LLC_BI__Lien__c lien = new LLC_BI__Lien__c(
			LLC_BI__Collateral__c = coll.Id,
			LLC_BI__Loan__c = loan.Id
		);
		insert lien;
		return lien;
	}
	
	private static String loanId;

    @isTest
    static void setupData() {
    	
    	loanId = createLoan().Id;
        
        nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
			ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
		nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
		locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANSENDSERVICENAME);
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANRESERVESENDSERVICENAME);
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANMODIFICATIONSENDSERVICENAME);
        locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANRENEWALSENDSERVICENAME);
        
    }
    
    @isTest
    private static void testWithStandardController(){
    	
    	ABConfiguration configuration = new ABConfiguration();
        configuration.LoadPluginConfigurations();
        configuration.TogglePluginConfigurations(true);
        
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
    	
    	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
    	insert loan;
        ABLoanController c = new ABLoanController(new ApexPages.StandardController(loan));
        system.assertEquals(true,c.reserveLoanButtonEnabled);
    }

    @isTest
    private static void testWithoutStandardController(){
    	
    	ABConfiguration configuration = new ABConfiguration();
        configuration.LoadPluginConfigurations();
        configuration.TogglePluginConfigurations(true);
        
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
        
    	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
    	insert loan;
        
        System.currentPageReference().getParameters().put('id', loan.Id);
        
        ABLoanController c = new ABLoanController();
        
        system.assertEquals(true,c.reserveLoanButtonEnabled);
    }
    
    @isTest
    private static void testWithoutStandardController_renewbuttonenabled(){
    	
    	ABConfiguration configuration = new ABConfiguration();
        configuration.LoadPluginConfigurations();
        configuration.TogglePluginConfigurations(true);
        
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
        
    	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
    	loan.LLC_BI__lookupKey__c = 'number_M1_R1';
    	insert loan;
        
        System.currentPageReference().getParameters().put('id', loan.Id);
        
        ABLoanController c = new ABLoanController();
        
        system.assertEquals(true,c.renewLoanButtonEnabled);
    }
    
    @isTest
    private static void testWithoutStandardController_modifybuttonenabled(){
    	
    	ABConfiguration configuration = new ABConfiguration();
        configuration.LoadPluginConfigurations();
        configuration.TogglePluginConfigurations(true);
        
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
        
    	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
    	loan.LLC_BI__lookupKey__c = 'number_R1_M1';
    	insert loan;
        
        System.currentPageReference().getParameters().put('id', loan.Id);
        
        ABLoanController c = new ABLoanController();
        
        system.assertEquals(true,c.modifyLoanButtonEnabled);
    }
    
    @isTest
    private static void testWithoutStandardController_ReservationsDisabled(){
    	
    	ABConfiguration configuration = new ABConfiguration();
        configuration.LoadPluginConfigurations();
        configuration.TogglePluginConfigurations(true);
        
        nFORCE__System_Properties__c property1 = [SELECT Id FROM nFORCE__System_Properties__c WHERE nFORCE__Category_Name__c='AutomatedBookingConfiguration' AND nFORCE__Key__c = 'Enable Reserve Loan Button'][0];
        property1.nFORCE__Value__c = 'false';
        update property1;
		
        
    	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
    	insert loan;
        
        System.currentPageReference().getParameters().put('id', loan.Id);
        
        ABLoanController c = new ABLoanController();
        
        system.assertEquals(true,!c.reserveLoanButtonEnabled);
    }
    
    @isTest
    private static void testWithoutStandardController_ReservationsDisabled_AlreadyReserved(){
    	
    	ABConfiguration configuration = new ABConfiguration();
        configuration.LoadPluginConfigurations();
        configuration.TogglePluginConfigurations(true);
        
    	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
    	insert loan;
        
        LLC_BI__External_Application_Lookup__c newExtApp = new LLC_BI__External_Application_Lookup__c(
						LLC_BI__External_Id__c = 'reservednumber',
						LLC_BI__Context_Id__c = loan.Id,
						Name = ABConfiguration.LOANRESERVATIONLOOKUPKEY
					);
		insert newExtApp;
        
        System.currentPageReference().getParameters().put('id', loan.Id);
        
        ABLoanController c = new ABLoanController();
        
        system.assertEquals(true,c.reserveLoanButtonEnabled); //we can continue to reserve as long as it hasnt been booked
    }
    
    @isTest
    private static void testWithoutStandardController_ReservationsDisabled_AlreadyBooked(){
    	
    	ABConfiguration configuration = new ABConfiguration();
        configuration.LoadPluginConfigurations();
        configuration.TogglePluginConfigurations(true);
        
    	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
    	loan.LLC_BI__lookupKey__c = 'reservednumber';
    	insert loan;
        
        LLC_BI__External_Application_Lookup__c newExtApp = new LLC_BI__External_Application_Lookup__c(
						LLC_BI__External_Id__c = 'reservednumber',
						LLC_BI__Context_Id__c = loan.Id,
						Name = ABConfiguration.LOANRESERVATIONLOOKUPKEY
					);
		insert newExtApp;
        
        System.currentPageReference().getParameters().put('id', loan.Id);
        
        ABLoanController c = new ABLoanController();
        
        system.assertEquals(true,!c.reserveLoanButtonEnabled);
    }
    
    @isTest
    private static void testWithoutStandardController_ReservationsDisabled_AlreadyBookedExternalAppDeleted(){
    	
    	ABConfiguration configuration = new ABConfiguration();
        configuration.LoadPluginConfigurations();
        configuration.TogglePluginConfigurations(true);
        
    	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
    	loan.LLC_BI__lookupKey__c = 'reservednumber';
    	insert loan;
        
        System.currentPageReference().getParameters().put('id', loan.Id);
        
        ABLoanController c = new ABLoanController();
        
        system.assertEquals(true,!c.reserveLoanButtonEnabled);
    }
    
    @isTest
    private static void testGetRequestHistory(){
    	
    	new nFUSE.DataInstaller().onInstall(null);
    	
    	ABConfiguration configuration = new ABConfiguration();
        configuration.LoadPluginConfigurations();
        configuration.TogglePluginConfigurations(true);
        
    	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
    	loan.LLC_BI__lookupKey__c = 'reservednumber';
    	insert loan;
    	
    	nFUSE__Transaction_Log__c log = new nFUSE__Transaction_Log__c(Name='TestLog',nFUSE__External_Id__c='123123123a'); //possible namespace issue
        log.nFUSE__Action__c = 'new';
        log.nFUSE__Api_Version__c = '1';
        log.nFUSE__App_Plugin__c = 'AutomatedBooking';
        log.nFUSE__Primary_Object_Id__c = loan.Id;
        log.nFUSE__Requested_By_User_Id__c = 'user';
        log.nFUSE__Transaction_Status__c = 'error';
        insert log;
        
        nFUSE__Transaction_Log__c log2 = new nFUSE__Transaction_Log__c(Name='TestLog1',nFUSE__External_Id__c='1231231231'); //possible namespace issue
        log2.nFUSE__Action__c = 'test';
        log2.nFUSE__Vendor_Status__c = ABConfiguration.LOANBOOKACTION;
        log2.nFUSE__Api_Version__c = '1';
        log2.nFUSE__App_Plugin__c = 'AutomatedBooking';
        log2.nFUSE__Primary_Object_Id__c = loan.Id;
        log2.nFUSE__Requested_By_User_Id__c = 'user';
        log2.nFUSE__Transaction_Status__c = 'error';
        insert log2;
        
        nFUSE__Transaction_Log__c log3 = new nFUSE__Transaction_Log__c(Name='TestLog2',nFUSE__External_Id__c='1231231232'); //possible namespace issue
        log3.nFUSE__Action__c = 'test';
        log3.nFUSE__Vendor_Status__c = ABConfiguration.LOANRESERVATIONACTION;
        log3.nFUSE__Api_Version__c = '1';
        log3.nFUSE__App_Plugin__c = 'AutomatedBooking';
        log3.nFUSE__Primary_Object_Id__c = loan.Id;
        log3.nFUSE__Requested_By_User_Id__c = 'user';
        log3.nFUSE__Transaction_Status__c = 'error';
        insert log3;
        
        nFUSE__Transaction_Log__c log4 = new nFUSE__Transaction_Log__c(Name='TestLog3',nFUSE__External_Id__c='1231231233'); //possible namespace issue
        log4.nFUSE__Action__c = 'test';
        log4.nFUSE__Vendor_Status__c = ABConfiguration.LOANRENEWALACTION;
        log4.nFUSE__Api_Version__c = '1';
        log4.nFUSE__App_Plugin__c = 'AutomatedBooking';
        log4.nFUSE__Primary_Object_Id__c = loan.Id;
        log4.nFUSE__Requested_By_User_Id__c = 'user';
        log4.nFUSE__Transaction_Status__c = 'error';
        insert log4;
        
        nFUSE__Transaction_Log__c log5 = new nFUSE__Transaction_Log__c(Name='TestLog4',nFUSE__External_Id__c='1231231234'); //possible namespace issue
        log5.nFUSE__Action__c = 'test';
        log5.nFUSE__Vendor_Status__c = ABConfiguration.LOANMODIFICATIONACTION;
        log5.nFUSE__Api_Version__c = '1';
        log5.nFUSE__App_Plugin__c = 'AutomatedBooking';
        log5.nFUSE__Primary_Object_Id__c = loan.Id;
        log5.nFUSE__Requested_By_User_Id__c = 'user';
        log5.nFUSE__Transaction_Status__c = 'error';
        insert log5;
        
        nFUSE__Transaction_Log__c log6 = new nFUSE__Transaction_Log__c(Name='TestLog5',nFUSE__External_Id__c='1231231235'); //possible namespace issue
        log6.nFUSE__Action__c = 'test';
        log6.nFUSE__Vendor_Status__c = ABConfiguration.LOAN_COMPLETE;
        log6.nFUSE__Api_Version__c = '1';
        log6.nFUSE__App_Plugin__c = 'AutomatedBooking';
        log6.nFUSE__Primary_Object_Id__c = loan.Id;
        log6.nFUSE__Requested_By_User_Id__c = 'user';
        log6.nFUSE__Transaction_Status__c = 'error';
        insert log6;
        
        nFUSE__Transaction_Log__c log7 = new nFUSE__Transaction_Log__c(Name='TestLog6',nFUSE__External_Id__c='1231231236'); //possible namespace issue
        log7.nFUSE__Action__c = 'test';
        log7.nFUSE__Vendor_Status__c = ABConfiguration.LOAN_RESERVED_COMPLETE;
        log7.nFUSE__Api_Version__c = '1';
        log7.nFUSE__App_Plugin__c = 'AutomatedBooking';
        log7.nFUSE__Primary_Object_Id__c = loan.Id;
        log7.nFUSE__Requested_By_User_Id__c = 'user';
        log7.nFUSE__Transaction_Status__c = 'error';
        insert log7;
        
        nFUSE__Transaction_Log__c log8 = new nFUSE__Transaction_Log__c(Name='TestLog7',nFUSE__External_Id__c='1231231237'); //possible namespace issue
        log8.nFUSE__Action__c = 'test';
        log8.nFUSE__Vendor_Status__c = ABConfiguration.LOAN_RENEWAL_COMPLETE;
        log8.nFUSE__Api_Version__c = '1';
        log8.nFUSE__App_Plugin__c = 'AutomatedBooking';
        log8.nFUSE__Primary_Object_Id__c = loan.Id;
        log8.nFUSE__Requested_By_User_Id__c = 'user';
        log8.nFUSE__Transaction_Status__c = 'error';
        insert log8;
        
        nFUSE__Transaction_Log__c log9 = new nFUSE__Transaction_Log__c(Name='TestLog8',nFUSE__External_Id__c='1231231238'); //possible namespace issue
        log9.nFUSE__Action__c = 'test';
        log9.nFUSE__Vendor_Status__c = ABConfiguration.LOAN_MODIFICATION_COMPLETE;
        log9.nFUSE__Api_Version__c = '1';
        log9.nFUSE__App_Plugin__c = 'AutomatedBooking';
        log9.nFUSE__Primary_Object_Id__c = loan.Id;
        log9.nFUSE__Requested_By_User_Id__c = 'user';
        log9.nFUSE__Transaction_Status__c = 'error';
        insert log9;
        
        System.currentPageReference().getParameters().put('id', loan.Id);
        
        ABEntities.CompoundTransactionLogResponse historyAsJson = ABLoanController.getTransactionStatus('1231231238');
        
        system.assertEquals(true,historyAsJson != null);
    }
    
    @isTest
    private static void testGetCoreMessage(){
    	
    	new nFUSE.DataInstaller().onInstall(null);
    	
    	ABConfiguration configuration = new ABConfiguration();
        configuration.LoadPluginConfigurations();
        configuration.TogglePluginConfigurations(true);
        
    	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
    	loan.LLC_BI__lookupKey__c = 'reservednumber';
    	insert loan;
    	
    	System.currentPageReference().getParameters().put('id', loan.Id);
        
        ABLoanController c = new ABLoanController();
        
        Map<String,Object> message = ABLoanController.getCoreMessage(loan.Id,'reservationmessage');
        
        system.assertEquals(true,!message.isEmpty());
    }
    
    
    
    @isTest
    private static void testInitiateBooking(){
    	
    	new nFUSE.DataInstaller().onInstall(null);
    	
    	nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
			ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
		nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
		locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANSENDSERVICENAME);
        
        
    	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
    	// loan.LLC_BI__lookupKey__c = 'reservednumber';
    	insert loan;
    	
    	LLC_BI__External_Application_Lookup__c newExtApp = new LLC_BI__External_Application_Lookup__c(
						LLC_BI__External_Id__c = 'reservednumber',
						LLC_BI__Context_Id__c = loan.Id,
						Name = ABConfiguration.LOANRESERVATIONLOOKUPKEY
					);
		insert newExtApp;
    	
        System.currentPageReference().getParameters().put('id', loan.Id);
        Test.startTest();
        ABEntities.AutomatedBookingResponse result = ABLoanController.bookLoan(loan.Id);
        Test.stopTest();
        system.assertEquals(true,result.IsSuccessful);
    }
    
    @isTest
    private static void testInitiateReservation(){
    	
    	new nFUSE.DataInstaller().onInstall(null);
    	
    	nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
			ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
		nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
		locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANRESERVESENDSERVICENAME);
        
        
    	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
    	// loan.LLC_BI__lookupKey__c = 'reservednumber';
    	insert loan;
    	
        System.currentPageReference().getParameters().put('id', loan.Id);
        Test.startTest();
        ABEntities.AutomatedBookingResponse result = ABLoanController.reserveLoan(loan.Id);
        Test.stopTest();
        system.assertEquals(true,result.IsSuccessful);
    }
    
    @isTest
    private static void testInitiateModification(){
    	
    	new nFUSE.DataInstaller().onInstall(null);
    	
    	nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
			ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
		nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
		locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANMODIFICATIONSENDSERVICENAME);
        
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
        
    	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
    	loan.LLC_BI__lookupKey__c = 'reservednumber_M1';
    	insert loan;
    	
    	
        System.currentPageReference().getParameters().put('id', loan.Id);
        Test.startTest();
        ABEntities.AutomatedBookingResponse result = ABLoanController.modifyLoan(loan.Id);
        Test.stopTest();
        system.assertEquals(true,result.IsSuccessful);
    }
    
    @isTest
    private static void testInitiateRenewal(){
    	
    	new nFUSE.DataInstaller().onInstall(null);
    	
    	nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
			ABConfiguration.PLUGIN_NAME, ABConfiguration.PLUGIN_VERSION, null);
		nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
		locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class, ABConfiguration.LOANRENEWALSENDSERVICENAME);
        
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
        
    	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
    	loan.LLC_BI__lookupKey__c = 'reservednumber_R1';
    	insert loan;
    	
    	
        System.currentPageReference().getParameters().put('id', loan.Id);
        Test.startTest();
        ABEntities.AutomatedBookingResponse result = ABLoanController.renewLoan(loan.Id);
        Test.stopTest();
        system.assertEquals(true,result.IsSuccessful);
    }
    
    
    
    
    
    
    
    
    @isTest
    private static void testInitiateBooking_Errors(){
    	
    	new nFUSE.DataInstaller().onInstall(null);
    	
        //already been booked
    	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
    	loan.LLC_BI__lookupKey__c = 'reservednumber';
    	insert loan;
    	
        System.currentPageReference().getParameters().put('id', loan.Id);
        
        ABLoanController.forceTestingException = true;
        
        Test.startTest();
        ABEntities.AutomatedBookingResponse result = ABLoanController.bookLoan(loan.Id);
    	system.assertEquals(false,result.IsSuccessful);
        Test.stopTest();
    }
    
    @isTest
    private static void testInitiateReservation_Errors(){
    	
    	new nFUSE.DataInstaller().onInstall(null);
    	
        //already booked
    	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
    	loan.LLC_BI__lookupKey__c = 'reservednumber';
    	insert loan;
    	
		
        System.currentPageReference().getParameters().put('id', loan.Id);
        
        ABLoanController.forceTestingException = true;
        
        
        Test.startTest();
        
    	ABEntities.AutomatedBookingResponse result = ABLoanController.reserveLoan(loan.Id);
    	system.assertEquals(false,result.IsSuccessful);
        
        Test.stopTest();
    }
    
    @isTest
    private static void testInitiateModification_Errors(){
    	
    	new nFUSE.DataInstaller().onInstall(null);
    	
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
        
        //hasnt been booked so error
    	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
    	//loan.LLC_BI__lookupKey__c = 'reservednumber_M1';
    	insert loan;
    	
        System.currentPageReference().getParameters().put('id', loan.Id);
        
        ABLoanController.forceTestingException = true;
        
        
        Test.startTest();
        ABEntities.AutomatedBookingResponse result = ABLoanController.modifyLoan(loan.Id);
    	system.assertEquals(false,result.IsSuccessful);
        
        Test.stopTest();
    }
    
    @isTest
    private static void testInitiateRenewal_Errors(){
    	
    	new nFUSE.DataInstaller().onInstall(null);
    	
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
        
        //hasnt been booked so error
    	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
    	//loan.LLC_BI__lookupKey__c = 'reservednumber_R1';
    	insert loan;
    	
    	
        System.currentPageReference().getParameters().put('id', loan.Id);
        
        ABLoanController.forceTestingException = true;
        
        Test.startTest();
        
        ABEntities.AutomatedBookingResponse result = ABLoanController.renewLoan(loan.Id);
        system.assertEquals(false,result.IsSuccessful);
        
        
        Test.stopTest();
       
    }
    
    
}