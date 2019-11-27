// Author: Alexander Nourbakhsh
// Date: 06.13.2016
// Purpose: One Trigger per Object

trigger cardProductTrigger on Card_Product__c (after update) {
    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            updateParentAcctCompanyIdFBCSalesPerson.updateParentAcctCompanyIdFBCSalesPerson(Trigger.new, Trigger.oldMap);
            updateParentAcctCardsMailedDate.updateParentAcctCardsMailedDate(Trigger.new, Trigger.oldMap);
        }
    }
}