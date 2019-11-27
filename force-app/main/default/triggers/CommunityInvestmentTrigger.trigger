trigger CommunityInvestmentTrigger on Community_Giving__c (after update) {
    if(Trigger.isAfter) {
        if(Trigger.isUpdate) {
            updateFICNonProfitOrg.compareNonProfitOrg(Trigger.oldMap, Trigger.new);
        }
    }
}