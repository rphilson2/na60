trigger tridentAccountRecords on Account (after insert) {
    //System.Debug(LoggingLevel.DEBUG, 'Entering tridentAccountRecords. Trigger.isAfter=' + Trigger.isAfter + '; Trigger.isInsert=' + Trigger.isInsert);

    //boolean triggerIsDisabled = TriggerSupport__c.getInstance('Account').TriggerIsDisabled__c;
    //System.Debug(LoggingLevel.DEBUG, 'Code: tridentAccountRecords trigger. Custom Setting: TriggerSupport__c.get("Account").TriggerIsDisabled__c = ' + triggerIsDisabled);
    //if (triggerIsDisabled) {
    //    System.Debug(LoggingLevel.INFO, 'Exiting tridentAccountRecords without processing insert/update; Custom Setting: Account.TriggerIsDisabled = ' + triggerIsDisabled);
    //    return;
    //}
    
    List<Account> newTridentAccounts = new List<Account>();
    for (Account acct : Trigger.new) {
        if (acct.recordTypeId == '012a0000001ZVU7') {
            newTridentAccounts.add(acct); 
        }   
    }
    
    
    PartnerNetworkConnection trident = 
        [SELECT Id, ConnectionStatus, ConnectionName 
         FROM PartnerNetworkConnection  
         WHERE ConnectionStatus = 'Accepted' 
         AND ConnectionName = 'ISO'];

    
        List<PartnerNetworkRecordConnection> tridentAccountConnection  = new List<PartnerNetworkRecordConnection>();
        for (Account acct : newTridentAccounts){
            PartnerNetworkRecordConnection newRecord = 
        new PartnerNetworkRecordConnection(

                ConnectionId = trident.Id,
                LocalRecordId = acct.Id,
                SendClosedTasks = false,
                SendOpenTasks = false,
                SendEmails = false
        );

            tridentAccountConnection.add(newRecord);
        }
        
        
        if (tridentAccountConnection.size() > 0){
            System.debug('TRIDENT > Sharing ' + tridentAccountConnection.size() + ' records');
            insert tridentAccountConnection;
        }
}