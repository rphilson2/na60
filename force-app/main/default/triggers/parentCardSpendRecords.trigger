// Author: Alexander Nourbakhsh
// Date Created/Modified: 06.15.2016
// Project: Card Spend
// Purpose:
// 
// 1) To parent inserted Monthly record type Card_Spend__c records with their parent Accounts based on Company ID.
// 2) To prevent insertion of Monthly record type Card_Spend__c records older than 24 months.
// 3) To prevent insertion of Monthly record type Card_Spend__c records without a found parent Account via a Company ID match. 
//
//

trigger parentCardSpendRecords on Card_Spend__c (before insert) {
	
    Id monthlyRecordTypeId = [SELECT id
                              FROM recordType
                              WHERE name = 'Monthly' 
                              AND sObjectType = 'Card_Spend__c'].id;
    
    List<Card_Spend__c> unParentedCardSpendRecords = new List<Card_Spend__c>();
    List<String> companyIds = new List<String>();

    // Gather:
    // Card Spend records into a list for processing. (unParentedCardSpendRecords)     
    // Company Ids into a list from Card Spend list. (companyIds)
    for(Card_Spend__c card : Trigger.new) {
        if(card.recordTypeId == monthlyRecordTypeId) {
        	unParentedCardSpendRecords.add(card);
        	companyIds.add(card.Company_ID__c);
            
        } else {
        // do nothing
        }
    }
            
    System.debug('Card Spend records to be processed: ' + unParentedCardSpendRecords.size());
                
    Map<String, Id> parentAccountMap = new Map<String, Id>();

    // Query Account object for Accounts with matching Company Ids.                           
    // Put Account Ids and Account Company Ids into a map for reparenting process.
    for(Account acct : [SELECT id, Existing_Company_ID__c
                        FROM Account
                        WHERE Existing_Company_ID__c
                        IN: companyIds
                        LIMIT 50000])
     {   
          parentAccountMap.put(acct.Existing_Company_ID__c, acct.id);     
     }

    System.debug(parentAccountMap.size() + ' Account records with Company IDs gathered for parenting');
 
    // Used to store the number of Card Spend records that found an Account with a matching Company ID, and shall be inserted. 
    Integer i= 0;    
                         
    // If an Account with a matching Company Id is found then update the Master-Detail relationship field 
    // on the Card Spend record with the Account Id, and add the Card Spend record to the 
    // parentedCardSpendRecordstoInsert Card Spend list for insertion.
    for(Card_Spend__c cp : unParentedCardSpendRecords){
        if (cp.Month_End__c < System.today().addMonths(-24)) {
            // If Card_Spend__c record is older than 24 months from the current date of the current user's (service user) timezone,
            // then do not add record to insertion list. 
            cp.addError('CARD SPEND RECORD INSERTION ABORTED! MONTH END DATE ' + cp.Month_End__c + ' OLDER THAN 24 MONTHS!');
    
        } else if (parentAccountMap.containskey(cp.Company_ID__c)) {
            cp.Parent_Account__c = parentAccountMap.get(cp.Company_ID__c);
            i+=1;
            
        } else {
            // If an Account with a matching Company Id is not found then throw error message and do not add record to insertion list.         
            cp.addError('CARD SPEND RECORD INSERTION ABORTED! NO ACCOUNT RECORD FOUND WITH A COMPANY ID OF ' + cp.Company_ID__c);
        }
    }

    // Insert list of parented Card Spend records.    
    System.debug('Inserting ' + i + ' parented Card Spend records');           
}