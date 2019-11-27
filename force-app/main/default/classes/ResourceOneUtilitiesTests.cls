// Author: Rick Philson
// Date Created: 2017-05-30
// 
// Project: ResourceOne Leads
// Purpose: Test class for ResourceOneUtilities
//

@isTest

private class ResourceOneUtilitiesTests {

    //Test 1: input - List<Lead> with ResourceOne RecordTypeId
    //        expected result: true, the List<Lead> is from ResourceOne
    @isTest static void isResourceOneRecord_ValidResourceOneRecordType() {
        //Arrange
        List<Lead> leads = BuildTestLeads('012a0000001NbXnAAK');      
        
        //Act
        Boolean actual = ResourceOneUtilities.isResourceOneRecord(leads);
        
        //Assert
        System.assertEquals(true, actual);        
    }
    
    //Test 2: input - List<Lead> with non-ResourceOne RecordTypeId
    //        expected result: false, the List<Lead> is NOT from ResourceOne
    @isTest static void isResourceOneRecord_InvalidResourceOneRecordType() {
        //Arrange
        List<Lead> leads = BuildTestLeads('01230000000sYhS');      
       
        //Act
        Boolean actual = ResourceOneUtilities.isResourceOneRecord(leads);
        
        //Assert
        System.assertEquals(false, actual);        
    }
    
    //Test 3: input - List<Lead> with blank (aka spaces) RecordTypeId
    //        expected result: false, the List<Lead> is NOT from ResourceOne
    //   Note: this test fails for the wrong reason.
    //      I'd like to simulate creating a Lead with a blank record type;
    //      As of 2017-05-31, I am unable to create a Lead with a blank RecordTypeId.
    //         --> System.StringException:Invalid id
    //      To that end, I am commenting out Test 3
    //@isTest static void isResourceOneRecord_RecordTypeIdIsBlank() {
        //Arrange
        //List<Lead> leads = BuildTestLeads('  ');      
        
        //Act
        //Boolean actual = ResourceOneUtilities.isResourceOneRecord(leads);
        
        //Assert
        //System.assertEquals(false, actual);        
    //}

    //Test 4: input - List<Lead> without setting the RecordTypeId... RecordTypeId == null
    //        expected result: false, the List<Lead> is NOT from ResourceOne
    @isTest static void isResourceOneRecord_RecordTypeIdIsNull() {
        //Arrange
        List<Lead> leads = new List<Lead>(); 
        leads.add(new Lead(Company='Disney', LastName='Mouse', FirstName='Mickey', Status='Open'));
        leads.add(new Lead(Company='Disney', LastName='Duck', FirstName='Donald', Status='Open'));
        leads.add(new Lead(Company='Warner Bros.', LastName='Fudd', FirstName='Elmer', Status='Open'));
        leads.add(new Lead(Company='Warner Bros', LastName='Bunny', FirstName='Bugs', Status='Open'));
        leads.add(new Lead(Company='Universal', LastName='Rabbit', FirstName='Roger', Status='Open'));
        
        //Act
        Boolean actual = ResourceOneUtilities.isResourceOneRecord(leads);
        
        //Assert
        System.assertEquals(false, actual);        
    }
    

    //Helper Method: build testable List<Lead>
    private static List<Lead> BuildTestLeads(String recordTypeId) {
        List<Lead> leads = new List<Lead>(); 
             
        leads.add(new Lead(Company='Disney', LastName='Mouse', FirstName='Mickey', Status='Open', RecordTypeId=recordTypeId));
        leads.add(new Lead(Company='Disney', LastName='Duck', FirstName='Donald', Status='Open', RecordTypeId=recordTypeId));
        leads.add(new Lead(Company='Warner Bros.', LastName='Fudd', FirstName='Elmer', Status='Open', RecordTypeId=recordTypeId));
        leads.add(new Lead(Company='Warner Bros', LastName='Bunny', FirstName='Bugs', Status='Open', RecordTypeId=recordTypeId));
        leads.add(new Lead(Company='Universal', LastName='Rabbit', FirstName='Roger', Status='Open', RecordTypeId=recordTypeId));
        
        return leads;
    }
}