@isTest
public class Test_FNNI_PortalRegHandler {
    public static User loginUser;

    private static final String FIRST_NAME = 'First Name';
	private static final String LAST_NAME = 'Last Name';
	private static final String EMAIL = 'Email';
	private static final String FEDERATION_ID = 'Federation Id';
	private static final String PHONE = 'Phone';
    private static final String PRODUCT = 'Product Code';
    private static final String BANKNO = 'Bank Number';

	private static final String SSO_FIRST_NAME = 'first_name';
	private static final String SSO_LAST_NAME = 'last_name';
	private static final String SSO_EMAIL = 'email_address';
	private static final String SSO_SUBJECT = 'subject';
	private static final String SSO_PHONE = 'phone';
    private static final String SSO_PRODUCT = 'product';
    private static final String SSO_BANKNO = 'bank_number';

    private static final String SSO = 'SSO';
    
    @TestSetup
    private static void setup(){
        // Create FieldMaps
        setupFieldMaps();
        
        
    }
    
    @isTest
    private static void testupdateFederationIDonAccount(){
        Account a = new Account(Name='Test Account Name', FNB_System_of_record_id__c = FEDERATION_ID, ownerId = [SELECT ID FROM User WHERE Name ='Service Account' LIMIT 1].id);
        insert a;
        FNNI_PortalRegHandler.updateFederationIDonAccount(a.id, FEDERATION_ID);
    }

    @isTest
    private static void testfindExistingIndividual(){
		FNNI_PortalRegHandler prh = new FNNI_PortalRegHandler();
        Contact c1 = prh.findExistingIndividual(null);
        System.assertEquals(null, c1);
        
        Account a = new Account(Name='Test Account Name', FNB_System_of_record_id__c = FEDERATION_ID, ownerId = [SELECT ID FROM User WHERE Name ='Service Account' LIMIT 1].id);
        insert a;
        Contact c2 = new Contact(LastName = 'Contact Last Name', FirstName = 'test', AccountID = a.id);
        insert c2;
        Contact c3 = prh.findExistingIndividual(FEDERATION_ID);
        System.assertEquals(c2.Id, c3.Id);
    }
    
    @isTest
    private static void testSetAttributes1(){
        Map<String, String> attributes = new Map<String, String> {
            'email_address' => 'newUserZY@fnni.com', 
            'last_name' => 'User',
            'first_name' => 'New',
            'LastName' => 'User',
            'FirstName' => 'New',                    
            'bank_number' => '001-00001',
            'mobile' => '999-999-9999',
            'product' => 'CHK-BAS',
            'phone' => '704-704-7044'
        };
        Contact c = new Contact(LastName = 'Contact Last Name', FirstName = 'test');
        insert c;
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator' Limit 1];    
        User user = new User();
        user.ProfileID = p.Id;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.FirstName = 'first';
        user.LastName = 'last';
        user.Username = 'newUserZZ@fnni.com';   
        user.CommunityNickname = 'testUser123';
        user.Alias = 't1';
        //user.FederationIdentifier = 'newUserZY@fnni.com';
        //user.UserRoleId = r.Id;
        user.Email = 'newUserZZ@fnni.com';
        user.IsActive = true;
 
        insert user;
        
        User u = FNNI_PortalRegHandler.setAttributes(user, c, attributes);
        
        system.assertEquals(c.LastName, u.LastName);
        system.assertEquals(c.FirstName, u.FirstName);
        system.assertEquals(attributes.get('email_address'), u.Email);
        system.assertEquals(attributes.get('phone'), u.Phone);
       
    }
    
    @isTest
    private static void testSetAttributes2(){
        Map<String, String> attributes = new Map<String, String> {
            'last_name' => 'User',
            'first_name' => 'New',
            'LastName' => 'User',
            'FirstName' => 'New',                    
            'bank_number' => '001-00001',
            'mobile' => '999-999-9999',
            'product' => 'CHK-BAS'
        };
        Contact c = new Contact(LastName = 'Contact Last Name', Work_Phone__c = '7047047044', Email = 'test@test.com');
        insert c;
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator' Limit 1];    
        User user = new User();
        user.ProfileID = p.Id;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.FirstName = 'first';
        user.LastName = 'last';
        user.Username = 'newUserZZ@fnni.com';   
        user.CommunityNickname = 'testUser123';
        user.Alias = 't1';
        //user.FederationIdentifier = 'newUserZY@fnni.com';
        //user.UserRoleId = r.Id;
        user.Email = 'newUserZZ@fnni.com';
        user.IsActive = true;
        insert user;

        User u = FNNI_PortalRegHandler.setAttributes(user, c, attributes);
        
        system.assertEquals(c.LastName, u.LastName);
        system.assertEquals(c.FirstName, u.FirstName);
        system.assertEquals(c.Email, u.Email);
        system.assertEquals(c.Work_Phone__c, u.Phone);
       
    }

                            
    
   @isTest
    private static void test4(){
        Id samlSsoProviderId = null;
        Id communityId = getCommunityId();
        Id portalId = null;
        String assertion = '';
        UserRole r;
				

        //System.runAs ( new User(Id = UserInfo.getUserId()) ) {
         /*  Account a = new Account(Name='Test Account Name', FNB_System_of_record_id__c = 'newUserZY');
            insert a;
         Contact c = new Contact(LastName = 'Contact Last Name', AccountId = a.id);
            insert c; 
             r = [select id from UserRole where PortalType = 'CustomerPortal' limit 1];
            
            // Profile p = [SELECT Id FROM Profile WHERE license = :license Limit 1];     
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus Login User' Limit 1];
            */
			Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator' Limit 1];    
            User user = new User();
            user.ProfileID = p.Id;
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.TimeZoneSidKey = 'America/New_York';
            user.LocaleSidKey = 'en_US';
            user.FirstName = 'first';
            user.LastName = 'last';
            user.Username = 'newUserZZ@fnni.com';   
            user.CommunityNickname = 'testUser123';
            user.Alias = 't1';
            //user.FederationIdentifier = 'newUserZY@fnni.com';
            //user.UserRoleId = r.Id;
            user.Email = 'newUserZZ@fnni.com';
            user.IsActive = true;
            //user.ContactId = c.Id;
           // user.PortalRole = 'Manager';
           // user.nPortal__Is_Customer_Portal_Account_Owner_User__c = true;
           // user.nPortal__Has_Reached_Ownership_Limit__c = false;

            
            insert user;
    
        //   }
         
		//User cuser = [SELECT Id, UserRoleId, Username, LastName, Email, Alias, CommunityNickname from User where ProfileId = :p.Id];
        System.RunAs(user) {
 
             String federationIdentifier = 'newUserZY@fnni.com';
            Map<String, String> attributes = new Map<String, String> {
                'email_address' => 'newUserZY@fnni.com', 
                    'first_name' => 'New',
                    'bank_number' => '001-00001',
                    'phone' => '999-999-9999',
                    'product' => 'CHK-BAS',
                    'FederationIdentifier' => 'newUserZY@fnni.com'
                    };
        
            FNNI_PortalRegHandler prh = new FNNI_PortalRegHandler();
            loginUser = prh.createUser(samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, null);

          
            attributes = new Map<String, String> {
                'email_address' => 'newUserZY@fnni.com', 
                    'last_name' => 'User',
                    'first_name' => 'New',
                    'LastName' => 'User',
                    'FirstName' => 'New',                    
                    'bank_number' => '001-00001',
                    'mobile' => '999-999-9999',
                    'product' => 'CHK-BAS'
                    };
        
           
            loginUser = prh.createUser(samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, null);   
			
			attributes = new Map<String, String> {
                'email_address' => 'newUserZY@fnni.com', 
                    'first_name' => 'New',
                    'bank_number' => '001-00001',
                    'phone' => '999-999-9999',
                    'product' => 'CHK-BAS',
                    'FederationIdentifier' => 'newUserZY@fnni.com'
                    };
      
            loginUser = prh.createUser(samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, null);		
			           Account a = new Account(Name='Test Account Name', FNB_System_of_record_id__c = 'newUserZY');
					     Contact c = new Contact(LastName = 'Contact Last Name', AccountId = a.id);
         
            insert a;	 
			insert c;   
			attributes = new Map<String, String> {
                'email_address' => 'newUserZY@fnni.com', 
                    'first_name' => 'New',
                    'bank_number' => '001-00001',
                    'phone' => '999-999-9999',
                    'product' => 'CHK-BAS',
                    'FederationIdentifier' => 'newUserZY@fnni.com'
                    };
        
            federationIdentifier = 'newUserZY@fnni.com';
            loginUser = prh.createUser(samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, null);     
			attributes = new Map<String, String> {
                'email_address' => 'newUserZY@fnni.com', 
                    'last_name' => 'User',
                    'first_name' => 'New',
                    'LastName' => 'User',
                    'FirstName' => 'New',                    
                    'bank_number' => '001-00001',
                    'mobile' => '999-999-9999',
                    'product' => 'CHK-BAS',
					'FederationIdentifier' => 'newUserZY@fnni.com',
					'ContactId' => c.Id
                    };
        
      
            loginUser = prh.createUser(samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, null);
        }
    }

	//*
   /* @isTest
    private static void test3(){
        Id samlSsoProviderId = null;
        Id communityId = getCommunityId();
        Id portalId = null;
        String assertion = '';
        UserRole r;
        //System.runAs ( new User(Id = UserInfo.getUserId()) ) {
           Account a = new Account(Name='Test Account Name', FNB_System_of_record_id__c = 'newUserZY');
            insert a;
         Contact c = new Contact(LastName = 'Contact Last Name', AccountId = a.id);
            insert c; 
             r = [select id from UserRole where PortalType = 'CustomerPortal' limit 1];
            
            // Profile p = [SELECT Id FROM Profile WHERE license = :license Limit 1];     
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus Login User' Limit 1];
            
            User user = new User();
            user.ProfileID = p.Id;
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.TimeZoneSidKey = 'America/New_York';
            user.LocaleSidKey = 'en_US';
            user.FirstName = 'first';
            user.LastName = 'last';
            user.Username = 'newUserZZ@fnni.com';   
            user.CommunityNickname = 'testUser123';
            user.Alias = 't1';
            //user.FederationIdentifier = 'newUserZY@fnni.com';
            //user.UserRoleId = r.Id;
            user.Email = 'newUserZZ@fnni.com';
            user.IsActive = true;
            user.ContactId = c.Id;
            user.PortalRole = 'Manager';
            user.nPortal__Is_Customer_Portal_Account_Owner_User__c = true;
            user.nPortal__Has_Reached_Ownership_Limit__c = false;

            
            insert user;
    
        //   }
        User cuser = [SELECT Id, UserRoleId, Username, LastName, Email, Alias, CommunityNickname from User where Username = 'newUserZZ@fnni.com'];
        System.RunAs(cuser) {
   
             String federationIdentifier = 'newUserZY@fnni.com';
            Map<String, String> attributes = new Map<String, String> {
                'email_address' => 'newUserZY@fnni.com', 
                    'first_name' => 'New',
                    'bank_number' => '001-00001',
                    'phone' => '999-999-9999',
                    'product' => 'CHK-BAS',
                    'FederationIdentifier' => 'newUserZY@fnni.com'
                    };
        
            FNNI_PortalRegHandler prh = new FNNI_PortalRegHandler();
            loginUser = prh.createUser(samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, null);
           
        }
    }
 
    @isTest
    private static void test2(){
        Id samlSsoProviderId = null;
        Id communityId = getCommunityId();
        Id portalId = null;
        String assertion = '';
        UserRole r;
        //System.runAs ( new User(Id = UserInfo.getUserId()) ) {
           Account a = new Account(Name='Test Account Name');
            insert a;
         Contact c = new Contact(LastName = 'Contact Last Name', AccountId = a.id);
            insert c; 
             r = [select id from UserRole where PortalType = 'CustomerPortal' limit 1];
            
            // Profile p = [SELECT Id FROM Profile WHERE license = :license Limit 1];     
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus Login User' Limit 1];
            
            User user = new User();
            user.ProfileID = p.Id;
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.TimeZoneSidKey = 'America/New_York';
            user.LocaleSidKey = 'en_US';
            user.FirstName = 'first';
            user.LastName = 'last';
            user.Username = 'newUserZZ@fnni.com';   
            user.CommunityNickname = 'testUser123';
            user.Alias = 't1';
            //user.UserRoleId = r.Id;
            user.FederationIdentifier = 'newUserZZ@fnni.com';
            user.Email = 'newUserZZ@fnni.com';
            user.IsActive = true;
            user.ContactId = c.Id;
            user.PortalRole = 'Manager';
            user.nPortal__Is_Customer_Portal_Account_Owner_User__c = true;
            user.nPortal__Has_Reached_Ownership_Limit__c = false;

            
            insert user;
    
        //   }
        User cuser = [SELECT Id, UserRoleId, Username, LastName, Email, Alias, CommunityNickname from User where Username = 'newUserZZ@fnni.com'];
        System.RunAs(cuser) {
   
             String federationIdentifier = 'newUserZY@fnni.com';
            Map<String, String> attributes = new Map<String, String> {
                'email_address' => 'newUserZY@fnni.com', 
                    'first_name' => 'New',
                    'bank_number' => '001-00001',
                    'phone' => '999-999-9999',
                    'product' => 'CHK-BAS'
                    };
        
            FNNI_PortalRegHandler prh = new FNNI_PortalRegHandler();
            loginUser = prh.createUser(samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, null);
           
        }
    }

    @isTest
    private static void test1(){
        
    
       
		  
            
          
        Id samlSsoProviderId = null;
        Id communityId = getCommunityId();
        Id portalId = null;
        String assertion = '';
        UserRole r;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
           Account a = new Account(Name='Test Account Name',  FNB_System_of_record_id__c='newUserZY');
            insert a;
         Contact c = new Contact(LastName = 'Contact Last Name', AccountId = a.id);
            insert c; 
             r = [select id from UserRole where PortalType = 'CustomerPortal' limit 1];
            
            // Profile p = [SELECT Id FROM Profile WHERE license = :license Limit 1];     
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus Login User' Limit 1];
            
            User user = new User();
            user.ProfileID = p.Id;
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.TimeZoneSidKey = 'America/New_York';
            user.LocaleSidKey = 'en_US';
            user.FirstName = 'first';
            user.LastName = 'last';
            user.Username = 'newUserZZ@fnni.com';   
            user.CommunityNickname = 'testUser123';
            user.Alias = 't1';
            //user.UserRoleId = r.Id;
            user.Email = 'newUserZZ@fnni.com';
            user.IsActive = true;
            user.ContactId = c.Id;
            user.FederationIdentifier = 'newUserZZ@fnni.com';
            user.PortalRole = 'Manager';
            user.nPortal__Is_Customer_Portal_Account_Owner_User__c = true;
            user.nPortal__Has_Reached_Ownership_Limit__c = false;

            
            insert user;
    
           }
        User cuser = [SELECT Id, UserRoleId, Username, LastName, Email, Alias, CommunityNickname from User where Username = 'newUserZZ@fnni.com'];
        System.RunAs(cuser) {
   
             String federationIdentifier = 'newUserZY@fnni.com';
            Map<String, String> attributes = new Map<String, String> {
                'email_address' => 'newUserZY@fnni.com', 
                    'last_name' => 'User',
                    'first_name' => 'New',
                    'LastName' => 'User',
                    'FirstName' => 'New',                    
                    'bank_number' => '001-00001',
                    'mobile' => '999-999-9999',
                    'product' => 'CHK-BAS'
                    };
        
            FNNI_PortalRegHandler prh = new FNNI_PortalRegHandler();
            loginUser = prh.createUser(samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, null);
           
        }
    }
    */
    private static void setupFieldMaps() {
		String userObjString = User.getSObjectType().getDescribe().getLocalName();
        List<LLC_BI__Field_Map__c> fieldMaps = new List<LLC_BI__Field_Map__c>();
        fieldMaps.add(
            new LLC_BI__Field_Map__c(
                Name = FIRST_NAME,
                LLC_BI__Orig_Obj__c = SSO,
                LLC_BI__Orig_Obj_Field__c = SSO_FIRST_NAME,
                LLC_BI__Target_Obj__c = userObjString,
                LLC_BI__Target_Obj_Field__c = User.FirstName.getDescribe().getLocalName()
            ));
        fieldMaps.add(
            new LLC_BI__Field_Map__c(
                Name = LAST_NAME,
                LLC_BI__Orig_Obj__c = SSO,
                LLC_BI__Orig_Obj_Field__c = SSO_LAST_NAME,
                LLC_BI__Target_Obj__c = userObjString,
                LLC_BI__Target_Obj_Field__c = User.LastName.getDescribe().getLocalName()
            ));
        fieldMaps.add(
            new LLC_BI__Field_Map__c(
                Name = EMAIL,
                LLC_BI__Orig_Obj__c = SSO,
                LLC_BI__Orig_Obj_Field__c = SSO_EMAIL,
                LLC_BI__Target_Obj__c = userObjString,
                LLC_BI__Target_Obj_Field__c = User.Email.getDescribe().getLocalName()
            ));
        fieldMaps.add(
            new LLC_BI__Field_Map__c(
                Name = FEDERATION_ID,
                LLC_BI__Orig_Obj__c = SSO,
                LLC_BI__Orig_Obj_Field__c = SSO_SUBJECT,
                LLC_BI__Target_Obj__c = userObjString,
                LLC_BI__Target_Obj_Field__c = User.FederationIdentifier.getDescribe().getLocalName()
            ));
        fieldMaps.add(
             new LLC_BI__Field_Map__c(
                 Name = PHONE,
                 LLC_BI__Orig_Obj__c = SSO,
                 LLC_BI__Orig_Obj_Field__c = SSO_PHONE,
                 LLC_BI__Target_Obj__c = userObjString,
                 LLC_BI__Target_Obj_Field__c = User.Phone.getDescribe().getLocalName()
             ));        
        fieldMaps.add(
             new LLC_BI__Field_Map__c(
                 Name = PRODUCT,
                 LLC_BI__Orig_Obj__c = SSO,
                 LLC_BI__Orig_Obj_Field__c = SSO_PRODUCT,
                 LLC_BI__Target_Obj__c = userObjString,
                 LLC_BI__Target_Obj_Field__c = User.Product_Code__c.getDescribe().getLocalName()
             ));        
        fieldMaps.add(
             new LLC_BI__Field_Map__c(
                 Name = BANKNO,
                 LLC_BI__Orig_Obj__c = SSO,
                 LLC_BI__Orig_Obj_Field__c = SSO_BANKNO,
                 LLC_BI__Target_Obj__c = userObjString,
                 LLC_BI__Target_Obj_Field__c = User.Bank_Number__c.getDescribe().getLocalName()
             ));
		insert fieldMaps;
    }
    
	private static Id getCommunityId() {
		return [
			SELECT
				Id
			FROM
				Community
			LIMIT 1
		].Id;
	}    
    
}