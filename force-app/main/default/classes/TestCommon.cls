// Library of common test methods
public class TestCommon{
    // Create a test volunteer organization.
    public static Volunteer_Organization__c setupVolunteerOrganization(){
    	
        Volunteer_Organization__c vo = new Volunteer_Organization__c( Name='Test Org' );
        
        insert vo;
        
        return vo;
    }
     
    // Create a test Volunteer Activity.
    public static Volunteer_Activity__c setupActivity( Volunteer_Organization__c vo, integer maxParticipants ){
    	
        Volunteer_Activity__c newAct = new  Volunteer_Activity__c( 
                                                City__c='TestCity', 
                                                Country__c='TestCountry',
                                                Description__c='TestDescription',
                                                Name='Test Activity',
                                                State_Province__c='TS',
                                                Street__c='Test Street',
                                                Zip_Postal_Code__c='100101',
                                                Max_Number_of_Participants__c=maxParticipants,
                                                Volunteer_Organization__c=vo.Id,
                                                Date_and_Time__c=DateTime.Now(),
                                                Duration_Hours__c=3.0);

        insert newAct;

        return newAct;
    }
    
    // Used by the generate test user object methods.
    private static integer userTestName = 100;
    private static User [] testUsers = new List<User>();
     
    // Test the sign-up process.
    testmethod static void testSignUp(){
        User newUser = setupUser();
        
        System.assert( newUser != null );
    }
      
    // Create a test user.
    public static User setupUser(){   
        User[] users = setupUsers();
        
        return users[0];
    }
        
    // Create a test user.
    public static User [] setupUsers(){
    	// We only use at most 2 users because DE orgs by default only
    	// come with two user licenses.
        integer quantity = 2;
 
        if( quantity <= TestCommon.testUsers.size() ){
        	return TestCommon.testUsers;
        }
  
        User[] users = [ select Id,LanguageLocaleKey,LocaleSidKey,TimeZoneSidKey,ProfileId,EmailEncodingKey 
                        	from User 
                        	where isActive=true 
                        	limit : quantity ];
   
        for( User user : users ){     	
             TestCommon.testUsers.add( user );
        }
  
        if( quantity <= testUsers.size() ){
            return TestCommon.testUsers;
        }

        integer count = quantity - testUsers.size();
        
        User user = TestCommon.testUsers[0];
                            
        while( count-- > 0 ){	
        	
            string lastName = 'APEX' + userTestName++;
	        string email 	= lastName + '@test.com';
	        string alias 	= lastName.substring(0, 7);
	        
	        User testUser = new User(
                                LastName=lastName,
	                            Alias=alias,
	                            Email=email,
	                            CommunityNickname=lastName,
	                            Username=email,
	                            LocaleSidKey=user.LocaleSidKey,
	                            TimeZoneSidKey=user.TimeZoneSidKey,
	                            ProfileId=user.ProfileId,
	                            EmailEncodingKey=user.EmailEncodingKey,
	                            LanguageLocaleKey=user.LanguageLocaleKey);
	  
	        insert testUser;
	        
	        TestCommon.testUsers.add( testUser );
        }

        return TestCommon.testUsers;
    }
}