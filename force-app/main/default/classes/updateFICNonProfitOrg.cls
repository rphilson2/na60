//Author:  Dallas Grafton
//Date:  2019-03-13
//VersionOne Story:  S-28706
//Purpose:  Update the non-profit org field on FIC Survey application if it is changed on the corresponding community investment.

public without sharing class updateFICNonProfitOrg {

    private final Map<Id, Community_Giving__c> oldMap;
    private final List<Community_Giving__c> newCommGiv;
    
    public static void compareNonProfitOrg(Map<Id, Community_Giving__c> oldMap, 
                                            List<Community_Giving__c> newCommGiv) {                                            
       for(Community_Giving__c newComm: newCommGiv) {
          Community_Giving__c oldComm = oldMap.get(newComm.id);
          if (newComm.Non_Profit_Organization__c != oldComm.Non_Profit_Organization__c) {
             if (newComm.FIC_Survey_Application__c != null) {
                updateFIC(newComm);
             }
          }
       }
    }
 
    public static void updateFIC(Community_Giving__c commGivtogetFIC) {
       FIC_Survey_Application__c appToUpdate = [SELECT id, name, Non_Profit_Organization__c from FIC_Survey_Application__c where id = :commGivtogetFIC.FIC_Survey_Application__c];
       appToUpdate.Non_Profit_Organization__c = commGivtogetFIC.Non_Profit_Organization__c;
       appToUpdate.Update_Code__c = '37';
       update appToUpdate;
    }
}