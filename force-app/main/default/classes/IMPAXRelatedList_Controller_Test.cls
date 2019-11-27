// Author: Dallas Grafton
// Date Created/Modified: 01/24/2018
// Project: IMPAX Page

@isTest
public class IMPAXRelatedList_Controller_Test {
    
    static testMethod void IMPAXRelatedList_Controller_Test() {
        List<TriggerSupport__c> triggerSupportSettings = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSetting = new TriggerSupport__c();
        accountTriggerSetting.Name = 'Account';
        accountTriggerSetting.TriggerIsDisabled__c = true;
        
        triggerSupportSettings.add(accountTriggerSetting);
        
        insert triggerSupportSettings;

        RecordType RecTypeID = [select id, name from Recordtype where sobjecttype = 'Account' and name = 'Person Account'];
        System.AssertEquals('01230000000sSnGAAU', RecTypeId.Id);

        Account acct = new Account(firstname = 'TestAccount', lastname = 'IMPAXRL', recordTypeId = RecTypeID.id);
        insert acct;
        
        IMPAX__c IMPAXTest = new IMPAX__c(Account__c = acct.Id);
        insert IMPAXTest;
        
        ApexPages.currentPage().getParameters().put('id',acct.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(acct);
        IMPAXRelatedList_Controller ce = new IMPAXRelatedList_Controller(sc);
        
        test.startTest();
        
        List<IMPAX__c> IMPAXRecords = ce.getIMPAX();
        
        System.assertNotEquals(null, IMPAXRecords);
        
        test.stopTest();

        accountTriggerSetting.TriggerIsDisabled__c = false;
        update triggerSupportSettings;
        
    }
}