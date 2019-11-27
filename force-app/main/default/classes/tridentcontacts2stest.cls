@istest
public class tridentcontacts2stest {
    static testmethod void tridentcontact(){
    
    Contact trident1 = new Contact(
    lastname = 'trident1', recordtypeid = '012a0000001ZVUv');
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