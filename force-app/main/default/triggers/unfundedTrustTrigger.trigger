// Author: Alexander Nourbakhsh
// Date Created/Modified: 07/22/2016
// Project: Unfunded Trust
// Purpose: One Trigger per Object

trigger unfundedTrustTrigger on Unfunded_Trust__c (before update) {
    if(Trigger.isBefore) {
        if(Trigger.isUpdate) {
          //unfundedTrustHelper.preventUpdates(Trigger.oldMap, Trigger.new);
            fundTrustAccount.fundTrustAccount(Trigger.oldMap, Trigger.new);
        }
    }
}