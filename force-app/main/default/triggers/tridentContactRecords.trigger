trigger tridentContactRecords on Contact (after insert) {


    List<Contact> newTridentContacts = new List<Contact>();
    for (Contact cont : Trigger.new) {
        if (cont.recordTypeId == '012a0000001ZVUv') {
            newTridentContacts.add(cont); 
        }   
    }
    

    PartnerNetworkConnection trident = 
        [SELECT Id, ConnectionStatus, ConnectionName 
         FROM PartnerNetworkConnection  
         WHERE ConnectionStatus = 'Accepted' 
         AND ConnectionName = 'ISO'];


        List<PartnerNetworkRecordConnection> tridentContactConnection  = new List<PartnerNetworkRecordConnection>();
        for (Contact cont : newTridentContacts){
            PartnerNetworkRecordConnection newrecord = 
        new PartnerNetworkRecordConnection(

                ConnectionId = trident.Id,
                LocalRecordId = cont.id,  
                SendClosedTasks = false,
                SendOpenTasks = false,
                SendEmails = false
        );

            tridentContactConnection.add(newrecord);
        }
        
        
        if (tridentContactConnection.size() > 0){
            System.debug('TRIDENT > Sharing ' + tridentContactConnection.size() + ' records');
            insert tridentContactConnection;
        }
}