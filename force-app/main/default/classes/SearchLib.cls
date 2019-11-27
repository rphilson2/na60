/**
* Used for the search feature.
*/
public class SearchLib{
	
    List<SearchResultFactory.ResultObject> results = new List<SearchResultFactory.ResultObject>();
    
    /**
    * Action for querying results
    * @param input
    * @return queryResult
    */ 
    private List<SObject> queryResults( SearchRequest input ){ 
    	
        String tableName 				= input.getSearchObject();    
        Set<String> displayFieldNames 	= new Set<String>();
        
        for( String displayField : input.getResultColumns() ){
            displayFieldNames.add( displayField );
        }
    
        Map<String, String> fieldValueMap 			= input.getFieldValueMap();
        Map<String, String> digestedFieldValueMap 	= new Map<String, String>();
        
        for( String fieldName : fieldValueMap.keyset() ){
            String value = fieldValueMap.get( fieldName ); 
            
            if( value != null && value != '' ){
                digestedFieldValueMap.put( fieldName, value );
            }
        }   
                
        Map<String, String[]> filterMap 		= input.getFilterMap();
        Map<String, String[]> digestedFilterMap = new Map<String, String[]>();
        
        for( String fieldName : filterMap.keyset() ){
            String[] value = filterMap.get( fieldName );
             
            if( value != null && value.size() > 0 ){
                digestedFilterMap.put( fieldName, value );
            }
        }    
    
        String queryString = buildQueryString( tablename, displayFieldNames, input.getAdditionalWhereClauses(), digestedFieldValueMap, digestedFilterMap );
        
        if( input.getSortColumn() != null ){
            queryString += ' ORDER BY ' + input.getSortColumn() + ' ASC';
        }
        
        if( input.getRecordsetSize() != null ){
            queryString += ' LIMIT ' + input.getRecordsetSize();
        }
    	
        List<SObject> queryResult = Database.query( queryString );
        
        return queryResult;
    }
    
    /**
    * Method for building the dynamic query string
    * @param tableName
    * @param displayFieldNames
    * @param defaultWhereClauses
    * @param searchParamNameValue
    * @param searchFilters
    * @return query
    */ 
    public static String buildQueryString( String tableName, Set<String> displayFieldNames, List<String> defaultWhereClauses, Map<String, String> searchParamNameValue, Map<String, String[]> searchFilters ){
    
        // add in name and id if they aren't already in there
        Set<String> check = new Set<String>();
        check.addAll( displayFieldNames );
        if( !( check.contains( 'Name' )|| check.contains( 'name' ) ) ){
            displayFieldNames.add( 'Name' );
        } 
    
        if( !( check.contains( 'Id' ) || check.contains( 'id' ) ) ){
            displayFieldNames.add( 'Id' );
        }
    
        Integer counter = 0;
        
        //Start building query
        String query = 'Select ';
    
        // add display fields
        for( String displayField : displayFieldNames ){
            query += String.escapeSingleQuotes( displayField );
            if( counter++ < displayFieldNames.size() - 1 ){
                query += ',';
            }
        }
    
        // add table
        query += ' From ' + String.escapeSingleQuotes( tableName ) + ' ';
    
        // add query parameters
        if( defaultWhereClauses.size() > 0 || searchParamNameValue.size() > 0 || searchFilters.size() > 0 ){
            query += 'Where ';
        }
        counter = 0;
        for( String clause : defaultWhereClauses ){
            query +=  clause;
            if( ( counter++ < defaultWhereClauses.size() - 1 ) || ( searchParamNameValue.size() > 0 || searchFilters.size() > 0 ) ){
                query += ' and ';
            }
        }
        
        Map<String, Schema.SObjectField> allFieldsMap = Schema.SObjectType.Volunteer_Activity__c.fields.getMap();
        counter = 0;
        for( String fieldName : searchParamNameValue.keyset() ){
        	       	
        	if( allFieldsMap.get( fieldName ) != null ){
        		Schema.SObjectField fld 				= allFieldsMap.get( fieldName );
        		Schema.DescribeFieldResult fldResult 	= fld.getDescribe();
        		
        		if( fldResult.getType() == DisplayType.Boolean ){
        			query += String.escapeSingleQuotes( fieldName ) + ' = ' + String.escapeSingleQuotes( searchParamNameValue.get( fieldName ) );
        		}else{
        			String aux = searchParamNameValue.get( fieldName ).replace( '*', '' );
        			query += String.escapeSingleQuotes( fieldName ) + ' like \'%' + String.escapeSingleQuotes( aux ) + '%\'';
        		}
        	}
        	
            if( counter++ < searchParamNameValue.size() - 1 ){
                query += ' and ';
            }
        }
                
        // add filters to the where clause coming from picklist values
        if( searchParamNameValue.size() > 0 && searchFilters.size() > 0 ){
            query += ' and ';
        }        
        
        counter = 0;
        for( String fieldName : searchFilters.keyset() ){
            query += String.escapeSingleQuotes( fieldName ) + ' IN (';
            Integer valueCounter = 0;
            for( String filterValue : searchFilters.get( fieldName ) ){
                query += '\'' + String.escapeSingleQuotes( filterValue ) + '\'';
                if( valueCounter++ < searchFilters.get( fieldName ).size() - 1 ){
                    query += ', ';
                }
            }
            query += ') ';
            if( counter++ < searchFilters.size() - 1 ){
                query += ' and ';
            }
        }
        
        return query;
    }
    
    /**
    * Method which returns all results
    * @param input
    * @return results
    */ 
    public List<SearchResultFactory.ResultObject> getResults( SearchRequest input ){
        
        // clear out old results
        results.clear();   
    
        List<SObject> queryResult = queryResults(input);
        
        // Fill result set list
        List<String> resultColumnLabels = input.getResultColumnLabels();
        List<String> resultColumns 		= input.getResultColumns();
        
        for( Sobject s : queryResult ){
            SearchResultFactory.ResultObject r = SearchResultFactory.newResultObject( s, resultColumns, resultColumnLabels );
            this.results.add( r );
        }
    
        return this.results;
    }
}