// Author: Alexander Nourbakhsh
// Date: 05.09.2016
// Project: Card Spend
// Purpose: To update the parent Account record Company ID field (Existing_Company_ID__c) 
// when the Company ID (Company_ID__c) field is changed/updated. 


trigger updateParentAccountCompanyID on Card_Product__c (after update) {
    
    List<Card_Product__c> cardProductsUpdated = new List <Card_Product__c>();
    
    for(Card_Product__c cardProduct : Trigger.new){
        System.debug('For Loop Cycling');
        Card_Product__c oldCardProduct = Trigger.oldMap.get(cardproduct.id);
        if (cardproduct.Company_ID__c != oldCardProduct.Company_ID__c){
            cardProductsUpdated.add(cardProduct);
            System.debug('Added Records to List');
        }    
    }
    
    System.debug('cardProductsUpdated.Size: ' + cardProductsUpdated.size());   
        
            Map<Id, String> parentAccounts = new Map<Id, String>();
            for(Card_Product__c i : cardProductsUpdated){
                parentAccounts.put(i.Account__c, i.Company_ID__c);
                System.debug('ParenAccountsSize: ' + parentAccounts.size());
                System.debug(parentAccounts);
            }
                
            List<Account> accountsToBeUpdated = [SELECT Id
                                                 FROM Account
                                                 WHERE Id IN: parentAccounts.keySet()
                                                 LIMIT 50000];
            
            System.debug('accountsToBeUpdated.size: ' + accountsToBeUpdated.size());
            
            for(Account acct : accountsToBeUpdated){
                acct.Existing_Company_ID__c = parentAccounts.get(acct.Id);
            
            }  
            
            update accountsTobeUpdated;           

}