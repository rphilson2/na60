// Author: Alexander Nourbakhsh
// Date Created/Modified: 10.19.2016
// Project: Account Ownership Change
//

public without sharing class qualifyOwnershipChange {
    
    public static void qualifyRecords (List<Account> newAccts, Map<Id,Account> oldAcctsMap) {
        
        List<Account> qualNewAcct = new List<Account>();
        Map<Id,Account> qualOldAcctMap = new Map<Id,Account>();
        
        for(Account acct : newAccts) {
            
            Account oldAcct = null;
            oldAcct = oldAcctsMap.get(acct.id);
            
            if(acct.ownerId != oldAcct.ownerId) {
                
                qualNewAcct.add(acct);
                qualOldAcctMap.put(oldAcct.Id, oldAcct);    
            }   
    	}
        
        if(qualNewAcct.size() > 0) {
            
            notifyOwner.qualifyRecords(qualNewAcct, qualOldAcctMap);
            
        }
    }
}