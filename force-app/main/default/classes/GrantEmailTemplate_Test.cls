@isTest
public class GrantEmailTemplate_Test {
    @istest
    public static void GrantEmailTemplate1(){
       test.starttest();
     
        contact facemarklist=new contact();
          facemarklist.lastname='TestName';
          facemarklist.CRA_Contact_Title__c='TestTitle';
          facemarklist.Email='TestEmail@gmail.com';
          facemarklist.CRA_Market_Name__c='Kansas';
           insert facemarklist;
        
       Community_Giving__c  CMG= new Community_Giving__c();
        CMG.Market__c='Kansas';
        CMG.requestor_Email__c='Test@gmail.com';
        CMG.Grant_Contact_Email__c='Test1@gmail.com';
        CMG.Reviewed_by_MCIC_Decision__c='Approved';
        CMG.purpose__c='Educated Workforce';
        CMG.Awarded_date__c = Date.newInstance(2017, 12, 9);
            insert CMG ;        
        //Emailtemplate 
        string count='2';
        apexpages.StandardController con =new apexpages.StandardController(CMG);
        GrantEmailTemplate d  = new GrantEmailTemplate(con);
         PageReference pageRef = Page.AtodecisionTemplate1; // Add your VF page Name here
        pageRef.getParameters().put('filecount',count);
         Test.setCurrentPage(pageRef);
        
         list<Attachment>Attach=new list<Attachment>();
        list<string>lstnames=new list<string>();
        list<id>ids=new list<id>();
        for(integer i=1; i<=3;i++){
         Attachment attachs=new Attachment();       
          attachs.Name='Unit Test Attachment';
          Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
          attachs.body=bodyBlob;
          attachs.parentId=CMG.id;
          Attach.add(attachs);
            
        }
        insert Attach;
        system.assertnotequals(2,Attach.size());
       
       /*for(integer i=1;i<=integer.valueof(count); i++){
            attach.add(new Attachment());
        }*/
      

        
        d.blockBool=false;
        d.FromAddress='test@fnni.com';
        d.toAddress='test1@fnni.com';
        d.templateDeveName='testing';
        d.sendEmail();
        //d.dispatcher();
        d.findTemplate(new Community_Giving__c());
      //d.filecount='2';
      //d.addattachment();
      //d.Uploaddoc();
       test.stoptest();
       
    }

    public static void GrantEmailTemplate2(){
       test.starttest();
     
        contact facemarklist=new contact();
          facemarklist.lastname='TestName';
          facemarklist.CRA_Contact_Title__c='TestTitle';
          facemarklist.Email='TestEmail@gmail.com';
          facemarklist.CRA_Market_Name__c='Kansas';
           insert facemarklist;
        
       Community_Giving__c  CMG= new Community_Giving__c();
        CMG.Market__c='Kansas';
        CMG.requestor_Email__c='Test@gmail.com';
        CMG.Grant_Contact_Email__c='Test1@gmail.com';
        CMG.Reviewed_by_MCIC_Decision__c='Approved';
        CMG.purpose__c='Educated Workforce';
        CMG.Awarded_date__c = null;
            insert CMG ;        
        //Emailtemplate 
        string count='2';
        apexpages.StandardController con =new apexpages.StandardController(CMG);
        GrantEmailTemplate d  = new GrantEmailTemplate(con);
         PageReference pageRef = Page.AtodecisionTemplate1; // Add your VF page Name here
        pageRef.getParameters().put('filecount',count);
         Test.setCurrentPage(pageRef);
        
         list<Attachment>Attach=new list<Attachment>();
        list<string>lstnames=new list<string>();
        list<id>ids=new list<id>();
        for(integer i=1; i<=3;i++){
         Attachment attachs=new Attachment();       
          attachs.Name='Unit Test Attachment';
          Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
          attachs.body=bodyBlob;
          attachs.parentId=CMG.id;
          Attach.add(attachs);
            
        }
        insert Attach;
        system.assertnotequals(2,Attach.size());
       
       /*for(integer i=1;i<=integer.valueof(count); i++){
            attach.add(new Attachment());
        }*/
      

        
        d.blockBool=false;
        d.FromAddress='test@fnni.com';
        d.toAddress='test1@fnni.com';
        d.templateDeveName='testing';
        d.sendEmail();
        //d.dispatcher();
        d.findTemplate(new Community_Giving__c());
      //d.filecount='2';
      //d.addattachment();
      //d.Uploaddoc();
       test.stoptest();
       
    }
   
}