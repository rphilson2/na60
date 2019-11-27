// Author: Alexander Nourbakhsh
// Date Created/Modified: 06.16.2016
// Purpose: One trigger per object

trigger cardSpendTrigger on Card_Spend__c (after insert) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            dailyCardSpendProcess.dailyCardSpendProcess(Trigger.new);
        }
    }
}