// Author: Rick Philson
// Date Created: 2017-05-29
// 
// Project: ResourceOne Leads
// Purpose: Utility class for ResourceOne Leads
// 
public class ResourceOneUtilities {

    // Utility Method: isResourceOneRecord
    // Purpose: determine if the new leads (source: trigger.new) are from ResourceOne 
    public static Boolean isResourceOneRecord(List<Lead> leads) {
        
        //if the RecordTypeId in the first lead within the List is null, it must not be from ResourceOne
        if (leads[0].RecordTypeId == null) {
            return false;
        }
        
        //if the RecordTypeId in the first lead within the List is '012a0000001NbXnAAK', 
        //   the leads in flight are from ResourceOne
        if (leads[0].RecordTypeId == '012a0000001NbXnAAK') {
            return true;
        }
        else {
            return false;
        }
    }
}