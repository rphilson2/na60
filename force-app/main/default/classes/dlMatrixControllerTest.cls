@isTest
public class dlMatrixControllerTest {
     @isTest static void TestFetchDailyStats() {
        Date testDate = Date.newInstance(2019, 8, 8);
        CoreDataLoadStatistic__c cd = new CoreDataLoadStatistic__c(Data_Type__c='BusinessCustomer',Status__c='Completed Successfully',Successful_Record_Count__c = 62132,Failed_Record_Count__c = 2, Load_Date__c = testDate);
        insert cd; 
         
        List<CoreDataLoadStatistic__c> dailyStats = dlMatrixController.fetchDailyStats(testDate);
        System.assertEquals('BusinessCustomer', dailyStats[0].Data_Type__c);
        System.assertEquals(62132, dailyStats[0].Successful_Record_Count__c);
    }
    
      @isTest static void TestGetErrorLog() {
        // Test data setup        
        // Create an account with an opportunity, and then try to delete it        
        Date testDate = System.today() - 1;
        Dataload_Error_Log__c el = new Dataload_Error_Log__c(Object_Type__c='BusinessCustomer', External_Id__c = '65000211848_2019-09-10', FNB_System_of_record_id__c='65000211848', Business_Name__c='Vivian M Bonham Trust', Error__c='DUPLICATES_DETECTED:You cannot create this record because there is a duplicate identified in Salesforce.',Date_Insert__c = testDate);
        insert el;   
        
        // Perform test
        //         
        List<Dataload_Error_Log__c> el2 = dlMatrixController.getErrorLog(System.today() - 1, 'BusinessCustomer');        
        Test.startTest();
        System.assertEquals('65000211848', el2[0].FNB_System_of_record_id__c);
        System.assertEquals('Vivian M Bonham Trust', el2[0].Business_Name__c);
        Test.stopTest();
    }    
}