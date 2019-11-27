public class emailTriggerUpdateHandler {
    // Trigger Handler to mask card numbers in description and subject
    public static void beforeInsertUpdateEmail(List<EmailMessage> newEmail) {
     String regex = '[.\\s]?\\d{4}[-\\s]?\\d{4}[-\\s]?\\d{4}[-\\s]?\\d{4}\\b';
     for(EmailMessage emailObj: newEmail) {
        String htmlBody = emailObj.HtmlBody;
        String description = emailObj.TextBody;
        String subject = emailObj.Subject;
        String maskedhtmlBody = maskEmailDescription(regex, htmlBody);
        if( maskedhtmlBody != null && maskedhtmlBody != '') {
          System.Debug(LoggingLevel.INFO, 'take htmlbody1');
          emailObj.HtmlBody = maskedhtmlBody;
        } else {
          System.Debug(LoggingLevel.INFO, 'take htmlbody2'+ htmlBody);
          emailObj.HtmlBody = htmlBody;   
        }
        String maskedDesc =maskEmailDescription(regex, description);
        if( maskedDesc != null && maskedDesc != '') {
          System.Debug(LoggingLevel.INFO, ' description ');
          emailObj.TextBody = maskedDesc;
        } else {
          System.Debug(LoggingLevel.INFO, ' description check'+ description);
          emailObj.TextBody = description;   
        }
        String maskedSubj = maskEmailSubject(regex, subject);
        if( maskedSubj != null && maskedSubj != '') {
            System.Debug(LoggingLevel.INFO, 'subject');
            emailObj.Subject = maskedSubj;
        } else {
            System.Debug(LoggingLevel.INFO, 'subject check' + subject);
            emailObj.Subject = subject;   
        } 
     }
        
    }
        
    //Mask the card number pattern in the text description
    public static String maskEmailDescription(String regex, String description) {
        String changedDesc = null;
        System.Debug(LoggingLevel.INFO, 'Entering case insert/update trigger1 = ' + description);
        if(description != null && description != '') {
          changedDesc = StringEvaluator.replaceMatch(regex, description);
        }
        return changedDesc;
    }
        
    //Mask the card number pattern in Subject
    public static String maskEmailSubject(String regex, String subject) {
        String changedSubj = null;
        if(subject != null && subject != '') {
          changedSubj = StringEvaluator.replaceMatch(regex, subject);
        }
      return changedSubj;        
    }
}