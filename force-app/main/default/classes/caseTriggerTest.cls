@isTest
public class caseTriggerTest {

    //Positive test for insert and update
    @isTest
    static void matchpatternTest() {
        String descmatch = 'Hi Kristin - card# 1058 3443 5689 5673, written for $50,000.00, was deposited for $5,000.00 on 8/21.Requesting a credit in the amount of $45,000.00.Thank you.';
        String converted = 'Hi Kristin - card#105834******5673, written for $50,000.00, was deposited for $5,000.00 on 8/21.Requesting a credit in the amount of $45,000.00.Thank you.';
        String subject = 'TDA Credit request - $45,000.00 card# 1058 3443 5689 5673';
        String convertedSubject = 'TDA Credit request - $45,000.00 card#105834******5673';
        Test.startTest();
        Case casenew = new Case();
        RecordType recordType = new RecordType(Name='NewCase');
        casenew.RecordTypeId = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('CTS Support').getRecordTypeId();
        System.Debug(LoggingLevel.INFO, 'Testing matchpatternTest case insert trigger1 = ' + Case.sObjectType.getDescribe().getRecordTypeInfosByName());
        casenew.Description = descmatch;
        casenew.Subject = subject;
        casenew.Application_ID__c ='ABC123';
        System.Debug(LoggingLevel.INFO, 'Testing case matchpatternTest insert trigger2 = ' + casenew.Description);
        insert casenew;
        Case caseretrieved =[SELECT Description, Subject FROM Case WHERE Application_ID__c = :casenew.Application_ID__c];
        System.Debug(LoggingLevel.INFO, 'Testing case matchpatternTest insert trigger desc = '+ caseretrieved.Description);
        System.Debug(LoggingLevel.INFO, 'Testing case matchpatternTest insert trigger subj = '+ caseretrieved.Subject);
        System.assertEquals(converted, caseretrieved.Description);
        System.assertEquals(convertedSubject, caseretrieved.Subject);
        
        caseretrieved.Description = descmatch;
        caseretrieved.Subject = subject;
        System.Debug(LoggingLevel.INFO, 'Testing case matchpatternTest before update trigger desc = '+ caseretrieved.Description);
        System.Debug(LoggingLevel.INFO, 'Testing case matchpatternTest before update trigger subj = '+ caseretrieved.Subject);

        update caseretrieved;
        Case caseupdated =[SELECT Description, Subject FROM Case WHERE Application_ID__c = :casenew.Application_ID__c];
        System.Debug(LoggingLevel.INFO, 'Testing case matchpatternTest update trigger desc = '+ caseupdated.Description);
        System.Debug(LoggingLevel.INFO, 'Testing case matchpatternTest update trigger subj = '+ caseupdated.Subject);
        System.assertEquals(converted, caseupdated.Description);
        System.assertEquals(convertedSubject, caseupdated.Subject);
        
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
        Case casenew = new Case();
        casenew.RecordTypeId = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('CTS Support').getRecordTypeId();
        System.Debug(LoggingLevel.INFO, 'Testing nomatchpatternTest1 case insert trigger1 = ' + casenew.Description);
        casenew.Description = descmatch;
        System.Debug(LoggingLevel.INFO, 'Testing nomatchpatternTest2 case insert trigger2 = ' + casenew.Description);
        casenew.Subject = subject;
        casenew.Application_ID__c ='ABC123';
        insert casenew;
        Case caseretrieved =[SELECT Description, Subject FROM Case WHERE Application_ID__c = :casenew.Application_ID__c Limit 1];
        System.Debug(LoggingLevel.INFO, 'Testing nomatchpatternTest3 case insert trigger3 = '+ caseretrieved.Description);
        System.Debug(LoggingLevel.INFO, 'Testing nomatchpatternTest4 case insert trigger4 = '+ caseretrieved.Subject);
        System.assertEquals(converted, caseretrieved.Description);
        System.assertEquals(convertedSubject, caseretrieved.Subject);
        
        caseretrieved.Description = descmatch;
        caseretrieved.Subject = subject;
        update caseretrieved;
        Case caseupdated =[SELECT Description, Subject FROM Case WHERE Application_ID__c = :casenew.Application_ID__c];
        System.Debug(LoggingLevel.INFO, 'Testing nomatchpatternTest1 case update trigger desc = '+ caseupdated.Description);
        System.Debug(LoggingLevel.INFO, 'Testing nomatchpatternTest2 case update trigger subj = '+ caseupdated.Subject);
        System.assertEquals(converted, caseupdated.Description);
        System.assertEquals(convertedSubject, caseupdated.Subject);
        Test.stopTest();
         
    }

    @isTest
    static void nomatchpatternNullTest() {
        String descmatch = ' ';
        String converted = null;
        String subject = 'TDA Credit request - $45,000.00 card# 1058 3443, 5334';
        String convertedSubject = subject;
        Test.startTest();
        Case casenew = new Case();
        casenew.RecordTypeId = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('CTS Support').getRecordTypeId();//getRecordTypeInfosByName().get('NewCase').getRecordTypeId();
        System.Debug(LoggingLevel.INFO, 'Testing nomatchpatternNullTest1 case insert trigger1 = ' + casenew.Description);
        casenew.Description = descmatch;
        System.Debug(LoggingLevel.INFO, 'Testing nomatchpatternNullTest2 case insert trigger2 = ' + casenew.Description);
        casenew.Subject = subject;
        casenew.Application_ID__c ='ABC123';
        insert casenew;
        Case caseretrieved =[SELECT Description, Subject FROM Case WHERE Application_ID__c = :casenew.Application_ID__c Limit 1];
        System.Debug(LoggingLevel.INFO, 'Testing nomatchpatternNullTest3 case insert trigger3 = '+ caseretrieved.Description);
        System.Debug(LoggingLevel.INFO, 'Testing nomatchpatternNullTest4 case insert trigger4 = '+ caseretrieved.Subject);
        System.assertEquals(converted, caseretrieved.Description);
        System.assertEquals(convertedSubject, caseretrieved.Subject);
        
        caseretrieved.Description = descmatch;
        caseretrieved.Subject = subject;
        update caseretrieved;
        Case caseupdated =[SELECT Description, Subject FROM Case WHERE Application_ID__c = :casenew.Application_ID__c];
        System.Debug(LoggingLevel.INFO, 'Testing nomatchpatternNullTest1 case update trigger desc = '+ caseupdated.Description);
        System.Debug(LoggingLevel.INFO, 'Testing nomatchpatternNullTest2 case update trigger subj = '+ caseupdated.Subject);
        System.assertEquals(converted, caseupdated.Description);
        System.assertEquals(convertedSubject, caseupdated.Subject);
        Test.stopTest();
         
    }


}