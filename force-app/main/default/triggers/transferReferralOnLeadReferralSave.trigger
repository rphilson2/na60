trigger transferReferralOnLeadReferralSave on Lead (before insert) { 
   for (Lead ld : Trigger.new) {
             if(ld.recordtypeid == '012a0000001NbEt' && ld.Lead_Recipient__c != null) {         
                  ld.ownerid = ld.Lead_Recipient__c;
              }
   }
}