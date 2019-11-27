@isTest
private class COIDupTriggerClass{
    
    @isTest
    static void test1()
    {
        COI__c coi = new COI__c( Name = 'Test123', Company__c = 'Test456');
        insert coi;
        coi = [select Id, Name, Company__c from COI__c where Id = :coi.Id];
        System.assertEquals(coi.Name, 'Test123');
    }
}