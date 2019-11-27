@RestResource(urlMapping='/accounts/*')
global with sharing class CdsUpdater {
    
    @HttpGet
    //endpoint: https://instance.salesforce.com/services/apexrest/accounts/cixfId
    global static Boolean checkCixf() {
        RestRequest req = RestContext.request;
        String details = null;
		String Status = 'Failure';       
        // get the cixfId from the end of the URL
        String cixfId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);       
        System.debug('Cds Updater - The cixfId is ' + cixfId);
        List<Account> results = new List<Account>();
        // query for exsiting account with cixfId
        results = [SELECT Id FROM Account WHERE FNB_System_of_record_id__c =: cixfId];  
        System.debug('Cds Updater - Result size: ' + results.size());
        status = 'Success';
        
        // if query returns any record, means the cixfId exists
        if(results.size()>0){
            details = 'Customer with CIXFID '+ cixfid + ' exists.';
            updateLogs('Get','checkCixf', 'Account', status, details);
            return true;
        } else{
            details = 'Customer with CIXFID '+ cixfid + ' does not exist.';
            updateLogs('Get','checkCixf', 'Account', status, details);
            return false;
        }
    }
  
    @HttpPost
    //endpoint: https://instance.salesforce.com/services/apexrest/account
    global static String addCustomer(String cixfId, String name) {
        
        String status = 'FAILURE';
        String details = null;
        Account account = new Account();
        account.Name = name;
        account.FNB_System_of_record_id__c = cixfId;
        
        // Create a new account
        try{
            insert account;
            status = 'SUCCESS';
            details = 'Customer '+ name +'with CIXFID '+ cixfid + ' is successfully inserted';
        }catch (Exception e){
            details = 'Failed inserting the record for Customer '+ name +'with CIXFID '+ cixfid +
                'with this error: ' + e.getMessage() ;
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        updateLogs('Create','addCustomer', 'Account', status, details);
        return status;     
    }
    @testVisible
    public static void updateLogs(String action, String apiname, String objectName, String status, String details ) {
        FnboLog__c fnlog = new FnboLog__c();
        fnlog.Action__c = action;
        fnlog.API_Name__c = apiname; 
        fnlog.SObject_Name__c = objectName;
        fnlog.Status__c = status;
        fnlog.Log_Detail__c = details;
        insert fnlog;
    }
    
}