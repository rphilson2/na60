// Author: Rick Philson
// Date Created: 2017-07-06
// Project: Automate Purging Card Spend Monthly Data S-05706
// Purpose: Identify and delete Card Spend Monthly records older than 24 months
// Project Components:
//    deleteStaleCardSpendData - implements Batchable
//    deleteStaleCardSpendDataTests - test class
//    schedulerDeleteStaleCardSpendData - implements Schedulable
//    schedulerDeleteStaleCardSpendDataTests - test class

global with sharing class schedulerDeleteStaleCardSpendData implements Schedulable {
    //Note 1: @TestVisible makes the private instance variable accessible for testing classes
    //Note 2: date less than operator identifies records OLDER than condition.
    //        Specifically, WHERE Month_End__c < LAST_N_MONTHS:24 identifies records older than 24 months
    @TestVisible private String SOQL_QUERY = 'SELECT Id, Month_End__c, RecordTypeId FROM Card_Spend__c WHERE Month_End__c < LAST_N_MONTHS:24';

    global void execute(SchedulableContext sc) {
        try {
            //instantiate Apex batch class
            deleteStaleCardSpendData batchClass = new deleteStaleCardSpendData(SOQL_QUERY);
            
            //executeBatch parms: a. context b. batch size)
            Database.executebatch(batchClass, 200);
        } catch (exception e) {
            // Debugs
            System.debug('The following exception has occured: ' + e.getMessage());
            System.debug('Stack Trace: ' + e.getStackTraceString());    
        }
    }
}