@isTest
public class processFicSurveyApps_Test {
  @isTest
    public static void processFicSurveyApps_Test() {
              
        Id grantRecordTypeId = [SELECT Id
                                FROM RecordType
                                WHERE sObjectType = 'FIC_Survey_Application__c'
                                AND Name = 'Grant'
                                LIMIT 1].id;
        
        Volunteer_Organization__c volOrg = new Volunteer_Organization__c(name = 'test Vol Org');
        insert volOrg;
        
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
                                                                                  Non_Profit_Organization__c = volOrg.Id);
        Insert ficsurveyAppDon;
        
        Blob attachbodyDon = Blob.valueOf('Attach Body Blob');
        
        Attachment attachDon = new Attachment(parentId = ficsurveyAppDon.id,
                                              name = 'attachment test',
                                              body = attachbodyDon);
        
        insert attachDon;
        
        ficsurveyAppDon.Conversion__c = True;
        
        update ficsurveyAppDon;
        
        Id commGivingDon = [SELECT Id, FIC_Survey_Application__c
                            FROM Community_Giving__c
                            WHERE FIC_Survey_Application__c =: ficsurveyAppDon.Id
                            LIMIT 1].FIC_Survey_Application__c;
        
        System.assertEquals(ficsurveyAppDon.Id, commGivingDon);
        System.assertEquals('Omaha', ficsurveyAppDon.Market__c);
        
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
        
        FIC_Survey_Application__c ficsurveyAppSpon = new FIC_Survey_Application__c(Market__c = 'Texas',
                                                                                  Organization_City__c = 'texas',
                                                                                  Amount_Requested__c = 1000,
                                                                                  Conversion_Type__c = 'Sponsorship',
                                                                                  Program_Event_Description__c = 'Test',
                                                                                  Provide_Name_and_Service_Description__c = 'Test test Test',
                                                                                  Program_Event_Name__c = 'Test',
                                                                                  First_National_Bank_Request__c = True,
                                                                                  Briefly_Describe_Community_Issue__c = 'More Test',
                                                                                  Briefly_Describe_Community_Success__c = 'More Texas More Test',
                                                                                  Non_Profit_Organization__c = volOrg.Id);
        Insert ficsurveyAppSpon;
        
        Blob attachbodySpon = Blob.valueOf('Attach Body Blob');
        
        Attachment attachSpon = new Attachment(parentId = ficsurveyAppDon.id,
                                              name = 'attachment test',
                                              body = attachbodySpon);
        
        insert attachSpon;
        
        ficsurveyAppSpon.Conversion__c = True;
        
        update ficsurveyAppSpon;
        
        Id commGivingSpon = [SELECT Id, FIC_Survey_Application__c
                            FROM Community_Giving__c
                            WHERE FIC_Survey_Application__c =: ficsurveyAppSpon.Id
                            LIMIT 1].FIC_Survey_Application__c;
        
        System.assertEquals(ficsurveyAppSpon.Id, commGivingSpon);
        System.assertEquals('Texas', ficsurveyAppSpon.Market__c);
        
        
        ficsurveyAppSpon.Conversion__c = False;
        try{
            update ficsurveyAppSpon;
        } catch (Exception e) {
            
            String exceptionMessage =  e.getMessage();
            System.assertNotEquals(null, exceptionMessage);
        }
        
        System.assertNotEquals(ficsurveyAppSpon.Conversion__c, null);
        
        // Grant
        
        FIC_Survey_Application__c ficsurveyAppGrant = new FIC_Survey_Application__c(
                                                                                  Organization_City__c = 'texas',
                                                                                  Amount_Requested__c = 1000,
                                                                                  G_Educated_Workforce__c = True,
                                                                                  G_Stable_Housing__c = True,
                                                                                  G_Strong_Local_Economies__c = True,
                                                                                  G_Neighborhood_Revitalization__c = True,
                                                                                  G_Eligible_for_Free_and_Reduced_Lunch__c = 10,
                                                                                  G_Schools_Free_and_Reduced_Lunch__c = 'test',
                                                                                  Conversion_Type__c = 'Grant',
                                                                                  Program_Event_Description__c = 'Test',
                                                                                  Provide_Name_and_Service_Description__c = 'Test test Test',
                                                                                  Program_Event_Name__c = 'Test',
                                                                                  recordTypeId = grantRecordTypeId,
                                                                                  First_National_Bank_Request__c = True,
                                                                                  Briefly_Describe_Community_Issue__c = 'More Test',
                                                                                  Briefly_Describe_Community_Success__c = 'More Texas More Test',
                                                                                  Non_Profit_Organization__c = volOrg.Id);
        Insert ficsurveyAppGrant;
        
        Blob attachbodyGrant = Blob.valueOf('Attach Body Blob');
        
        Attachment attachGrant = new Attachment(parentId = ficsurveyAppGrant.id,
                                              name = 'attachment test',
                                              body = attachbodySpon);
        
        insert attachGrant;
        
        ficsurveyAppGrant.Conversion__c = True;
        
        update ficsurveyAppGrant;
        
        Id commGivingGrant = [SELECT Id, FIC_Survey_Application__c
                            FROM Community_Giving__c
                            WHERE FIC_Survey_Application__c =: ficsurveyAppGrant.Id
                            LIMIT 1].FIC_Survey_Application__c;
        
        System.assertEquals(ficsurveyAppGrant.Id, commGivingGrant);
        
        
        ficsurveyAppSpon.Conversion__c = False;
        try{
            update ficsurveyAppGrant;
        } catch (Exception e) {
            
            String exceptionMessage =  e.getMessage();
            System.assertNotEquals(null, exceptionMessage);
        }
        
        System.assertNotEquals(ficsurveyAppGrant.Conversion__c, null);
        
        // Null
            
        FIC_Survey_Application__c ficsurveyAppNull = new FIC_Survey_Application__c(Market__c = 'Lincoln',
                                                                                  Organization_City__c = 'Lincoln',
                                                                                  Amount_Requested__c = 1000,
                                                                                  //Conversion_Type__c = 'Sponsorship',
                                                                                  Program_Event_Description__c = 'Test',
                                                                                  Provide_Name_and_Service_Description__c = 'Test test Test',
                                                                                  Program_Event_Name__c = 'Test Test',
                                                                                  First_National_Bank_Request__c = True,
                                                                                  Briefly_Describe_Community_Issue__c = 'More Test',
                                                                                  Briefly_Describe_Community_Success__c = 'More More Test',
                                                                                  Non_Profit_Organization__c = volOrg.Id);
        Insert ficsurveyAppNull;
        System.assertEquals('Lincoln', ficsurveyAppNull.Market__c);
        
        ficsurveyAppNull.Conversion__c = True;
        
        try {
            update ficsurveyAppNull;
        } catch (Exception e) {
        
            String exceptionMessage =  e.getMessage(); 
            System.assertNotEquals(null, exceptionMessage);
            
        }
        
        System.assertEquals(ficsurveyAppNull.Conversion_Date__c, null);
        
        
    }
    @isTest
    public static void processFicSurveyApps_FloodTest() {
              
        Id floodRecordTypeId = [SELECT Id
                                FROM RecordType
                                WHERE sObjectType = 'FIC_Survey_Application__c'
                                AND Name = 'Flood Relief'
                                LIMIT 1].id;
        
        Volunteer_Organization__c volOrg = new Volunteer_Organization__c(name = 'test Vol Org');
        insert volOrg;
        
        FIC_Survey_Application__c ficsurveyAppFlood = new FIC_Survey_Application__c(recordtypeid = floodRecordTypeId,
                                                                                  Market__c = 'Omaha',
                                                                                  Organization_City__c = 'Omaha',
                                                                                  Amount_Requested__c = 1000,
                                                                                  Conversion_Type__c = 'Flood Relief',
                                                                                  Program_Event_Description__c = 'Test',
                                                                                  Provide_Name_and_Service_Description__c = 'Test test Test',
                                                                                  Program_Event_Name__c = 'Test',
                                                                                  First_National_Bank_Request__c = True,
                                                                                  Flood_Describe_Impact__c = 'More Test',
                                                                                  Flood_Describe_Track_Record__c = 'More More Test',
                                                                                  Non_Profit_Organization__c = volOrg.Id);
        Insert ficsurveyAppFlood;
        
        Blob attachbodyFlood = Blob.valueOf('Attach Body Blob');
        
        Attachment attachFlood = new Attachment(parentId = ficsurveyAppFlood.id,
                                              name = 'attachment test',
                                              body = attachbodyFlood);
        
        insert attachFlood;
        
        ficsurveyAppFlood.Conversion__c = True;
        
        update ficsurveyAppFlood;
        
        Id commGivingFlood = [SELECT Id, FIC_Survey_Application__c
                            FROM Community_Giving__c
                            WHERE FIC_Survey_Application__c =: ficsurveyAppFlood.Id
                            LIMIT 1].FIC_Survey_Application__c;
        
        System.assertEquals(ficsurveyAppFlood.Id, commGivingFlood);
        System.assertEquals('Omaha', ficsurveyAppFlood.Market__c);
        
        Id commGivingFloodId = [SELECT Id, FIC_Survey_Application__c
                            FROM Community_Giving__c
                            WHERE FIC_Survey_Application__c =: ficsurveyAppFlood.Id
                            LIMIT 1].Id;
        
        Id commGivingFloodAttachment = [SELECT Id, ParentId
                                      FROM Attachment
                                      WHERE ParentId =: commGivingFloodId].ParentId;
        
        Id ficsurveyAppFloodCommGivingId = [SELECT Id, Community_Investment__c
                                          FROM FIC_Survey_Application__c
                                          WHERE Community_Investment__c =: commGivingFloodId].Community_Investment__c;
        
        System.assertEquals(ficsurveyAppFloodCommGivingId, commGivingFloodId);
        System.assertEquals(commGivingFloodAttachment, commGivingFloodId);
    }

    @isTest
    public static void processFicSurveyApps_FloodTest_code37() {
              
        Id floodRecordTypeId = [SELECT Id
                                FROM RecordType
                                WHERE sObjectType = 'FIC_Survey_Application__c'
                                AND Name = 'Flood Relief'
                                LIMIT 1].id;
        
        Volunteer_Organization__c volOrg = new Volunteer_Organization__c(name = 'test Vol Org');
        insert volOrg;

        Volunteer_Organization__c volOrg2 = new Volunteer_Organization__c(name = 'test Vol Org2');
        insert volOrg2;
        
        FIC_Survey_Application__c ficsurveyAppFlood = new FIC_Survey_Application__c(recordtypeid = floodRecordTypeId,
                                                                                  Market__c = 'Omaha',
                                                                                  Organization_City__c = 'Omaha',
                                                                                  Amount_Requested__c = 1000,
                                                                                  Conversion_Type__c = 'Flood Relief',
                                                                                  Program_Event_Description__c = 'Test',
                                                                                  Provide_Name_and_Service_Description__c = 'Test test Test',
                                                                                  Program_Event_Name__c = 'Test',
                                                                                  First_National_Bank_Request__c = True,
                                                                                  Flood_Describe_Impact__c = 'More Test',
                                                                                  Flood_Describe_Track_Record__c = 'More More Test',
                                                                                  Non_Profit_Organization__c = volOrg.Id);
        Insert ficsurveyAppFlood;
        
        Blob attachbodyFlood = Blob.valueOf('Attach Body Blob');
        
        Attachment attachFlood = new Attachment(parentId = ficsurveyAppFlood.id,
                                              name = 'attachment test',
                                              body = attachbodyFlood);
        
        insert attachFlood;
        
        ficsurveyAppFlood.Conversion__c = True;
        
        update ficsurveyAppFlood;
        
        community_giving__c commGivingFloodNP = [SELECT Id, FIC_Survey_Application__c, non_profit_organization__c, non_profit_organization__r.name
                            FROM Community_Giving__c
                            WHERE FIC_Survey_Application__c =: ficsurveyAppFlood.Id
                            LIMIT 1];
        
        commGivingFloodNP.non_profit_organization__c = volOrg2.id;
        update commGivingFloodNP;

        FIC_Survey_Application__c ficsurveyAppFloodNP = [SELECT Id, non_profit_organization__r.name from FIC_Survey_Application__c where id = : ficsurveyAppFlood.Id]; 
        
        System.assertEquals('test Vol Org2', ficsurveyAppFloodNP.non_profit_organization__r.name);
      //System.assertEquals(commGivingFloodAttachment, commGivingFloodId);
    }        
}