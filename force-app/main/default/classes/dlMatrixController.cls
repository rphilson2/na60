public class dlMatrixController {
    @AuraEnabled
    public static List<CoreDataLoadStatistic__c> fetchDailyStats(Date insertDate) {
        List<CoreDataLoadStatistic__c> dailyStats = [SELECT Data_Type__c, Status__c, Total_Record_Count__c, Successful_Record_Count__c, Failed_Record_Count__c 
                                                     FROM CoreDataLoadStatistic__c WHERE Load_Date__c = :insertDate];
        return dailyStats;
    }
    
    @AuraEnabled
    public static List<Dataload_Error_Log__c> getErrorLog(Date insertDate, String objType)
    {
        List<Dataload_Error_Log__c> ErrorLogFieldValues = [SELECT FNB_System_of_Record_Id__c, First_Name__c, Middle_Name__c, Last_Name__c, Business_Name__c, DBA__c, 
                                                  Tax_ID__c, TriggerData_ID__c, Bank_Number__c, Trigger_Type__c, Assignee__c, PL_ID__c, Precision_Lender_ID__c, CIXF_ID__c, CIXF__c,
                                                  Error__c, Date_Insert__c FROM Dataload_Error_Log__c 
                                                  WHERE Date_Insert__c = :insertDate AND Object_Type__c = :objType];
        return ErrorLogFieldValues;
    }
}