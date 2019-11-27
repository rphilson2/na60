// Author: Alexander Nourbakhsh
// Date: 06.27.2016
// Project: Card Spend
// Purpose: Update Card_Product__c record parent Account with the Card_Product__c record 
// Company_Id__c and FBC_Sales_Person__c field values.  

public without sharing class updateParentAcctCompanyIdFBCSalesPerson {
    
    //Map and list to allow passing of Trigger.oldMap and Trigger.new  trigger context variables 
    private final Map<Id, Card_Product__c> oldMap;
    private final List<Card_Product__c> newCardProducts;
    
    public static void updateParentAcctCompanyIdFBCSalesPerson(List<Card_Product__c> newCardProducts, Map<Id, Card_Product__c> oldMap) {
        
        List<Card_Product__c> cardProductsUpdated = new List <Card_Product__c>();
        
        //Loop thru new Card Product versions and qualify records where FBC_Sales_Person__c 
        //or Company_ID__c field values were changed 
        for(Card_Product__c cardProduct : newCardProducts){
            Card_Product__c oldCardProduct = oldMap.get(cardproduct.id);
            if (cardproduct.FBC_Sales_Person__c != oldCardProduct.FBC_Sales_Person__c
                || cardproduct.Company_ID__c != oldCardProduct.Company_ID__c) {
                cardProductsUpdated.add(cardProduct);
    
            }    
        }   
                  
        Map<Id, Card_Product__c> parentAccounts = new Map<Id, Card_Product__c>();
        
        //Put parent Account Id as key and Card Product sObject as value in map
        for(Card_Product__c i : cardProductsUpdated) {
            parentAccounts.put(i.Account__c, i);
                    
            }
        
        //Gather parent Accounts           
        List<Account> accountsToBeUpdated = [SELECT Id
                                             FROM Account
                                             WHERE Id IN: parentAccounts.keySet()
                                             LIMIT 50000];
        
        //Loop thru list of parent Accounts and assign field values from parentAccounts map        
        for(Account acct : accountsToBeUpdated){
            Card_Product__c childCardProduct = parentAccounts.get(acct.Id);
            
            acct.Existing_Company_ID__c = childCardProduct.Company_ID__c;
            acct.Card_Product_FBC_Sales_Person__c = childCardProduct.FBC_Sales_Person__c;
            
            }  
            
            // Update parent Account records  
            update accountsTobeUpdated;           
    }
}