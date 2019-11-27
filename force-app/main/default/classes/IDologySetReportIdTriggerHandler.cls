public class IDologySetReportIdTriggerHandler { //extends nFORCE.ATriggerHandler {

    /*
    public override Type getType() {
        return IDologySetReportIdTriggerHandler.class;
    }
        
    public override void beforeUpdate(List<sObject> newObjs, List<sObject> oldObjs, Set<Id> objIds) {
        
    }
    
    public override void beforeInsert(List<sObject> objs) {
        handleAccountUpdate(objs);
    }
*/

    public static void handleAccountUpdate(List<sObject> newObjs){
		List<nFUSE__Transaction_Log__c> txnList = (List<nFUSE__Transaction_Log__c >) newObjs;
        List<nFUSE__Transaction_Log__c> IdLogs = new List<nFUSE__Transaction_Log__c >();
        for(nFUSE__Transaction_Log__c txnItem : txnList){
            if(txnItem.nFUSE__Action__c == 'Verification'
               && txnItem.nFUSE__App_Plugin__c == 'Idology_Verification'){
                IdLogs.add(txnItem);
            }
        }
        if(IdLogs.Size()>0){
            List<Account> acctUpdateList = new List<Account>();
            for (nFUSE__Transaction_Log__c txnItem : IdLogs) {
                Account acctItem = new Account();
                acctItem.Id = txnItem.nFUSE__Primary_Object_Id__c;
                acctItem.ID_Verification_No__c = setIDFromTxn(txnItem);
                if(acctItem.Id != null && acctItem.ID_Verification_No__c != null)
                    acctUpdateList.add(acctItem);
            }
            if(acctUpdateList.size()>0) nFORCE.DmlUtility.updateObj(acctUpdateList);
        }
    }

    private static String setIDFromTxn(nFUSE__Transaction_Log__c txnLog){
		String retVal = '';
        
        try{
            IDologyResponse iDResp = (IDologyResponse) JSON.deserialize(txnLog.nFUSE__Transaction_Detail__c, IDologyResponse.Class);
            retVal = iDResp.transactionDetails.vendorVerificationId;
        } catch (Exception ex){
            // Ignore exceptions and return blank.
        }
        
        return retVal;
    }

    public class IDologyResponse {
        String transactionStatus;
        String vendorStatus;
        TransactionDetail transactionDetails;
    }
    
    public class TransactionDetail {
        String vendorVerificationId;
        String vendorSpecificStatus;
        String vendorStatus;
    }
    
}