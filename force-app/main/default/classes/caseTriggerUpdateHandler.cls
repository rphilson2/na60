public class caseTriggerUpdateHandler {
    // Trigger Handler to mask card numbers in description and subject
    public static void beforeInsertUpdateCase(List<Case> newCasevalue) {
     String regex = '[.\\s]?\\d{4}[-\\s]?\\d{4}[-\\s]?\\d{4}[-\\s]?\\d{4}\\b';
     for(Case caseObj: newCasevalue) {
        String description = caseObj.description;
        String subject = caseObj.Subject;
        String maskedDesc =maskCaseDescription(regex, description);
        if( maskedDesc != null && maskedDesc != '') {
          System.Debug(LoggingLevel.INFO, 'In description');
          caseObj.Description = maskedDesc;
        } else {
          System.Debug(LoggingLevel.INFO, 'In description check '+ description);
          caseObj.Description = description;   
        }
        String maskedSubj = maskCaseSubject(regex, subject);
        if( maskedSubj != null && maskedSubj != '') {
            System.Debug(LoggingLevel.INFO, 'In subject');
            caseObj.Subject = maskedSubj;
        } else {
            System.Debug(LoggingLevel.INFO, 'In subject check' + subject);
            caseObj.Subject = subject;   
        } 
     }
    }
        
    //Mask the card number pattern in Description
    public static String maskCaseDescription(String regex, String description) {
        String changedDesc = null;
        System.Debug(LoggingLevel.INFO, 'Entering case insert/update trigger1 = ' + description);
        if(description != null && description != '') {
          changedDesc = StringEvaluator.replaceMatch(regex, description);
        }
        return changedDesc;
    }
        
    //Mask the card number pattern in Subject
    public static String maskCaseSubject(String regex, String subject) {
        String changedSubj = null;
        if(subject != null && subject != '') {
          changedSubj = StringEvaluator.replaceMatch(regex, subject);
        }
      return changedSubj;        
    }
}