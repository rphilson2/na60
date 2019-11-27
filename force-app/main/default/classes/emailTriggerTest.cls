@isTest
public class emailTriggerTest {
   //Positive test for insert and update
    @isTest
    static void matchpatternTest() {
        String descmatch = 'Hi Kristin - card# 1058 3443 5689 5673, written for $50,000.00, was deposited for $5,000.00 on 8/21.Requesting a credit in the amount of $45,000.00.Thank you.';
        String converted = 'Hi Kristin - card#105834******5673, written for $50,000.00, was deposited for $5,000.00 on 8/21.Requesting a credit in the amount of $45,000.00.Thank you.';
        String subject = 'TDA Credit request - $45,000.00 card# 1058 3443 5689 5673';
        String convertedSubject = 'TDA Credit request - $45,000.00 card#105834******5673';
        Test.startTest();
        EmailMessage emailnew = new EmailMessage();
        emailnew.TextBody = descmatch;
        emailnew.Subject = subject;
        System.Debug(LoggingLevel.INFO, 'Testing email matchpatternTest insert trigger2 = ' + emailnew.TextBody);
        insert emailnew;
        EmailMessage emailretrieved =[SELECT TextBody, Subject FROM EmailMessage Limit 1];
        System.Debug(LoggingLevel.INFO, 'Testing case matchpatternTest insert trigger desc = '+ emailretrieved.TextBody);
        System.Debug(LoggingLevel.INFO, 'Testing case matchpatternTest insert trigger subj = '+ emailretrieved.Subject);
        System.assertEquals(converted, emailretrieved.TextBody);
        System.assertEquals(convertedSubject, emailretrieved.Subject);
        
        emailretrieved.TextBody = descmatch;
        emailretrieved.Subject = subject;
        System.Debug(LoggingLevel.INFO, 'Testing email matchpatternTest before update trigger desc = '+ emailretrieved.TextBody);
        System.Debug(LoggingLevel.INFO, 'Testing email matchpatternTest before update trigger subj = '+ emailretrieved.Subject);

        update emailretrieved;
        EmailMessage emailupdated =[SELECT TextBody, Subject FROM EmailMessage Limit 1];
        System.Debug(LoggingLevel.INFO, 'Testing case matchpatternTest update trigger desc = '+ emailupdated.TextBody);
        System.Debug(LoggingLevel.INFO, 'Testing case matchpatternTest update trigger subj = '+ emailupdated.Subject);
        System.assertEquals(converted, emailupdated.TextBody);
        System.assertEquals(convertedSubject, emailupdated.Subject);
        
        Test.stopTest();
    }
    //Negative test for insert and update
    @isTest
    static void nomatchpatternTest() {
        String descmatch = 'Hi Kristin - card# 1058 3443 5689 , 5334 written for $50,000.00, was deposited for $5,000.00 on 8/21.Requesting a credit in the amount of $45,000.00.Thank you.';
        String converted = descmatch;
        String subject = 'TDA Credit request - $45,000.00 card# 1058 3443, 5334';
        String convertedSubject = subject;
        Test.startTest();
        EmailMessage emailnew = new EmailMessage();
        emailnew.TextBody = descmatch;
        emailnew.Subject = subject;
        System.Debug(LoggingLevel.INFO, 'Testing email matchpatternTest insert trigger2 = ' + emailnew.TextBody);
        insert emailnew;
        EmailMessage emailretrieved =[SELECT TextBody, Subject FROM EmailMessage Limit 1];
        System.Debug(LoggingLevel.INFO, 'Testing case matchpatternTest insert trigger desc = '+ emailretrieved.TextBody);
        System.Debug(LoggingLevel.INFO, 'Testing case matchpatternTest insert trigger subj = '+ emailretrieved.Subject);
        System.assertEquals(converted, emailretrieved.TextBody);
        System.assertEquals(convertedSubject, emailretrieved.Subject);
        
        emailretrieved.TextBody = descmatch;
        emailretrieved.Subject = subject;
        System.Debug(LoggingLevel.INFO, 'Testing email matchpatternTest before update trigger desc = '+ emailretrieved.TextBody);
        System.Debug(LoggingLevel.INFO, 'Testing email matchpatternTest before update trigger subj = '+ emailretrieved.Subject);

        update emailretrieved;
        EmailMessage emailupdated =[SELECT TextBody, Subject FROM EmailMessage Limit 1];
        System.Debug(LoggingLevel.INFO, 'Testing case matchpatternTest update trigger desc = '+ emailupdated.TextBody);
        System.Debug(LoggingLevel.INFO, 'Testing case matchpatternTest update trigger subj = '+ emailupdated.Subject);
        System.assertEquals(converted, emailupdated.TextBody);
        System.assertEquals(convertedSubject, emailupdated.Subject);
        
        Test.stopTest();
         
    }

    @isTest
    static void nomatchpatternNullTest() {
        String descmatch = ' ';
        String converted = null;
        String subject = 'TDA Credit request - $45,000.00 card# 1058 3443, 5334';
        String convertedSubject = subject;
        Test.startTest();
        EmailMessage emailnew = new EmailMessage();
        emailnew.HtmlBody = descmatch;
        emailnew.TextBody = descmatch;
        emailnew.Subject = subject;
        System.Debug(LoggingLevel.INFO, 'Testing email matchpatternTest insert trigger2 = ' + emailnew.TextBody);
        insert emailnew;
        EmailMessage emailretrieved =[SELECT TextBody, HtmlBody, Subject FROM EmailMessage Limit 1];
        System.Debug(LoggingLevel.INFO, 'Testing case matchpatternTest insert trigger desc = '+ emailretrieved.TextBody);
        System.Debug(LoggingLevel.INFO, 'Testing case matchpatternTest insert trigger subj = '+ emailretrieved.Subject);
        System.assertEquals(converted, emailretrieved.TextBody);
        System.assertEquals(convertedSubject, emailretrieved.Subject);
        emailretrieved.HtmlBody = descmatch;
        emailretrieved.TextBody = descmatch;
        emailretrieved.Subject = subject;
        System.Debug(LoggingLevel.INFO, 'Testing email matchpatternTest before update trigger desc = '+ emailretrieved.TextBody);
        System.Debug(LoggingLevel.INFO, 'Testing email matchpatternTest before update trigger subj = '+ emailretrieved.Subject);

        update emailretrieved;
        EmailMessage emailupdated =[SELECT TextBody, HtmlBody, Subject FROM EmailMessage Limit 1];
        System.Debug(LoggingLevel.INFO, 'Testing case matchpatternTest update trigger desc = '+ emailupdated.TextBody);
        System.Debug(LoggingLevel.INFO, 'Testing case matchpatternTest update trigger subj = '+ emailupdated.Subject);
        System.assertEquals(converted, emailupdated.HtmlBody);
        System.assertEquals(converted, emailupdated.TextBody);
        System.assertEquals(convertedSubject, emailupdated.Subject);
        
        Test.stopTest();
         
    }

}