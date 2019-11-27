// Author: Alexander Nourbakhsh
// Date Created/Modified: 09/29/2016
// Project: Unfunded Trust
// Purpose: To create a branded funded Account record type and branded related Contacts
// 09/29/2016 - Added branded related Opportunity. 


public class fundTrustAccount {
    
    // Before insert trigger .oldMap map and .new sObject list
    private final Map<Id, Unfunded_Trust__c> oldUnfundedMap;
    private final List<Unfunded_Trust__c> newUnfundedList;
        
    // Main method
    public static void fundTrustAccount(Map<Id, Unfunded_Trust__c> oldUnfundedMap, List<Unfunded_Trust__c> newUnfundedList) {
    
            
        // Get Trust Account Record Type Id
        String acctRecordTypeId = [SELECT Id
                                   FROM RecordType 
                                   WHERE sObjectType = 'Account' 
                                   AND Name = 'Trust'].Id;
            
        // List of new Trust Accounts to be Inserted
        List<Account> newTrustAccounts = new List<Account>();
        
        // List of new Trust Accounts Source Unfunded Trust Ids
        List<String> sourceUnfundedTrustIds = new List<String>();
        
        // List of qualified Unfunded Trusts for Contact record parenting
        List<Unfunded_Trust__c> qualifiedUnfundedTrusts = new List<Unfunded_Trust__c>();
        
        // Map for Contact record parenting
        Map<String, Id> unfundTrustIdAccountMap = new Map<String, Id>();  
            
            // Loop thru new sObject versions and compare to old sObject versions
            for(Unfunded_Trust__c unfund: newUnfundedList) {
                Unfunded_Trust__c oldUnfunded = oldUnfundedMap.get(unfund.id);
                // If status is 'Funded' and is a new value compared to old version 
                if(unfund.Status__c == 'Funded' && unfund.Status__c != oldUnfunded.Status__c){
                    
                    // Add Unfunded Trust record to qualified list for contact record reparenting
                    qualifiedUnfundedTrusts.add(unfund);
                    
                    // Create new Trust Account record and trim source Unfunded Trust Id to 15 char
                    Account trustAcct = new Account(name = unfund.name, 
                                                    recordTypeId = acctRecordTypeId,
                                                    Source_Unfunded_Trust_ID__c = String.valueOf(unfund.id).substring(0, 15));
                    
                    // Add Account to list for insertion
                    newTrustAccounts.add(trustAcct);
                    
                    // Add Source Unfunded Trust Ids to list
                    sourceUnfundedTrustIds.add(trustAcct.Source_Unfunded_Trust_ID__c);
                    
                // If status is changed from 'Funded' to any other value compared to old version
                } else if (unfund.Status__c != 'Funded' && oldUnfunded.Status__c == 'Funded') {
                    // Throw error message
                    unfund.addError(' You cannot change the "Status" field once an Unfunded Trust has been funded.');
                    
                }
                
            }
        
        // Insert new Trust Accounts
        insert newTrustAccounts;
        
        // Loop thru newly inserted Trust Accounts
        for(Account acct : [SELECT Id, Source_Unfunded_Trust_ID__c
                            FROM Account
                            WHERE Source_Unfunded_Trust_ID__c 
                            IN: sourceUnfundedTrustIds]) {
            
            Id x18Id = acct.Source_Unfunded_Trust_ID__c;                   
                                
            // Put Source Unfunded Trust Id and Account into map                  
            unfundTrustIdAccountMap.put(x18Id, acct.Id);   
            }

        createTrustContacts(unfundTrustIdAccountMap, qualifiedUnfundedTrusts);
        createOpportunity(unfundTrustIdAccountMap, qualifiedUnfundedTrusts);
    }    
    
    public static void createTrustContacts(Map<String, Id> unfundTrustIdAccountMap, List<Unfunded_Trust__c> qualifiedUnfundedTrusts) {
        
        // Get Trust Contact Record Type Id
        String contRecordTypeId = [SELECT Id
                                   FROM RecordType 
                                   WHERE sObjectType = 'Contact' 
                                   AND Name = 'Trust'].Id;
    
        // List of new Trust Contacts to be Inserted
        List<Contact> newTrustContacts = new List<Contact>();
        
        // Loop thru qualified Unfunded Trust records for Trust Contact record creation
        for(Unfunded_Trust__c unfund : qualifiedUnfundedTrusts) {
            
            // If Unfunded Trust Grantor Last Name is not null then create Trust Contact for Unfunded Trust Grantor
            if(unfund.Grantor_Last_Name__c != null) {
                
                // Create Trust Contact for grantor        
                Contact grantorCont = new Contact(lastname = unfund.Grantor_Last_Name__c, 
                                                  firstname = unfund.Grantor_First_Name__c, 
                                                  phone = unfund.Grantor_Phone__c,
                                                  email = unfund.Grantor_Email__c,
                                                  mailingStreet = unfund.Grantor_Billing_Street__c,
                                                  mailingCity = unfund.Grantor_Billing_City__c,
                                                  mailingState = unfund.Grantor_Billing_State__c,
                                                  mailingPostalCode = unfund.Grantor_Billing_Zip__c,
                                                  mailingCountry = unfund.Grantor_Billing_Country__c,
                                                  recordTypeId = contRecordTypeId,
                                                  accountId = unfundTrustIdAccountMap.get(unfund.id));
                
                // Add new Trust Contact to Contact list for insertion     
                newTrustContacts.add(grantorCont);
                
            }
            
            // If Unfunded Trust Additional Contact Last Name is not null then create Trust Contact for Unfunded Trust Additional Contact
            if(unfund.Additional_Contact_Last_Name__c != null) {
                
                // Create Trust Contact for additional contact
                Contact additionalCont = new Contact(lastname = unfund.Additional_Contact_Last_Name__c, 
                                                  firstname = unfund.Additional_Contact_First_Name__c, 
                                                  phone = unfund.Additional_Contact_Phone__c,
                                                  email = unfund.Additional_Contact_Email__c,
                                                  mailingStreet = unfund.Additional_Contact_Street__c,
                                                  mailingCity = unfund.Additional_Contact_City__c,
                                                  mailingState = unfund.Additional_Contact_State__c,
                                                  mailingPostalCode = unfund.Additional_Contact_Zip__c,
                                                  mailingCountry = unfund.Additional_Contact_Country__c,
                                                  recordTypeId = contRecordTypeId,
                                                  accountId = unfundTrustIdAccountMap.get(unfund.id));
                
                // Add new Trust Contact to Contact list for insertion     
                newTrustContacts.add(additionalCont);
                             
            }    
        }
    
    // Insert new Trust Contacts
    insert newTrustContacts;    
    }
    
    public static void createOpportunity(Map<String, Id> unfundTrustIdAccountMap, List<Unfunded_Trust__c> qualifiedUnfundedTrusts) {
        
        Id oppRecordTypeId = [SELECT Id
                           FROM RecordType 
                           WHERE sObjectType = 'Opportunity' 
                           AND Name = 'Wealth Management'
                           LIMIT 1].Id;
    
        List<Opportunity> newOpps = new List<Opportunity>();
        
        for(Unfunded_Trust__c unfund : qualifiedUnfundedTrusts) {
        
            try {
                
                Opportunity newOpp = new Opportunity(
                    name = unfund.name,
                    accountId = unfundTrustIdAccountMap.get(unfund.id),
                    Assets_under_Managment__c = unfund.Assets_under_Management__c,
                    one_Time_Fees__c = unfund.One_Time_Fees__c,
                    annual_Revenue__c = unfund.Annual_Revenue__c,
                    closeDate = date.today(),
                    stageName = 'Situation/Objective Assessment Initiated',
                    recordTypeId = oppRecordTypeId);
                    
                if (unfund.COI__c != null) {
                
                    newOpp.Lead_Source_COI__c = unfund.COI__c;
                    
                }    
                    
                newOpps.Add(newOpp);
            
            } catch (Exception e) {
                
                unfund.addError(' Processing failure. Not enough information to create Opportunity.');   
            }
        }
              
        insert newOpps;
            
    }                               
}