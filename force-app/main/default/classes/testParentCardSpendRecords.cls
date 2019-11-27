@isTest
public class testParentCardSpendRecords {

    public static testMethod void ParentCardSpendRecords(){
    
        //08/08/2019 Added as part of test class fix -begin
        List<TriggerSupport__c> triggerSupportList = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSupportSetting = new TriggerSupport__c();
        accountTriggerSupportSetting.Name = 'Account';
        accountTriggerSupportSetting.TriggerIsDisabled__c = true;
        triggerSupportList.add(accountTriggerSupportSetting);
        insert triggerSupportList;
        
        Account acct = new Account(name = 'Parent Test 1', Industry = 'Education', Existing_Company_ID__c = '777');
        insert acct;
        
        Id monthlyRecordTypeId = [SELECT id
                                  FROM recordType
                                  WHERE name = 'Monthly' 
                                  AND sObjectType = 'Card_Spend__c'].id;
        try{
        	Card_Spend__c cspendOld = new Card_Spend__c(company_Id__c = '777', Month_End__c = date.newinstance(2014, 2, 2), recordTypeId = monthlyRecordTypeId);
       		insert cspendOld;
        } catch (exception e) {
        } 
        try{
        	Card_Spend__c cspendNew = new Card_Spend__c(company_Id__c = '777', Month_End__c = date.newinstance(2014, 8, 2), recordTypeId = monthlyRecordTypeId);      
       		insert cspendNew;
        } catch (exception e) {
        }
        try{
        	Card_Spend__c cspendNoId = new Card_Spend__c(company_Id__c = '778', Month_End__c = date.newinstance(2014, 8, 2), recordTypeId = monthlyRecordTypeId);
        	insert cspendNoId;
        } catch (exception e) {
        }
        
    }
}