public class assignOwner {
    
    List<Lead> leads = new List<Lead>();
    
    public static void assignLeadOwner(List<Lead> leads) {
    
        Map<String, Id> userAssignMap = new Map<String, Id>();
        
        List<User> users = [SELECT Id, email 
                            FROM User WHERE isActive = true limit 10000];
                            
        for(User u: users) {
            userAssignMap.put(u.email,u.Id);
        }
        
        for(Lead l: leads) {
            if (userAssignMap.containsKey(l.ResourceOneOwnerEmail__c)) {
                l.ownerId = userAssignMap.get(l.ResourceOneOwnerEmail__c);
            } else {
                l.ownerId = UserInfo.getUserId();
            }
        }
    }
}