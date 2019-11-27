public class R1Qualification {

    List<Lead> newLeads = new List<Lead>();

    // ResourceOne Record Type
               
    public static void qualifyRecordType (List<Lead> newLeads) {
    
        List<Lead> leads = new List<Lead>();
        
        Id r1id = [SELECT Id
                   FROM RecordType
                   WHERE sObjectType = 'Lead'
                   AND Name = 'Mortgage Lead'
                   LIMIT 1].Id;
        
        for (Lead ld : newLeads) {
            if(ld.recordtypeId == r1id) {            
                leads.add(ld);
        }
    
        assignOwner.assignLeadOwner(leads);
    }
    }  
}