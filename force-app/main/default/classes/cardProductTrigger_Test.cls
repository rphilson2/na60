@istest
public class cardProductTrigger_Test{
    static testmethod void cardProductTrigger(){
        //08/08/2019 Added as part of test class fix -begin
      	List<TriggerSupport__c> triggerSupportList = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSupportSetting = new TriggerSupport__c();
       	accountTriggerSupportSetting.Name = 'Account';
        accountTriggerSupportSetting.TriggerIsDisabled__c = true;
        triggerSupportList.add(accountTriggerSupportSetting);
        insert triggerSupportList;
       //08/08/2019-end
        
        Account acct = new Account(name = 'Parent Test 1', Industry = 'Education');
        insert acct;
        
        Id FBCSalesPersonId = [SELECT Id
                            FROM User
                            WHERE lastname = 'Nourbakhsh'
                            LIMIT 1].id;
        
        Id accountId = [SELECT Id 
                        FROM Account 
                        WHERE Name = 'Parent Test 1' 
                        LIMIT 1].Id;
                        
        //DAG 07/17/2018 ADS002977 Added value Company_Annual_revenue__c field, since this field is now required.
        Card_Product__c crdp = new Card_Product__c(name = 'Card Product Test 1', Account__c = accountId, Company_Annual_Revenue__c = 123456.65);
        insert crdp;
        
        crdp.Company_ID__c = '123456789';
        update crdp;
        
        List<Card_Product__c> assertSize = [SELECT Id 
                                            FROM Card_Product__c 
                                            LIMIT 10];
        
        System.assertEquals(assertSize.size(), 1);
        
        crdp.Cards_Mailed_Date__c = Date.newInstance(2016, 2, 17);
        update crdp;
        
        System.assertEquals(crdp.Cards_Mailed_Date__c.year(), 2016);
        
        crdp.FBC_Sales_Person__c = FBCSalesPersonId;
        update crdp;
        
        System.assertEquals(crdp.FBC_Sales_Person__c, FBCSalesPersonId);
    }
}