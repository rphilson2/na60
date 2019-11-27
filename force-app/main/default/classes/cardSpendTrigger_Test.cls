@isTest
public class cardSpendTrigger_Test{

    //08/08/2019 Added as part of test class fix -begin
    @TestSetup
    static void setupData() {    
   	 List<TriggerSupport__c> triggerSupportList = new List<TriggerSupport__c>();
     TriggerSupport__c accountTriggerSupportSetting = new TriggerSupport__c();
     accountTriggerSupportSetting.Name = 'Account';
     accountTriggerSupportSetting.TriggerIsDisabled__c = true;
     triggerSupportList.add(accountTriggerSupportSetting);
     insert triggerSupportList;
    }
	//08/08/2019-end
 
    @IsTest()
    static void cardSpendTrigger_Test(){ 
   
        Account acct = new Account(name = 'test123', Existing_Company_Id__c = '5555', Cards_Mailed_Date__c = Date.newInstance(2016, 5, 17), X60_Day_Daily_Spend_List__c = 'Base', 
                    X180_Day_Daily_Spend_List__c = 'Base', X60_Day_Daily_Spend_Sum__c = 0, X180_Day_Daily_Spend_Sum__c = 0,
                    X60_Day_Daily_Spend__c = False, X180_Day_Daily_Spend__c = False, Est_60_Day_Spend__c = 10000, Est_180_Day_Spend__c = 2000);
        
        insert acct;
        
        String cardSpendRecordTypeId = [SELECT Id 
                                 FROM recordtype 
                                 WHERE sObjectType = 'Card_Spend__c'
                                 AND name = 'Daily'
                                 LIMIT 1].Id;
        
        Card_Spend__c cardSpend = new Card_Spend__c(Company_Id__c = '5555', RecordTypeId = cardSpendRecordTypeId,
                                  Day_Spend__c = 100, System_of_Record_Id__c ='123789', Day_End__c = Date.newInstance(2016, 6, 17));
        insert cardSpend;
        
        List<Card_Spend__c> cardSpendRecords = [SELECT Id
                                                FROM Card_Spend__c
                                                LIMIT 50000];
        
        System.assertEquals(cardSpendRecords.size(), 0);
        
        acct.X60_Day_Daily_Spend_List__c = 'Base,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60';
        update acct;
        
        Card_Spend__c cardSpend2 = new Card_Spend__c(Company_Id__c = '5555', RecordTypeId = cardSpendRecordTypeId,
                                  Day_Spend__c = 100, System_of_Record_Id__c ='123456', Day_End__c = Date.newInstance(2016, 6, 18));
        insert cardSpend2;
        
        List<Card_Spend__c> cardSpendRecords2 = [SELECT Id
                                                FROM Card_Spend__c
                                                LIMIT 50000];
        
        System.assertEquals(cardSpendRecords2.size(), 0);
        
        acct.X180_Day_Daily_Spend_List__c = 'Base,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180';
        update acct;
        
        Card_Spend__c cardSpend3 = new Card_Spend__c(Company_Id__c = '5555', RecordTypeId = cardSpendRecordTypeId,
                                  Day_Spend__c = 100, System_of_Record_Id__c ='454456', Day_End__c = Date.newInstance(2016, 6, 18));
        insert cardSpend3;
        
        List<Card_Spend__c> cardSpendRecords3 = [SELECT Id
                                                FROM Card_Spend__c
                                                LIMIT 50000];
        
        System.assertEquals(cardSpendRecords3.size(), 0);
    }  
}