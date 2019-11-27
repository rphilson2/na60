// Author: Alexander Nourbakhsh
// Date Created/Modified: 11/16/2016
// Purpose: Forward sObject records to Partner Network Connection
// Salesforce to Salesforce Integration

public class forwardRecords {

    public List<sObject> records = new List<sObject>();
    public Id connId;
    
    public static void forwardRecords (List<sObject> records, Id connId) {
        
        List<PartnerNetworkRecordConnection> connRecords = new List<PartnerNetworkRecordConnection>();
        
        for (sObject rec : Records){
            PartnerNetworkRecordConnection newRecord = 
        new PartnerNetworkRecordConnection(

                ConnectionId = connId,
                LocalRecordId = rec.Id,
                SendClosedTasks = false,
                SendOpenTasks = false,
                SendEmails = false
        );

            connRecords.add(newRecord);
        }
        
        
        if (connRecords.size() > 0){
            System.debug('Records Forwarded: ' + connRecords.size());
            insert connRecords;
        }   
    }    
}