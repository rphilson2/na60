public without sharing class ExpQual { 
    public class ExpQual_Exception extends Exception {}
    @testVisible
    public class ReturnDetails {
        @testVisible
        String status;
        @testVisible
        String message;
        @testVisible
        String error;
        
    }
    
    public static ReturnDetails sendRequest(string appIdString, String mockCalloutResponse){
        Id applicationId = (ID) appIdString;
        String ip;
        String calloutResponse;
        if(Test.isRunningTest()){
            ip = '127.0.0.1';
            calloutResponse = mockCalloutResponse;
        } else {
            ip = Auth.SessionManagement.getCurrentSession().get('SourceIp');
            calloutResponse = SUCCESS;
        }
            
        ID userId = Userinfo.getUserId();
        ExpID_BusinessProcess bp = new ExpID_BusinessProcess();
        
        ReturnDetails retDet = new ReturnDetails();
        try{
            if(!Test.isRunningTest()){
                calloutResponse = bp.sendRequest(applicationId, ip, userId);
            }
            if(calloutResponse == SUCCESS) {
                retDet.status = SUCCESS;
                retDet.message = INTEGRATION_SUCCESS_MESSAGE;
                retDet.error = '';
            } else if (calloutResponse == ID_VERIFICATION_FAILURE) {
               retDet.status = FAILURE;
                retDet.message = INTEGRATION_ERROR_MESSAGE;
                retDet.error = '';
            } else if (calloutResponse == ERROR){
                throw(new ExpQual_Exception(ERROR));
            }
        } catch(Exception ex) {
            retDet.status = ERROR;
            retDet.message = INTEGRATION_ERROR_MESSAGE;
            retDet.error = 'Cause: ' + ex.getCause() + ' Line: ' + ex.getLineNumber() + ' Message: ' + ex.getMessage() + ' StackTrace: ' + ex.getStackTraceString();
        }
        return retDet;
    }
    
    @remoteAction
    public static ReturnDetails sendRequest(String appIdString) {
        return sendRequest(appIdString, '');
    }
    
    /*
     * Added for Customer Portal 'NextButton' fix on ID Check route. Works for all UI groups
     * nCino Support Case #72140
     * Referenced in Exp_Qual_ID.vfc
     */
    @remoteAction
    public static String getNextRoute(Id appId){
        return getNextRouteHelper(appId);
    }
     
    /*
     * Added for Customer Portal 'NextButton' fix on ID Check route. Works for all UI groups
     * nCino Support Case #72140
     * Helper method for remote action
     */
    public static String getNextRouteHelper(Id appId){
        // Query Session to update with next Route Group
        nFORCE__Session__c session = [SELECT id, nFORCE__Route_Group__c, nFORCE__Route_Group__r.nFORCE__Group__c 
                                      FROM nFORCE__Session__c 
                                      WHERE id IN 
                                      (SELECT nPortal__Session__c 
                                       FROM nPortal__Context__c 
                                       WHERE nPortal__Application__c =:appId)
                                      LIMIT 1];
        // Query the ID Check route group for this UI group. This will always be the route this button is used on.
        nFORCE__Route_Group__c IdCheckRouteGroup = [SELECT id, nFORCE__Group__c, nFORCE__Order__c, nFORCE__Route__r.nFORCE__Body__c 
                                                    FROM nFORCE__Route_Group__c 
                                                    WHERE nFORCE__Group__c =:session.nFORCE__Route_Group__r.nFORCE__Group__c 
                                                    AND nFORCE__Route__r.nFORCE__Body__c =:Label.Exp_Component 
                                                    LIMIT 1];
        // Query the next visible route group in the UI group
        nFORCE__Route_Group__c nextRouteGroup = [SELECT id, nFORCE__Route__r.nFORCE__App__c 
                                                 FROM nFORCE__Route_Group__c 
                                                 WHERE nFORCE__Group__c =:IdCheckRouteGroup.nFORCE__Group__c 
                                                 AND nFORCE__Order__c > :IdCheckRouteGroup.nFORCE__Order__c 
                                                 AND nFORCE__Is_Hidden__c = false 
                                                 ORDER BY nFORCE__Order__c ASC 
                                                 LIMIT 1];
        // Update Session with new route group ID
        session.nFORCE__Route_Group__c = nextRouteGroup.Id; 
        update session;
        // Return the next route group's App to modify page URL in JS
        return nextRouteGroup.nFORCE__Route__r.nFORCE__App__c;
    }
    
    
    @testVisible
    private static String 
        SUCCESS = Label.SUCCESS_MESSAGE,
        FAILURE = Label.FAILURE_MESSAGE,
        ERROR = Label.ERROR_MESSAGE,
        ID_VERIFICATION_FAILURE = Label.ID_VERIFICATION_FAILURE,
        INTEGRATION_ERROR_MESSAGE = Label.IntegrationMessageError,
        INTEGRATION_SUCCESS_MESSAGE = Label.IntegrationMessageSuccess;

}