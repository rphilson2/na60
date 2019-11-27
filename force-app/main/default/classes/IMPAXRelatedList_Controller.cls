// Author: Dallas Grafton
// Date Created/Modified: 01.04.2018
// Project: IMPAX VF page
// Purpose: 
//

public class IMPAXRelatedList_Controller {

    private list<IMPAX__c> IMPAX = new List<IMPAX__c>();
    private boolean renderPage = True;
    
    public IMPAXRelatedList_Controller(ApexPages.StandardController controller) {
        
                try{
            // SOQL statements to build sObject lists                      
            IMPAX = [SELECT Id, Name, Account__c, Account__r.Name, CreatedById, LastModifiedById, CreatedDate, LastModifiedDate
                    FROM IMPAX__c 
                    WHERE Account__c = :ApexPages.currentPage().getParameters().get('id')
                    LIMIT 50000];        
      
                } catch (exception e) {
            
           renderPage = false;
                }      
    }
    
        public list<IMPAX__C> getIMPAX() {
                return IMPAX;
    }
    
}