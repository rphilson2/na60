// Created: 2016.10.19
// Purpose: One trigger per object
// RVC:
//   2018-11-19  Rick Philson  :: added logic to check Custom Setting before executing
//                             ::   if TriggerSupport__c.get('Account').TriggerIsDisabled__c, bypass account trigger code
//   2018-10-25  Rick Philson  :: changed trigger event subscription from BEFORE UPDATE to AFTER UPDATE
//                             :: custom Apex class, AccountToProtectedCustomerDataCopier, is now called AFTER UPDATE
//   2018-08-31  Rick Philson  :: before update - call AccountToProtectedCustomerDataCopier class

trigger accountTrigger on Account (after update) {
    System.Debug(LoggingLevel.DEBUG, 'Entering accountTrigger. Trigger.isAfter=' + Trigger.isAfter + '; Trigger.isUpdate=' + Trigger.isUpdate);
    
    boolean triggerIsDisabled = TriggerSupport__c.getInstance('Account').TriggerIsDisabled__c;
    System.Debug(LoggingLevel.DEBUG, 'Code: accountTrigger. Custom Setting: TriggerSupport__c.get("Account").TriggerIsDisabled__c = ' + triggerIsDisabled);

    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            if (triggerIsDisabled) {
                System.Debug(LoggingLevel.INFO, 'Exiting accountTrigger without processing insert/updates; Custom Setting: Account.TriggerIsDisabled = ' + triggerIsDisabled);
                return;
            }
            AccountToProtectedCustomerDataCopier.evaluateUpdatedAccountRecords(Trigger.New, Trigger.oldMap);
        }
    }
}