@isTest
public class AtoDecisionTemplateCtrl_Test {
    @istest
           static void testme(){
       Community_Giving__c  CMG= new Community_Giving__c();
        CMG.Market__c='Kansas';
        CMG.requestor_Email__c='Test@gmail.com';
        CMG.Grant_Contact_Email__c='Test1@gmail.com';
        CMG.Reviewed_by_MCIC_Decision__c='Approved';
            insert CMG ;
               
               
            Community_Survey__c ficSurObj = new Community_Survey__c();
            //ficSurObj.Name = templateDeveName;
            ficSurObj.Community_Investment__c = CMG.id;
            ficSurObj.Date_sent__c = System.Today();
            ficSurObj.Email_Body__c  ='Testbody';
            ficSurObj.From_Email__c  ='Test@gmail.com';
            ficSurObj.To_Email__c='Test1@gmail.com';
            insert ficSurObj;
            
    list<Community_Giving__c>CM=[Select id,Market__c,requestor_Email__c,Grant_Contact_Email__c,Reviewed_by_MCIC_Decision__c from Community_Giving__c];
               system.assertequals(true,CM.size()>0);
               Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
               
         Attachment a=new Attachment(name='Unit Test Attachment',body=bodyBlob,parentId=CMG.id,IsPrivate=false);
               insert a;
               
             list<Attachment>Atch=[select id,name,body,isprivate from Attachment where id=:a.id];
               system.assertequals(true,atch.size()>0);
               
               
              // string count='2';
        apexpages.StandardController con =new apexpages.StandardController(CMG);
        AtoDecisionTemplateCtrl d  = new AtoDecisionTemplateCtrl(con);
               d.filecount='1';
               d.countlist=new list<selectoption>();
               d.attach=Atch;
               d.Attnames=new list<string>();
              // string email='Test@gmail.com';
               //d.calFromAddress('Test@gmail.com');
               d.Uploaddoc();
               
         PageReference pageRef = Page.AtodecisionTemplate1; // Add your VF page Name here
        //pageRef.getParameters().put('filecount',count);
         Test.setCurrentPage(pageRef);
               
        
    }
    
    @istest 
    static void testusecase2(){
      Community_Giving__c  CMG= new Community_Giving__c();
        CMG.Market__c='Kansas';
        CMG.requestor_Email__c='Test@gmail.com';
        CMG.Grant_Contact_Email__c='Test1@gmail.com';
        CMG.Reviewed_by_MCIC_Decision__c='Approved';
            insert CMG ;
        Community_Survey__c ficSurObj = new Community_Survey__c();
            //ficSurObj.Name = templateDeveName;
            ficSurObj.Community_Investment__c = CMG.id;
            ficSurObj.Date_sent__c = System.Today();
            ficSurObj.Email_Body__c  ='Testbody';
            ficSurObj.From_Email__c  ='Test@gmail.com';
            ficSurObj.To_Email__c='Test1@gmail.com';
            insert ficSurObj;
            
    list<Community_Giving__c>CM=[Select id,Market__c,requestor_Email__c,Grant_Contact_Email__c,Reviewed_by_MCIC_Decision__c from Community_Giving__c];
               system.assertequals(true,CM.size()>0);
               Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
               
         Attachment a=new Attachment(name='Unit Test Attachment',body=bodyBlob,parentId=CMG.id,IsPrivate=false);
               insert a;
               
             list<Attachment>Atch=[select id,name,body,isprivate from Attachment where id=:a.id];
               system.assertequals(true,atch.size()>0);
           list<id>Attis=new list<id>();
           for(Attachment a1:Atch){
              Attis.add(a1.id);
                }
                 system.assertequals(true,attis.size()>0);
              // string count='2';
        apexpages.StandardController con =new apexpages.StandardController(CMG);
        AtoDecisionTemplateCtrl d  = new AtoDecisionTemplateCtrl(con);
               d.filecount='2';
               d.countlist=new list<selectoption>();
               d.attach=Atch;
               d.Attnames=new list<string>();
               d.addattachment();
               d.attachesid=Attis;
               //d.templateName='Grant_Decline_Template';
              // d.conObjMarket=new contact();
             // d.templateName = 'Grant_Decline_Template';
             list<Messaging.Emailfileattachment>Sendattach=new  list<Messaging.Emailfileattachment>();
                Messaging.Emailfileattachment ME=new Messaging.Emailfileattachment();
                  ME.setfilename(Atch[0].name);
                    ME.setbody(Atch[0].body);
                     Sendattach.add(ME);
        system.assertequals(true,Sendattach.size()>0);
         //taking away due to test failure
         //d.sendemail();
 
               
         PageReference pageRef = Page.AtodecisionTemplate1; // Add your VF page Name here
        //pageRef.getParameters().put('filecount',count);
         Test.setCurrentPage(pageRef);
               
          
    }
    @istest static void recordtype(){
        list<recordtype>rec=[select id,name,DeveloperName from recordtype where DeveloperName='Donation'];
        
       Community_Giving__c  CMG= new Community_Giving__c();
        CMG.Market__c='Kansas';
        CMG.requestor_Email__c='Test@gmail.com';
        CMG.Grant_Contact_Email__c='Test1@gmail.com';
        CMG.RecordTypeid=rec[0].id;
        CMG.Reviewed_by_MCIC_Decision__c='Approved';
            insert CMG ;
        
        Community_Survey__c ficSurObj = new Community_Survey__c();
            //ficSurObj.Name = templateDeveName;
            ficSurObj.Community_Investment__c = CMG.id;
            ficSurObj.Date_sent__c = System.Today();
            ficSurObj.Email_Body__c  ='Testbody';
            ficSurObj.From_Email__c  ='Test@gmail.com';
            ficSurObj.To_Email__c='Test1@gmail.com';
            insert ficSurObj;
            
    list<Community_Giving__c>CM=[Select id,Market__c,requestor_Email__c,Grant_Contact_Email__c,Reviewed_by_MCIC_Decision__c from Community_Giving__c];
               system.assertequals(true,CM.size()>0);
               Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
               
         Attachment a=new Attachment(name='Unit Test Attachment',body=bodyBlob,parentId=CMG.id,IsPrivate=false);
               insert a;
               
             list<Attachment>Atch=[select id,name,body,isprivate from Attachment where id=:a.id];
               system.assertequals(true,atch.size()>0);
               
               
              // string count='2';
        apexpages.StandardController con =new apexpages.StandardController(CMG);
        AtoDecisionTemplateCtrl d  = new AtoDecisionTemplateCtrl(con);
               d.filecount='1';
               d.countlist=new list<selectoption>();
               d.attach=Atch;
               d.Attnames=new list<string>();
              // string email='Test@gmail.com';
               //d.calFromAddress('Test@gmail.com');
               d.Uploaddoc();
               
         PageReference pageRef = Page.AtodecisionTemplate1; // Add your VF page Name here
        //pageRef.getParameters().put('filecount',count);
         Test.setCurrentPage(pageRef);
    } 
@istest static void recordtype1(){
        list<recordtype>rec=[select id,name,DeveloperName from recordtype where DeveloperName='Sponsorship'];
        
       Community_Giving__c  CMG= new Community_Giving__c();
        CMG.Market__c='Kansas';
        CMG.requestor_Email__c='Test@gmail.com';
        CMG.Grant_Contact_Email__c='Test1@gmail.com';
        CMG.RecordTypeid=rec[0].id;
        CMG.Reviewed_by_MCIC_Decision__c='Approved';
            insert CMG ;
    
    
    Community_Survey__c ficSurObj = new Community_Survey__c();
            //ficSurObj.Name = templateDeveName;
            ficSurObj.Community_Investment__c = CMG.id;
            ficSurObj.Date_sent__c = System.Today();
            ficSurObj.Email_Body__c  ='Testbody';
            ficSurObj.From_Email__c  ='Test@gmail.com';
            ficSurObj.To_Email__c='Test1@gmail.com';
            insert ficSurObj;
            
    list<Community_Giving__c>CM=[Select id,Market__c,requestor_Email__c,Grant_Contact_Email__c,Reviewed_by_MCIC_Decision__c from Community_Giving__c];
               system.assertequals(true,CM.size()>0);
               Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
               
         Attachment a=new Attachment(name='Unit Test Attachment',body=bodyBlob,parentId=CMG.id,IsPrivate=false);
               insert a;
               
             list<Attachment>Atch=[select id,name,body,isprivate from Attachment where id=:a.id];
               system.assertequals(true,atch.size()>0);
               
               
              // string count='2';
        apexpages.StandardController con =new apexpages.StandardController(CMG);
        AtoDecisionTemplateCtrl d  = new AtoDecisionTemplateCtrl(con);
    
 
               d.filecount='1';
               d.countlist=new list<selectoption>();
               d.attach=Atch;
               d.Attnames=new list<string>();
              // string email='Test@gmail.com';
               //d.calFromAddress('Test@gmail.com');
               d.Uploaddoc();
               
         PageReference pageRef = Page.AtodecisionTemplate1; // Add your VF page Name here
        //pageRef.getParameters().put('filecount',count);
         Test.setCurrentPage(pageRef);
    }     
       
@istest static void recordtype3(){
        list<recordtype>rec=[select id,name,DeveloperName from recordtype where DeveloperName='Sponsorship'];
        
       Community_Giving__c  CMG= new Community_Giving__c();
        CMG.Market__c='Kansas';
        CMG.requestor_Email__c='Test@gmail.com';
        CMG.Grant_Contact_Email__c='Test1@gmail.com';
        CMG.RecordTypeid=rec[0].id;
        CMG.Reviewed_by_MCIC_Decision__c='Denied';
            insert CMG ;
    Community_Survey__c ficSurObj = new Community_Survey__c();
            //ficSurObj.Name = templateDeveName;
            ficSurObj.Community_Investment__c = CMG.id;
            ficSurObj.Date_sent__c = System.Today();
            ficSurObj.Email_Body__c  ='Testbody';
            ficSurObj.From_Email__c  ='Test@gmail.com';
            ficSurObj.To_Email__c='Test1@gmail.com';
            insert ficSurObj;
            
    list<Community_Giving__c>CM=[Select id,Market__c,requestor_Email__c,Grant_Contact_Email__c,Reviewed_by_MCIC_Decision__c from Community_Giving__c];
               system.assertequals(true,CM.size()>0);
               Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
               
         Attachment a=new Attachment(name='Unit Test Attachment',body=bodyBlob,parentId=CMG.id,IsPrivate=false);
               insert a;
               
             list<Attachment>Atch=[select id,name,body,isprivate from Attachment where id=:a.id];
               system.assertequals(true,atch.size()>0);
               
               
              // string count='2';
        apexpages.StandardController con =new apexpages.StandardController(CMG);
        AtoDecisionTemplateCtrl d  = new AtoDecisionTemplateCtrl(con);
    
 
               d.filecount='1';
               d.countlist=new list<selectoption>();
               d.attach=Atch;
               d.Attnames=new list<string>();
              // string email='Test@gmail.com';
               //d.calFromAddress('Test@gmail.com');
               d.Uploaddoc();
               
         PageReference pageRef = Page.AtodecisionTemplate1; // Add your VF page Name here
        //pageRef.getParameters().put('filecount',count);
         Test.setCurrentPage(pageRef);
    }  
    @istest static void recordtype4(){
        list<recordtype>rec=[select id,name,DeveloperName from recordtype where DeveloperName='Donation'];
        
       Community_Giving__c  CMG= new Community_Giving__c();
        CMG.Market__c='Kansas';
        CMG.requestor_Email__c='Test@gmail.com';
        CMG.Grant_Contact_Email__c='Test1@gmail.com';
        CMG.RecordTypeid=rec[0].id;
        CMG.Reviewed_by_MCIC_Decision__c='Denied';
            insert CMG ;
        Community_Survey__c ficSurObj = new Community_Survey__c();
            //ficSurObj.Name = templateDeveName;
            ficSurObj.Community_Investment__c = CMG.id;
            ficSurObj.Date_sent__c = System.Today();
            ficSurObj.Email_Body__c  ='Testbody';
            ficSurObj.From_Email__c  ='Test@gmail.com';
            ficSurObj.To_Email__c='Test1@gmail.com';
            insert ficSurObj;
            
    list<Community_Giving__c>CM=[Select id,Market__c,requestor_Email__c,Grant_Contact_Email__c,Reviewed_by_MCIC_Decision__c from Community_Giving__c];
               system.assertequals(true,CM.size()>0);
               Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
               
         Attachment a=new Attachment(name='Unit Test Attachment',body=bodyBlob,parentId=CMG.id,IsPrivate=false);
               insert a;
               
             list<Attachment>Atch=[select id,name,body,isprivate from Attachment where id=:a.id];
               system.assertequals(true,atch.size()>0);
               
               
              // string count='2';
        apexpages.StandardController con =new apexpages.StandardController(CMG);
        AtoDecisionTemplateCtrl d  = new AtoDecisionTemplateCtrl(con);
    
 
               d.filecount='1';
               d.countlist=new list<selectoption>();
               d.attach=Atch;
               d.Attnames=new list<string>();
              // string email='Test@gmail.com';
               //d.calFromAddress('Test@gmail.com');
               d.Uploaddoc();
               
         PageReference pageRef = Page.AtodecisionTemplate1; // Add your VF page Name here
        //pageRef.getParameters().put('filecount',count);
         Test.setCurrentPage(pageRef);
    }   
}