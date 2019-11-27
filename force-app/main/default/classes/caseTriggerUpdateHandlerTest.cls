@isTest
public class caseTriggerUpdateHandlerTest {
    public static String regex = '[.\\s]?\\d{4}[-\\s]?\\d{4}[-\\s]?\\d{4}[-\\s]?\\d{4}\\b';

    @isTest
    static void maskCaseDescriptionTest() {
        String descr = 'Hi Kristin - card# 1058 3444 3657 4555';
        String descChanged = caseTriggerUpdateHandler.maskCaseDescription(regex, descr);
        System.assertEquals('Hi Kristin - card#105834******4555', descChanged);
    }
    
    @isTest
    static void maskCaseSubjectTest() {
        String sub='About card# 1058 3444 3657 4555';
        String changed = caseTriggerUpdateHandler.maskCaseSubject(regex, sub);
        System.assertEquals('About card#105834******4555', changed);
    }
    
    @isTest
    static void beforeInsertUpdateCaseNullTest() {
        String changed = caseTriggerUpdateHandler.maskCaseDescription(regex, ' ');
        String changedSub = caseTriggerUpdateHandler.maskCaseSubject(regex, ' ');
        System.assertEquals(' ', changed);
        System.assertEquals(' ', changedSub);
    }
    
    @isTest
    static void beforeInsertUpdateCaseTest() {
        String descmatch = 'Hi Kristin - card# 1058 3443 5689 5673, written for $50,000.00, was deposited for $5,000.00 on 8/21.Requesting a credit in the amount of $45,000.00.Thank you.';
        String converted = 'Hi Kristin - card#105834******5673, written for $50,000.00, was deposited for $5,000.00 on 8/21.Requesting a credit in the amount of $45,000.00.Thank you.';
        String subject = 'TDA Credit request - $45,000.00 card#105834******5673';
        String convertedSubject = 'TDA Credit request - $45,000.00 card#105834******5673';
        Test.startTest();
        Case casenew = new Case();
        RecordType recordType = new RecordType(Name='NewCase');
        casenew.RecordTypeId = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('CTS Support').getRecordTypeId();//getRecordTypeInfosByName().get('NewCase').getRecordTypeId();
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

}