@istest
public class notifyOwner_Test {

    public static testMethod void qualifyRecords() {
      //DAG 07/17/2018 changed the Profile here from Super User.  Super User no longer has enough permissions to run this.         
        Profile prof = [SELECT Id 
                        FROM Profile 
                        WHERE Name='Custom System Admin'
                        LIMIT 1];
        
        User testUser = new User(Alias = 'testUser', Email='testuser@fnni.com', 
                           EmailEncodingKey='UTF-8', LastName='Tester', 
                           LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = prof.Id,
               TimeZoneSidKey='America/Los_Angeles', UserName='testuser@fnni.com');
        
        List<Account> accts = new List<Account>();
        
        Account Test1 = new Account(name = 'ownerTest1',
                                         Reason_for_changing_owner__c = 'test reason',
                                         ownerId = '005a000000BtQ2C');
        accts.add(Test1);
            
        Account Test2 = new Account(name = 'ownerTest2',
                                         Reason_for_changing_owner__c = 'test reason',
                                       ownerid = '005a000000CMoTZ');
        accts.add(Test2);
        
        Account Test3 = new Account(name = 'ownerTest3',
                                         Reason_for_changing_owner__c = 'test reason');
    accts.add(Test3);
        
        insert accts;
        
        
        for(Account acct : accts) {
            acct.ownerid = '005a000000CMoTZ';
        }
        System.runAs(testUser){   
          update accts;
        } 
        
        List<Account> accts2 = new List<Account>();
        
        Account Test4 = new Account(name = 'ownerTest4',
                                         Reason_for_changing_owner__c = 'test reason',
                                         ownerId = '005a000000CLOKt');
        accts2.add(Test4);
            
        Account Test5 = new Account(name = 'ownerTest5',
                                         Reason_for_changing_owner__c = 'test reason',
                                       ownerid = '005a000000CMoTZ');
        accts2.add(Test5);
        
        Account Test6 = new Account(name = 'ownerTest6',
                                         Reason_for_changing_owner__c = 'test reason');
    accts2.add(Test6);
        
        insert accts2;
         for(Account acct : accts2) {
            acct.ownerid = '005a000000CLOKt';
        }
        update accts2;
        
    } 
}