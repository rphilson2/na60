// Author: Alexander Nourbakhsh
// Date: 09.27.2016
// Purpose: One Trigger per Object

trigger ficSurveyApplicationTrigger on FIC_Survey_Application__c (before update) {
    if(Trigger.isBefore) {
        if(Trigger.isUpdate) {
            processFicSurveyApps.qualifyFicSurveyApps(Trigger.oldMap, Trigger.new);
        }
    }
}