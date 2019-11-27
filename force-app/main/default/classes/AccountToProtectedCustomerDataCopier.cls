// Author: Rick Philson
// Date Created: 2018-08-31
// Purpose: Copy Customer (aka Account) data to Protected_Customer_Info__c object
// Project Components:
//  a. Apex Trigger: accountTrigger 
//  b. Apex Class:   AccountToProtectedCustomerDataCopier
//  c. Test Class:   AccountToProtectedCustomerDataTester

//2019-07-18 Change OLD to New:Added code to change what is sent to Protected Customer Data.  Previously we were sending the oldmap Account
//                             Pre-update values to there.  With this change, we are now sending the Post update values.
//2019-06-25 Business PCD:     Added new fields to Protected_Customer_Data__c for Business customers.  Added population of those fields
//                             to procedures updateProtectedCustomerDataRecord and createProtectedCustomerDataRecord.
//2019-04-10 Add to blocked:   Added Customer Care nCino to list of Profiles that CANNOT update ProtectedCustomerData.
//2018-11-30 Bug Fix:          Logic is not correctly identifying and blocking users based on Profile
//2018-11-19 Enhancement:      Modify logic to exclude updating PCD if the update was incited by Custom System Admin
//2018-10-25 Bug Fix:          The original design called to evaluate the updatedRecord.LastModifiedById to determine if the Service Account
//                             incited the update.  We are calling this class from accountTrigger on the BEFORE UPDATE event.
//                             LastModifiedById and LastModifiedByDate are only updated with the DML commit, consequently we are evaluating
//                             the right field too early.  
//                             Mofifying logic to run AFTER UPDATE for two reasons:
//                             1. to leverage the LastModifiedById  <AND>
//                             2. to ensure we process (copy) Customer records that HAVE BEEN updated.
//2018-09-19 Bug Fix:          Refactoring logic to avoid "Too many SOQL queries" when mass updating Customer
//                             Moving all SOQL Queries and DML statements outside for loop
//2018-09-18 Bug Fix:          Bypass updated record if the FNB_System_Of_Record_Id__c is null.
//                             The FNB_System_Of_Record_Id__c must be populated in order to create or update a Protected_Customer_Data record
//2018-09-06 New Requirement:  updates from Service Account should NOT be applied to ProtectedCustomerData 
//                             UNLESS the field being updated is FNB_System_Of_Record_Id__c

public without sharing class AccountToProtectedCustomerDataCopier{
    private static Map<String, Schema.SObjectField> acctSchema = Schema.SObjectType.Account.fields.getMap();
    
    //Note: the following is a list of Customer (aka Account) fields that, if updated, 
    //      should incite a copy of data from Customer.obj to Protected_Customer_Data__c.obj
    private static List<String> listOfProtectedAccountFields= new List<String> {
                                'firstname', 'middlename', 'lastname', 'preferred_name__pc',
                                'fnb_system_of_record_id__c', 
                                'persondonotcall', 'do_not_mail__c', 'personhasoptedoutofemail',
                                'personmailingstreet', 'personmailingcity', 'personmailingstate', 'personmailingpostalcode', 'personmailingcountry',
                                'personhomephone', 'personmobilephone', 'work_phone__pc',
                                'personemail', 'email_2__pc', 'email_3__pc',
                                'occupation__pc', 'employer__pc',
                                'name', 'billingstreet', 'billingcity', 'billingstate', 'billingpostalcode',
                                'phone', 'fax', 'dba_name__c'
                             };
    //1b. SOQL Query: Get the User.Ids for accounts that should NOT update ProtectedCustomerData
    //    Profile                     Profile Id             
    //    Custom System Admin         00e0c000002GVrpAAG
    //    Customer Care – Cloudingo   00e0c00000287fjAAA
    //    nCino Administrator         00e0c00000287grAAA
    //    nCino Community User        00e0c00000287hfAAA
    //    Customer Care nCino         00e0c00000287hzAAA
    private static Set<Id> blockedProfileIds = new Set<Id>{'00e0c000002GVrpAAG','00e0c00000287fjAAA','00e0c00000287grAAA','00e0c00000287hfAAA','00e0c00000287hzAAA'};
    private static Set<Id> blockedUsers = new Set<Id>(new Map<Id, User>([SELECT Id FROM User WHERE ProfileId IN :blockedProfileIds]).keySet());
    public static void evaluateUpdatedAccountRecords(List<Account> updatedAccountRecords, Map<Id, Account> originalAccountsMap) {
        System.Debug(LoggingLevel.DEBUG, 'Entering AccountToProtectedCustomerDataCopier.evaluateUpdatedAccountRecords() method');
        System.Debug(LoggingLevel.DEBUG, 'Number of updatedAccountRecords=' + updatedAccountRecords.size());
        System.Debug(LoggingLevel.DEBUG, 'Number of originalAccountsMap=' + originalAccountsMap.size());
        System.Debug(LoggingLevel.DEBUG, 'Number of blockedProfileIds: ' + blockedProfileIds .size());
        System.Debug(LoggingLevel.DEBUG, 'Number of blockedUsers: ' + blockedUsers.size());
        
        //Preprocessing Steps:
        //1. SOQL Query: Get the User.Id for the Service Account
        Id serviceAccountId = [SELECT Id, Name from User WHERE Name = 'Service Account'].Id;
        System.Debug(LoggingLevel.DEBUG, 'ServiceAccount.Id=' + serviceAccountId);
        
        //2. SOQL Query: Get a List of corresponding Protected_Customer_Records
        //      Note: one SOQL query will return all of the corresponding Protected_Customer_Data records for the updatedAccountRecords
        List<Protected_Customer_Data__c> pcdRecords = [SELECT Id, Name, Parent_Id__c,
                                                              First_Name__c, Middle_Name__c, Last_Name__c, Preferred_Name__c,
                                                              Do_Not_Call__c, Do_Not_Mail__c, Email_Opt_Out__c,
                                                              Mailing_Street__c, Mailing_City__c, Mailing_State__c, Mailing_Zip__c, Mailing_Country__c,
                                                              Home_Phone__c, Mobile__c, Work_Phone__c,
                                                              Email__c, Email_2__c, Email_3__c,
                                                              Occupation__c, Employer__c,
                                                              Business_Name__c, Business_Billing_Street__c, Business_Billing_City__c, Business_Billing_State__c,
                                                              Business_Phone__c, Business_Fax__c, Business_DBA_Name__c, Business_Do_Not_Mail__c
                                                         FROM Protected_Customer_Data__c 
                                                        WHERE Parent_Id__c IN : originalAccountsMap.keySet()];
        //3. Build a Map<T,T> of the corresponding PCD records; key=Parent_Id__C 
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c>();
        for(Protected_Customer_Data__c pcdRecord : pcdRecords) {
            correspondingPcdRecordsMap.put(pcdRecord.Parent_Id__c, pcdRecord);
        }
        System.Debug(LoggingLevel.DEBUG, 'correspondingPcdRecordsMap built; size()=' + correspondingPcdRecordsMap.size());
        
        //4. Create a container to hold all of the records that need to be updated or inserted into Protected_Customer_Data
        List<Protected_Customer_Data__c> recordsToBeUpserted = new List<Protected_Customer_Data__c>();
        System.Debug(LoggingLevel.DEBUG, 'recordsToBeUpserted List<> built');
        
//for loop to process updated records.
//DO NOT EMBEDDED ANY SOQL OR DML STATEMENTS WITHIN THIS LOOP OR ANY CALLED METHODS
        for (Account updatedAccountRecord : updatedAccountRecords) {
            
            //Precheck: if update was incited by a "blocked user", do NOT create or update PCD record
            if (blockedUsers.contains(updatedAccountRecord.LastModifiedById)) {
                System.Debug(LoggingLevel.DEBUG, 'Update on Account.Id ' + updatedAccountRecord.Id + ' incited by blocked user: ' + updatedAccountRecord.LastModifiedById + '. Do NOT create or update PCD record.');
                continue;  //go to top of the for loop to process the next record; do NOT create or update PCD record
            } else {
                System.Debug(LoggingLevel.DEBUG, 'Update on Account.Id ' + updatedAccountRecord.Id + ' incited by un-blocked user: ' + updatedAccountRecord.LastModifiedById + '.');
            }
                        
            //5. loop thru the updated Account fields to determine which field(s) have been updated
            List<String> fieldsThatHaveBeenUpdated = new List<String>();
            for (String fieldName : acctSchema.keyset()) {
                //bypass fields we don't need to monitor like LastModifiedDate, LastModifiedById, SystemModStamp
                switch on fieldName.toLowercase() {
                    when 'lastmodifieddate', 'lastmodifiedbyid', 'systemmodstamp' {
                        continue;  //do not add it to the list of fields that have been updated
                    }
                    when 'ownership_change_time__c' {
                        continue;  //do not add it to the list of fields that have been updated
                    }
                    when 'commercial_card_rm__c' {
                    // Use case:  this case and the next 10 case ignores relationship field change. However, any PCD field change will be included in PCD. 
                    // This satisfied the condition to ignore relationship field but change the non relationship field.
                        continue;  //do not add it to the list of fields that have been updated
                    }
                    when 'commercial_lending_rm__c' {
                        continue;  //do not add it to the list of fields that have been updated
                    }
                    when 'cts_officer__c' {
                        continue;  //do not add it to the list of fields that have been updated
                    }
                    when 'first_bankcard_affinity_rm__c'{
                        continue;  //do not add it to the list of fields that have been updated
                    }
                    when 'global_banking_officer__c' {
                        continue;  //do not add it to the list of fields that have been updated
                    }
                    when 'mortgage_lo__c' {
                        continue;  //do not add it to the list of fields that have been updated
                    }
                    when 'nest_advisor__c' {
                        continue;  //do not add it to the list of fields that have been updated
                    }
                    when 'retail_banker__c' {
                        continue;  //do not add it to the list of fields that have been updated
                    }
                    when 'small_business_rm__c' {
                        continue;  //do not add it to the list of fields that have been updated
                    }
                    when 'washington_county_bank_rm__c' {
                        continue;  //do not add it to the list of fields that have been updated
                    }
                    when 'wealth_management_rm__c' {
                        continue;  //do not add it to the list of fields that have been updated
                    }
                    when else {
                        if (updatedAccountRecord.get(fieldName) != originalAccountsMap.get(updatedAccountRecord.Id).get(fieldName)) {
                            fieldsThatHaveBeenUpdated.add(fieldName);
                        }
                    }
                }
            }
            System.Debug(LoggingLevel.DEBUG, 'User inciting update: ' + updatedAccountRecord.LastModifiedById + '; fields updated: ' + String.join(fieldsThatHaveBeenUpdated, ','));
            
            //Logic is driven by User making the update
            if (updatedAccountRecord.LastModifiedById == serviceAccountId) {
                if (fieldsThatHaveBeenUpdated.size() == 1 && fieldsThatHaveBeenUpdated[0].equalsIgnoreCase('Fnb_System_of_Record_Id__c')) {
                    //Use case:
                    //  update was incited by the Service Account while applying a new or found CIXF Id to existing an Customer record
                    //  ...Create or Update a PCD record
                    UpdateSysOfRecordID(correspondingPCDRecordsMap, originalAccountsMap.get(updatedAccountRecord.Id), recordsToBeUpserted);
                } else {
                    //Use case:
                    //  update was incited by the Service Account for any other routine (i.e. DataLoader) that updates the Account object
                    continue;  //go to top of the for loop to process the next record; do NOT create or update PCD record
                }
            } else  {
                if (updateRequestIncludesAtLeastOneProtectedField(fieldsThatHaveBeenUpdated)) {
                    if (updatedAccountRecord.FNB_System_of_record_id__c != Null) {
                        //Use case: 
                        //   Update was incited by non-Service Account user
                        //      AND update included at least one of the protected fields
                        //         AND updated Account record has a Cixf Id (aka Fnb_System_of_Record_Id__c)
                        processUpdateRecord(correspondingPCDRecordsMap, updatedAccountRecord, recordsToBeUpserted);
                    } else {
                    //Use case:
                    //   Update was incited by non-Service Account user
                    //      BUT record does not have a Cixf Id (aka Fnb_System_of_Record_Id__c)
                        continue;  //go to top of the for loop to process the next record
                    }
                } else {
                    //Use case:
                    //   Update was incited by non-Service Account user
                    //      BUT update did NOT include at least one of the protected fields
                    continue;  //go to top of the for loop to process the next record; do NOT create or update PCD record
                }
            } 
        }   //end for loop
        
        //Do all DML statements here... outside the for loop
        if (recordsToBeUpserted.size() > 0) {
            Database.UpsertResult[] upsertResults = upsertProtectedCustomerData(recordsToBeUpserted);
            processUpsertResults(upsertResults);
        }
    }
    
    //Interrogate fields changed against list of protected (Account) fields
    public static boolean updateRequestIncludesAtLeastOneProtectedField(List<String> listOfFieldsUpdated) {
        System.Debug(LoggingLevel.DEBUG, 'Entering AccountToProtectedCustomerDataCopier.updateRequestIncludesAtLeastOneProtectedField()' + String.join(listOfFieldsUpdated, ','));

        for (String item: listOfFieldsUpdated) {
            if (listOfProtectedAccountFields.contains(item.toLowerCase())) {
                System.Debug(LoggingLevel.Debug, 'returning TRUE from updateRequestIncludesAtLeastOneProtectedField');
                return true;
            } else {
                continue;
            }
        }
        System.Debug(LoggingLevel.Debug, 'returning FALSE from updateRequestIncludesAtLeastOneProtectedField');
        return false;  //if we get here, we've checked all the fields updated and none of the updated fields were amoung the 
    }

    public static void UpdateSysOfRecordID(Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap, Account updatedRecord, List<Protected_Customer_Data__c> recordsToBeUpserted) {
        System.Debug(LoggingLevel.DEBUG, 'Entering AccountToProtectedCustomerDataCopier.processUpdateRecord(); updatedRecord.Id=' + updatedRecord.Id);
        System.Debug(LoggingLevel.DEBUG, '>>> serialized preupdatedRecord:' + System.Json.serialize(updatedRecord));

      //Since this paragraph is only performed when a sys admin updates the System of Record id field on a customer (changing it from a blank to something), this paragraph will only call
      //the procedure to create a new PCD record, never the one to update an existing PCD record. 
        Protected_Customer_Data__c newPCDRecord = createNewProtectedCustomerDataRecord(updatedRecord);
        recordsToBeUpserted.add(newPCDRecord);
    }

    public static void processUpdateRecord(Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap, Account updatedRecord, List<Protected_Customer_Data__c> recordsToBeUpserted) {
        System.Debug(LoggingLevel.DEBUG, 'Entering AccountToProtectedCustomerDataCopier.processUpdateRecord(); updatedRecord.Id=' + updatedRecord.Id);
        System.Debug(LoggingLevel.DEBUG, '>>> serialized updatedRecord:' + System.Json.serialize(updatedRecord));

        if (correspondingPCDRecordsMap.containsKey(updatedRecord.Id)) {
            Protected_Customer_Data__c existingPCDRecord = correspondingPCDRecordsMap.get(updatedRecord.Id);
            updateProtectedCustomerDataRecord(existingPCDRecord, updatedRecord);
            recordsToBeUpserted.add(existingPCDRecord);
        } else {
            Protected_Customer_Data__c newPCDRecord = createNewProtectedCustomerDataRecord(updatedRecord);
            recordsToBeUpserted.add(newPCDRecord);
        }
    }
    
    //Update Protected_Customer_Record with pre-updated Customer (aka Account) values
    //  Apex Note: Reference types, like Protected_Customer_Data__c, are passed by reference.
    //             The method updates the memory address of the protectedCustData variable
    public static void updateProtectedCustomerDataRecord(Protected_Customer_Data__c protectedCustData, Account updateValues) {
        System.Debug(LoggingLevel.DEBUG, 'Entering AccountToProtectedCustomerDataCopier.updateProtectedCustomerDataRecord(); pcdRecord.Name=' + protectedCustData.Name);

        //for all field, replace protected data with the newly values that the record in Account are being updated to.
        protectedCustData.First_Name__c = updateValues.FirstName;
        protectedCustData.Middle_Name__c = updateValues.MiddleName;
        protectedCustData.Last_Name__c = updateValues.LastName;
        protectedCustData.Preferred_Name__c = updateValues.Preferred_Name__pc;
        protectedCustData.Do_Not_Call__c = updateValues.PersonDoNotCall;
        protectedCustData.Do_Not_Mail__c = updateValues.Do_Not_Mail__c;
        protectedCustData.Email_Opt_Out__c = updateValues.PersonHasOptedOutOfEmail;
        protectedCustData.Mailing_Street__c = updateValues.PersonMailingStreet;
        protectedCustData.Mailing_City__c = updateValues.PersonMailingCity;
        protectedCustData.Mailing_State__c = updateValues.PersonMailingState;
        protectedCustData.Mailing_Zip__c = updateValues.PersonMailingPostalCode;
        protectedCustData.Mailing_Country__c = updateValues.PersonMailingCountry;
        protectedCustData.Home_Phone__c = updateValues.PersonHomePhone;
        protectedCustData.Mobile__c = updateValues.PersonMobilePhone;
        protectedCustData.Work_Phone__c = updateValues.Work_Phone__pc;
        protectedCustData.Email__c = updateValues.PersonEmail;
        protectedCustData.Email_2__c = updateValues.Email_2__pc;
        protectedCustData.Email_3__c = updateValues.Email_3__pc;
        protectedCustData.Occupation__c = updateValues.Occupation__pc;
        protectedCustData.Employer__c = updateValues.Employer__pc;
        protectedCustData.Business_Name__c = updateValues.Name;
        protectedCustData.Business_Phone__c = updateValues.Phone;
        protectedCustData.Business_Fax__c = updateValues.Fax;
        protectedCustData.Business_Billing_Street__c = updateValues.BillingStreet;
        protectedCustData.Business_Billing_City__c = updateValues.BillingCity;
        protectedCustData.Business_Billing_State__c = updateValues.BillingState;
        protectedCustData.Business_Billing_PostalCode__c = updateValues.BillingPostalCode;
        protectedCustData.Business_Billing_Country__c = updateValues.BillingCountry;
        protectedCustData.Business_DBA_Name__c = updateValues.DBA_Name__c;
        protectedCustData.Business_Do_Not_Mail__c = updateValues.Do_Not_Mail__c;
    }

    //Create and return a new Protected_Customer_Data record using the pre-updated Customer (aka Account) values
    public static Protected_Customer_Data__c createNewProtectedCustomerDataRecord(Account updateValues) {
        System.Debug(LoggingLevel.DEBUG, 'Entering AccountToProtectedCustomerDataCopier.createNewProtectedCustomerDataRecord(); account.Id=' + updateValues.Id);

        return new Protected_Customer_Data__c(        
                Parent_Id__c = updateValues.Id,       
                FNB_System_of_Record_Id__c = updateValues.FNB_System_of_Record_Id__c,
                First_Name__c = updateValues.FirstName,
                Middle_Name__c = updateValues.MiddleName,
                Last_Name__c = updateValues.LastName,
                Preferred_Name__c = updateValues.Preferred_Name__pc,
                Do_Not_Call__c = updateValues.PersonDoNotCall,
                Do_Not_Mail__c = updateValues.Do_Not_Mail__c,
                Email_Opt_Out__c = updateValues.PersonHasOptedOutOfEmail,
                Mailing_Street__c = updateValues.PersonMailingStreet,
                Mailing_City__c = updateValues.PersonMailingCity,
                Mailing_State__c = updateValues.PersonMailingState,
                Mailing_Zip__c = updateValues.PersonMailingPostalCode,
                Mailing_Country__c = updateValues.PersonMailingCountry,
                Home_Phone__c = updateValues.PersonHomePhone,
                Mobile__c = updateValues.PersonMobilePhone,
                Work_Phone__c = updateValues.Work_Phone__pc,
                Email__c = updateValues.PersonEmail,
                Email_2__c = updateValues.Email_2__pc,
                Email_3__c = updateValues.Email_3__pc,
                Occupation__c = updateValues.Occupation__pc,
                Employer__c = updateValues.Employer__pc,
                Business_Name__c = updateValues.Name,
                Business_Phone__c = updateValues.Phone,
                Business_Fax__c = updateValues.Fax,
                Business_Billing_Street__c = updateValues.BillingStreet,
                Business_Billing_City__c = updateValues.BillingCity,
                Business_Billing_State__c = updateValues.BillingState,
                Business_Billing_PostalCode__c = updateValues.BillingPostalCode,
                Business_Billing_Country__c = updateValues.BillingCountry,
                Business_DBA_Name__c = updateValues.DBA_Name__c);                
    }
    
    //Update Existing and/or Insert new Protected Customer records
    public static Database.UpsertResult[] upsertProtectedCustomerData(List<Protected_Customer_Data__c> records) {
        System.Debug(LoggingLevel.DEBUG, 'Entering AccountToProtectedCustomerDataCopier.upsertProtectedCustomerData(); numberOfRecords=' + records.size());
        Database.UpsertResult[] sr =  Database.upsert(records, false);
        return sr;
    }
    
    //Process DML results
    public static void processUpsertResults(Database.UpsertResult[] upsertResults) {
        System.Debug(LoggingLevel.DEBUG, 'Entering AccountToProtectedCustomerDataCopier.processUpsertResults()');
        for(Database.UpsertResult sr : upsertResults) {
            if (sr.isSuccess()) {
                if (sr.isCreated()) {
                    System.debug(LoggingLevel.DEBUG, 'Protected_Customer_Data record successfully created; Id: ' + sr.getId());
                } else {
                    System.debug(LoggingLevel.DEBUG, 'Protected_Customer_Data record successfully updated; Id: ' + sr.getId());
                }
            } else {
                for(Database.Error err : sr.getErrors()) {
                    System.debug(LoggingLevel.DEBUG, 'The following error has occurred.');
                    System.debug(LoggingLevel.DEBUG, err.getStatusCode() + ': ' + err.getMessage());
                    System.debug(LoggingLevel.DEBUG, 'Account fields that affected this error: ' + err.getFields());
                }
            }
        }
    }
}