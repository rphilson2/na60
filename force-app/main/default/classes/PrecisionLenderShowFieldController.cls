public class PrecisionLenderShowFieldController {	   
    @AuraEnabled
    public static List<Account> getFieldValues(Id acctId)
    {
        List<Account> PLFieldValues = [SELECT PLNDR__FS_Loan_Average_Balance__c,
            PLNDR__FS_Average_Assets__c,
            PLNDR__Total_Loan_Commitment__c,
            PLNDR__Current_Deposit_Balance__c,
            PLNDR__Current_Loan_Balance__c,
            PLNDR__FTPFS_Net_Income__c,
            PLNDR__FTPFS_ROA__c,
            PLNDR__FTPFS_ROE__c,
            PLNDR__FTPFS_Target_ROE__c,
            PLNDR__FTPFS_Interest_Income__c,
            PLNDR__FTPFS_Interest_Expense__c,
            PLNDR__Total_relationship_FTP_Net_Income__c,
            PLNDR__Total_Relationship_FTP_ROA__c,
            PLNDR__Total_Relationship_FTP_ROE__c,
            PLNDR__Total_Relationship_FTP_Target_ROE__c FROM Account WHERE Id = :acctId];
        return PLFieldValues;
    }
    
    @AuraEnabled
    public static List<PrecisionLenderShowField__C> getPLSetup()
    {
        List<PrecisionLenderShowField__C> Setup = [SELECT Average_Assets__c, Current_Deposit_Balance__c, Current_Loan_Balance__c, FTP_Interest_Expense__c,
                                                  FTP_Interest_Income__c, FTP_Net_Income__c, FTP_ROA__c, FTP_ROE__c, FTP_Target_ROE__c, Loan_Average_Balance__c,
                                                  Total_Loan_Commitment__c, Total_Relationship_FTP_Net_Income__c, Total_Relationship_FTP_ROA__c,
                                                  Total_Relationship_FTP_ROE__c, Total_Relationship_FTP_Target_ROE__c FROM PrecisionLenderShowField__C];
        return Setup;
    }
    
}