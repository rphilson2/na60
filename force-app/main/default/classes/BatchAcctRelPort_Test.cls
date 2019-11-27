//RJP Notes (2019-09-11):
//The Database.executeBatch is attempting to create FNNI_Account_Relationship_Portal__c records.
//  There is an AFTER INSERT trigger event being called... fnniAccountRelationshipPortalTrigger
//    The trigger call fntsPartnerNetworkConnection.forwardFntsConn() passing in the new FNNI_Account_Relationship_Portal__c records.
//    The network status does not work which is causing the process to fail with an "INVALID_PARTNER_NETWORK_STATUS" error.
//The FNTS bridge may no longer be needed.  If that is the case, the following objects/code can be removed.
//   a. FNNI_Account_Relationship_Portal__c - custom object
//   b. fnniAccountRelationshipPortalTrigger - custom trigger
//   c.	fntsPartnerNetworkConnection - custom class
//   d. BatchAcctRelPort_Test - test class
//   e. fntsPartnerConnForward_Test - test class

@isTest
public class BatchAcctRelPort_Test {
 /*Commenting out the test class as per the Story S-46099
    //DAG 08/07/2018 comment out all instances of Current_Relationship__c.  Field is no longer needed.  ADS ticket ADS0003026.
    public static testMethod void genBatchTest() {
               
        List<Account> testAccts = new List<Account>();
        
        for(Integer i=0;i<30;i++) {
            Account acct = new Account(
            Name = 'Test',
            Current_Card_Relationship__c = 'Test',
            Current_CTS_Relationship__c = 'Test',
          //Current_Relationship__c = 'Test',
            Current_Insurance_Relationship__c = 'Test',
            Current_Lauritzen_Relationship__c = 'Test',
            Current_Lending_Relationship__c = 'Test',
            Current_Wealth_Account__c = 'Test');
            
            testAccts.add(acct);
        }
        
        insert testAccts;
        
        
        Test.startTest();
        batchAcctRelPortGen testGen = new batchAcctRelPortGen();
      //testGen.query = 'SELECT Id, Name, Current_Card_Relationship__c, Current_CTS_Relationship__c, Current_Relationship__c, Current_Insurance_Relationship__c,Current_Lauritzen_Relationship__c, Current_Lending_Relationship__c, Owner_Full_Name__c, Current_Wealth_Account__c FROM Account WHERE IsPersonAccount = False AND Non_Disclosure_Agreement__c = False';
        testGen.query = 'SELECT Id, Name, Current_Card_Relationship__c, Current_CTS_Relationship__c, Current_Insurance_Relationship__c,Current_Lauritzen_Relationship__c, Current_Lending_Relationship__c, Owner_Full_Name__c, Current_Wealth_Account__c FROM Account WHERE IsPersonAccount = False AND Non_Disclosure_Agreement__c = False';
        Database.executeBatch(testGen);
        Test.stopTest();
        
        System.assertEquals(Database.countquery('SELECT COUNT() FROM FNNI_Account_Relationship_Portal__c'), 30);
    }    
       
    public static testMethod void delbatchTest() {
               
        List<FNNI_Account_Relationship_Portal__c> testRelPortRecs = new List<FNNI_Account_Relationship_Portal__c>();
        
        for(Integer i=0;i<30;i++) {
            FNNI_Account_Relationship_Portal__c rec = new FNNI_Account_Relationship_Portal__c(
            Name__c = 'Test');
            
            testRelPortRecs.add(rec);
        }
        
        insert testRelPortRecs;
        
        
        Test.startTest();
        batchAcctRelPortDel testDel = new batchAcctRelPortDel();
        testDel.query = 'SELECT Id FROM FNNI_Account_Relationship_Portal__c';
        Database.executeBatch(testDel);
        Test.stopTest();
        
        System.assertEquals(Database.countquery('SELECT COUNT() FROM FNNI_Account_Relationship_Portal__c'), 0);
    }*/
}