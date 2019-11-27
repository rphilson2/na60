@isTest
global class ProductLandingPageControllerTest {


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

	static LLC_BI__Product__c createProduct(String subProductCode) {
		return createProduct(createDefaultProductType(), null, subProductCode);
	}

	static LLC_BI__Product__c createProduct(LLC_BI__Product_Type__c sProductType, LLC_BI__Product_Feature__c sProductFeature, String subProductCode) {
		Id productTypeId = null;

		if(sProductType != null && sProductType.Id != null) productTypeId = sProductType.Id;
		else productTypeId = createDefaultProductType().Id;

		LLC_BI__Product__c sProduct = new LLC_BI__Product__c(
			Name = 'Test Product '+ subProductCode,
			LLC_BI__Product_Type__c = productTypeId,
			LLC_BI__RealEstate_Type__c = 'LLC_BI__RealEstate_Type__c',
            SubProduct_Code__c = subProductCode
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
                Product_Code__c = 'SAV-DEP'
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
        return [SELECT Id, AccountID FROM User WHERE Alias = 'portal'];
    }
    
    @isTest
    static void testredirect() {
        LLC_BI__Product__c prod0 = createProduct('S2');
        Id ProductId = prod0.id;
        ProductLandingPageController controller = new ProductLandingPageController();
        PageReference pr = controller.getPage(ProductId);

        System.runas(getPortalUserId()){
            Test.startTest();
            PageReference prNew = controller.redirect();
            System.assertEquals(pr.getUrl(),prNew.getUrl());  
            System.assertEquals(true,prNew.getRedirect());  
            Test.stopTest();
        }
    }
    
    
    @isTest
    public static void testGetPage(){
        LLC_BI__Product__c prod0 = createProduct('73');
        Id ProductId = prod0.id;
        PageReference pr = Page.nPORTAL__OnlineApplication;
        String prefUrl = pr.getUrl();
        prefUrl += '?new=true&productId=' + productId;

        Test.startTest();
        ProductLandingPageController controller = new ProductLandingPageController();
        PageReference prNew = controller.getPage(productId);
        System.assertEquals(prefUrl,prNew.getUrl());  
		Test.stopTest();
    }
    
    
    @isTest
    public static void testgetUser(){
        User u = getPortalUserId();
        System.runas(u){
            Test.startTest();
    		System.assertEquals(u.id, ProductLandingPageController.getUser(u.id).id);
	    	Test.stopTest();
        }
    }

    @isTest
    public static void testgetAccount(){
        User u = getPortalUserId();
        System.runas(u){
            Test.startTest();
    		System.assertEquals(u.AccountID, ProductLandingPageController.getAccount(u.AccountID).id);
	    	Test.stopTest();
        }
    }
    
    @isTest
    public static void testgetValidCustomerTier(){
        Test.startTest();
        System.assertEquals('0', ProductLandingPageController.getValidCustomerTier('0'));
        System.assertEquals('1', ProductLandingPageController.getValidCustomerTier('1'));
        System.assertEquals('2', ProductLandingPageController.getValidCustomerTier('2'));
        System.assertEquals('0', ProductLandingPageController.getValidCustomerTier(null));
        System.assertEquals('0', ProductLandingPageController.getValidCustomerTier('3'));
		Test.stopTest();
    }
    
	@isTest
    public static void testgetProductId(){
        String subProductId = '73';
        LLC_BI__Product__c prod = createProduct(subProductId);
        Test.startTest();
		System.assertEquals(prod.id, ProductLandingPageController.getProductId(subProductId));
		Test.stopTest();
    }
    
    @isTest
    public static void testGetSubProductCode(){
        Test.startTest();
        System.assertEquals('73', ProductLandingPageController.GetSubProductCode('CHK-BAS', null));
        System.assertEquals('73', ProductLandingPageController.GetSubProductCode('CHK-BAS', '0'));
        System.assertEquals('73', ProductLandingPageController.GetSubProductCode('CHK-BAS', '1'));
        System.assertEquals('73', ProductLandingPageController.GetSubProductCode('CHK-BAS', '2'));
        
        System.assertEquals('99', ProductLandingPageController.GetSubProductCode('CHK-PRM', '0'));
        System.assertEquals('99', ProductLandingPageController.GetSubProductCode('CHK-PRM', '1'));
        System.assertEquals('99', ProductLandingPageController.GetSubProductCode('CHK-PRM', '2'));
        System.assertEquals('99', ProductLandingPageController.GetSubProductCode('CHK-PRM', null));
        
        System.assertEquals('S2', ProductLandingPageController.GetSubProductCode('SAV-DEP', '0'));
        System.assertEquals('S4', ProductLandingPageController.GetSubProductCode('SAV-DEP', '1'));
        System.assertEquals('E4', ProductLandingPageController.GetSubProductCode('SAV-DEP', '2'));
        System.assertEquals(null, ProductLandingPageController.GetSubProductCode('SAV-DEP', null));
        
        System.assertEquals('M3', ProductLandingPageController.GetSubProductCode('SAV-MMA', '0'));
        System.assertEquals('M4', ProductLandingPageController.GetSubProductCode('SAV-MMA', '1'));
        System.assertEquals('E7', ProductLandingPageController.GetSubProductCode('SAV-MMA', '2'));
        System.assertEquals(null, ProductLandingPageController.GetSubProductCode('SAV-MMA', null));
        
        System.assertEquals(null, ProductLandingPageController.GetSubProductCode(null, null));  
        System.assertEquals(null, ProductLandingPageController.GetSubProductCode('BOGIE', null));  
		Test.stopTest();
    }
    
}