// Author: Alexander Nourbakhsh
// Date Created/Modified: 06.28.2016
// Project: Card Spend
// Purpose: To evaluate Account records where X180_Day_Daily_Spend_Sum__c
// field value is less than the Est_180_Day_Spend__c field value respectively, 
// AND when at evalution the Cards_Mailed_Date__c field is outside the 180 date range, 
// 

public without sharing class accountDaily180SpendWorkflow {

    public void accountDaily180SpendWorkflow() {
        System.debug('firing accountDaily180SpendWorkflow');
        // List of Accounts for processing
        List<Account> spendAccts = [SELECT Id, Existing_Company_Id__c, Cards_Mailed_Date__c, X60_Day_Daily_Spend_Sum__c, 
         							X180_Day_Daily_Spend_Sum__c, X60_Day_Daily_Spend__c, X180_Day_Daily_Spend__c, Est_60_Day_Spend__c, 
         							Est_180_Day_Spend__c, Card_Product_FBC_Sales_Person__r.isActive
         							FROM Account 
             						WHERE Existing_Company_Id__c != Null
                                    AND Cards_Mailed_Date__c != Null
                                    AND Card_Product_FBC_Sales_Person__r.isActive = True];
       
        // List of Accounts to qualify for Process Builder tasks
        List<Account> acctsProBuilder = New List<Account>();
        
        for(Account acct : spendAccts) {
            
            // 180 datetime calculation
            Date acctCardsMailed0 = acct.Cards_Mailed_Date__c.date().addDays(15);
            Date acctCardsMailedDate180 = acctCardsMailed0.addDays(180);
            // Current datetime calculation
            datetime todayDateTime = datetime.now();

            
            // Qualify Accounts
            if(acct.X180_Day_Daily_Spend__c == false 
               && (todayDateTime > acctCardsMailedDate180) 
               && (acct.X180_Day_Daily_Spend_Sum__c < acct.Est_180_Day_Spend__c)) {
                   // Update Account field values and add to list
                   acct.X180_Day_Daily_Spend__c = true;
                   acctsProBuilder.add(acct);
                   
               }
        } 
        
        // Update Accounts
        update acctsProBuilder;
    }
}