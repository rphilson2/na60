// Author: Alexander Nourbakhsh
// Date Created/Modified: 07/22/2016
// Project: Unfunded Trust

@isTest
public class fundTrustAccount_Test {

    static testMethod void fundTrustAccount() {
        //08/08/2019 Added as part of test class fix -begin
        List<TriggerSupport__c> triggerSupportList = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSupportSetting = new TriggerSupport__c();
        accountTriggerSupportSetting.Name = 'Account';
        accountTriggerSupportSetting.TriggerIsDisabled__c = true;
        triggerSupportList.add(accountTriggerSupportSetting);
        insert triggerSupportList;
        
        Unfunded_Trust__c unfund1 = new Unfunded_Trust__c(name = 'test123', 
                                                         Status__c = 'Active',
                                                         Additional_Contact_City__c = '',
                                                         Additional_Contact_Country__c = '',
                                                         Additional_Contact_Email__c = '',
                                                         Additional_Contact_First_Name__c = '',
                                                         Additional_Contact_Last_Name__c = '',
                                                         Additional_Contact_Phone__c = '',
                                                         Additional_Contact_State__c = '',
                                                         Additional_Contact_Street__c = '',
                                                         Additional_Contact_Zip__c = '',
                                                         Grantor_Billing_City__c = '',
                                                         Grantor_Billing_Country__c = '',
                                                         Grantor_Billing_State__c = '',
                                                         Grantor_Billing_Street__c = '',
                                                         Grantor_Billing_Zip__c = '',
                                                         Grantor_Email__c = '',
                                                         Grantor_First_Name__c = '',
                                                         Grantor_Last_Name__c = '',
                                                         Grantor_Phone__c ='');
        insert unfund1;
        
        System.assertEquals(unfund1.Status__c, 'Active');
        System.assertNotEquals(unfund1.Status__c, 'Funded');
        
        unfund1.Status__c = 'Funded';
        update unfund1;
        
        System.assertEquals(unfund1.Status__c, 'Funded');
        
        try {     
            unfund1.Status__c = 'Inactive';
            update unfund1;
        } catch (exception e) {
            
        }
        
        Unfunded_Trust__c unfund2 = new Unfunded_Trust__c(name = 'test123', 
                                                         Status__c = 'Active',
                                                         Additional_Contact_City__c = 'Richmond',
                                                         Additional_Contact_Country__c = 'Kenturky',
                                                         Additional_Contact_Email__c = 'ham@test.com',
                                                         Additional_Contact_First_Name__c = 'QA',
                                                         Additional_Contact_Last_Name__c = 'Tester',
                                                         Additional_Contact_Phone__c = '5712823848',
                                                         Additional_Contact_State__c = 'KY',
                                                         Additional_Contact_Street__c = '1234 Tester',
                                                         Additional_Contact_Zip__c = '22344',
                                                         Grantor_Billing_City__c = 'New Orleans',
                                                         Grantor_Billing_Country__c = 'USA',
                                                         Grantor_Billing_State__c = 'LA',
                                                         Grantor_Billing_Street__c = '1234 French Ave',
                                                         Grantor_Billing_Zip__c = '56733',
                                                         Grantor_Email__c = 'zero@gmail235.com',
                                                         Grantor_First_Name__c = '',
                                                         Grantor_Last_Name__c = 'Developer',
                                                         Grantor_Phone__c ='6885',
                                                         Assets_under_Management__c = 1000,
                                                         One_Time_Fees__c = 1500,
                                                         Annual_Revenue__c = 250);
        insert unfund2;
        
        System.assertNotEquals(unfund2.Status__c, 'Funded');
        System.assertEquals(unfund2.Status__c, 'Active');
        
        unfund2.Status__c = 'Funded';
        update unfund2;
        
        System.assertEquals(unfund2.Status__c, 'Funded');
        
        List<Account> testAcctCreated = [SELECT Id, Source_Unfunded_Trust_ID__c
                                         FROM Account];
        
        System.assertEquals(testAcctCreated.size(), 2);
        
        List<Opportunity> testOppCreated = [SELECT Id, AccountId
                                            FROM Opportunity];
        
        System.assertEquals(testOppCreated.size(), 2);
        
        ApexPages.currentPage().getParameters().put('id',unfund2.id);
        ApexPages.StandardController stdunfundedTrust2 = new ApexPages.StandardController(unfund2);
        unfundedTrustController unfundTrust = new unfundedTrustController(stdunfundedTrust2);
        
        test.startTest();
        Account[] unFundedAccounts = unfundTrust.getAccounts();
        Opportunity[] unFundedOpportunities = unfundTrust.getOpportunities();
        Boolean renderPage = unfundTrust.getRenderPage();
        System.assertNotEquals(null, unFundedAccounts);
        System.assertNotEquals(null, unFundedOpportunities);
        System.assertNotEquals(null, renderPage);
        test.stopTest();
    
    }
}