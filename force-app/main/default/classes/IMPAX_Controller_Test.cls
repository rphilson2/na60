// Author: Dallas Grafton
// Date Created/Modified: 01.24.2018
// Project: IMPAX Page
// Purpose: 
//

@isTest
public class IMPAX_Controller_Test {
    
  public static testmethod void IMPAX_Controller_Test_Insert() {
        List<TriggerSupport__c> triggerSupportSettings = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSetting = new TriggerSupport__c();
        accountTriggerSetting.Name = 'Account';
        accountTriggerSetting.TriggerIsDisabled__c = true;
        
        triggerSupportSettings.add(accountTriggerSetting);
        
        insert triggerSupportSettings;

        RecordType RecTypeID = [select id, name from Recordtype where sobjecttype = 'Account' and name = 'Person Account'];
        System.AssertEquals('01230000000sSnGAAU', RecTypeId.Id);

        Account acct = new Account(firstname = 'TestAccount', lastname = 'IMPAX', recordTypeId = RecTypeID.id);
        insert acct;

        IMPAX__c IMPAX = new IMPAX__c(id = null);

        ApexPages.currentPage().getParameters().put('accountid', acct.id);            
        ApexPages.StandardController sc = new ApexPages.StandardController(IMPAX);
        IMPAX_Controller ce = new IMPAX_Controller(sc);
        
        ce.insertIMPAX();
        System.AssertEquals(acct.Id, IMPAX.account__c);

        accountTriggerSetting.TriggerIsDisabled__c = false;
        update triggerSupportSettings;
        
  }

  public static testmethod void IMPAX_Controller_Test_Insert2() {
        List<TriggerSupport__c> triggerSupportSettings = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSetting = new TriggerSupport__c();
        accountTriggerSetting.Name = 'Account';
        accountTriggerSetting.TriggerIsDisabled__c = true;
        
        triggerSupportSettings.add(accountTriggerSetting);
        
        insert triggerSupportSettings;

        RecordType RecTypeID = [select id, name from Recordtype where sobjecttype = 'Account' and name = 'Person Account'];
        System.AssertEquals('01230000000sSnGAAU', RecTypeId.Id);

        Account acct = new Account(firstname = 'TestAccount', lastname = 'IMPAX', recordTypeId = RecTypeID.id);
        insert acct;
        IMPAX__c IMPAX = new IMPAX__c(id = null, name = 'ImpaxINSTest');

        ApexPages.currentPage().getParameters().put('accountid', acct.id);            
        ApexPages.StandardController sc = new ApexPages.StandardController(IMPAX);
        IMPAX_Controller ce = new IMPAX_Controller(sc);
        
        ce.insertIMPAX(); 
        System.AssertEquals(acct.Id, IMPAX.account__c);
        
        accountTriggerSetting.TriggerIsDisabled__c = false;
        update triggerSupportSettings;

  }

  public static testmethod void IMPAX_Controller_Test_Update() {
        List<TriggerSupport__c> triggerSupportSettings = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSetting = new TriggerSupport__c();
        accountTriggerSetting.Name = 'Account';
        accountTriggerSetting.TriggerIsDisabled__c = true;
        
        triggerSupportSettings.add(accountTriggerSetting);
        
        insert triggerSupportSettings;

        RecordType RecTypeID = [select id, name from Recordtype where sobjecttype = 'Account' and name = 'Person Account'];
        System.AssertEquals('01230000000sSnGAAU', RecTypeId.Id);
  
        Account acct = new Account(firstname = 'TestAccountUp', lastname = 'IMPAX', recordTypeId = RecTypeID.id);
        insert acct;

        IMPAX__c IMPAX = new IMPAX__c(account__c = acct.id);
        insert IMPAX;

        ApexPages.currentPage().getParameters().put('id', IMPAX.id);            
        ApexPages.StandardController sc = new ApexPages.StandardController(IMPAX);
        IMPAX_Controller ce = new IMPAX_Controller(sc);
        
        ce.updateIMPAX();        

        accountTriggerSetting.TriggerIsDisabled__c = false;
        update triggerSupportSettings;
            
  }

  public static testmethod void IMPAX_Controller_Test_Update2() {
        List<TriggerSupport__c> triggerSupportSettings = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSetting = new TriggerSupport__c();
        accountTriggerSetting.Name = 'Account';
        accountTriggerSetting.TriggerIsDisabled__c = true;
        
        triggerSupportSettings.add(accountTriggerSetting);
        
        insert triggerSupportSettings;

        RecordType RecTypeID = [select id, name from Recordtype where sobjecttype = 'Account' and name = 'Person Account'];
        System.AssertEquals('01230000000sSnGAAU', RecTypeId.Id);
  
        Account acct = new Account(firstname = 'TestAccountUp2', lastname = 'IMPAX', recordTypeId = RecTypeID.id);
        insert acct;

        IMPAX__c IMPAX = new IMPAX__c(account__c = acct.id, name = 'ImpaxTest');
        insert IMPAX;

        ApexPages.currentPage().getParameters().put('id', IMPAX.id);            
        ApexPages.StandardController sc = new ApexPages.StandardController(IMPAX);
        IMPAX_Controller ce = new IMPAX_Controller(sc);
        
        ce.updateIMPAX();        

        accountTriggerSetting.TriggerIsDisabled__c = false;
        update triggerSupportSettings;
            
  }
  

  public static testmethod void IMPAX_Controller_Test_Delete() {
        List<TriggerSupport__c> triggerSupportSettings = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSetting = new TriggerSupport__c();
        accountTriggerSetting.Name = 'Account';
        accountTriggerSetting.TriggerIsDisabled__c = true;
        
        triggerSupportSettings.add(accountTriggerSetting);
        
        insert triggerSupportSettings;

        RecordType RecTypeID = [select id, name from Recordtype where sobjecttype = 'Account' and name = 'Person Account'];
        System.AssertEquals('01230000000sSnGAAU', RecTypeId.Id);
  
        Account acct = new Account(firstname = 'TestAccountUp2', lastname = 'IMPAX', recordTypeId = RecTypeID.id);
        insert acct;

        IMPAX__c IMPAX = new IMPAX__c(account__c = acct.id);
        insert IMPAX;

        ApexPages.currentPage().getParameters().put('id', IMPAX.id);            
        ApexPages.StandardController sc = new ApexPages.StandardController(IMPAX);
        IMPAX_Controller ce = new IMPAX_Controller(sc);
        
        ce.deleteIMPAX();
        
        accountTriggerSetting.TriggerIsDisabled__c = false;
        update triggerSupportSettings;
        
  }

  public static testmethod void IMPAX_Controller_Test_Cancel() {
        List<TriggerSupport__c> triggerSupportSettings = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSetting = new TriggerSupport__c();
        accountTriggerSetting.Name = 'Account';
        accountTriggerSetting.TriggerIsDisabled__c = true;
        
        triggerSupportSettings.add(accountTriggerSetting);
        
        insert triggerSupportSettings;

        RecordType RecTypeID = [select id, name from Recordtype where sobjecttype = 'Account' and name = 'Person Account'];
        System.AssertEquals('01230000000sSnGAAU', RecTypeId.Id);
  
        Account acct = new Account(firstname = 'TestAccountUp2', lastname = 'IMPAX', recordTypeId = RecTypeID.id);
        insert acct;

        IMPAX__c IMPAX = new IMPAX__c(account__c = acct.id);
        insert IMPAX;

        ApexPages.currentPage().getParameters().put('id', IMPAX.id);            
        ApexPages.StandardController sc = new ApexPages.StandardController(IMPAX);
        IMPAX_Controller ce = new IMPAX_Controller(sc);
        
        ce.CancelIMPAX();
        
        accountTriggerSetting.TriggerIsDisabled__c = false;
        update triggerSupportSettings;
            
  }

}