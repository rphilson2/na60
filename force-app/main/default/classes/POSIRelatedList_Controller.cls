// Author: Alexander Nourbakhsh
// Date Created/Modified: 01.31.2017
// Project: POSI Grid
// Purpose: 
//

public class POSIRelatedList_Controller {

    private list<POSI__c> POSI = new List<POSI__c>();
    private boolean renderPage = True;
    
    public POSIRelatedList_Controller(ApexPages.StandardController controller) {
        
                try{
            // SOQL statements to build sObject lists                      
            POSI = [SELECT Id, Name, Account__c, Account__r.Name, CreatedById, CreatedDate
                    FROM POSI__c 
                    WHERE Account__c = :ApexPages.currentPage().getParameters().get('id')
                    LIMIT 50000];        
      
                } catch (exception e) {
            
           renderPage = false;
                }      
    }
    
        public list<POSI__C> getPOSI() {
                return POSI;
    }    
    public boolean getRenderPage() {
        return renderPage;
    } 
}