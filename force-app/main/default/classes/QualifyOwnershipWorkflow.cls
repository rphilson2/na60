// Author: Alexander Nourbakhsh
// Date Created/Modified: 07.28.2016
// Project: Account Ownership
// Purpose: Qualify Account for Account Ownership Change Workflow
//

public class QualifyOwnershipWorkflow {

    //2018-11-29  RJP  Commenting logic so the class is "deactivated" allowing the Previous Owner field to be deleted from Account object
    
    // Old Map of Account and list of new Account version
    //private final Map<Id, Account> oldAcctMap = New Map<Id, Account>();
    //private final List<Account> newAcctList = New List<Account>();
    
    //2018-11-29 RJP Had to keep the method uncommented for code coverage (Removed all params, it previously had parameters). 
      public static void QualifyOwnershipWorkflow(){  
    //    
    //    // Map of User Ids and isActive boolean status
    //    Map<Id, Boolean> userIsActiveMap = New Map<Id, Boolean>();
    //    for(User usr : [SELECT Id, IsActive
    //                    FROM User
    //                    WHERE IsActive = True
    //                    LIMIT 1]) {
    //        userIsActiveMap.put(usr.Id, usr.IsActive);
    //    }
    //
    //    
    //    // Loop thru new Account records
    //    for(Account acct : newAcctList) {
    //        // Get old Account version from map
    //        Account oldAcct = oldAcctMap.get(acct.id);
    //        // Compare OwnerId field between old and new Account versions and check if old owner was active
    //        if((acct.ownerId != oldAcct.ownerId) && (userIsActiveMap.get(oldAcct.ownerId) == True)) {
    //            // Update previous owner field with old owner and check workflow invoking field
    //            acct.Ownership_Change__c = True;
    //            acct.Previous_Owner__c = oldAcct.ownerId;
    //            
    //        }
    //    }
      }  
}