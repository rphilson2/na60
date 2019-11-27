public class ProspectProfileExtension {
public Prospect_Profile__c Prospect_Profile {get;set;}

public ProspectProfileExtension(ApexPages.standardController stdController){
    Prospect_Profile = (Prospect_Profile__c)stdController.getRecord();
    Prospect_Profile.Account__c = ApexPages.currentPage().getParameters().get('Account__c');
    Prospect_Profile.Name = ApexPages.currentPage().getParameters().get('Name');
    Prospect_Profile.Accounting_Firm__c = ApexPages.currentPage().getParameters().get('Accounting_Firm__c');
    Prospect_Profile.Legal_Firm__c = ApexPages.currentPage().getParameters().get('Legal_Firm__c');
}}