public class fntsPartnerNetworkConnection {
    
    public List<sObject> records = new List<sObject>();
    
    public static void forwardFntsConn (List<sObject> records) {
    
        Id fntsConnId = [SELECT Id
         				 FROM PartnerNetworkConnection  
         				 WHERE ConnectionStatus = 'Accepted' 
         				 AND ConnectionName = 'First National Technology Solutions'
                         LIMIT 1].Id;
        
        forwardRecords.forwardRecords(records, fntsConnId);
        
    }
}