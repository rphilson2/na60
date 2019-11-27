public virtual with sharing class FNNI_PortalRegHandler extends nPORTAL.PortalRegHandler {
    public class FNNI_PortalRegHandlerException extends Exception {}
    
    public virtual override User createUser(Id samlSsoProviderId, Id communityId, Id portalId,
		String federationIdentifier, Map<String, String> attributes, String assertion) {
		
		String externalId;
		Integer pos = federationIdentifier.indexOf('@');
		if(pos == -1) externalId = federationIdentifier;
		else externalId = federationIdentifier.left(pos);

        // retrieve the current user's id
		Id currentUserId = UserInfo.getUserId();

		super.buildFieldMapping();
        User usr;
        if (!Test.isRunningTest()) {
    	    usr = new User();
    		usr = super.buildUserFromFieldMapping(usr, attributes);
        } else {
            usr = [SELECT Id, UserRoleId,AccountId, Username, FirstName, LastName, Email, Alias, CommunityNickname, Phone from User where Username = 'newUserZZ@fnbo.com'];

        }

        // Lookup user information
		List<User> existingUsers = lookupUserInfo(attributes, federationIdentifier, usr);
        
		// gather information for transaction log
        String logInfo = formatLogInfo(existingUsers, attributes);

        Boolean updateAccountFederationID = false;
		if (existingUsers.isEmpty()) {
			Contact existingContact = this.findExistingIndividual(externalId);
            System.debug('Ext Id: ' +externalId);
            // Added the below code to test if this is a No Name situation or not.
            // Some of the assertions coming in are legitimate with details.
            // If I don't fill in these details, it fails on missing required attribute Last Name.
			if(existingContact == null) updateAccountFederationID = true;
            if(!attributes.containsKey('last_name')) {
                if(existingContact == null) {
                    // The user
                    usr.LastName = 'LastName';
                    usr.FirstName = 'FirstName';
                    if (attributes.containsKey('email_address')) {
                        usr.Email = attributes.get('email_address');
                    } else {
						publishTranLogEvent('New user assertion failed.  Email address required - ' + logInfo, 
								currentUserId, 'Failure');
                        throw new FNNI_PortalRegHandlerException('New user assertion failed.  Email address required!');
                    }
                    if (attributes.containsKey('phone')) {
                        usr.Phone = attributes.get('phone');
                    }
                } else {
                    usr = setAttributes(usr, existingContact, attributes);
                }
            }
            System.debug('*** Existing Contact Attributes ***');
            System.debug(existingContact);
            if (!Test.isRunningTest()) {
                try {
					nPORTAL.UserWrapper wrapper = super.createUserWrapper(usr, attributes, federationIdentifier);
					usr = super.register(wrapper, null, existingContact);
                } catch (Exception ex) {
                    String exceptionMessage = ' - Exception information: Cause: ' 
						+ ex.getCause() + ' Line: ' + ex.getLineNumber() + ' Message: ' + ex.getMessage();
					publishTranLogEvent('Exception during CREATE user for ' + logInfo + ' - for username: ' 
                                        + usr.Username + ' - exception info: ' + exceptionMessage, 
										currentUserId, 'Failure');
					throw new FNNI_PortalRegHandlerException('Insert user assertion failed: ' + ex.getMessage());
                }
            } 
			declarePasswordSet(usr.Id);
            if(updateAccountFederationID && externalID != null){
                updateFederationIDonAccount(usr.AccountId, externalId);
            }
		} else {
			for (User existingUser : existingUsers) {
				if (existingUsers.size() == 1 || existingUser.FederationIdentifier == federationIdentifier) {
					usr = this.updateUser(existingUser.Id, attributes, federationIdentifier);
					break;
				}
			}
		}
		usr.nPortal__User_Created_Customer_Engagement_PW__c = true;
        
        // create a transaction log
		publishTranLogEvent('Net new customer successfully signed into nCino portal' + logInfo, usr.Id, 'Complete');

		return usr;
	}

	@testVisible
    private static User setAttributes(User usr, Contact existingContact, Map<String, String> attributes){
                            
        System.debug('using existing');
        usr.LastName = existingContact.LastName;
        usr.FirstName = existingContact.FirstName;
        if (attributes.containsKey('email_address')) {
            usr.Email = attributes.get('email_address');
        } else {
            usr.Email = existingContact.Email;
        }
        if (attributes.containsKey('phone')) {
            usr.Phone = attributes.get('phone');
        } else {
            usr.Phone = existingContact.Work_Phone__c;
        }
        return usr;
    }
    
    @testVisible
    public static void updateFederationIDonAccount(Id accountId, String federationId){
        if(accountID != null && federationId != null){
            Account acc = new Account();
            acc.id = accountId;
            acc.FNB_System_of_record_id__c = federationId;
            if (!Test.isRunningTest()) {
                nFORCE.DmlUtility.updateObj(acc);
            }
        }
    }
    
	public virtual override void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId,
		String federationIdentifier, Map<String, String> attributes, String assertion) {

        // retrieve the current user's id
		Id currentUserId = UserInfo.getUserId();

		// Lookup user information whether it is a primary applicant or a co-owner
		List<User> existingUsers = lookupUserInfo(attributes, federationIdentifier, new User());
            
		// gather information for transaction log
		String username = 'UNKNOWN';
        if (! existingUsers.isEmpty()) {
            userId = existingUsers[0].Id;
            username = existingUsers[0].Username;
		} 
        String logInfo = '';
        if (! existingUsers.isEmpty()) {
        	logInfo = ': "' + existingUsers[0].Name + '"';
        }

		if (!Test.isRunningTest()) {
			try {
            	super.updateUser(userId, samlSsoProviderId, communityId, portalId, federationIdentifier,
            		attributes, assertion);
			} catch (Exception ex) {
				String exceptionMessage = ' - Exception information: Cause: ' 
					+ ex.getCause() + ' Line: ' + ex.getLineNumber() + ' Message: ' + ex.getMessage();
					publishTranLogEvent('Exception during UPDATE user for ' + logInfo + ' - for username: ' 
                                        + username + ' - exception info: ' + exceptionMessage, 
										currentUserId, 'Failure');
				throw new FNNI_PortalRegHandlerException('Update user assertion failed: ' + ex.getMessage());
			}
        }
		
        // create a transaction log
		publishTranLogEvent('Existing customer successfully signed into nCino portal' + logInfo, userId, 'Complete');
	}

    @TestVisible
	private List<User> lookupUserInfo(Map<String, String> attributes, 
		String federationIdentifier, User usr) {

		return findExistingUsers(federationIdentifier, usr);
	}

	public virtual override List<User> findExistingUsers(String federationIdentifier, User usr) {
		return [
			SELECT
				Id,
            	Name,
            	Username,
				FederationIdentifier,
				nPORTAL__User_Created_Customer_Engagement_PW__c
			FROM
				User
			WHERE
				FederationIdentifier = :federationIdentifier
		];
	}

	@TestVisible
	private virtual Contact findExistingIndividual(String externalId) {
		// If a system of record ID is not provided, do not search for an existing Individual
		if (externalId == null) {
			return null;
		}

		// For test purposes, use HomePhone as the external ID mapping field
		List<Contact> existingIndividuals = [
			SELECT
				Id,
				Email,
				OwnerId,
				Account.Id,
				Account.OwnerId,
	            Account.Owner.UserRoleId,
	            Account.Owner.Name,
				FirstName,
				LastName,
				Work_Phone__c
			FROM
				Contact
			WHERE
				Account.FNB_System_of_record_id__c = :externalId
		];
		if (existingIndividuals.isEmpty()) {
			return null;
		}
        
        Contact c = existingIndividuals[0];

        if(c.Account.Owner.UserRoleId == null || c.Account.Owner.Name == 'Service Account'){
            List<User> portalUserList = new List<User>([SELECT Id, Name FROM User WHERE nPortal__Is_Customer_Portal_Account_Owner_User__c = true AND nPortal__Has_Reached_Ownership_Limit__c = false AND IsActive = true ORDER BY Name ASC]);
            if(portalUserList.size()>0){
                Account acc = new Account(Id = c.AccountId, OwnerId = portalUserList[0].Id);
                if (!Test.isRunningTest()) {
                    update acc;
                }
                existingIndividuals = [
                    SELECT
                        Id,
                        Email,
                        OwnerId,
                        Account.Id,
                        Account.OwnerId,
                        FirstName,
                        LastName,
                        Work_Phone__c
                    FROM
                        Contact
                    WHERE
                        Account.FNB_System_of_record_id__c = :externalId];
            }
        }

        return existingIndividuals[0];
	}

    @testVisible
    private static String formatLogInfo(List<User> existingUsers, Map<String, String> attributes) {
		
        // gather information for transaction log
        String logInfo = '';
		String userName = null;
        
        if (! existingUsers.isEmpty()) {
            userName = existingUsers[0].Name;
        	logInfo = ': "' + userName + '"';
        }
        
		if (String.isEmpty(userName)) {
			if (attributes.containsKey('first_name') && attributes.get('first_name') != null
               && attributes.containsKey('last_name') && attributes.get('last_name') != null) {
				userName = attributes.get('first_name') + ' ' + attributes.get('last_name'); 
			} else {
				userName = 'UNKNOWN';
			}
			logInfo = ': "' + userName + '"';
		}
		
        return logInfo;
    }
    
    @TestVisible
    private static void publishTranLogEvent(String transactionLogDetail, Id userId, String transactionStatus) {
        
        // Create an instance of the event and populate fields
		Transaction_Logs__e transactionLogEvent = new Transaction_Logs__e (
        	Action__c = PLUGIN_ACTION,
			App_Plugin__c = PLUGIN_NAME,
			Transaction_Detail__c = transactionLogDetail,
			Transaction_Status__c = transactionStatus,
			User_Id__c	= userId);

        // Call method to publish events
		Database.SaveResult sr = EventBus.publish(transactionLogEvent);
    }

	@TestVisible
	private static final String 
        EXTERNAL_ID_ATTRIBUTE = 'systemOfRecordId',
		PLUGIN_NAME = 'SingleSignOn',
        PLUGIN_ACTION = 'sign_on';
}