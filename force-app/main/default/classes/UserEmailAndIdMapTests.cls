// Author: Rick Philson
// Date Created: 2017-05-31
// 
// Project: ResourceOne Leads
// Purpose: Test class for UserEmailAndMapTests
//
@isTest

private class UserEmailAndIdMapTests {

    //Test 1: input - email address in all lower case characters
    //        expected result: User.Id for rphilson@fnni.com
    @isTest private static void getUserIdUsingEmailAddress_ValidEmail_AllLowerCaseCharacters() {
        //Assign
        UserEmailAndIdMap emailIdMap = new UserEmailAndIdMap();
                
        //Act
        Id actualValue = emailIdMap.getUserIdUsingEmailAddress('rphilson@fnni.com');
        Id expectedValue = '005a000000COYqXAAX';  //User.Id for Richard Philson; email='rphilson@fnni.com in nCino Sandbox'
        // Id expectedValue = '005a000000DDEz1';  //User.Id for Richard Philson; email='rphilson@fnni.com'        
        
        //Assert
        System.assertEquals(expectedValue, actualValue);
    }

    //Test 2: input - email address in all upper case characters
    //        expected result: User.Id for rphilson@fnni.com
    @isTest private static void getUserIdUsingEmailAddress_ValidEmail_AllUpperCaseCharacters() {
        //Assign
        UserEmailAndIdMap emailIdMap = new UserEmailAndIdMap();
                
        //Act
        Id actualValue = emailIdMap.getUserIdUsingEmailAddress('RPHILSON@FNNI.COM');
        Id expectedValue = '005a000000COYqXAAX';
        //Id expectedValue = '005a000000DDEz1';
        
        //Assert
        System.assertEquals(expectedValue, actualValue); 
    }

    //Test 3: input - email address in mixed case characters
    //        expected result: User.Id for rphilson@fnni.com
    @isTest private static void getUserIdUsingEmailAddress_ValidEmail_MixedCaseCharacters() {
        //Assign
        UserEmailAndIdMap emailIdMap = new UserEmailAndIdMap();
                
        //Act
        Id actualValue = emailIdMap.getUserIdUsingEmailAddress('RPhilson@fnni.com');
        Id expectedValue = '005a000000COYqXAAX';
       // Id expectedValue = '005a000000DDEz1';
        
        //Assert
        System.assertEquals(expectedValue, actualValue);    
    }
    
    //Test 4: input - invalid email address... one not contained in Salesforce
    //        expected result: User.Id for Service Account
    @isTest private static void getUserIdUsingEmailAddress_EmailAddressNotFound_ReturnServiceAccount() {
        //Assign
        UserEmailAndIdMap emailIdMap = new UserEmailAndIdMap();
                
        //Act
        Id actualValue = emailIdMap.getUserIdUsingEmailAddress('rphilson@cox.net');
        Id expectedValue = '005a000000COYqX';
        
        //Assert
        System.assertEquals(expectedValue, actualValue);    
    }

    //Test 5: input - invalid email address... blank (or spaces)
    //        expected result: User.Id for Service Account
    @isTest private static void getUserIdUsingEmailAddress_BlankEmailAddress_ReturnServiceAccount() {
        //Assign
        UserEmailAndIdMap emailIdMap = new UserEmailAndIdMap();
                
        //Act
        Id actualValue = emailIdMap.getUserIdUsingEmailAddress('');
        Id expectedValue = '005a000000COYqX';
        
        //Assert
        System.assertEquals(expectedValue, actualValue);    
    }


    //Test 6: input - invalid email address... null
    //        expected result: User.Id for Service Account
    @isTest private static void getUserIdUsingEmailAddress_EmailAddressIsNull_ReturnServiceAccount() {
        //Assign
        UserEmailAndIdMap emailIdMap = new UserEmailAndIdMap();
                
        //Act
        Id actualValue = emailIdMap.getUserIdUsingEmailAddress(null);
        Id expectedValue = '005a000000COYqX';
        
        //Assert
        System.assertEquals(expectedValue, actualValue);    
    }

}