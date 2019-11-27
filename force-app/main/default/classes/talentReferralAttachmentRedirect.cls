// Author: Alexander Nourbakhsh
// Date Created/Modified: 07.24.2016
// Project: Talent Referral
// Purpose: 
//

public class talentReferralAttachmentRedirect {
    
    public transient Attachment transientAttachment;
    // Talent Referral sObject record
    private final Employee_Talent_Referral__c talentReferral;
    
    // Attachment 
    public Attachment attachment {
        get {
            if (transientAttachment == null) 
                transientAttachment = new Attachment();
            return transientAttachment;
        }

        set;
    }
    
    // Get record of Talent Referral
    public talentReferralAttachmentRedirect (ApexPages.StandardController stdController)
    {
        talentReferral = (Employee_Talent_Referral__c)stdController.getRecord();
    }
    
    // Button logic
    public PageReference saveAndDirect() {
        
        // Insert Talent Referral sObject record
        insert talentReferral;
        // Insert attachment if not null (body used as indicator)
        if (attachment.Body != null) {
        attachment.parentId = talentReferral.Id;
        insert attachment;
        }
      
        // Redirect
        PageReference page = new pageReference('https://connect.fnni.com/homepage/login/');
        page.setRedirect(true);
        return page;
     }
}