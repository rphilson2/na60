// Author: Alexander Nourbakhsh
// Date Created/Modified: 02/01/2017
// Project: POSI Grid

@isTest
public class POSIRelatedList_Controller_Test {
    
    static testMethod void POSIRelatedList_Controller_Test() {
       
        //08/08/2019 Added as part of test class fix -begin
 
	     List<TriggerSupport__c> triggerSupportList = new List<TriggerSupport__c>();
         TriggerSupport__c accountTriggerSupportSetting = new TriggerSupport__c();
         accountTriggerSupportSetting.Name = 'Account';
         accountTriggerSupportSetting.TriggerIsDisabled__c = true;
         triggerSupportList.add(accountTriggerSupportSetting);
         insert triggerSupportList;
         Account acct = new Account(name = 'posiTestAccount', recordTypeId = '01230000000sSMd');
        
        insert acct;
        
        POSI__c posiTest = new POSI__C(Account__c = acct.Id);
        insert posiTest;
        
        ApexPages.currentPage().getParameters().put('id',acct.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(acct);
        POSIRelatedList_Controller ce = new POSIRelatedList_Controller(sc);
        
        test.startTest();
        
        List<POSI__c> posiRecords = ce.getPOSI();
        Boolean posiRender = ce.getRenderPage();
        
        System.assertNotEquals(null, posiRecords);
        System.assertNotEquals(null, posiRender);
        
        test.stopTest();
        
    }
}