// Created By: James McCord
// Modified By: Takashi Koyama
// Created Date:  12/21/2016  Modified Date: 08/22/2019
// Project:  ResourceOne file Integration
// Purpose:  Automation of the processing of data into the Salesforce Platform

@isTest
public class R1QualificationTestClass {
 
    @testSetup static void setup() {
        
        // Create common test accounts
        
       Id r1id = [SELECT Id FROM RecordType
       WHERE sObjectType = 'Lead' AND Name = 'Mortgage Lead' LIMIT 1].Id;
        
        List<Lead> leadList = new List<Lead>();
        
        List<String> c = new List<String>();
            c.add('Miller Electric');
            c.add('Freds Surf Shop');
            c.add('Bangers Groceries');
            c.add('Toms Hardware Shop');
            c.add('Puztys Electronics');
            c.add('Augies Billards');          
 
        
        List<String> last = new List<String>();
            last.add('Miller');
            last.add('Smithston');
            last.add('Cramer');
            last.add('Blugpust');
            last.add('FridenHikel');
            last.add('Capalano');
        
        for (Integer i = 0; i < c.size(); i++) {
            //Lead l = new Lead(Company = c[i],LastName = last[i], Status='Open');
            Lead l = new Lead(Company = c[i],LastName = last[i], Status='Open', RecordTypeId = r1id, ResourceOneOwnerEmail__c = 'cweiss@fnni.com' );
            leadList.add(l);
        }

        insert leadList;             
     }        

    @isTest
    public static  void qualifyRecordTypeTest() {   
        List<Lead> leadList = [SELECT Company, LastName, Status, RecordTypeId, ResourceOneOwnerEmail__c FROM Lead LIMIT 100];
        
        R1Qualification.qualifyRecordType(leadList);         
        System.assertEquals(6, leadList.size());

    }   
 
}