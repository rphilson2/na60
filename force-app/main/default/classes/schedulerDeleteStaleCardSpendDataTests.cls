// Author: Rick Philson
// Date Created: 2017-07-06
// Project: Automate Purging Card Spend Monthly Data S-05706
// Purpose: Identify and delete Card Spend Monthly records older than 24 months
// Project Components:
//    deleteStaleCardSpendData - implements Batchable
//    deleteStaleCardSpendDataTests - test class
//    schedulerDeleteStaleCardSpendData - implements Schedulable
//    schedulerDeleteStaleCardSpendDataTests - test class

@isTest(SeeAllData=true)
public class schedulerDeleteStaleCardSpendDataTests {

    public static testmethod void testSchedule() {
        Test.StartTest();
            DateTime dt = Datetime.now().addMinutes(1);
            String CRON_EXPRESSION = '0 ' + dt.minute() + ' ' + dt.hour() + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
            schedulerDeleteStaleCardSpendData batchJob = new schedulerDeleteStaleCardSpendData();
            batchJob.SOQL_QUERY = 'SELECT Id, Month_End__c FROM Card_Spend__c WHERE Month_End__c = 2015-02-28 LIMIT 200';
            String jobId = System.Schedule('Test schedulerDeleteStaleCardSpendData', CRON_EXPRESSION , batchJob);
        Test.stopTest();
        System.debug('>>> batch jobId: ' + jobId);
    }
}