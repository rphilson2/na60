trigger DepositTrigger on LLC_BI__Deposit__c (before insert) {
    //TriggerHandler.executeObjectTrigger(Schema.LLC_BI__Deposit__c.sObjectType);

    List<LLC_BI__Deposit__c> depositList = (List<LLC_BI__Deposit__c>) trigger.new;
    Set<Id> userIdSet = new Set<ID>();    
    userIdSet.add(System.UserInfo.getUserId());
    Map<Id,User> userMap = new Map<Id, User>([SELECT ID, Bank_Number__c FROM user WHERE Id IN :userIdSet]);
    for(LLC_BI__Deposit__c depositItem : depositList){
        if(userMap.containsKey(System.UserInfo.getUserId())){
            User usr = userMap.get(System.UserInfo.getUserId());
            depositItem.Bank_Number__c = usr.Bank_Number__c;
        }
    }
}