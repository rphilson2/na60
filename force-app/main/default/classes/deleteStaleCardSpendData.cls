// Author: Rick Philson
// Date Created: 2017-07-06
// Project: Automate Purging Card Spend Monthly Data S-05706
// Purpose: Identify and delete Card Spend Monthly records older than 24 months
// Project Components:
//    deleteStaleCardSpendData - implements Batchable
//    deleteStaleCardSpendDataTests - test class
//    schedulerDeleteStaleCardSpendData - implements Schedulable
//    schedulerDeleteStaleCardSpendDataTests - test class

global class deleteStaleCardSpendData implements Database.Batchable<sObject>, Database.Stateful {
    //private instance fields
    string query;
    
    //constructor
    global deleteStaleCardSpendData(String soql) {
        //if (Test.isRunningTest()) {
            System.debug('>>>entering deleteStaleCardSpendData() using ' + soql);
        //}
        query = soql;
    }
        
    //start: collect the records or objects to be passed to the interface method execute
    global Database.QueryLocator start(Database.BatchableContext bc) {
        //if (Test.isRunningTest()) {
            System.debug('>>>entering start()... query=' + query);
        //}
 
        return Database.getQueryLocator(query);
    }
    
    //execute: delete the stale records identified in start()
    global void execute(Database.BatchableContext bc, List<Card_Spend__c> staleRecords) {
        //if (Test.isRunningTest()) {
            System.debug('>>>entering execute()... staleRecords.size()=' + staleRecords.size());
        //}
        
        try {
            //try to delete staleRecords
            //if (Test.isRunningTest()) {
                System.debug('>>>execute()::deleting ' + staleRecords.size() + ' records');
            //}
            delete staleRecords;
            //if (Test.isRunningTest()) {
                System.debug('>>>execute()::delete completed');
            //}
        } catch (Exception e) {
            System.debug('==> Exception: ' + e.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        //if (Test.isRunningTest()) {
             System.debug('>>>entering finish()... ');
        //}
        
        //get results of batch job
        AsyncApexJob aaJob = [SELECT Id, 
                                     Status,
                                     NumberOfErrors,
                                     JobItemsProcessed,
                                     TotalJobItems,
                                     CompletedDate,
                                     ExtendedStatus,
                                     ApexClass.name
                                FROM AsyncApexJob
                               WHERE id = :bc.getJobId()];

        //compose email message
        List<String> emailContent =  new List<String>();
        emailContent.add('Results from ' + aaJob.ApexClass.name);
        emailContent.add('query: ' + query);
        emailContent.add('jobItemsProcessed: ' + aaJob.JobItemsProcessed);
        emailContent.add('totalJobItems: ' + aaJob.TotalJobItems);
        emailContent.add('numberOfErrors: ' + aaJob.NumberOfErrors);
    
        //build email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();     
        mail.setToAddresses(new String[] {'SalesforceNotifications@fnni.com'} );
        mail.setReplyTo('noreply@salesforce.com');                      
        mail.setSubject('Batch Job Summary -- ' + aaJob.ApexClass.name);
        mail.setPlainTextBody(string.join(emailContent, '\n'));
        
        //if (Test.isRunningTest()) {
            System.debug('>>>mailMessage: ' + '\n' + string.join(emailContent, '\n'));
        //}
        
        try {
            //send email in case of no errors
            Messaging.sendEmail( new Messaging.SingleEmailMessage[]{mail});    
        } catch (Exception e) {
            System.debug('==> Exception: ' + e.getMessage());
            System.debug('>>>mailMessage: ' + '\n' + string.join(emailContent, '\n'));
        }
    }
}