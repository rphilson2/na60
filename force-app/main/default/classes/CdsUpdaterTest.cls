@isTest
public class CdsUpdaterTest {
 
    @testSetup 
    static void setup(){
        List<TriggerSupport__c> triggerSupportList = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSupportSetting = new TriggerSupport__c();
        accountTriggerSupportSetting.Name = 'Account';
        accountTriggerSupportSetting.TriggerIsDisabled__c = true;
        triggerSupportList.add(accountTriggerSupportSetting);
        insert triggerSupportList;
        insert new Account(Name = 'CdsTestCustomer',FNB_System_of_record_id__c = '12345678999');
    }
    
    //Positive test
    @isTest 
    static void checkCixfTest(){
        String cixfId = '12345678999'; 

        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = 'https://fnni--ncino.cs69.my.salesforce.com/services/apexrest/account/' + cixfId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        //Call the method to test
        Boolean response = CdsUpdater.checkCixf();

        //Verify status
        System.assertEquals(true,response);
    }
 
    //Negative test
	@isTest 
    static void checkCixfNegTest(){ 		
        String cixfId = '98765432101';
        
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestURI = 'https://fnni--ncino.cs69.my.salesforce.com/services/apexrest/account/' + cixfId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        //Call the method to test
        Boolean response = CdsUpdater.checkCixf();
        
        //Verify status
        System.assertEquals(false,response);
    }
    
    //Positvie test
    @isTest 
    static void addCustomerTest(){
        String cixfId = '12345678990';
        String name = 'CdsTestCustomer';

        RestRequest request = new RestRequest();
        request.requestURI = 'https://fnni--ncino.cs69.my.salesforce.com/services/apexrest/account';
        request.httpMethod = 'Post';
        
        //Call the method to test
        String result = CdsUpdater.addCustomer(cixfId, name); 
        System.assertEquals('SUCCESS',result);
    }
    
    //Negative test
    @isTest 
    static void addCustomerNegTest(){
        String cixfId = '12345678999';
        String name = 'CdsTestCustomer';
        
        //Call the method to test
        String result = CdsUpdater.addCustomer(cixfId, name); 
        System.assertEquals('FAILURE',result);
    }
    @isTest
    static void testUpdateLogs() {
        String cixfId = '12345678990';
        String name = 'CdsTestMeCustomer';

        RestRequest request = new RestRequest();
        request.requestURI = 'https://fnni--ncino.cs69.my.salesforce.com/services/apexrest/account';
        request.httpMethod = 'Post';
        
        //Call the method to test
        String result = CdsUpdater.addCustomer(cixfId, name); 
        List<FnboLog__c> fnlogList = new List<FnboLog__c>();
        
        fnlogList = [Select Action__c from FnboLog__c where SObject_Name__c = 'Account' Limit 5];
        System.assert(fnlogList.size() >0 );
        
        System.assertEquals('Create',fnlogList.get(0).Action__c);  
    }
}