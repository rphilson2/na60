// Author: Alexander Nourbakhsh
// Date Created/Modified: 02.01.2017
// Project: POSI Grid
// Purpose: 
//

@isTest
public class POSI_Controller_Test {
    
    public static testmethod void POSI_Controller_Test() {
        //08/08/2019 Added as part of test class fix -begin
        List<TriggerSupport__c> triggerSupportList = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSupportSetting = new TriggerSupport__c();
        accountTriggerSupportSetting.Name = 'Account';
        accountTriggerSupportSetting.TriggerIsDisabled__c = true;
        triggerSupportList.add(accountTriggerSupportSetting);
        insert triggerSupportList;
        
        Account acct = new Account(name = 'posiTestAccount', recordTypeId = '01230000000sSMd');
        insert acct;
        ApexPages.currentPage().getParameters().put('accountid', acct.id);        
        POSI__c posi = new POSI__c(Account__c = acct.Id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(posi);
        POSI_Controller ce = new POSI_Controller(sc);
        
        ce.AccountId = acct.id;
        
        ce.insertPOSI();
        
        ce.updatePOSI();
        
        ce.POSIpdf();
        
        ce.deletePOSI();
            
    }
    public static testmethod void POSI_Controller_Test_Cancel() {
        //08/08/2019 Added as part of test class fix -begin
        List<TriggerSupport__c> triggerSupportList = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSupportSetting = new TriggerSupport__c();
        accountTriggerSupportSetting.Name = 'Account';
        accountTriggerSupportSetting.TriggerIsDisabled__c = true;
        triggerSupportList.add(accountTriggerSupportSetting);
        insert triggerSupportList;
        
        Account acct = new Account(name = 'posiTestAccount', recordTypeId = '01230000000sSMd');
        insert acct;
        ApexPages.currentPage().getParameters().put('accountid', acct.id);        
        POSI__c posi = new POSI__c(Account__c = acct.Id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(posi);
        POSI_Controller ce = new POSI_Controller(sc);
        
        ce.AccountId = acct.id;
        
        ce.cancelPOSI();
                    
    }
    
    public static testmethod void POSI_Controller_Test_PDF() {
        //08/08/2019 Added as part of test class fix -begin
        List<TriggerSupport__c> triggerSupportList = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSupportSetting = new TriggerSupport__c();
        accountTriggerSupportSetting.Name = 'Account';
        accountTriggerSupportSetting.TriggerIsDisabled__c = true;
        triggerSupportList.add(accountTriggerSupportSetting);
        insert triggerSupportList;
        
        Account acct = new Account(name = 'posiTestAccount', recordTypeId = '01230000000sSMd');
        insert acct;
        POSI__c posi = new POSI__c(Account__c = acct.Id);
        insert posi;
        ApexPages.currentPage().getParameters().put('id', posi.id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(posi);
        POSI_Controller ce = new POSI_Controller(sc);
    }    
}