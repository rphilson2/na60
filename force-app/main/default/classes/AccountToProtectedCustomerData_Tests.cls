@isTest

public class AccountToProtectedCustomerData_Tests {

    @TestSetup
    static void CreateCustomSetting() {
        List<TriggerSupport__c> triggerSupportSettings = new List<TriggerSupport__c>();
        TriggerSupport__c accountTriggerSetting = new TriggerSupport__c();
        accountTriggerSetting.Name = 'Account';
        accountTriggerSetting.TriggerIsDisabled__c = true;
        triggerSupportSettings.add(accountTriggerSetting);
        
        insert triggerSupportSettings;        
    }


//==== evaluateUpdatedAccountRecords() tests ==================================================================================// 
    @isTest
    static void evaluateUpdatedAccountRecords_SvcAcct_test01_CixfIdUpdated() {
                
        Account originalRecord = getTestCustomerRecord_LastModifiedBySvcAccount();
        Database.SaveResult sr = Database.insert(originalRecord);
        Map<Id, Account> originalAccountsMap = new Map<Id, Account> { originalRecord.Id => originalRecord} ;
            
        Account updatedRecord = originalRecord.clone(true, false, true, true);
        updatedRecord.FNB_System_of_record_id__c = 'abc123';

        List<Account> updatedRecords = new List<Account>{ updatedRecord };

        AccountToProtectedCustomerDataCopier.evaluateUpdatedAccountRecords(updatedRecords, originalAccountsMap);
        
        //Note: there is no returned value you can run a System.Assert against
    }

    @isTest
    static void evaluateUpdatedAccountRecords_SvcAcct_test01_CixfIdUpdatedandPCDExists() {
        Account originalRecord = getTestCustomerRecord_LastModifiedBySvcAccount();
        Database.SaveResult sr = Database.insert(originalRecord);
        Map<Id, Account> originalAccountsMap = new Map<Id, Account> { originalRecord.Id => originalRecord} ;
            
        Account updatedRecord = originalRecord.clone(true, false, true, true);
        updatedRecord.FNB_System_of_record_id__c = 'abc123';

        Protected_Customer_Data__c existingPCD = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc001',
                        First_Name__c = 'Oscar', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );
        Database.SaveResult insertedExistingPCD = Database.insert(existingPCD);

        List<Account> updatedRecords = new List<Account>{ updatedRecord };

        AccountToProtectedCustomerDataCopier.evaluateUpdatedAccountRecords(updatedRecords, originalAccountsMap);
        
        //Note: there is no returned value you can run a System.Assert against
                
    }
    
    @isTest
    static void evaluateUpdatedAccountRecords_SvcAcct_test02_NoCixfIdOnCustomerRecord() {
        Account originalRecord = getTestCustomerRecord_LastModifiedBySvcAccount();
        Database.SaveResult sr = Database.insert(originalRecord);
        Map<Id, Account> originalAccountsMap = new Map<Id, Account> { originalRecord.Id => originalRecord} ;
            
        Account updatedRecord = originalRecord.clone(true, false, true, true);
        updatedRecord.Preferred_Name__pc = 'Oscar the Great';

        List<Account> updatedRecords = new List<Account>{ updatedRecord };

        AccountToProtectedCustomerDataCopier.evaluateUpdatedAccountRecords(updatedRecords, originalAccountsMap);
        
        //Note: there is no returned value you can run a System.Assert against
    }
    
    @isTest
    static void evaluateUpdatedAccountRecords_SvcAcct_test03_PreferredNameUpdated() {
        Account originalRecord = getTestCustomerRecord_LastModifiedBySvcAccount();
        Database.SaveResult sr = Database.insert(originalRecord);
        Map<Id, Account> originalAccountsMap = new Map<Id, Account> { originalRecord.Id => originalRecord} ;
            
        Account updatedRecord = originalRecord.clone(true, false, true, true);
        updatedRecord.Preferred_Name__pc = 'Oscar the Great';

        List<Account> updatedRecords = new List<Account>{ updatedRecord };

        AccountToProtectedCustomerDataCopier.evaluateUpdatedAccountRecords(updatedRecords, originalAccountsMap);
        
        //Note: there is no returned value you can run a System.Assert against
    }

    @isTest
    static void evaluateUpdatedAccountRecords_SvcAcct_test04_MultipleFieldsUpdated() {
        Account originalRecord = getTestCustomerRecord_LastModifiedBySvcAccount();
        Database.SaveResult sr = Database.insert(originalRecord);
        Map<Id, Account> originalAccountsMap = new Map<Id, Account> { originalRecord.Id => originalRecord} ;
            
        Account updatedRecord = originalRecord.clone(true, false, true, true);
        updatedRecord.Preferred_Name__pc = 'Oscar the Great';
        updatedRecord.FNB_System_of_record_id__c = 'abc123';

        List<Account> updatedRecords = new List<Account>{ updatedRecord };

        AccountToProtectedCustomerDataCopier.evaluateUpdatedAccountRecords(updatedRecords, originalAccountsMap);
        
        //Note: there is no returned value you can run a System.Assert against
    }
    
    @isTest
    static void evaluateUpdatedAccountRecords_NonSvcAcct_test01_NoProtectedFieldsUpdated() {
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.SaveResult sr = Database.insert(originalRecord);
        Map<Id, Account> originalAccountsMap = new Map<Id, Account> { originalRecord.Id => originalRecord} ;
            
        Account updatedRecord = originalRecord.clone(true, false, true, true);
        updatedRecord.Wealth_Estate_Planning_Newsletter__c = true;

        List<Account> updatedRecords = new List<Account>{ updatedRecord };

        AccountToProtectedCustomerDataCopier.evaluateUpdatedAccountRecords(updatedRecords, originalAccountsMap);
        
        //Note: there is no returned value you can run a System.Assert against
    }
    
    @isTest
    static void evaluateUpdatedAccountRecords_NonSvcAcct_test02_AtLeastOneProtectedFieldUpdated() {
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.SaveResult sr = Database.insert(originalRecord);
        Map<Id, Account> originalAccountsMap = new Map<Id, Account> { originalRecord.Id => originalRecord} ;
            
        Account updatedRecord = originalRecord.clone(true, false, true, true);
        updatedRecord.Wealth_Estate_Planning_Newsletter__c = true;
        updatedRecord.Preferred_Name__pc = 'Johnny B. Good';

        List<Account> updatedRecords = new List<Account>{ updatedRecord };

        AccountToProtectedCustomerDataCopier.evaluateUpdatedAccountRecords(updatedRecords, originalAccountsMap);
        
        //Note: there is no returned value you can run a System.Assert against
    }
    
    @isTest
    static void evaluateUpdatedAccountRecords_NonSvcAcct_test03_ProtectedFieldsUpdated_NoCixfIdOnCustomerRecord() {
        Account originalRecord = getTestCustomer1AccountRecord();
        originalRecord.FNB_System_of_record_id__c = Null;
        Database.SaveResult sr = Database.insert(originalRecord);
        Map<Id, Account> originalAccountsMap = new Map<Id, Account> { originalRecord.Id => originalRecord} ;
            
        Account updatedRecord = originalRecord.clone(true, false, true, true);
        updatedRecord.Wealth_Estate_Planning_Newsletter__c = true;
        updatedRecord.Preferred_Name__pc = 'Johnny B. Good';

        List<Account> updatedRecords = new List<Account>{ updatedRecord };

        AccountToProtectedCustomerDataCopier.evaluateUpdatedAccountRecords(updatedRecords, originalAccountsMap);
        
        //Note: there is no returned value you can run a System.Assert against
    }


//    @isTest(seeAllData=true)  2018-09-20 - Disabling test method... throwing System.SObjectException: 
//                                 SObject row was retrieved via SOQL without querying the requested field: Account.IsDeleted
    static void evaluateUpdatedAccountRecords_NonSvcAcct_test04_UpdateCustomerWithExistingPCDRecord() {
        //grab a real record from the ORG that has a PCD record...  Scott TestAcct I
        Account originalRecord = [SELECT Id, FirstName, LastName, Preferred_Name__pc FROM Account WHERE Id = '0014F00000C0Gf9' LIMIT 1];
            
        Map<Id, Account> originalAccountsMap = new Map<Id, Account> { originalRecord.Id => originalRecord} ;
            
        //simulate the change record
        Account updatedRecord = originalRecord.clone(true, false, true, true);
        updatedRecord.Wealth_Estate_Planning_Newsletter__c = true;
        updatedRecord.Preferred_Name__pc = 'Johnny B. Good';

        List<Account> updatedRecords = new List<Account>{ updatedRecord };

        AccountToProtectedCustomerDataCopier.evaluateUpdatedAccountRecords(updatedRecords, originalAccountsMap);
        
        //Note: there is no returned value you can run a System.Assert against
    }

    @isTest
    static void evaluateUpdatedAccountRecords_NonSvcAcct_test04_UpdateCustomerWithExistingPCDRecord_blankOutPhoneNumber() {
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.SaveResult sr = Database.insert(originalRecord);
        Map<Id, Account> originalAccountsMap = new Map<Id, Account> { originalRecord.Id => originalRecord} ;
            
        Account updatedRecord = originalRecord.clone(true, false, true, true);
        updatedRecord.PersonHomePhone = '';

        Protected_Customer_Data__c existingPCD = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc001',
                        First_Name__c = 'Oscar', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = 'USA', 
                        Home_Phone__c = '8775551212', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );
        Database.SaveResult insertedExistingPCD = Database.insert(existingPCD);

        List<Account> updatedRecords = new List<Account>{ updatedRecord };

        AccountToProtectedCustomerDataCopier.evaluateUpdatedAccountRecords(updatedRecords, originalAccountsMap);
        
        string expected = null;
        Protected_Customer_Data__c actualPCD = [select id, name, Home_Phone__c from Protected_Customer_Data__c where Parent_id__c = :updatedRecord.Id limit 1];
        string actual = actualPCD.Home_Phone__c;

        //Assert: Phone number in PCD should be blank.
        System.AssertEquals(expected, actual);
        
    }
    
    // ====================================================================================================
    @isTest
    static void evaluateUpdatedAccountRecords_BlockOrAllow_test01_ProtectedFieldsUpdated_CommercialCardRMFieldUpdated() {       
        //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true);        
        updatedAccountRecord.Commercial_Card_RM__c = '0050c00000Dbef0AAB';   
        //c. create expected Protected_Customer_Data record        
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Oscar', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );

        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => expected };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
              
        //Assert: only record should be the same as the found Protected Customer record
        System.AssertEquals(expected, actualList[0]);
    }   
    
    
    @isTest
    static void evaluateUpdatedAccountRecords_BlockOrAllow_test02_ProtectedFieldsUpdated_CommercialCardRMFieldUpdated() {
        //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true);
        updatedAccountRecord.FirstName = 'Steve';
        updatedAccountRecord.Commercial_Card_RM__c = '0050c00000Dbef0AAB';   
        
         //c. create expected Protected_Customer_Data record
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Steve', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );

          //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => expected };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);       
       
        //Assert: only record should be the same as the found Protected Customer record
        System.AssertEquals(expected, actualList[0]);
    }
    @isTest
    static void evaluateUpdatedAccountRecords_BlockOrAllow_test03_ProtectedFieldsUpdated_CommercialLendingRMFieldUpdated() {
         //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true); 
        updatedAccountRecord.Commercial_Lending_RM__c = '005300000055GHwAAM';        

         //c. create expected Protected_Customer_Data record        
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Oscar', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );

        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => expected };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
              
        //Assert: only record should be the same as the found Protected Customer record
        System.AssertEquals(expected, actualList[0]);
    }
    @isTest
    static void evaluateUpdatedAccountRecords_BlockOrAllow_test04_ProtectedFieldsUpdated_CommercialLendingRMFieldUpdated() {
         //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true); 
        updatedAccountRecord.FirstName = 'Steve';
        updatedAccountRecord.Commercial_Lending_RM__c = '005300000055GHwAAM';        

         //c. create expected Protected_Customer_Data record        
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Steve', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );

        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => expected };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
              
        //Assert: only record should be the same as the found Protected Customer record
        System.AssertEquals(expected, actualList[0]);
    }
    @isTest
    static void evaluateUpdatedAccountRecords_BlockOrAllow_test05_ProtectedFieldsUpdated_CTSOfficerFieldUpdated() {
         //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true); 
        updatedAccountRecord.CTS_Officer__c = '005300000055GHwAAM';  

         //c. create expected Protected_Customer_Data record        
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Oscar', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );

        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => expected };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
              
        //Assert: only record should be the same as the found Protected Customer record
        System.AssertEquals(expected, actualList[0]);
    }
    @isTest
    static void evaluateUpdatedAccountRecords_BlockOrAllow_test06_ProtectedFieldsUpdated_CTSOfficerFieldUpdated() {
        //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true); 
        updatedAccountRecord.FirstName = 'Steve';
        updatedAccountRecord.CTS_Officer__c = '005300000055GHwAAM';  

         //c. create expected Protected_Customer_Data record        
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Steve', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );

        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => expected };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
              
        //Assert: only record should be the same as the found Protected Customer record
        System.AssertEquals(expected, actualList[0]);
    }
    @isTest
    static void evaluateUpdatedAccountRecords_BlockOrAllow_test07_ProtectedFieldsUpdated_FirstBankcardAffinityRMFieldUpdated() {
          //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true);         
        updatedAccountRecord.First_Bankcard_Affinity_RM__c = '005300000055GHwAAM';  

         //c. create expected Protected_Customer_Data record        
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Oscar', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );

        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => expected };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
              
        //Assert: only record should be the same as the found Protected Customer record
        System.AssertEquals(expected, actualList[0]);
    }    
    @isTest
    static void evaluateUpdatedAccountRecords_BlockOrAllow_test08_ProtectedFieldsUpdated_FirstBankcardAffinityRMFieldUpdated() {
        //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true); 
        updatedAccountRecord.FirstName = 'Steve';
        updatedAccountRecord.First_Bankcard_Affinity_RM__c = '005300000055GHwAAM'; 

         //c. create expected Protected_Customer_Data record        
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Steve', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );

        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => expected };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
              
        //Assert: only record should be the same as the found Protected Customer record
        System.AssertEquals(expected, actualList[0]);
    }
    @isTest
    static void evaluateUpdatedAccountRecords_BlockOrAllow_test09_ProtectedFieldsUpdated_GlobalBankingOfficerFieldUpdated() {   
        //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true);         
        updatedAccountRecord.Global_Banking_Officer__c = '005300000055GHwAAM'; 

         //c. create expected Protected_Customer_Data record        
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Oscar', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );

        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => expected };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
              
        //Assert: only record should be the same as the found Protected Customer record
        System.AssertEquals(expected, actualList[0]);
    }
     @isTest
    static void evaluateUpdatedAccountRecords_BlockOrAllow_test10_ProtectedFieldsUpdated_GlobalBankingOfficerFieldUpdated() {
         //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true); 
        updatedAccountRecord.FirstName = 'Steve';
        updatedAccountRecord.Global_Banking_Officer__c = '005300000055GHwAAM'; 

         //c. create expected Protected_Customer_Data record        
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Steve', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );

        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => expected };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
              
        //Assert: only record should be the same as the found Protected Customer record
        System.AssertEquals(expected, actualList[0]);
    }
    @isTest
    static void evaluateUpdatedAccountRecords_BlockOrAllow_test11_ProtectedFieldsUpdated_MortgageLOFieldUpdated() {        
         //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true);         
        updatedAccountRecord.Mortgage_LO__c = '005300000055GHwAAM'; 

         //c. create expected Protected_Customer_Data record        
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Oscar', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );

        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => expected };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
              
        //Assert: only record should be the same as the found Protected Customer record
        System.AssertEquals(expected, actualList[0]);
    }
    @isTest
    static void evaluateUpdatedAccountRecords_BlockOrAllow_test12_ProtectedFieldsUpdated_MortgageLOFieldUpdated() {
         //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true); 
        updatedAccountRecord.FirstName = 'Steve';
        updatedAccountRecord.Mortgage_LO__c = '005300000055GHwAAM'; 

         //c. create expected Protected_Customer_Data record        
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Steve', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );

        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => expected };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
              
        //Assert: only record should be the same as the found Protected Customer record
        System.AssertEquals(expected, actualList[0]);
    }
    @isTest
    static void evaluateUpdatedAccountRecords_BlockOrAllow_test13_ProtectedFieldsUpdated_NESTAdvisorFieldUpdated() {
         //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true);         
        updatedAccountRecord.NEST_Advisor__c = '005300000055GHwAAM'; 

         //c. create expected Protected_Customer_Data record        
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Oscar', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );

        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => expected };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
              
        //Assert: only record should be the same as the found Protected Customer record
        System.AssertEquals(expected, actualList[0]);
    }
    @isTest
    static void evaluateUpdatedAccountRecords_BlockOrAllow_test14_ProtectedFieldsUpdated_NESTAdvisorFieldUpdated() {
         //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true); 
        updatedAccountRecord.FirstName = 'Steve';
        updatedAccountRecord.NEST_Advisor__c = '005300000055GHwAAM'; 

         //c. create expected Protected_Customer_Data record        
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Steve', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );

        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => expected };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
              
        //Assert: only record should be the same as the found Protected Customer record
        System.AssertEquals(expected, actualList[0]);
    }
    @isTest
    static void evaluateUpdatedAccountRecords_BlockOrAllow_test15_ProtectedFieldsUpdated_RetailBankerFieldUpdated() {
         //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true);         
        updatedAccountRecord.Retail_Banker__c = '005300000055GHwAAM'; 

         //c. create expected Protected_Customer_Data record        
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Oscar', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );

        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => expected };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
              
        //Assert: only record should be the same as the found Protected Customer record
        System.AssertEquals(expected, actualList[0]);
    }
    @isTest
    static void evaluateUpdatedAccountRecords_BlockOrAllow_test16_ProtectedFieldsUpdated_RetailBankerFieldUpdated() {
        //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true);      
        updatedAccountRecord.FirstName = 'Steve';
        updatedAccountRecord.Retail_Banker__c = '005300000055GHwAAM'; 

         //c. create expected Protected_Customer_Data record        
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Steve', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );

        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => expected };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
              
        //Assert: only record should be the same as the found Protected Customer record
        System.AssertEquals(expected, actualList[0]);
    }
    
    @isTest
    static void evaluateUpdatedAccountRecords_BlockOrAllow_test17_ProtectedFieldsUpdated_SmallBusinessRMFieldUpdated() {
        //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true);         
        updatedAccountRecord.Small_Business_RM__c = '005300000055GHwAAM'; 

         //c. create expected Protected_Customer_Data record        
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Oscar', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );

        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => expected };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
              
        //Assert: only record should be the same as the found Protected Customer record
        System.AssertEquals(expected, actualList[0]);
    }
    @isTest
    static void evaluateUpdatedAccountRecords_BlockOrAllow_test18_ProtectedFieldsUpdated_SmallBusinessRMFieldUpdated() {
          //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true);   
        updatedAccountRecord.FirstName = 'Steve';
        updatedAccountRecord.Small_Business_RM__c = '005300000055GHwAAM'; 

         //c. create expected Protected_Customer_Data record        
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Steve', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );

        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => expected };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
              
        //Assert: only record should be the same as the found Protected Customer record
        System.AssertEquals(expected, actualList[0]);
    }
    @isTest
    static void evaluateUpdatedAccountRecords_BlockOrAllow_test19_ProtectedFieldsUpdated_WashingtonCountyBankRMFieldUpdated() {
        //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true);         
        updatedAccountRecord.Washington_County_Bank_RM__c = '005300000055GHwAAM';

         //c. create expected Protected_Customer_Data record        
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Oscar', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );

        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => expected };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
              
        //Assert: only record should be the same as the found Protected Customer record
        System.AssertEquals(expected, actualList[0]);
    }
    @isTest
    static void evaluateUpdatedAccountRecords_BlockOrAllow_test20_ProtectedFieldsUpdated_WashingtonCountyBankRMFieldUpdated() {
        //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true);      
        updatedAccountRecord.FirstName = 'Steve';
        updatedAccountRecord.Washington_County_Bank_RM__c = '005300000055GHwAAM';

         //c. create expected Protected_Customer_Data record        
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Steve', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );

        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => expected };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
              
        //Assert: only record should be the same as the found Protected Customer record
        System.AssertEquals(expected, actualList[0]);
    }
    @isTest
    static void evaluateUpdatedAccountRecords_BlockOrAllow_test21_ProtectedFieldsUpdated_WealthManagementRMFieldUpdated() {
        //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true);         
        updatedAccountRecord.Wealth_Management_RM__c = '005300000055GHwAAM';

         //c. create expected Protected_Customer_Data record        
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Oscar', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );

        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => expected };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
              
        //Assert: only record should be the same as the found Protected Customer record
        System.AssertEquals(expected, actualList[0]);
    }
     @isTest
    static void evaluateUpdatedAccountRecords_BlockOrAllow_test22_ProtectedFieldsUpdated_WealthManagementRMFieldUpdated() {
        //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true);      
        updatedAccountRecord.FirstName = 'Steve';
        updatedAccountRecord.Wealth_Management_RM__c = '005300000055GHwAAM';

         //c. create expected Protected_Customer_Data record        
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Steve', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '2222 Vine Street', 
                        Mailing_City__c = 'Lincoln', 
                        Mailing_State__c = 'NE', 
                        Mailing_Zip__c = '68105', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = 'gaffer', 
                        Employer__c = 'unemployed' 
                    );

        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => expected };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
              
        //Assert: only record should be the same as the found Protected Customer record
        System.AssertEquals(expected, actualList[0]);
    }

    
    @isTest
    static void evaluateUpdatedAccountRecords_BlockedUser_test01_MultipleFieldsUpdated() {
        Account originalRecord = getTestCustomerRecord_LastModifiedByCustSysAdmin();
        Database.SaveResult sr = Database.insert(originalRecord);
        Map<Id, Account> originalAccountsMap = new Map<Id, Account> { originalRecord.Id => originalRecord} ;

        Account updatedRecord = originalRecord.clone(true, false, true, true);
        updatedRecord.Preferred_Name__pc = 'Foghorn R Leghorn';
        updatedRecord.FNB_System_of_record_id__c = 'abc123';

        List<Account> updatedRecords = new List<Account>{ updatedRecord };
       
        //Act
        AccountToProtectedCustomerDataCopier.evaluateUpdatedAccountRecords(updatedRecords, originalAccountsMap);
        //Assert
        Account ActualUpdatedRecord = [SELECT Id, Preferred_Name__pc, FNB_System_of_Record_Id__c FROM Account WHERE Id = :originalRecord.id];
        
        system.assertequals(originalRecord.Preferred_Name__pc, ActualUpdatedRecord.Preferred_Name__pc);
    }

    @isTest
    static void evaluateUpdatedAccountRecords_BlockedUser_test02_MultipleFieldsUpdated() {
        Account originalRecord = getTestCustomerRecord_LastModifiedByCustCarenCino();
        Database.SaveResult sr = Database.insert(originalRecord);
        Map<Id, Account> originalAccountsMap = new Map<Id, Account> { originalRecord.Id => originalRecord} ;

        Account updatedRecord = originalRecord.clone(true, false, true, true);
        updatedRecord.Preferred_Name__pc = 'Foghorn R Leghorn';
        updatedRecord.FNB_System_of_record_id__c = 'abc123';

        List<Account> updatedRecords = new List<Account>{ updatedRecord };
       
        //Act
        AccountToProtectedCustomerDataCopier.evaluateUpdatedAccountRecords(updatedRecords, originalAccountsMap);
        //Assert
        Account ActualUpdatedRecord = [SELECT Id, Preferred_Name__pc, FNB_System_of_Record_Id__c FROM Account WHERE Id = :originalRecord.id];
        
        system.assertequals(originalRecord.Preferred_Name__pc, ActualUpdatedRecord.Preferred_Name__pc);
    }

    @isTest
    static void evaluateUpdatedAccountRecords_BlockedUser_test03_MultipleFieldsUpdated() {
        Account originalRecord = getTestCustomerRecord_LastModifiedByCustCareCloudingo();
        Database.SaveResult sr = Database.insert(originalRecord);
        Map<Id, Account> originalAccountsMap = new Map<Id, Account> { originalRecord.Id => originalRecord} ;

        Account updatedRecord = originalRecord.clone(true, false, true, true);
        updatedRecord.Preferred_Name__pc = 'Foghorn R Leghorn';
        updatedRecord.FNB_System_of_record_id__c = 'abc123';

        List<Account> updatedRecords = new List<Account>{ updatedRecord };
       
        //Act
        AccountToProtectedCustomerDataCopier.evaluateUpdatedAccountRecords(updatedRecords, originalAccountsMap);
        //Assert
        Account ActualUpdatedRecord = [SELECT Id, Preferred_Name__pc, FNB_System_of_Record_Id__c FROM Account WHERE Id = :originalRecord.id];
        
        system.assertequals(originalRecord.Preferred_Name__pc, ActualUpdatedRecord.Preferred_Name__pc);
    }

    @isTest
    static void evaluateUpdatedAccountRecords_BlockedUser_test04_MultipleFieldsUpdated() {
        Account originalRecord = getTestCustomerRecord_LastModifiedBynCinoAdmin();
        Database.SaveResult sr = Database.insert(originalRecord);
        Map<Id, Account> originalAccountsMap = new Map<Id, Account> { originalRecord.Id => originalRecord} ;

        Account updatedRecord = originalRecord.clone(true, false, true, true);
        updatedRecord.Preferred_Name__pc = 'Foghorn R Leghorn';
        updatedRecord.FNB_System_of_record_id__c = 'abc123';

        List<Account> updatedRecords = new List<Account>{ updatedRecord };
       
        //Act
        AccountToProtectedCustomerDataCopier.evaluateUpdatedAccountRecords(updatedRecords, originalAccountsMap);
        //Assert
        Account ActualUpdatedRecord = [SELECT Id, Preferred_Name__pc, FNB_System_of_Record_Id__c FROM Account WHERE Id = :originalRecord.id];
        
        system.assertequals(originalRecord.Preferred_Name__pc, ActualUpdatedRecord.Preferred_Name__pc);
    }
/*
    @isTest
    static void evaluateUpdatedAccountRecords_BlockedUser_test05_MultipleFieldsUpdated() {
        Account originalRecord = getTestCustomerRecord_LastModifiedBynCinoCommUser();
        Database.SaveResult sr = Database.insert(originalRecord);
        Map<Id, Account> originalAccountsMap = new Map<Id, Account> { originalRecord.Id => originalRecord} ;

        Account updatedRecord = originalRecord.clone(true, false, true, true);
        updatedRecord.Preferred_Name__pc = 'Foghorn R Leghorn';
        updatedRecord.FNB_System_of_record_id__c = 'abc123';

        List<Account> updatedRecords = new List<Account>{ updatedRecord };
       
        //Act
        AccountToProtectedCustomerDataCopier.evaluateUpdatedAccountRecords(updatedRecords, originalAccountsMap);
        //Assert
        Account ActualUpdatedRecord = [SELECT Id, Preferred_Name__pc, FNB_System_of_Record_Id__c FROM Account WHERE Id = :originalRecord.id];
        
        system.assertequals(originalRecord.Preferred_Name__pc, ActualUpdatedRecord.Preferred_Name__pc);
    }
*/    
//==== processUpdateRecord() tests ==========================================================================================//
    @isTest
    static void processUpdateRecord_test01_correspondingPCDRecordsMap_containsKey_true() {
        //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
                    
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true);
        updatedAccountRecord.Preferred_Name__pc = 'Mean Green';
        updatedAccountRecord.PersonDoNotCall = true;
        updatedAccountRecord.Do_Not_Mail__c = true;
        updatedAccountRecord.PersonHasOptedOutOfEmail = true;
        updatedAccountRecord.PersonMailingStreet = '123 Sesame Street';
        updatedAccountRecord.PersonMailingCity = 'Brooklyn';
        updatedAccountRecord.PersonMailingState = 'NY';
        updatedAccountRecord.PersonMailingPostalCode = '11111';
        updatedAccountRecord.PersonMailingCountry = 'US';
        updatedAccountRecord.PersonHomePhone = '8775551212';
        updatedAccountRecord.PersonMobilePhone = '8775551234';
        updatedAccountRecord.Work_Phone__pc = '8775559876';
        updatedAccountRecord.PersonEmail = 'oscarTheGrouch@pbs.org';
        updatedAccountRecord.Email_2__pc = 'oscarTheGrouch@gmail.com';
        updatedAccountRecord.Email_3__pc = 'oscarTheGrouch@yahoo.com';
        updatedAccountRecord.Occupation__pc = 'muppet'; 
        updatedAccountRecord.Employer__pc = 'PBS';
        
        //c. create expected Protected_Customer_Data record
        Protected_Customer_Data__c testPcdRecord = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Oscar', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = 'Mean Green', 
                        Do_Not_Call__c = true, 
                        Do_Not_Mail__c = true, 
                        Email_Opt_Out__c = true, 
                        Mailing_Street__c = '123 Sesame Street', 
                        Mailing_City__c = 'Brooklyn', 
                        Mailing_State__c = 'NY', 
                        Mailing_Zip__c = '11111', 
                        Mailing_Country__c = 'US', 
                        Home_Phone__c = '8775551212', 
                        Mobile__c = '8775551234', 
                        Work_Phone__c = '8775559876', 
                        Email__c = 'oscarTheGrouch@pbs.org', 
                        Email_2__c = 'oscarTheGrouch@gmail.com', 
                        Email_3__c = 'oscarTheGrouch@yahoo.com', 
                        Occupation__c = 'muppet', 
                        Employer__c = 'PBS' 
                    );
        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => testPcdRecord };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
        
        //Asert 1: size of List should be one
        System.AssertEquals(1, actualList.size());
        //Assert 2: only record should be the same as the found Protected Customer record
        System.AssertEquals(testPcdRecord, actualList[0]);
    }

    @isTest
    static void processUpdateRecord_test02_correspondingPCDRecordsMap_containsKey_false() {
        //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
                    
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true);
 
        //c. create an empty map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c>();
            
        //d. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
        
        //Asert 1: size of List should be one
        System.AssertEquals(1, actualList.size());
        //Assert 2: only record should have same values as the updatedAccountRecord
        System.AssertEquals(updatedAccountRecord.FirstName, actualList[0].First_Name__c);
    }

//==== updateRequestIncludesAtLeastOneProtectedField() tests ================================================================//
    @isTest
    static void updateRequestIncludesAtLeastOneProtectedField_test01_OneProtectedFieldUpdated() {
        //Note: the following is a list is defined as a static class variable in AccountToProtectedCustomerDataCopier class 
        //      It is shown here for reference
        //List<String> listOfProtectedAccountFields= new List<String> {
        //                        'firstname', 'middlename', 'lastname', 'preferred_name__pc',
        //                        'fnb_system_of_record_id__c', 
        //                        'persondonotcall', 'do_not_mail__c', 'personhasoptedoutofemail',
        //                        'personmailingstreet', 'personmailingcity', 'personmailingstate', 'personmailingpostalcode', 'personmailingcountry',
        //                        'personhomephone', 'personmobilephone', 'work_phone__pc',
        //                        'personemail', 'email_2__pc', 'email_3__pc',
        //                        'occupation__pc', 'employer__pc'
        //                     };
        List<String> listOfUpdatedFields= new List<String> { 'FirstBorn', 'CollegeNickName', 'MiddleName', 'SocialSecurityNumber', 'GMailPassword' };
                    
        boolean expected = true;                     
        boolean actual = AccountToProtectedCustomerDataCopier.updateRequestIncludesAtLeastOneProtectedField(listOfUpdatedFields);

        System.AssertEquals(expected, actual);
    }
    
    @isTest
    static void updateRequestIncludesAtLeastOneProtectedField_test02_MultipleProtectedFieldsUpdated() {
        //Note: the following is a list is defined as a static class variable in processAccountUpdate class 
        //      It is shown here for reference
        //List<String> listOfProtectedAccountFields= new List<String> {
        //                        'firstname', 'middlename', 'lastname', 'preferred_name__pc',
        //                        'fnb_system_of_record_id__c', 
        //                        'persondonotcall', 'do_not_mail__c', 'personhasoptedoutofemail',
        //                        'personmailingstreet', 'personmailingcity', 'personmailingstate', 'personmailingpostalcode', 'personmailingcountry',
        //                        'personhomephone', 'personmobilephone', 'work_phone__pc',
        //                        'personemail', 'email_2__pc', 'email_3__pc',
        //                        'occupation__pc', 'employer__pc'
        //                     };
        List<String> listOfUpdatedFields= new List<String> { 'FirstName', 'CollegeNickName', 'MiddleName', 'SocialSecurityNumber', 'GMailPassword' };
                    
        boolean expected = true;                     
        boolean actual = AccountToProtectedCustomerDataCopier.updateRequestIncludesAtLeastOneProtectedField(listOfUpdatedFields);

        System.AssertEquals(expected, actual);
    }
    
    @isTest
    static void updateRequestIncludesAtLeastOneProtectedField_test03_ZeroProtectedFieldsUpdated() {
        //Note: the following is a list is defined as a static class variable in processAccountUpdate class 
        //      It is shown here for reference
        //List<String> listOfProtectedAccountFields= new List<String> {
        //                        'firstname', 'middlename', 'lastname', 'preferred_name__pc',
        //                        'fnb_system_of_record_id__c', 
        //                        'persondonotcall', 'do_not_mail__c', 'personhasoptedoutofemail',
        //                        'personmailingstreet', 'personmailingcity', 'personmailingstate', 'personmailingpostalcode', 'personmailingcountry',
        //                        'personhomephone', 'personmobilephone', 'work_phone__pc',
        //                        'personemail', 'email_2__pc', 'email_3__pc',
        //                        'occupation__pc', 'employer__pc'
        //                     };
        List<String> listOfUpdatedFields= new List<String> { 'FirstBorn', 'CollegeNickName', 'SirName', 'SocialSecurityNumber', 'GMailPassword' };
                    
        boolean expected = false;                     
        boolean actual = AccountToProtectedCustomerDataCopier.updateRequestIncludesAtLeastOneProtectedField(listOfUpdatedFields);

        System.AssertEquals(expected, actual);
    }

//==== updateProtectedCustomerDataRecord() tests ============================================================================//
    @isTest
    static void updateProtectedCustomerDataRecord_test01_FieldLevelTest() {        
        //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
                    
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true);
        updatedAccountRecord.Preferred_Name__pc = 'Mean Green';
        updatedAccountRecord.PersonDoNotCall = true;
        updatedAccountRecord.Do_Not_Mail__c = true;
        updatedAccountRecord.PersonHasOptedOutOfEmail = true;
        updatedAccountRecord.PersonMailingStreet = '123 Sesame Street';
        updatedAccountRecord.PersonMailingCity = 'Brooklyn';
        updatedAccountRecord.PersonMailingState = 'NY';
        updatedAccountRecord.PersonMailingPostalCode = '11111';
        updatedAccountRecord.PersonMailingCountry = 'US';
        updatedAccountRecord.PersonHomePhone = '8775551212';
        updatedAccountRecord.PersonMobilePhone = '8775551234';
        updatedAccountRecord.Work_Phone__pc = '8775559876';
        updatedAccountRecord.PersonEmail = 'oscarTheGrouch@pbs.org';
        updatedAccountRecord.Email_2__pc = 'oscarTheGrouch@gmail.com';
        updatedAccountRecord.Email_3__pc = 'oscarTheGrouch@yahoo.com';
        updatedAccountRecord.Occupation__pc = 'muppet'; 
        updatedAccountRecord.Employer__pc = 'PBS';
        
        //c. create expected Protected_Customer_Data record
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Oscar', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = 'Mean Green', 
                        Do_Not_Call__c = true, 
                        Do_Not_Mail__c = true, 
                        Email_Opt_Out__c = true, 
                        Mailing_Street__c = '123 Sesame Street', 
                        Mailing_City__c = 'Brooklyn', 
                        Mailing_State__c = 'NY', 
                        Mailing_Zip__c = '11111', 
                        Mailing_Country__c = 'US', 
                        Home_Phone__c = '8775551212', 
                        Mobile__c = '8775551234', 
                        Work_Phone__c = '8775559876', 
                        Email__c = 'oscarTheGrouch@pbs.org', 
                        Email_2__c = 'oscarTheGrouch@gmail.com', 
                        Email_3__c = 'oscarTheGrouch@yahoo.com', 
                        Occupation__c = 'muppet', 
                        Employer__c = 'PBS' 
                    );

        //d. The existing Protected_Customer_Data record will already have the Parent_Id__c set.
        //  I'm setting the Parent_Id__c and Fnb_System_of_Record_Id in the constructor to simulate the existing PCD record
        Protected_Customer_Data__c actual = new Protected_Customer_Data__c(Parent_Id__c = updatedAccountRecord.Id, Fnb_System_Of_Record_Id__c = 'abc123');
        
        AccountToProtectedCustomerDataCopier.updateProtectedCustomerDataRecord(actual, updatedAccountRecord);
    
        //Test outcome
        System.AssertEquals(expected.Parent_Id__c, actual.Parent_Id__c, 'Parent_Id__c failed');
        System.AssertEquals(expected.FNB_System_of_Record_Id__c, actual.FNB_System_of_Record_Id__c, 'FNB_System_of_Record_Id__c failed');
        System.AssertEquals(expected.First_Name__c, actual.First_Name__c, 'First_Name__c failed');
        System.AssertEquals(expected.Middle_Name__c, actual.Middle_Name__c, 'Middle_Name__c failed');
        System.AssertEquals(expected.Last_Name__c, actual.Last_Name__c, 'Last_Name__c failed');
        System.AssertEquals(expected.Preferred_Name__c, actual.Preferred_Name__c, 'Preferred_Name__cfailed');
        System.AssertEquals(expected.Do_Not_Call__c, actual.Do_Not_Call__c, 'Do_Not_Call__cfailed');
        System.AssertEquals(expected.Do_Not_Mail__c, actual.Do_Not_Mail__c, 'Do_Not_Mail__cfailed');
        System.AssertEquals(expected.Email_Opt_Out__c, actual.Email_Opt_Out__c, 'Email_Opt_Out__cfailed');
        System.AssertEquals(expected.Mailing_Street__c, actual.Mailing_Street__c, 'Mailing_Street__cfailed');
        System.AssertEquals(expected.Mailing_City__c, actual.Mailing_City__c, 'Mailing_City__cfailed');
        System.AssertEquals(expected.Mailing_State__c, actual.Mailing_State__c, 'Mailing_State__cfailed');
        System.AssertEquals(expected.Mailing_Zip__c, actual.Mailing_Zip__c, 'Mailing_Zip__cfailed');
        System.AssertEquals(expected.Mailing_Country__c, actual.Mailing_Country__c, 'Mailing_Country__cfailed');
        System.AssertEquals(expected.Home_Phone__c, actual.Home_Phone__c, 'Home_Phone__cfailed');
        System.AssertEquals(expected.Mobile__c, actual.Mobile__c, 'Mobile__c failed');
        System.AssertEquals(expected.Work_Phone__c, actual.Work_Phone__c, 'Work_Phone__cfailed');
        System.AssertEquals(expected.Email__c, actual.Email__c, 'Email__c failed');
        System.AssertEquals(expected.Email_2__c, actual.Email_2__c, 'Email_2__c failed');
        System.AssertEquals(expected.Email_3__c, actual.Email_3__c, 'Email_3__c failed');
        System.AssertEquals(expected.Occupation__c, actual.Occupation__c, 'Occupation__c failed');
        System.AssertEquals(expected.Employer__c, actual.Employer__c, 'Employer__c failed');
    }

    @isTest
    static void updateProtectedCustomerDataRecord_test02_sObjectLevelTest() {
        //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
                    
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true);
        updatedAccountRecord.Preferred_Name__pc = 'Mean Green';
        updatedAccountRecord.PersonDoNotCall = true;
        updatedAccountRecord.Do_Not_Mail__c = true;
        updatedAccountRecord.PersonHasOptedOutOfEmail = true;
        updatedAccountRecord.PersonMailingStreet = '123 Sesame Street';
        updatedAccountRecord.PersonMailingCity = 'Brooklyn';
        updatedAccountRecord.PersonMailingState = 'NY';
        updatedAccountRecord.PersonMailingPostalCode = '11111';
        updatedAccountRecord.PersonMailingCountry = 'US';
        updatedAccountRecord.PersonHomePhone = '8775551212';
        updatedAccountRecord.PersonMobilePhone = '8775551234';
        updatedAccountRecord.Work_Phone__pc = '8775559876';
        updatedAccountRecord.PersonEmail = 'oscarTheGrouch@pbs.org';
        updatedAccountRecord.Email_2__pc = 'oscarTheGrouch@gmail.com';
        updatedAccountRecord.Email_3__pc = 'oscarTheGrouch@yahoo.com';
        updatedAccountRecord.Occupation__pc = 'muppet'; 
        updatedAccountRecord.Employer__pc = 'PBS';
        
        //c. create expected Protected_Customer_Data record
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Oscar', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = 'Mean Green', 
                        Do_Not_Call__c = true, 
                        Do_Not_Mail__c = true, 
                        Email_Opt_Out__c = true, 
                        Mailing_Street__c = '123 Sesame Street', 
                        Mailing_City__c = 'Brooklyn', 
                        Mailing_State__c = 'NY', 
                        Mailing_Zip__c = '11111', 
                        Mailing_Country__c = 'US', 
                        Home_Phone__c = '8775551212', 
                        Mobile__c = '8775551234', 
                        Work_Phone__c = '8775559876', 
                        Email__c = 'oscarTheGrouch@pbs.org', 
                        Email_2__c = 'oscarTheGrouch@gmail.com', 
                        Email_3__c = 'oscarTheGrouch@yahoo.com', 
                        Occupation__c = 'muppet', 
                        Employer__c = 'PBS',
                        Business_Name__c=null,
                        Business_Phone__c=null,
                        Business_Fax__c=null,
                        Business_Billing_Street__c=null,
                        Business_Billing_City__c=null,
                        Business_Billing_State__c=null,
                        Business_Billing_PostalCode__c=null,
                        Business_Billing_Country__c=null,
                        Business_DBA_Name__c=null,
                        Business_Do_Not_Mail__c=true
                    );

        //d. The existing Protected_Customer_Data record will already have the Parent_Id__c set.
        //  I'm setting the Parent_Id__c and Fnb_System_of_Record_Id in the constructor to simulate the existing PCD record
        Protected_Customer_Data__c actual = new Protected_Customer_Data__c(Parent_Id__c = updatedAccountRecord.Id, Fnb_System_Of_Record_Id__c = 'abc123');
        
        AccountToProtectedCustomerDataCopier.updateProtectedCustomerDataRecord(actual, updatedAccountRecord);
        
        //Test outcome        
        System.AssertEquals(expected, actual);  
    } 

    @isTest
    static void updateProtectedCustomerDataRecord_test03_sObjectLevelTest_updateHomePhoneNumberFieldtoBlanks() {
        //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        Map<Id, Account> originalAccountsMap = new Map<Id, Account> { originalRecord.Id => originalRecord} ;
                    
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true);
        updatedAccountRecord.Preferred_Name__pc = 'Mean Green';
        updatedAccountRecord.PersonDoNotCall = true;
        updatedAccountRecord.Do_Not_Mail__c = true;
        updatedAccountRecord.PersonHasOptedOutOfEmail = true;
        updatedAccountRecord.PersonMailingStreet = '123 Sesame Street';
        updatedAccountRecord.PersonMailingCity = 'Brooklyn';
        updatedAccountRecord.PersonMailingState = 'NY';
        updatedAccountRecord.PersonMailingPostalCode = '11111';
        updatedAccountRecord.PersonMailingCountry = 'US';
        updatedAccountRecord.PersonHomePhone = '';
        updatedAccountRecord.PersonMobilePhone = '8775551234';
        updatedAccountRecord.Work_Phone__pc = '8775559876';
        updatedAccountRecord.PersonEmail = 'oscarTheGrouch@pbs.org';
        updatedAccountRecord.Email_2__pc = 'oscarTheGrouch@gmail.com';
        updatedAccountRecord.Email_3__pc = 'oscarTheGrouch@yahoo.com';
        updatedAccountRecord.Occupation__pc = 'muppet'; 
        updatedAccountRecord.Employer__pc = 'PBS';
        
        //c. create expected Protected_Customer_Data record
        Protected_Customer_Data__c existingPCD = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Oscar', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = 'Mean Green', 
                        Do_Not_Call__c = true, 
                        Do_Not_Mail__c = true, 
                        Email_Opt_Out__c = true, 
                        Mailing_Street__c = '123 Sesame Street', 
                        Mailing_City__c = 'Brooklyn', 
                        Mailing_State__c = 'NY', 
                        Mailing_Zip__c = '11111', 
                        Mailing_Country__c = 'US', 
                        Home_Phone__c = '8775551212', 
                        Mobile__c = '8775551234', 
                        Work_Phone__c = '8775559876', 
                        Email__c = 'oscarTheGrouch@pbs.org', 
                        Email_2__c = 'oscarTheGrouch@gmail.com', 
                        Email_3__c = 'oscarTheGrouch@yahoo.com', 
                        Occupation__c = 'muppet', 
                        Employer__c = 'PBS',
                        Business_Do_Not_Mail__c = true
                    );

        Database.insert(existingPCD);
        //d. The existing Protected_Customer_Data record will already have the Parent_Id__c set.
        List<Account> updatedRecords = new List<Account>{ updatedAccountRecord};        
        AccountToProtectedCustomerDataCopier.evaluateUpdatedAccountRecords(updatedRecords, originalAccountsMap);
        string expected = null;                   

        Protected_Customer_Data__c phone_num_check = [select id, Home_Phone__c from Protected_Customer_Data__c where parent_id__c = :updatedAccountRecord.Id limit 1];
        string actual = phone_num_check.Home_Phone__c;
        //Test outcome
        System.AssertEquals(expected, actual);  
    } 

//==== createNewProtectedCustomerDataRecord() tests =========================================================================//
    @isTest
    static void createNewProtectedCustomerDataRecord_test01_FieldLevelTest() {
        //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true);
        updatedAccountRecord.Preferred_Name__pc = 'Mean Green';
        updatedAccountRecord.PersonDoNotCall = true;
        updatedAccountRecord.Do_Not_Mail__c = true;
        updatedAccountRecord.PersonHasOptedOutOfEmail = true;
        updatedAccountRecord.PersonMailingStreet = '123 Sesame Street';
        updatedAccountRecord.PersonMailingCity = 'Brooklyn';
        updatedAccountRecord.PersonMailingState = 'NY';
        updatedAccountRecord.PersonMailingPostalCode = '11111';
        updatedAccountRecord.PersonMailingCountry = 'US';
        updatedAccountRecord.PersonHomePhone = '8775551212';
        updatedAccountRecord.PersonMobilePhone = '8775551234';
        updatedAccountRecord.Work_Phone__pc = '8775559876';
        updatedAccountRecord.PersonEmail = 'oscarTheGrouch@pbs.org';
        updatedAccountRecord.Email_2__pc = 'oscarTheGrouch@gmail.com';
        updatedAccountRecord.Email_3__pc = 'oscarTheGrouch@yahoo.com';
        updatedAccountRecord.Occupation__pc = 'muppet'; 
        updatedAccountRecord.Employer__pc = 'PBS';
        
        //c. create expected Protected_Customer_Data record
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Oscar', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = 'Mean Green', 
                        Do_Not_Call__c = true, 
                        Do_Not_Mail__c = true, 
                        Email_Opt_Out__c = true, 
                        Mailing_Street__c = '123 Sesame Street', 
                        Mailing_City__c = 'Brooklyn', 
                        Mailing_State__c = 'NY', 
                        Mailing_Zip__c = '11111', 
                        Mailing_Country__c = 'US', 
                        Home_Phone__c = '8775551212', 
                        Mobile__c = '8775551234', 
                        Work_Phone__c = '8775559876', 
                        Email__c = 'oscarTheGrouch@pbs.org', 
                        Email_2__c = 'oscarTheGrouch@gmail.com', 
                        Email_3__c = 'oscarTheGrouch@yahoo.com', 
                        Occupation__c = 'muppet', 
                        Employer__c = 'PBS' 
                    );
                    
        //d. run test
        Protected_Customer_Data__c actual = AccountToProtectedCustomerDataCopier.createNewProtectedCustomerDataRecord(updatedAccountRecord);
    
        //e. compare outcome
        System.AssertEquals(expected.Parent_Id__c, actual.Parent_Id__c, 'Parent_Id__c failed');
        System.AssertEquals(expected.FNB_System_of_Record_Id__c, actual.FNB_System_of_Record_Id__c, 'FNB_System_of_Record_Id__c failed');
        System.AssertEquals(expected.First_Name__c, actual.First_Name__c, 'First_Name__c failed');
        System.AssertEquals(expected.Middle_Name__c, actual.Middle_Name__c, 'Middle_Name__c failed');
        System.AssertEquals(expected.Last_Name__c, actual.Last_Name__c, 'Last_Name__c failed');
        System.AssertEquals(expected.Preferred_Name__c, actual.Preferred_Name__c, 'Preferred_Name__c failed');
        System.AssertEquals(expected.Do_Not_Call__c, actual.Do_Not_Call__c, 'Do_Not_Call__c failed');
        System.AssertEquals(expected.Do_Not_Mail__c, actual.Do_Not_Mail__c, 'Do_Not_Mail__c failed');
        System.AssertEquals(expected.Email_Opt_Out__c, actual.Email_Opt_Out__c, 'Email_Opt_Out__c failed');
        System.AssertEquals(expected.Mailing_Street__c, actual.Mailing_Street__c, 'Mailing_Street__c failed');
        System.AssertEquals(expected.Mailing_City__c, actual.Mailing_City__c, 'Mailing_City__c failed');
        System.AssertEquals(expected.Mailing_State__c, actual.Mailing_State__c, 'Mailing_State__c failed');
        System.AssertEquals(expected.Mailing_Zip__c, actual.Mailing_Zip__c, 'Mailing_Zip__c failed');
        System.AssertEquals(expected.Mailing_Country__c, actual.Mailing_Country__c, 'Mailing_Country__c failed');
        System.AssertEquals(expected.Home_Phone__c, actual.Home_Phone__c, 'Home_Phone__c failed');
        System.AssertEquals(expected.Mobile__c, actual.Mobile__c, 'Mobile__c failed');
        System.AssertEquals(expected.Work_Phone__c, actual.Work_Phone__c, 'Work_Phone__c failed');
        System.AssertEquals(expected.Email__c, actual.Email__c, 'Email__c failed');
        System.AssertEquals(expected.Email_2__c, actual.Email_2__c, 'Email_2__c failed');
        System.AssertEquals(expected.Email_3__c, actual.Email_3__c, 'Email_3__c failed');
        System.AssertEquals(expected.Occupation__c, actual.Occupation__c, 'Occupation__c failed');
        System.AssertEquals(expected.Employer__c, actual.Employer__c, 'Employer__c failed');
    }

    @isTest
    static void createNewProtectedCustomerDataRecord_test02_sObjectLevelTest() {
        //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true);
        updatedAccountRecord.Preferred_Name__pc = 'Mean Green';
        updatedAccountRecord.PersonDoNotCall = true;
        updatedAccountRecord.Do_Not_Mail__c = true;
        updatedAccountRecord.PersonHasOptedOutOfEmail = true;
        updatedAccountRecord.PersonMailingStreet = '123 Sesame Street';
        updatedAccountRecord.PersonMailingCity = 'Brooklyn';
        updatedAccountRecord.PersonMailingState = 'NY';
        updatedAccountRecord.PersonMailingPostalCode = '11111';
        updatedAccountRecord.PersonMailingCountry = 'US';
        updatedAccountRecord.PersonHomePhone = '8775551212';
        updatedAccountRecord.PersonMobilePhone = '8775551213';
        updatedAccountRecord.Work_Phone__pc = '8775559876';
        updatedAccountRecord.PersonEmail = 'oscarTheGrouch@pbs.org';
        updatedAccountRecord.Email_2__pc = 'oscarTheGrouch@gmail.com';
        updatedAccountRecord.Email_3__pc = 'oscarTheGrouch@yahoo.com';
        updatedAccountRecord.Occupation__pc = 'muppet'; 
        updatedAccountRecord.Employer__pc = 'PBS';
        
        //c. create expected Protected_Customer_Data record
        Protected_Customer_Data__c expected = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Oscar', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = 'Mean Green', 
                        Do_Not_Call__c = true, 
                        Do_Not_Mail__c = true, 
                        Email_Opt_Out__c = true, 
                        Mailing_Street__c = '123 Sesame Street', 
                        Mailing_City__c = 'Brooklyn', 
                        Mailing_State__c = 'NY', 
                        Mailing_Zip__c = '11111', 
                        Mailing_Country__c = 'US', 
                        Home_Phone__c = '8775551212', 
                        Mobile__c = '8775551213', 
                        Work_Phone__c = '8775559876', 
                        Email__c = 'oscarTheGrouch@pbs.org', 
                        Email_2__c = 'oscarTheGrouch@gmail.com', 
                        Email_3__c = 'oscarTheGrouch@yahoo.com', 
                        Occupation__c = 'muppet', 
                        Employer__c = 'PBS',
                        Business_Name__c=null, 
                        Business_Phone__c=null, 
                        Business_Fax__c=null, 
                        Business_Billing_Street__c=null, 
                        Business_Billing_City__c=null, 
                        Business_Billing_State__c=null, 
                        Business_Billing_PostalCode__c=null,
                        Business_Billing_Country__c=null,
                        Business_DBA_Name__c=null                    
                        );            
        //d. run test
        Protected_Customer_Data__c actual = AccountToProtectedCustomerDataCopier.createNewProtectedCustomerDataRecord(updatedAccountRecord);
        
        //e. compare outcome
        System.AssertEquals(expected, actual);
    }

//==== upsertProtectedCustomerData() tests =================================================================================//
    @isTest
    static void upsertProtectedCustomerData_test01_goodCommit() {
        //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getTestCustomer1AccountRecord();
        Database.insert(originalRecord);
        
        //b. build a List of Protected Customer records to be upserted 
        Protected_Customer_Data__c newPcdRecord = new Protected_Customer_Data__c(
                        Parent_Id__c = originalRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = 'Oscar', 
                        Middle_Name__c = 'The', 
                        Last_Name__c = 'Grouch', 
                        Preferred_Name__c = 'Mean Green' 
                    );
        List<Protected_Customer_Data__c> recordsToBeUpserted = new List<Protected_Customer_Data__c> { newPcdRecord };

        //c. run test
        Database.UpsertResult[] actual = AccountToProtectedCustomerDataCopier.upsertProtectedCustomerData(recordsToBeUpserted);
        
        //d. compare outcome
        for(Database.UpsertResult sr : actual) {
            System.assert(sr.isSuccess());
        }
    }

//==== processUpdateRecord() tests ==========================================================================================//
    @isTest
    static void processUpdateRecord_test01_business_correspondingPCDRecordsMap_containsKey_true() {
        //a. create an Account record; commit it to the sObject so we have an Account.Id
        Account originalRecord = getBusinessCustomer1AccountRecord();
        Database.insert(originalRecord);
                    
        //b. clone the original Account; update values
        Account updatedAccountRecord = originalRecord.clone(true, false, true, true);
        updatedAccountRecord.billingstreet = '243 E Greenbriar Ln';
        
        //c. create expected Protected_Customer_Data record
        Protected_Customer_Data__c testPcdRecord = new Protected_Customer_Data__c(
                        Parent_Id__c = updatedAccountRecord.Id,
                        FNB_System_of_Record_Id__c = 'abc123',        
                        First_Name__c = '', 
                        Middle_Name__c = '', 
                        Last_Name__c = '', 
                        Preferred_Name__c = '', 
                        Do_Not_Call__c = false, 
                        Do_Not_Mail__c = false, 
                        Email_Opt_Out__c = false, 
                        Mailing_Street__c = '', 
                        Mailing_City__c = '', 
                        Mailing_State__c = '', 
                        Mailing_Zip__c = '', 
                        Mailing_Country__c = '', 
                        Home_Phone__c = '', 
                        Mobile__c = '', 
                        Work_Phone__c = '', 
                        Email__c = '', 
                        Email_2__c = '', 
                        Email_3__c = '', 
                        Occupation__c = '', 
                        Employer__c = '',
                        Business_Name__c='Acme Inc', 
                        Business_Phone__c='2125551212', 
                        Business_Fax__c='2125551234', 
                        Business_Billing_Street__c='42 W Rodeo Drive', 
                        Business_Billing_City__c='Alemeda', 
                        Business_Billing_State__c='CA', 
                        Business_Billing_PostalCode__c='95912', 
                        Business_DBA_Name__c='Dyn O Myte Inc'                         
                    );
        //d. create a map of Protected Customer records
        Map<Id, Protected_Customer_Data__c> correspondingPcdRecordsMap = new Map<Id, Protected_Customer_Data__c> {updatedAccountRecord.Id => testPcdRecord };
            
        //e. create List to hold updates from method
        List<Protected_Customer_Data__c> actualList = new List<Protected_Customer_Data__c>();
        
        //ACT
        AccountToProtectedCustomerDataCopier.processUpdateRecord(correspondingPcdRecordsMap, updatedAccountRecord, actualList);
        
        //Asert 1: size of List should be one
        System.AssertEquals(1, actualList.size());
        //Assert 2: only record should be the same as the found Protected Customer record
        System.AssertEquals(testPcdRecord, actualList[0]);
    }

        
//ToDo: write tests for: public static void processUpsertResults(Database.UpsertResult[] upsertResults)

//==== UTILITY METHODS FOR TESTING ==========================================================================================//
    private static Account getTestCustomer1AccountRecord() {
        String acctJsonString = '{"attributes":{"type":"Account",'
                              + '"url":"/services/data/v43.0/sobjects/Account/0010c00001qsquDAAQ"},'
                              + '"LastModifiedById":"00530000005dqfhAAA",'                    //User=Barry Gideon
                              + '"FNB_System_of_record_id__c":"abc123",'
                              + '"FirstName":"Oscar",'
                              + '"MiddleName":"The",'
                              + '"LastName":"Grouch",'
                              + '"Preferred_Name__pc":"",'
                              + '"PersonDoNotCall":"false",'
                              + '"Do_Not_Mail__c":"false",'
                              + '"PersonHasOptedOutOfEmail":"false",'
                              + '"PersonMailingStreet":"2222 Vine Street",'
                              + '"PersonMailingCity":"Lincoln",'
                              + '"PersonMailingState":"NE",'
                              + '"PersonMailingPostalCode":"68105",'
                              + '"PersonMailingcountry":"",'
                              + '"PersonHomePhone":"8775551212",'
                              + '"PersonMobilePhone":"8775551213",'
                              + '"Work_Phone__pc":"",'
                              + '"PersonEmail":"oscarTheGrouch@gmail.com",'
                              + '"Email_2__pc":"",'
                              + '"Email_3__pc":"",'
                              + '"Occupation__pc":"gaffer",'
                              + '"Employer__pc":"unemployed",'
                              + '"Commercial_Card_RM__c":"",'
                              + '"Commercial_Lending_RM__c":"",'
                              + '"CTS_Officer__c":"",'
                              + '"First_Bankcard_Affinity_RM__c":"",'
                              + '"Global_Banking_Officer__c":"",'
                              + '"Mortgage_LO__c":"",'
                              + '"NEST_Advisor__c":"",'
                              + '"Retail_Banker__c":"",'
                              + '"Small_Business_RM__c":"",'                             
                              + '"Washington_County_Bank_RM__c":""}';
        return (Account)Json.deserialize(acctJsonString, Account.class);
    }
    
    private static Protected_Customer_Data__c getTestCustomer1ProtectedCustomerDataRecord() {
        return new Protected_Customer_Data__c(
                        Parent_Id__c = '',
                        FNB_System_of_Record_Id__c = 'abc123',
                        First_Name__c = 'Oscar',
                        Middle_Name__c = 'The',
                        Last_Name__c = 'Grouch',
                        Preferred_Name__c = '',
                        Do_Not_Call__c = false,
                        Do_Not_Mail__c = false,
                        Email_Opt_Out__c = false,
                        Mailing_Street__c = '2222 Vine Street',
                        Mailing_City__c = 'Lincoln',
                        Mailing_State__c = 'NE',
                        Mailing_Zip__c = '68105',
                        Mailing_Country__c = '',
                        Home_Phone__c = '',
                        Mobile__c = '',
                        Work_Phone__c = '',
                        Email__c = 'oscarTheGrouch@gmail.com',
                        Email_2__c = '',
                        Email_3__c = '',
                        Occupation__c = 'gaffer',
                        Employer__c = 'unemployed',
                        Business_Do_Not_Mail__c = false
                    );
    }
    
    private static Account getTestCustomerRecord_LastModifiedBySvcAccount() {
        String acctJsonString= '{"attributes":{"type":"Account",'
                              + '"url":"/services/data/v43.0/sobjects/Account/0010c00001qsquDAAQ"},'
                              + '"LastModifiedById":"005a000000COYqXAAX",'                    //Service Account
                       //     + '"FNB_System_of_record_id__c":"",'
                              + '"FirstName":"Donald",'
                              + '"MiddleName":"",'
                              + '"LastName":"Duck",'
                              + '"Preferred_Name__pc":""}';
        return (Account)Json.deserialize(acctJsonString, Account.class);
    }
    
    private static Account getTestCustomerRecord_LastModifiedByCustSysAdmin() {
        String acctJsonString= '{"attributes":{"type":"Account",'
                              + '"url":"/services/data/v43.0/sobjects/Account/0010c00001qsquDAAQ"},'
                              + '"LastModifiedById":"005a000000DDEz1AAH",'                    //User: Richard Philson
                              + '"FNB_System_of_record_id__c":"Squid123",'
                              + '"FirstName":"Donald",'
                              + '"MiddleName":"",'
                              + '"LastName":"Duck",'
                              + '"Preferred_Name__pc":"Oh Yeah??"}';
        return (Account)Json.deserialize(acctJsonString, Account.class);
    }    

    private static Account getTestCustomerRecord_LastModifiedByCustCarenCino() {
        String acctJsonString= '{"attributes":{"type":"Account",'
                              + '"url":"/services/data/v43.0/sobjects/Account/0010c00001qsquDAAQ"},'
                              + '"LastModifiedById":"0050c00000DbkF3AAJ",'                    //User: Randi Adams
                       //     + '"FNB_System_of_record_id__c":"",'
                              + '"FirstName":"Donald",'
                              + '"MiddleName":"",'
                              + '"LastName":"Duck",'
                              + '"Preferred_Name__pc":"Oh Yeah??"}';
        return (Account)Json.deserialize(acctJsonString, Account.class);
    }    

    private static Account getTestCustomerRecord_LastModifiedByCustCareCloudingo() {
        String acctJsonString= '{"attributes":{"type":"Account",'
                              + '"url":"/services/data/v43.0/sobjects/Account/0010c00001qsquDAAQ"},'
                              + '"LastModifiedById":"0050c00000Dba1GAAR",'                    //User: Jordan Roy
                       //     + '"FNB_System_of_record_id__c":"",'
                              + '"FirstName":"Donald",'
                              + '"MiddleName":"",'
                              + '"LastName":"Duck",'
                              + '"Preferred_Name__pc":"Oh Yeah??"}';
        return (Account)Json.deserialize(acctJsonString, Account.class);
    }    

    private static Account getTestCustomerRecord_LastModifiedBynCinoAdmin() {
        String acctJsonString= '{"attributes":{"type":"Account",'
                              + '"url":"/services/data/v43.0/sobjects/Account/0010c00001qsquDAAQ"},'
                              + '"LastModifiedById":"0050c00000DberzAAB",'                    //User: Tyler Cooper
                       //     + '"FNB_System_of_record_id__c":"",'
                              + '"FirstName":"Donald",'
                              + '"MiddleName":"",'
                              + '"LastName":"Duck",'
                              + '"Preferred_Name__pc":"Oh Yeah??"}';
        return (Account)Json.deserialize(acctJsonString, Account.class);
    }    
    
    private static Account getBusinessCustomer1AccountRecord() {
        String acctJsonString = '{"attributes":{"type":"Account",'
                              + '"url":"/services/data/v43.0/sobjects/Account/0010c00001qsquDAAQ"},'
                              + '"LastModifiedById":"005a000000DDEz1AAH",'                    //User: Richard Philson
                              + '"FNB_System_of_record_id__c":"abc123",'
                              + '"RecordTypeID":"0120c000001ltuSAAQ",'
                              + '"Do_Not_Mail__c":"false",'
                              + '"Name":"Foghorn Leghorn",'
                              + '"BillingStreet":"74 E Canyon Hwy",'
                              + '"BillingCity":"Alemeda",'
                              + '"BillingState":"CA",'
                              + '"BillingPostalCode":"94912",'
                              + '"Phone":"2125551212",'
                              + '"Fax":"2125551213",'
                              + '"DBA_Name__c":"Dyn O Myte Inc"}';
        return (Account)Json.deserialize(acctJsonString, Account.class);
    }
}