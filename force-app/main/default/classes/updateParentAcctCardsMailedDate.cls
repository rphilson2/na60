// Author: Alexander Nourbakhsh
// Date: 06.27.2016
// Project: Card Spend
// Purpose: Stage Card_Product__c parent Account record for 60 and 180 day Daily Card_Spend__c record processing.
// A change to the Card_Product__c record Cards_Mailed_Date__c field will qualify the record for processing. 

public without sharing class updateParentAcctCardsMailedDate {
    
    //Map and list to allow passing of Trigger.oldMap and Trigger.new  trigger context variables 
    private final Map<Id, Card_Product__c> oldMap;
    private final List<Card_Product__c> newCardProducts;
    
    public static void updateParentAcctCardsMailedDate(List<Card_Product__c> newCardProducts, Map<Id, Card_Product__c> oldMap) {
        
        List<Card_Product__c> cardProductsUpdated = new List <Card_Product__c>();
        
        //Loop thru new Card Product versions and qualify records Cards_Mailed_Date__c field values were changed 
        for(Card_Product__c cardProduct : newCardProducts){
            Card_Product__c oldCardProduct = oldMap.get(cardproduct.id);
            if (cardproduct.Cards_Mailed_Date__c != oldCardProduct.Cards_Mailed_Date__c) {
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
            acct.Cards_Mailed_Date__c = childCardProduct.Cards_Mailed_Date__c;
            acct.Est_60_Day_Spend__c = childCardProduct.Est_60_Day_Spend__c;
            acct.Est_180_Day_Spend__c = childCardProduct.Est_180_Day_Spend__c;
            acct.Card_Product_FBC_Sales_Person__c = childCardProduct.FBC_Sales_Person__c;
            acct.X60_Day_Daily_Spend_List__c = 'Base';
            acct.X180_Day_Daily_Spend_List__c = 'Base';
            acct.X60_Day_Daily_Spend_Sum__c = 0;
            acct.X180_Day_Daily_Spend_Sum__c = 0;
            acct.X60_Day_Daily_Spend__c = false;
            acct.X180_Day_Daily_Spend__c = false;
            
            }  
            
            // Update parent Account records  
            update accountsTobeUpdated;           
    }
}