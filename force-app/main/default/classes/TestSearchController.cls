// Apex test methods for the SearchController class.
@isTest
private class TestSearchController{

    public static testmethod void t1(){
    	
        Set<String> displayFieldNames = new Set<String>();    
        displayFieldNames.add('Id');    
        displayFieldNames.add('Name');
        String tableName = 'Account';
        
        Map<String, String> searchFieldValues = new Map<String, String>();
        searchFieldValues.put('Name', 'United Partners');
        
        List<String> defaultWhereClause = new List<String>();
        String result 	= 'Select Id,Name From Account Where Name like \'%United Partners%\'';
        String query 	= SearchLib.buildQueryString( tableName, displayFieldNames, defaultWhereClause, searchFieldValues, new Map<String, String[]>() );
        System.assertEquals( result,query );    
        
        
    }

    public static void search( SearchRequest req ){
    	
        req.dump();
        SearchController controller = new SearchController();
        controller.setSearchObject( req );
        controller.search();
        
        System.assert( controller.getShowResults() == true );
        List<SearchResultFactory.ResultObject> searchResults = controller.getResults();
        
        controller.getSearchObject();
        controller.getNoResults();
        controller.setEventType( 'event' );
        
        for( SearchResultFactory.ResultObject res : searchResults ){
            res.dump();
        }
    }
    
    public static testmethod void searchTest(){
    
        SearchRequest searchObject = new SearchRequest();
        
        List<SelectOption> activityCategories = searchObject.getFilter1Picklist();
        String[] actCategoryNames = new String[activityCategories.size()];
        integer index = 0;
        
        for( SelectOption activityCat : activityCategories ){
            actCategoryNames[index++] = activityCat.getLabel();
        }
        
        //Case1
        searchObject.setField1Value('Red');
        searchObject.setField2Value('');
        searchObject.setField3Value('San Francisco');
        searchObject.setField5Value('true');
        String[] actCatValues = new String[] {actCategoryNames[0], actCategoryNames[1]};
        search( searchObject );
        
        //Case 2
        searchObject.setField1Value('');
        searchObject.setField2Value('');
        searchObject.setField3Value('');
        searchObject.setField5Value('false');
        search( searchObject );
        
        //Case 3
        searchObject.setFilter1Value(null);
        search( searchObject );
        
        //Case 3
        searchObject.setFilter1Value( actCategoryNames );
        search( searchObject );
    }
}