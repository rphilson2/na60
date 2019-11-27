@IsTest
public class UpdateErrorLogTest {

      @isTest static void TestErrorLog() {
        // Test data setup                
        Dataload_Error_Log__c el = new Dataload_Error_Log__c(External_ID__c='65000211848');
        insert el;   
        
        // Perform test        
        List<Dataload_Error_Log__c> el2 = [SELECT External_ID__c FROM Dataload_Error_Log__c LIMIT 1];
        Test.startTest();
        System.assertEquals('65000211848', el2[0].External_ID__c);        
        Test.stopTest();
    }    
}