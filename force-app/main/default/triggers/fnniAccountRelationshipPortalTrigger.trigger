// Author: Alexander Nourbakhsh
// Date: 11.14.2016
// Purpose: One Trigger per Object


trigger fnniAccountRelationshipPortalTrigger on FNNI_Account_Relationship_Portal__c (after insert) {
	if (Trigger.isAfter) {
		if (Trigger.isInsert) {
			fntsPartnerNetworkConnection.forwardFntsConn(trigger.new);   
        }    
	}
}