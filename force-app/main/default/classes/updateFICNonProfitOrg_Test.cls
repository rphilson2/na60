@isTest
public class updateFICNonProfitOrg_Test {
   @isTest
    public static void compareNonProfitOrg_UpdateNonProfitOrg() {
              
        Id grantRecordTypeId = [SELECT Id
                                FROM RecordType
                                WHERE sObjectType = 'FIC_Survey_Application__c'
                                AND Name = 'Donation/Sponsorship'
                                LIMIT 1].id;
        
        Volunteer_Organization__c volOrg = new Volunteer_Organization__c(name = 'test Vol Org');
        insert volOrg;

        Volunteer_Organization__c volOrgII = new Volunteer_Organization__c(name = 'test Vol OrgII');
        insert volOrgII;
        
        FIC_Survey_Application__c ficsurveyAppDon = new FIC_Survey_Application__c(Market__c = 'Omaha',
                                                                                  Organization_City__c = 'Omaha',
                                                                                  RecordTypeId = grantRecordTypeId,
                                                                                  Amount_Requested__c = 1000,
                                                                                  Conversion_Type__c = 'Donation',
                                                                                  Program_Event_Description__c = 'Test',
                                                                                  Provide_Name_and_Service_Description__c = 'Test test Test',
                                                                                  Program_Event_Name__c = 'Test',
                                                                                  First_National_Bank_Request__c = True,
                                                                                  Briefly_Describe_Community_Issue__c = 'More Test',
                                                                                  Briefly_Describe_Community_Success__c = 'More More Test',
                                                                                  Non_Profit_Organization__c = volOrg.Id);
        Insert ficsurveyAppDon;
        
        Blob attachbodyDon = Blob.valueOf('Attach Body Blob');
        
        Attachment attachDon = new Attachment(parentId = ficsurveyAppDon.id,
                                              name = 'attachment test',
                                              body = attachbodyDon);
        
        insert attachDon;
        
        ficsurveyAppDon.Conversion__c = True;
        
        update ficsurveyAppDon;
        
        Community_Giving__c commGivingDon = [SELECT Id, FIC_Survey_Application__c, Market__c, Non_Profit_Organization__c
                            FROM Community_Giving__c
                            WHERE FIC_Survey_Application__c =: ficsurveyAppDon.Id
                            LIMIT 1];
        
        System.assertEquals(ficsurveyAppDon.Id, commGivingDon.FIC_Survey_Application__c);
        System.assertEquals('Omaha', commGivingDon.Market__c);
        
        Id commGivingDonId = [SELECT Id, FIC_Survey_Application__c
                            FROM Community_Giving__c
                            WHERE FIC_Survey_Application__c =: ficsurveyAppDon.Id
                            LIMIT 1].Id;
        
        Id commGivingDonAttachment = [SELECT Id, ParentId
                                      FROM Attachment
                                      WHERE ParentId =: commGivingDonId].ParentId;
        
        Id ficsurveyAppDonCommGivingId = [SELECT Id, Community_Investment__c
                                          FROM FIC_Survey_Application__c
                                          WHERE Community_Investment__c =: commGivingDonId].Community_Investment__c;
        
        System.assertEquals(ficsurveyAppDonCommGivingId, commGivingDonId);
        System.assertEquals(commGivingDonAttachment, commGivingDonId);
        
        Community_Giving__c commGivingDonII = [SELECT Id, FIC_Survey_Application__c, Market__c, Non_Profit_Organization__c
                            FROM Community_Giving__c
                            WHERE FIC_Survey_Application__c =: ficsurveyAppDon.Id
                            LIMIT 1];

        commGivingDonII.Non_Profit_Organization__c = VolOrgII.id;
        
        update commGivingDonII;
      //updateFICNonProfitOrg.compareNonProfitOrg(Trigger.oldMap, Trigger.new);
        
        FIC_Survey_Application__c checkFICNonProfit1 = [SELECT id, name, Non_Profit_Organization__c, update_code__c from FIC_Survey_Application__c where id =: ficsurveyAppDon.Id];
        System.assertEquals(VolOrgII.id, checkFICNonProfit1.Non_Profit_Organization__c);
        System.assertEquals('XX', checkFICNonProfit1.Update_Code__c);
    }
   @isTest
    public static void compareNonProfitOrg_UpdateAnotherField() {
              
        Id donRecordTypeId = [SELECT Id
                                FROM RecordType
                                WHERE sObjectType = 'FIC_Survey_Application__c'
                                AND Name = 'Donation/Sponsorship'
                                LIMIT 1].id;
        
        Volunteer_Organization__c volOrg = new Volunteer_Organization__c(name = 'test Vol Org');
        insert volOrg;

        Volunteer_Organization__c volOrgII = new Volunteer_Organization__c(name = 'test Vol OrgII');
        insert volOrgII;
        
        FIC_Survey_Application__c ficsurveyAppDon = new FIC_Survey_Application__c(Market__c = 'Omaha',
                                                                                  Organization_City__c = 'Omaha',
                                                                                  Amount_Requested__c = 1000,
                                                                                  Conversion_Type__c = 'Donation',
                                                                                  Program_Event_Description__c = 'Test',
                                                                                  Provide_Name_and_Service_Description__c = 'Test test Test',
                                                                                  Program_Event_Name__c = 'Test',
                                                                                  First_National_Bank_Request__c = True,
                                                                                  Briefly_Describe_Community_Issue__c = 'More Test',
                                                                                  Briefly_Describe_Community_Success__c = 'More More Test',
                                                                                  Non_Profit_Organization__c = volOrg.Id,
                                                                                  RecordTypeid = donRecordTypeId);
        Insert ficsurveyAppDon;
        
        ficsurveyAppDon.Conversion__c = True;
        
        update ficsurveyAppDon;
        
        Community_Giving__c commGivingDon = [SELECT Id, FIC_Survey_Application__c, Non_Profit_Organization__c, Market__c
                            FROM Community_Giving__c WHERE FIC_Survey_Application__c =: ficsurveyAppDon.Id
                            LIMIT 1];
        
        System.assertEquals(ficsurveyAppDon.Id, commGivingDon.FIC_Survey_Application__c);
        System.assertEquals('Omaha', commGivingDon.Market__c);
        
        commGivingDon.Market__c = 'North Platte';
        
        update commGivingDon;
        
        Community_Giving__c checkCommGiv = [SELECT id, name, Market__c from Community_Giving__c where id =: commGivingDon.Id];
        FIC_Survey_Application__c checkFICNonProfit = [SELECT id, name, Market__c from FIC_Survey_Application__c where id =: ficsurveyAppDon.Id];
        
        System.assertEquals('North Platte', checkCommGiv.Market__c);
        System.assertEquals('Omaha', checkFICNonProfit.Market__c);
    }
   @isTest
    public static void compareNonProfitOrg_NoFIC() {
              
        Volunteer_Organization__c volOrg = new Volunteer_Organization__c(name = 'test Vol Org');
        insert volOrg;

        Volunteer_Organization__c volOrgII = new Volunteer_Organization__c(name = 'test Vol OrgII');
        insert volOrgII;
        
        Community_Giving__c CommGivingDon = new Community_Giving__c(Market__c = 'Omaha',
                                                                 Amount_Requested__c = 1000,
                                                                 Non_Profit_Organization__c = volOrg.Id);
        Insert CommGivingDon;
        
        commGivingDon.Market__c = 'North Platte';
        
        update commGivingDon;
        
        Community_Giving__c checkCommGiv = [SELECT id, name, Market__c from Community_Giving__c where id =: commGivingDon.Id];
        
        System.assertEquals('North Platte', checkCommGiv.Market__c);
    }                
}