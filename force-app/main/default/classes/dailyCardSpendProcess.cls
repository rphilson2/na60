// Author: Alexander Nourbakhsh
// Date Created/Modified: 06.27.2016
// Project: Card Spend
// Purpose: To process Daily record type Card_Spend__c records. The results 
// of processing are then updated on the parent Account. 

public without sharing class dailyCardSpendProcess {

    private final List<Card_Spend__c> newCardSpends;
    
    public static void dailyCardSpendProcess(List<Card_Spend__c> newCardSpends) {
        
        Id dailyRecordTypeId = [SELECT id
                                FROM recordType
                                WHERE name = 'Daily' 
                                AND sObjectType = 'Card_Spend__c'].id;
        List<Card_Spend__c> dailyRecords = New List<Card_Spend__c>();
        Set<String> companyIds = New Set<String>();
        List<Account> accounts = New List<Account>();
        
        //Qualify Card Spend records and supporting data if records are Daily record type
        for(Card_Spend__c rawcs : newCardSpends) {
            if(rawcs.recordTypeId == dailyRecordTypeId) {
                dailyRecords.add(rawcs);
                companyIds.add(rawcs.Company_Id__c);
            }
        } 
        
        //Gather parent Accounts of qualfied Card Spend records
        accounts = [SELECT Id, Existing_Company_Id__c, Cards_Mailed_Date__c, X60_Day_Daily_Spend_List__c, 
                    X180_Day_Daily_Spend_List__c, X60_Day_Daily_Spend_Sum__c, X180_Day_Daily_Spend_Sum__c,
                    X60_Day_Daily_Spend__c, X180_Day_Daily_Spend__c
                    FROM Account
                    WHERE Existing_Company_Id__c
                    IN: companyIds
                    AND Cards_Mailed_Date__c != null];
               
        // Card Spend data processing for digestion by parent Account
        for(Account acct : accounts) {
            System.debug('firing');
            String acctCompanyId = acct.Existing_Company_Id__c;
            
            // 60 and 180 date range calculation date variables
            Date acctCardsMailed0 = acct.Cards_Mailed_Date__c.date().addDays(15);
            Date acctCardsMailedDate60 = acctCardsMailed0.addDays(60);
            Date acctCardsMailedDate180 = acctCardsMailed0.addDays(180);
            
            // Collections of PriKeys to prevent double Card Spend record processing
            List<String> sixtyDayKeysList = acct.X60_Day_Daily_Spend_List__c.split(',');
            List<String> oneEightyDayKeysList = acct.X180_Day_Daily_Spend_List__c.split(',');
            Set<String> sixtyDayKeysSet = New Set<String>(sixtyDayKeysList);
            Set<String> oneEightyDayKeysSet = New Set<String>(oneEightyDayKeysList);
            
            // 60 day Card Spend record processing
            if(acct.X60_Day_Daily_Spend__c == false) {
                System.debug('firing');
                for(Card_Spend__c cs60 : dailyRecords) {
                    if((cs60.Company_ID__c != acctCompanyId)
                       || (sixtyDayKeysSet.contains(cs60.System_of_Record_Id__c))){
                        // Do nothing   
                    } else if ((acctCardsMailed0 <= cs60.Day_End__c) && (cs60.Day_End__c <= acctCardsMailedDate60)) {
                        // Update 60 Day daily sum Account field and PriKey map
                        acct.X60_Day_Daily_Spend_Sum__c += cs60.Day_Spend__c;
                        sixtyDayKeysSet.add(cs60.System_of_Record_Id__c);
                    }  
                }
                
                // Update parent Account PriKeys text field
                List<String> sixtyDayKeysStringList = New List<String>(sixtyDayKeysSet);
                acct.X60_Day_Daily_Spend_List__c = string.join(sixtyDayKeysStringList,',');
            }
            
            // 180 day Card Spend record processing
            if(acct.X180_Day_Daily_Spend__c == false) {
                
                for(Card_Spend__c cs180 : dailyRecords) {
                    if((cs180.Company_ID__c != acctCompanyId)
                       || (oneEightyDayKeysSet.contains(cs180.System_of_Record_Id__c))){
                        // Do nothing   
                    } else if ((acctCardsMailed0 <= cs180.Day_End__c) && (cs180.Day_End__c <= acctCardsMailedDate180)) {
                        // Update 180 Day daily sum Account field and PriKey map
                        acct.X180_Day_Daily_Spend_Sum__c += cs180.Day_Spend__c;
                        oneEightyDayKeysSet.add(cs180.System_of_Record_Id__c);
                    }  
                }
                
                // Update parent Account PriKeys text field
                List<String> oneEightyDayKeysStringList = New List<String>(oneEightyDayKeysSet);
                acct.X180_Day_Daily_Spend_List__c = string.join(oneEightyDayKeysStringList,',');
            }
            
        }
        // Update parent Accounts
        update accounts;
        // Purge daily Card Spend records to preserve system data space
        delete [SELECT Id
                FROM Card_Spend__c
                WHERE Id
                IN: dailyRecords];
    }
}