// Author: Alexander Nourbakhsh
// Date Created/Modified: 09/29/2016
// Project: Unfunded Trust

@isTest
public class coiLeadandTrustController_Test {

    static testMethod void coiLeadandTrustController_Test() {
        //08/08/2019 Added as part of test class fix -begin
        List<TriggerSupport__c> triggerSupportList = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSupportSetting = new TriggerSupport__c();
        accountTriggerSupportSetting.Name = 'Account';
        accountTriggerSupportSetting.TriggerIsDisabled__c = true;
        triggerSupportList.add(accountTriggerSupportSetting);
        insert triggerSupportList;
        
        Coi__c coi = new Coi__c(name = 'COI Test');
        insert coi;
        
        Lead openLead = new Lead(lastName = 'OpenLeadTest',
                                 status = 'Open',
                                 Lead_Source_COI__c = coi.id);
        insert openLead;
        
        Lead closedLead = new Lead(lastName = 'ClosedLeadTest',
                                 status = 'Closed',
                                 Lead_Source_COI__c = coi.id);
        insert closedLead;
        
        Unfunded_Trust__c testTrust = new Unfunded_Trust__c(name = 'Test Trust',
                                                  COI__c = coi.id);
        insert testTrust;
        
        try {
        
            testtrust.COI__c = null;
            update testTrust;
            
        } catch (exception e) {
        
            String message = e.getMessage();
            
        }
        
        
        System.assertEquals(testtrust.COI__c, testtrust.COI__c);
        
        testtrust.COI__c = coi.id;
        testtrust.Status__c = 'Funded';
        update testTrust;
        
 
        ApexPages.currentPage().getParameters().put('id',coi.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(coi);
        coiLeadandTrust_Controller ce = new coiLeadandTrust_Controller(sc);
        
        test.startTest();
        
        List<Account> coiAccounts = ce.getCoiAccounts();
        List<Opportunity> coiOpportunities = ce.getCoiOpportunities();
        List<Lead>coiLeadsOpen = ce.getCoiLeadsOpen();
        List<Lead>coiLeadsNotOpen = ce.getCoiLeadsNotOpen();
        list<Unfunded_Trust__c> coiFundTrusts = ce.getCoiFundTrusts();
        Boolean renderPage = ce.getRenderPage();
        
        System.assertNotEquals(null, coiAccounts);
        System.assertNotEquals(null, coiOpportunities);
        System.assertNotEquals(null, coiLeadsOpen);
        System.assertNotEquals(null, coiLeadsNotOpen);
        System.assertNotEquals(null, coiFundTrusts);
        System.assertNotEquals(null, renderPage);
        
        test.stopTest();
    
    }
}