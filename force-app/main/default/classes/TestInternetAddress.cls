// Apex test methods for the InternetAddress class.
@isTest
private class TestInternetAddress{
	
    testmethod static void testConstructors(){ 
    	          
        User user = TestCommon.setupUser();
             
        string address 			= 'One Landmark';
        string address2 		= 'One Landmark2';
        string personal 		= 'Volunteerforce';
        string personal2 		= 'Volunteerforce2';
        string encoded_personal = 'test';      
        
        InternetAddress via = new InternetAddress( address, user.Id );
        System.assertEquals( address, via.Address );
        System.assertEquals( null, via.EncodedPersonal );
        System.assertEquals( null, via.Personal );
        System.assertEquals( user.Id, via.UserId );
        System.assertEquals( null, via.CharSet );
        
        via = new InternetAddress( address, personal, user.Id );
        System.assertEquals( address, via.Address );
        System.assertEquals( null, via.EncodedPersonal );
        System.assertEquals( personal, via.Personal );
        System.assertEquals( user.Id, via.UserId );
        System.assertEquals( null, via.CharSet );     
        
        via = new InternetAddress( address, personal, user.EmailEncodingKey, user.Id );
        System.assertEquals( address, via.Address );
        System.assertEquals( null, via.EncodedPersonal );
        System.assertEquals( personal, via.Personal );
        System.assertEquals( user.Id, via.UserId );
        System.assertEquals( user.EmailEncodingKey, via.CharSet ); 
        
        via.EncodedPersonal = encoded_personal;
        System.assertEquals( encoded_personal, via.EncodedPersonal );
        
        via.Address = address2;
        System.assertEquals( address2, via.Address );
        
        via.Personal = personal2;
        System.assertEquals( personal2, via.Personal );  
        
        via.UserId = null;
        System.assertEquals( null, via.UserId );
        
        via.CharSet = null;
        system.assertEquals( null, via.Charset );      
    }
}