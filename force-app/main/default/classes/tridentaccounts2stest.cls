@istest
public class tridentaccounts2stest {
    static testmethod void tridentaccount(){
    
    Account trident1 = new Account(
    name = 'trident1', recordtypeid = '012a0000001ZVU7');
    insert trident1;
    
   
    PartnerNetworkRecordConnection isotrident = 
    new PartnerNetworkRecordConnection();
    
    isotrident.ConnectionId = '04Pa00000000j8c';
    isotrident.LocalRecordId = trident1.id;  
    isotrident.SendClosedTasks = false;
    isotrident.SendOpenTasks = false;
    isotrident.SendEmails = false;   
    insert isotrident; 
    
    
}}