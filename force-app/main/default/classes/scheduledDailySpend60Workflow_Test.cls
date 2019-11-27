@istest
public without sharing class scheduledDailySpend60Workflow_Test {
    static testmethod void scheduledDailySpend60Workflow_Test() {
        //08/08/2019 Added as part of test class fix -begin
        List<TriggerSupport__c> triggerSupportList = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSupportSetting = new TriggerSupport__c();
        accountTriggerSupportSetting.Name = 'Account';
        accountTriggerSupportSetting.TriggerIsDisabled__c = true;
        triggerSupportList.add(accountTriggerSupportSetting);
        insert triggerSupportList;
        
        Account daily60acct = new Account(Name = 'daily60acct', Existing_Company_Id__c = '12345' , Cards_Mailed_Date__c = Datetime.newInstance(2016, 1, 1, 1, 1, 1), X60_Day_Daily_Spend_Sum__c = 0, 
                                     X180_Day_Daily_Spend_Sum__c = 0, X60_Day_Daily_Spend__c = false, X180_Day_Daily_Spend__c = false, Est_60_Day_Spend__c = 50, 
                                     Est_180_Day_Spend__c = 50, Card_Product_FBC_Sales_Person__c = '005a000000CLOKt');
        
        insert daily60acct;
        
        Test.startTest();
        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        String jobId = System.schedule('Sample_Heading', CRON_EXP, new scheduledAccountDaily60SpendWorkflow() );   
        Test.stopTest();
        
        System.assertEquals(daily60acct.X60_Day_Daily_Spend__c, false);
        
    }

}