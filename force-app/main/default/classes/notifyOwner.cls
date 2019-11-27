// Author: Alexander Nourbakhsh
// Date Created/Modified: 10.19.2016
// Project: Account Ownership Change
//

public without sharing class notifyOwner {
    
    public static void qualifyRecords(List<Account> newAccts, Map<Id,Account> oldAcctsMap) {
	
        // Get context user info
        String contextUser = userInfo.getUserId();
        String contextProfile = userInfo.getProfileId();
        String contextEmail = userInfo.getUserEmail();
        String contextName = userInfo.getName();
       
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        List<String> profileNames = new List<String> {'System Administrator','Integration User'};
        Set<String> profileIdSet = new Set<String>();
        List<Id> newOwnerId = new List<Id>();
        List<Id> oldOwnerId = new List<Id>();
        Map<Id,String> newOwner = new Map<Id,String>();
        Map<Id,String> oldOwner = new Map<Id,String>();
        Map<Id,String> oldOwnerEmail = new Map<Id,String>();
        
        for(Account acct : newAccts) {
            newOwnerId.add(acct.ownerId);
        }
        
        for(Account acct : newAccts) {
            Account oldAcct = null;
            oldAcct = oldAcctsMap.get(acct.id);
            oldOwnerId.add(oldAcct.OwnerId);
        }
        
        for(User usr : [SELECT Id, name
                        FROM User
                        WHERE Id =: newOwnerId]) {
			newOwner.put(usr.id, usr.name);
                        }
        
		for(User usr : [SELECT Id, name, email
                        FROM User
                        WHERE Id =: oldOwnerId]) {
			oldOwner.put(usr.id, usr.name);
            oldOwnerEmail.put(usr.id, usr.Email);
                        }
		
        // Populate set, maps and vars
        for(Profile pro : [SELECT Id
                      		 FROM Profile
                      		 WHERE Name =: profileNames
             				 LIMIT 2]){
				profileIdSet.add(pro.id);                 
             }    
        
        for(Account acct : newAccts) {
            
            Account oldAcct = null;
            oldAcct = oldAcctsMap.get(acct.id);
            
            if(acct.Reason_for_changing_owner__c != null && (oldAcct.ownerId != contextUser)
                       && (profileIdSet.contains(contextProfile) != True)){
               
                try{
                           
                            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

                            message.setToAddresses(new String[] {oldOwnerEmail.get(oldacct.ownerId), 'anourbakhsh@fnni.com'});
                            message.setReplyTo(contextEmail);
                            message.setSenderDisplayName(contextName);
                            message.saveAsActivity = false;
                            String body;
                            if(acct.isPersonAccount == false) {
                            message.setSubject('Salesforce Account: ' + acct.name + ' - Ownership Has Been Transferred to ' + newOwner.get(acct.ownerId) + ' by ' + contextName);
                            body = oldOwner.get(oldacct.ownerId) + ', \n \n';
                            body += 'This is an automated Salesforce email alert informing you that a Salesforce Account has had its ownership transferred from you to another Salesforce user. Please reach out to the transferring user should you have concerns.' + '\n \n';
                            body += 'Salesforce Account: ' + acct.name + '\n \n';
                            body += 'New Owner: ' + newOwner.get(acct.ownerId) + '\n';
                            body += 'Previous Owner: ' + oldOwner.get(oldacct.ownerId) + '\n';
                            body += 'Transferer: ' + contextName + '\n';
                            body += 'Reason for Account Ownership Change: ' + oldacct.Reason_for_changing_owner__c;
                            } else if (acct.isPersonAccount == true) {
                            message.setSubject('Salesforce Person Account: ' + acct.firstname + ' ' + acct.lastname + ' - Ownership Has Been Transferred to ' + newOwner.get(acct.ownerId) + ' by ' + contextName);
                            body = oldOwner.get(oldacct.ownerId) + ', \n \n';
                            body += 'This is an automated Salesforce email alert informing you that a Salesforce Account has had its ownership transferred from you to another Salesforce user. Please reach out to the transferring user should you have concerns.' + '\n \n';
                            body += 'Salesforce Person Account: ' + acct.firstname + ' ' + acct.lastname + '\n \n';
                            body += 'New Owner: ' + newOwner.get(acct.ownerId) + '\n';
                            body += 'Previous Owner: ' + oldOwner.get(oldacct.ownerId) + '\n';
                            body += 'Transferer: ' + contextName + '\n';
                            body += 'Reason for Account Ownership Change: ' + oldacct.Reason_for_changing_owner__c;    
                            }
                            
                            message.setPlainTextBody(body);
                            
                            messages.add(message);
                           
                            acct.Reason_for_changing_owner__c = null;

                } catch (exception e) {
                    acct.addError(' An interal error has occurred. Please contact salesforcesupport@fnni.com');
                    
                }
                
            } else if(acct.Reason_for_changing_owner__c == null && oldAcct.ownerId != contextUser
                       && (profileIdSet.contains(contextProfile) != True)) {
                          
                      acct.addError('"Reason for changing owner" field is required to change Account ownership. Please return to the Account record and populate the "Reason for changing owner" field before changing the Account owner.');
 
            } else if(oldAcct.ownerId == contextUser
                       || profileIdSet.contains(contextProfile)) {
                           
                      acct.Reason_for_changing_owner__c = null;
                           
            } else {
            
                acct.addError(' An interal error has occurred. Please contact salesforcesupport@fnni.com');
                
            }
        
        }
        
			if (messages.size() > 0 ) {
        		Messaging.sendEmail(messages);
            }
    }   
}