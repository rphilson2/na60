@isTest
public class PrecisionLenderShowFieldControllerTest {
	 @testSetup static void setup() {
        // insert Custome Setting object TriggerSupport__c since there is no data from the test method.
        TriggerSupport__c trgsup = new TriggerSupport__c();      
        trgsup.Name = 'Account';
        trgsup.TriggerIsDisabled__c = True;             
        insert trgsup;     
         
        // Create common test accounts
        List<PrecisionLenderShowField__C> testPL = new List<PrecisionLenderShowField__C>();
        for(Integer i=0;i<1;i++) {
            testPL.add(new PrecisionLenderShowField__C(Average_Assets__c = true, Current_Deposit_Balance__c=true));
        }
        insert testPL;  
         
        List<Account> PLFieldValues = new List<Account>();
         for(Integer i=0;i<1;i++) {
            PLFieldValues.add(new Account(LastName='Test12345', PLNDR__FS_Loan_Average_Balance__c=100, PLNDR__FS_Average_Assets__c=150, PLNDR__Current_Deposit_Balance__c=300));
        }
        insert PLFieldValues;       
           
    }

    @isTest static void testSetup() {
        List<PrecisionLenderShowField__C> Setup = PrecisionLenderShowFieldController.getPLSetup();
        
        System.assertEquals(true, Setup[0].Average_Assets__c);
        System.assertEquals(true, Setup[0].Current_Deposit_Balance__c);
    }
    
     @isTest static void testFieldValues() {
        List<Account> acct = [SELECT ID FROM Account WHERE LastName='Test12345'];
        List<Account> PLFieldValue = PrecisionLenderShowFieldController.getFieldValues(acct[0].ID);
        
        System.assertEquals(100, PLFieldValue[0].PLNDR__FS_Loan_Average_Balance__c);
        System.assertEquals(150, PLFieldValue[0].PLNDR__FS_Average_Assets__c);
        System.assertEquals(300, PLFieldValue[0].PLNDR__Current_Deposit_Balance__c);
    }

}