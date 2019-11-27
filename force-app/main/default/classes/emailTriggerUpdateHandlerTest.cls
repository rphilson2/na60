@isTest
public class emailTriggerUpdateHandlerTest {
    public static String regex = '[.\\s]?\\d{4}[-\\s]?\\d{4}[-\\s]?\\d{4}[-\\s]?\\d{4}\\b';

    @isTest
    static void maskCaseDescriptionTest() {
        String descr = 'Hi Kristin - card# 1058 3444 3657 4555';
        String descChanged = emailTriggerUpdateHandler.maskEmailDescription(regex, descr);
        System.assertEquals('Hi Kristin - card#105834******4555', descChanged);
    }
    
    @isTest
    static void maskCaseSubjectTest() {
        String sub='About card# 1058 3444 3657 4555';
        String changed = emailTriggerUpdateHandler.maskEmailSubject(regex, sub);
        System.assertEquals('About card#105834******4555', changed);
    }
    
    @isTest
    static void beforeInsertUpdateCaseNullTest() {
        String changed = emailTriggerUpdateHandler.maskEmailDescription(regex, ' ');
        String changedSub = emailTriggerUpdateHandler.maskEmailSubject(regex, ' ');
        System.assertEquals(' ', changed);
        System.assertEquals(' ', changedSub);
    }
    
    @isTest
    static void beforeInsertUpdateEmailTest() {
        String descmatch = 'Hi Kristin - card# 1058 3443 5689 5673, written for $50,000.00, was deposited for $5,000.00 on 8/21.Requesting a credit in the amount of $45,000.00.Thank you.';
        String converted = 'Hi Kristin - card#105834******5673, written for $50,000.00, was deposited for $5,000.00 on 8/21.Requesting a credit in the amount of $45,000.00.Thank you.';
        String subject = 'TDA Credit request - $45,000.00 card# 1058 3443 5689 5673';
        String convertedSubject = 'TDA Credit request - $45,000.00 card#105834******5673';
        Test.startTest();
        EmailMessage emailnew = new EmailMessage();
        emailnew.TextBody = descmatch;
        emailnew.Subject = subject;
        emailnew.HtmlBody = descmatch;
        System.Debug(LoggingLevel.INFO, 'Testing email matchpatternTest insert trigger2 = ' + emailnew.TextBody);
        insert emailnew;
        EmailMessage emailretrieved =[SELECT TextBody, HtmlBody, Subject FROM EmailMessage Limit 1];
        System.Debug(LoggingLevel.INFO, 'Testing matchpatternTest insert trigger desc = '+ emailretrieved.TextBody);
        System.Debug(LoggingLevel.INFO, 'Testing matchpatternTest insert trigger subj = '+ emailretrieved.Subject);
        System.assertEquals(converted, emailretrieved.HtmlBody);
        System.assertEquals(converted, emailretrieved.TextBody);
        System.assertEquals(convertedSubject, emailretrieved.Subject);
        emailretrieved.HtmlBody = descmatch;
        emailretrieved.TextBody = descmatch;
        emailretrieved.Subject = subject;
        System.Debug(LoggingLevel.INFO, 'Testing matchpatternTest before update trigger desc = '+ emailretrieved.TextBody);
        System.Debug(LoggingLevel.INFO, 'Testing matchpatternTest before update trigger subj = '+ emailretrieved.Subject);

        update emailretrieved;
        EmailMessage emailupdated =[SELECT TextBody, HtmlBody, Subject FROM EmailMessage Limit 1];
        System.Debug(LoggingLevel.INFO, 'Testing matchpatternTest update trigger desc = '+ emailupdated.TextBody);
        System.Debug(LoggingLevel.INFO, 'Testing matchpatternTest update trigger subj = '+ emailupdated.Subject);
        System.assertEquals(converted, emailupdated.TextBody);
        System.assertEquals(convertedSubject, emailupdated.Subject);
        System.assertEquals(converted, emailupdated.HtmlBody);
        
        Test.stopTest();

    }

}