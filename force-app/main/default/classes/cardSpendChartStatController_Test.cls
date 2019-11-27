@isTest
public class cardSpendChartStatController_Test {
	@TestSetup
    static void setupData() {   
        //08/08/2019 Added as part of test class fix -begin
      	List<TriggerSupport__c> triggerSupportList = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSupportSetting = new TriggerSupport__c();
       	accountTriggerSupportSetting.Name = 'Account';
        accountTriggerSupportSetting.TriggerIsDisabled__c = true;
        triggerSupportList.add(accountTriggerSupportSetting);
        insert triggerSupportList;
       //08/08/2019-end
     }
    
    @isTest
    public static void cardSpendChartStatController_Test() {
        date myDate = system.Today();
        date firstDate = myDate.toStartOfMonth();
        date EndofLastMonth = firstDate - 1;

        Account acct = new Account(name = 'test123', Existing_Company_Id__c = '5555', Cards_Mailed_Date__c = EndofLastMonth, X60_Day_Daily_Spend_List__c = 'Base', 
                    X180_Day_Daily_Spend_List__c = 'Base', X60_Day_Daily_Spend_Sum__c = 0, X180_Day_Daily_Spend_Sum__c = 0,
                    X60_Day_Daily_Spend__c = False, X180_Day_Daily_Spend__c = False, Est_60_Day_Spend__c = 10000, Est_180_Day_Spend__c = 2000);
        
        insert acct;
        
        String cardSpendRecordTypeId = [SELECT Id 
                                        FROM recordtype 
                                        WHERE sObjectType = 'Card_Spend__c'
                                        AND name = 'Monthly'
                                        LIMIT 1].Id;
        system.debug('Test 1-- EndofLastMonth = ' + EndofLastMonth);
        Card_Spend__c cardSpend = new Card_Spend__c(Company_Id__c = '5555', RecordTypeId = cardSpendRecordTypeId, Parent_Account__c = acct.id, Company_Name__c = 'Acme Splosion Stuff',
                                  Month_Spend__c = 1000, System_of_Record_Id__c ='223789', Month_End__c = EndofLastMonth, 
                                                   Company_Credit_Limit__c = 2000, Multiple_Product_Flag__c = 'Y', Partnering_Bank__c = 'Wells Fargo');
        insert cardSpend;
        
        List<Card_Spend__c> cardSpendRecords = [SELECT Id
                                                FROM Card_Spend__c
                                                LIMIT 50000];
        
        ApexPages.currentPage().getParameters().put('id',acct.id);
        ApexPages.StandardController stdAccount = new ApexPages.StandardController(acct);
        cardSpendChartStatController StatAccountController  = new cardSpendChartStatController(stdAccount);
        ApexPages.currentPage().getParameters().put('id',acct.id);
        cardSpendChartStatController StatCustomAccountController  = new cardSpendChartStatController();
        
    }
    @isTest
    public static void cardSpendChartStatController_Test2() {
        date myDate = system.Today();
        date firstDate = myDate.toStartOfMonth();
        date EndofLastMonth = firstDate - 1;
        date myDateLastYear = system.Today() - 365;
        date firstDateLastYear = myDateLastYear.toStartOfMonth();
        date EndofLastYearMonth = firstDateLastYear - 1;

        Account acct = new Account(name = 'test123', Existing_Company_Id__c = '5555', Cards_Mailed_Date__c = EndofLastMonth, X60_Day_Daily_Spend_List__c = 'Base', 
                    X180_Day_Daily_Spend_List__c = 'Base', X60_Day_Daily_Spend_Sum__c = 0, X180_Day_Daily_Spend_Sum__c = 0,
                    X60_Day_Daily_Spend__c = False, X180_Day_Daily_Spend__c = False, Est_60_Day_Spend__c = 10000, Est_180_Day_Spend__c = 2000);
        
        insert acct;
        
        String cardSpendRecordTypeId = [SELECT Id 
                                        FROM recordtype 
                                        WHERE sObjectType = 'Card_Spend__c'
                                        AND name = 'Monthly'
                                        LIMIT 1].Id;
        
        Card_Spend__c cardSpend = new Card_Spend__c(Company_Id__c = '5555', RecordTypeId = cardSpendRecordTypeId, Parent_Account__c = acct.id,
                                  Month_Spend__c = 1000, System_of_Record_Id__c ='223789', Month_End__c = EndofLastMonth, 
                                                   Company_Credit_Limit__c = 2000, Multiple_Product_Flag__c = 'Y', Partnering_Bank__c = 'Union Bank');
        system.debug('Test 2-- EndofLastMonth = ' + EndofLastMonth);
        system.debug('Test 2-- CardSpend.Month_End__c = ' + CardSpend.Month_End__c);
        
        insert cardSpend;

        Card_Spend__c cardSpend2 = new Card_Spend__c(Company_Id__c = '5555', RecordTypeId = cardSpendRecordTypeId, Parent_Account__c = acct.id,
                                  Month_Spend__c = 1000, System_of_Record_Id__c ='339197', Month_End__c = EndofLastYearMonth, 
                                                   Company_Credit_Limit__c = 2000, Multiple_Product_Flag__c = 'Y', Partnering_Bank__c = 'CitiBank');
        insert cardSpend2;
        
        List<Card_Spend__c> cardSpendRecords = [SELECT Id
                                                FROM Card_Spend__c
                                                LIMIT 50000];
        
        System.assertEquals(cardSpendRecords.size(), 2);      
        
        ApexPages.currentPage().getParameters().put('id',acct.id);
        ApexPages.StandardController stdAccount = new ApexPages.StandardController(acct);
        cardSpendChartStatController StatAccountController  = new cardSpendChartStatController(stdAccount);
        ApexPages.currentPage().getParameters().put('id',acct.id);
        cardSpendChartStatController StatCustomAccountController  = new cardSpendChartStatController();        
        StatCustomAccountController.getCalcRecord();
        StatCustomAccountController.getRenderPage();
        StatCustomAccountController.getLastMonthEndDate();
        StatCustomAccountController.getCompanyID();
        StatCustomAccountController.getCompanyCreditLimit();
        StatCustomAccountController.getTBSCompanyName();
        StatCustomAccountController.getTBSPartneringBank();
        StatCustomAccountController.getProductCode();
        StatCustomAccountController.getMultipleProductFlag();
        StatCustomAccountController.getManagedFlag();
        StatCustomAccountController.getLiveAccountCount();
        StatCustomAccountController.getActiveCards();
        StatCustomAccountController.getYtdSpendSum();
        StatCustomAccountController.getPytdSpendSum();
        StatCustomAccountController.getYtdAvgPerUtil();
        StatCustomAccountController.getPytdAvgPerUtil();

        
    }
    @isTest
    public static void cardSpendChartStatController_Test3() {
        date myDate = system.Today();
        date firstDate = myDate.toStartOfMonth();
        date EndofLastMonth = firstDate - 1;

        Account acct = new Account(name = 'test123', Existing_Company_Id__c = '5555', Cards_Mailed_Date__c = EndofLastMonth, X60_Day_Daily_Spend_List__c = 'Base', 
                    X180_Day_Daily_Spend_List__c = 'Base', X60_Day_Daily_Spend_Sum__c = 0, X180_Day_Daily_Spend_Sum__c = 0,
                    X60_Day_Daily_Spend__c = False, X180_Day_Daily_Spend__c = False, Est_60_Day_Spend__c = 10000, Est_180_Day_Spend__c = 2000);
        
        insert acct;
        
        String cardSpendRecordTypeId = [SELECT Id 
                                        FROM recordtype 
                                        WHERE sObjectType = 'Card_Spend__c'
                                        AND name = 'Monthly'
                                        LIMIT 1].Id;
        
        List<Card_Spend__c> cardSpendRecords = [SELECT Id
                                                FROM Card_Spend__c
                                                LIMIT 50000];
        
        System.assertEquals(cardSpendRecords.size(), 0);      
        
        ApexPages.currentPage().getParameters().put('id',acct.id);
        ApexPages.StandardController stdAccount = new ApexPages.StandardController(acct);
        cardSpendChartStatController StatAccountController  = new cardSpendChartStatController(stdAccount);
        
        ApexPages.currentPage().getParameters().put('id',acct.id);
        cardSpendChartStatController StatCustomAccountController  = new cardSpendChartStatController();
        
    }        
}