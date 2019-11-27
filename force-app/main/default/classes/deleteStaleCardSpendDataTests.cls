// Author: Rick Philson
// Date Created: 07.06.2017
// Project: Automate Purging Card Spend Monthly Data S-05706
// Purpose: Identify and delete Card Spend Monthly records older than 24 months
// Project Components:
//    deleteStaleCardSpendData - implements Batchable
//    deleteStaleCardSpendDataTests - test class
//    schedulerDeleteStaleCardSpendData - implements Schedulable
//    schedulerDeleteStaleCardSpendDataTests - test class

@isTest(SeeAllData=true)
public class deleteStaleCardSpendDataTests {

    static testmethod void deleteRecordsTest_Limit200Records() {
        Test.startTest();
        deleteStaleCardSpendData batchJob = new deleteStaleCardSpendData('SELECT Id, Month_End__c FROM Card_Spend__c WHERE Month_End__c = 2015-02-28 LIMIT 200');
        Database.executeBatch(batchjob, 200);   
        Test.stopTest(); 
    }

  
    //Note: not sure how to force a DmlException
    //static testmethod void deleteRecordTest_ForcedException() {
    //    Test.startTest();
    //    deleteStaleCardSpendData batchJob = new deleteStaleCardSpendData('SELECT Id, Month_End__c FROM Card_Spend__c WHERE Month_End__c = 2015-02-28 LIMIT 200');
    //    Database.executeBatch(batchjob, 200);   
    //    Test.stopTest(); 
    //}
}