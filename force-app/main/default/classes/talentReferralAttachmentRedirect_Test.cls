@isTest
public class talentReferralAttachmentRedirect_Test {
    public static testMethod void talentReferralAttachmentRedirect_Test() {
        
        Employee_Talent_Referral__c talentReferral = new Employee_Talent_Referral__c(name = '123',
                                                                                    Referrer_Dept__c = 'IT',
                                                                                    Referring_Employee_Email_if_applicable__c = 'abc@abc.com',
                                                                                    Candidate_Email__c = 'abc@abc.com',
                                                                                    Candidate_Phone_Number__c = 'abc',
                                                                                    Referral_Source_Employee__c = 'alex',
                                                                                    Addtl_Notes__c = 'abc');
        //insert talentReferral;
        
        System.assertEquals(talentReferral.name, '123');
        System.assertNotEquals(talentReferral.name, '456');
        
		ApexPages.StandardController sc = new ApexPages.StandardController(talentReferral);
        talentReferralAttachmentRedirect cc = new talentReferralAttachmentRedirect(sc);
        pageReference action = cc.saveAndDirect();
        
        System.assertNotEquals(talentReferral.id, null);
        
	}
}