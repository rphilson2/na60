public with sharing class UICreateScreenFromRouteController
{
    public String RecordId {get; set;}
    transient Savepoint sp;
    
    public nFORCE__Route__c starting_route;
    public String screenNameGS {get; set;}
    public Boolean screenDisablePrintGS {get; set;}
    public Boolean screenShowContextObjectNameGS {get; set;}
    
    public Boolean addDataGridScreenSectionsGS {get; set;}
    public String numberOfDataGridScreenSectionsGS {get; set;}
    public Boolean addRelatedListScreenSectionsGS {get; set;}
    public String numberOfRelatedListScreenSectionsGS {get; set;}

    public UICreateScreenFromRouteController() {}
    
    public UICreateScreenFromRouteController(ApexPages.StandardController stdController)
    {
        RecordId = stdController.getId();
    }

    public void insertScreens()
    {        
        sp = Database.setSavepoint();
            
        //INSERT SCREEN
        nFORCE__Route__c theRoute = [SELECT ID, Name, nFORCE__Screen__c FROM nFORCE__Route__c WHERE Id = :RecordId];        
        if (screenNameGS.length() == 0)
        {
            screenNameGS = theRoute.Name;
        }
        nFORCE__Screen__c screen = new nFORCE__Screen__c(Name = screenNameGS, nFORCE__Disable_Print__c = screenDisablePrintGS, 
            nFORCE__Show_Link_To_Context_Object__c = screenShowContextObjectNameGS);
        insert screen;
          
        //INSERT SCREEN SECTION(S)
        List<nFORCE__Screen_Section__c> dataGridSS = new List<nFORCE__Screen_Section__c>();
        List<nFORCE__Screen_Section__c> relatedListSS = new List<nFORCE__Screen_Section__c>();
           
        Integer mainCount = 1;
        if (addDataGridScreenSectionsGS)
        {

            if (numberOfDataGridScreenSectionsGS.length() == 0 || !numberOfDataGridScreenSectionsGS.isNumeric())
            {
                numberOfDataGridScreenSectionsGS = '1';
            }                
                
            Integer count = 1;
            while (count <= Integer.valueof(numberOfDataGridScreenSectionsGS.trim()))
            {
                nFORCE__Screen_Section__c tempScreenSection = new nFORCE__Screen_Section__c(Name = 'DataGrid-' + count, nFORCE__Screen__c = screen.Id, nFORCE__sObject_Type__c = 'LLC_BI__Loan__c',
                    nFORCE__Section_Resource__c = 'MappedSObjectScreenResource', nFORCE__Default_Rendered__c = TRUE, nFORCE__Display_Toggle_Header__c = TRUE, 
                    nFORCE__Display_Toggle_Effect__c = 'slide', nFORCE__Display_Order__c = mainCount, nFORCE__Is_Editable__c = TRUE, nFORCE__Default_Editable__c = TRUE);
                dataGridSS.add(tempScreenSection);
                count++;
                mainCount++;           
            }
            insert dataGridSS;
        }
        
        if (addRelatedListScreenSectionsGS )
        {
            if (numberOfRelatedListScreenSectionsGS.length() == 0 || !numberOfRelatedListScreenSectionsGS.isNumeric())
            {
                numberOfRelatedListScreenSectionsGS = '1';                   
            }

            Integer count = 1;
            while (count <= Integer.valueof(numberOfRelatedListScreenSectionsGS.trim()))
            {
                nFORCE__Screen_Section__c tempScreenSection = new nFORCE__Screen_Section__c(Name = 'RelatedList-' + count, nFORCE__Screen__c = screen.Id, nFORCE__sObject_Type__c = 'LLC_BI__Loan__c',
                    nFORCE__Section_Resource__c = 'MappedSObjectHierarchyScreenResource', nFORCE__Default_Rendered__c = TRUE, nFORCE__Display_Toggle_Header__c = TRUE, 
                    nFORCE__Display_Toggle_Effect__c = 'slide', nFORCE__Display_Order__c = mainCount, nFORCE__Is_Editable__c = TRUE, nFORCE__Default_Editable__c = TRUE);
                relatedListSS.add(tempScreenSection);
                count++;
                mainCount++;
            }
            insert relatedListSS;                        
        }
            
        //ASSOCIATE SCREEN TO ROUTE
        theRoute.nFORCE__Screen__c = screen.Id;
        update theRoute;
        starting_route = theRoute;
    }
    
    public PageReference routeRedirect()
    {
        try
        {
            if(screenNameGS.length() == 0)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please specify a Screen Name.'));  
                return null;            
            }
            else if (addDataGridScreenSectionsGS == TRUE && numberOfDataGridScreenSectionsGS.length() == 0)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please specify how many data grid screen sections to create.'));  
                return null;                        
            }
            else if (addRelatedListScreenSectionsGS == TRUE && numberOfRelatedListScreenSectionsGS.length() == 0)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please specify how many related list screen sections to create.'));  
                return null;                         
            }
            else
            {
                sp = Database.setSavepoint();
                insertScreens();
                
                PageReference route_page = new ApexPages.StandardController(starting_route).view();
                route_page.setRedirect(true);   
                return route_page;             
            }              
        }
        catch(Exception e)
        {
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Adding Screens:  ' + e));  
            return null;
        }
    }    
}