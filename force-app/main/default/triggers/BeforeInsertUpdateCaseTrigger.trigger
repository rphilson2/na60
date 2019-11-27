trigger BeforeInsertUpdateCaseTrigger on Case (before insert, before update) {
    String regex = '\\b\\d{4}[-\\s]?\\d{4}[-\\s]?\\d{4}[-\\s]?\\d{4}\\b';        
    for(Case caseObj: Trigger.New) {
        //Case caseObj = Trigger.newMap.get(Id);
            String description = caseObj.description;
            String subject = caseObj.Subject;
            if(Trigger.isInsert || Trigger.isUpdate) {
                //replace the cardnumber pattern in description
                System.Debug(LoggingLevel.INFO, 'Entering case insert trigger1 = ' + description);
                String maskedDesc = StringEvaluator.replaceMatch(regex, description);
                if( maskedDesc != null && maskedDesc != '') {
                caseObj.Description = maskedDesc;
                } else {
                 caseObj.Description = description;   
                }
                System.Debug(LoggingLevel.INFO, 'Exiting case insert trigger = ' + caseObj.Description);
                //replace the cardnumber pattern in subject
                String maskedSubj = StringEvaluator.replaceMatch(regex, subject);
                if( maskedSubj != null && maskedDesc != '') {
                caseObj.Subject = maskedSubj;
                } else {
                 caseObj.Subject = subject;   
                }
                System.Debug(LoggingLevel.INFO, 'Exiting case insert trigger = ' + caseObj.Subject);
                return;
             }

        System.Debug(LoggingLevel.INFO, 'Exiting');
        return;
      }
}