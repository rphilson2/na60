/**
* Used for the search feature.
*/
public class SearchRequest{
	
    private String targetObject;
    private Map<String, String> fieldValueMap;
    private Map<String, String[]> additionalFilters;
    private String[] resultColumns;
    private Map<String, String> targetObjectFieldNameLabelMap;
    private List<SelectOption> targetObjectFieldPicklist;
    private Map<String, List<SelectOption>> searchFilterPicklists;
    private Map<String, Schema.SObjectField> targetObjectFieldMap;
    
    /**
    * Constructor
    */
    public SearchRequest(){
    	
        fieldValueMap 			= new Map<String, String>();
        searchFilterPicklists 	= new Map<String, List<SelectOption>>();
        additionalFilters 		= new Map<String, String[]>();
        resultColumns 			= new String[SearchConfig.getResultColumns().size()];
        Integer index = 0;
        
        for( String columnName : SearchConfig.getResultColumns() ){
            resultColumns[index++] = columnName;
        }
        
        Schema.DescribeSObjectResult targetObjDesc = SearchConfig.getTargetObject().getDescribe();
        targetObject 			= targetObjDesc.getName();
        targetObjectFieldMap 	= targetObjDesc.fields.getMap();
        generateFieldNameLabelMap();
    }
    
    /**
    * Method which generate the name label map
    */
    private void generateFieldNameLabelMap(){
    	
        Map<String, SObjectField> fieldMap = targetObjectFieldMap;
        targetObjectFieldMap = new Map<String, SObjectField>();
        
        if( targetObjectFieldNameLabelMap == null ){
            targetObjectFieldNameLabelMap = new Map<String, String>();
            
            for( String fieldName : fieldMap.keyset() ){
            	
                SObjectField field = fieldMap.get( fieldName );
                Schema.DescribeFieldResult fieldDesc = field.getDescribe();
                targetObjectFieldMap.put( fieldDesc.getName(), field );
                targetObjectFieldNameLabelMap.put( fieldDesc.getName(), fieldDesc.getLabel() );
            }
        }
    }
    
    /**
    * Gets all column lists
    * @return targetObjectFieldPicklist
    */
    public List<SelectOption> getColumnList(){
    	
        if( targetObjectFieldPicklist == null ){
            targetObjectFieldPicklist = new List<SelectOption>();
            Map<String, String> fieldLabelNameMap = new Map<String, String>();
            
            for( String fieldName : targetObjectFieldNameLabelMap.keyset() ){
                fieldLabelNameMap.put( targetObjectFieldNameLabelMap.get( fieldName ), fieldName );
            }
            
            List<String> fieldLabels = new List<String>(fieldLabelNameMap.keyset());
            fieldLabels.sort();
            for( String fieldLabel : fieldLabels ){
                String fieldName = fieldLabelNameMap.get( fieldLabel );
                targetObjectFieldPicklist.add( new SelectOption( fieldName, fieldLabel ) );
            }
        }
        
        return targetObjectFieldPicklist;
    }
    
    /**
    * gets all filter picklist items
    * @param fieldName
    * @return picklist
    */
    private List<SelectOption> getFilterPicklist( String fieldName ){
    	
        List<SelectOption> picklist = searchFilterPicklists.get( fieldName );
        if( picklist == null ){
            picklist = new List<SelectOption>();
            Schema.SObjectField filterField = targetObjectFieldMap.get( fieldName );
            if( filterField != null ){
                Schema.DescribeFieldResult fieldDesc = filterField.getDescribe();
                List<Schema.PicklistEntry> picklistValues = fieldDesc.getPicklistValues();
                
                for( Schema.PicklistEntry pick : picklistValues ){
                    picklist.add( new SelectOption( pick.getLabel(), pick.getLabel() ) );
                }
            }
            searchFilterPicklists.put( fieldName, picklist );
        }
        
        return picklist;
    }
    
    /**
    * getter for search object
    * @return targetObject
    */
    public String getSearchObject(){
        return targetObject;
    }
    
    /**
    * Getter for field value map
    * @return fieldValueMap
    */
    public Map<String, String> getFieldValueMap(){
        return fieldValueMap;
    }
    
    /**
    * Getter for filter map
    * @return additionalFilters
    */
    public Map<String, String[]> getFilterMap(){
        return additionalFilters;
    }
    
    /**
    * getter for result columns
    * @return List<String>
    */
    public List<String> getResultColumns(){
        return new List<String>( resultColumns );
    }
    
    /**
    * getter for result column labels
    * @return labels
    */
    public List<String> getResultColumnLabels(){
    	
        List<String> labels = new List<String>();
        for( String fieldName : resultColumns ){
            labels.add( targetObjectFieldNameLabelMap.get( fieldName ) );
        }
        return labels;
    }
    
    /**
    * getter for field values
    * @return String
    */
    public String getField1Value(){
        return fieldValueMap.get( SearchConfig.getSearchFields().get(0) );
    }
    
    /**
    * setter for field value
    * @param val
    */
    public void setField1Value( String val ){
        fieldValueMap.put( SearchConfig.getSearchFields().get(0), val );
    }
    
    /**
    * getter for field values 2
    * @return String
    */
    public String getField2Value(){
        return fieldValueMap.get( SearchConfig.getSearchFields().get(1) );
    }
    
    /**
    * setter for feild values 2
    * @param val
    */
    public void setField2Value( String val ){
        fieldValueMap.put( SearchConfig.getSearchFields().get(1), val );
    }
    
    /**
    * getter for field values 3
    * @return String
    */
    public String getField3Value(){
        return fieldValueMap.get( SearchConfig.getSearchFields().get(2) );
    }
    
    /**
    * setter for field values 3
    * @param val
    */
    public void setField3Value( String val ){
        fieldValueMap.put( SearchConfig.getSearchFields().get(2), val );
    }

	/**
    * getter for field value 4
    * @return String
    */
    public String getField4Value(){
        return fieldValueMap.get( SearchConfig.getSearchFields().get(3) );
    }
    
    /**
    * setter for field value 4
    * @param val
    */
    public void setField4Value( String val ){
        fieldValueMap.put( SearchConfig.getSearchFields().get(3), val );
    }
    
    /**
    * getter for field value 4
    * @return String
    */
    public String getField5Value(){
        return fieldValueMap.get( SearchConfig.getSearchFields().get(4) );
    }
    
    /**
    * setter for field value 4
    * @param val
    */
    public void setField5Value( String val ){
        fieldValueMap.put( SearchConfig.getSearchFields().get(4), val );
    }
    
    /**
    * gets all filter values 1
    * @return String[]
    */
    public String[] getFilter1Value(){
    	
        String filterFieldName = SearchConfig.getFilterFields().get(0);
        if( additionalFilters.get( filterFieldName ) == null ){
        	additionalFilters.put( filterFieldName, new String[]{} );
        }
        
        return additionalFilters.get( SearchConfig.getFilterFields().get(0) );
    }
    
    /**
    * setter for filter values 1	
    * @param val
    */
    public void setFilter1Value( String[] val ){
        additionalFilters.put( SearchConfig.getFilterFields().get(0), val );
    }
    
    /**
    * getter for field label
    * @return String
    */
    public String getField1Label(){
        return targetObjectFieldNameLabelMap.get( SearchConfig.getSearchFields().get(0) );
    }
    
    /**
    * getter for field label 2
    * @return String
    */
    public String getField2Label(){
        return targetObjectFieldNameLabelMap.get( SearchConfig.getSearchFields().get(1) );
    }
    
    /**
    * getter for field label 3
    * @return String
    */
    public String getField3Label(){
        return targetObjectFieldNameLabelMap.get( SearchConfig.getSearchFields().get(2) );
    }
    
    /**
    * getter for field label 4
    * @return String
    */
    public String getField4Label(){
        return targetObjectFieldNameLabelMap.get( SearchConfig.getSearchFields().get(3) );
    }
    
    /**
    * getter for field label 5
    * @return String
    */
    public String getField5Label(){
        return targetObjectFieldNameLabelMap.get( SearchConfig.getSearchFields().get(4) );
    }
    
    /**
    * getter for filter label 1
    * @return String
    */
    public String getFilter1Label(){
        return targetObjectFieldNameLabelMap.get( SearchConfig.getFilterFields().get(0) );
    }
    
    /**
    * Getter for all picklist values
    * @return List<SelectOption>
    */
    public List<SelectOption> getFilter1Picklist(){
        return getFilterPicklist( SearchConfig.getFilterFields().get(0) );
    }
    
    /**
    * retrieves all resul col
    * @return string
    */
    public String getResultCol1(){
        return SearchConfig.getResultColumns().get(0);
    }
    
    /**
    * setter for field col
    * @param fieldName
    */
    public void setResultCol1( String fieldName ){
        resultColumns[0] = fieldName;
    }
    
    /**
    * getter for result field col 2
    * @return String
    */
    public String getResultCol2(){
        return SearchConfig.getResultColumns().get(1);
    }
    
    /**
    * setter for result field col 2
    * @param fieldName
    */
    public void setResultCol2( String fieldName ){
        resultColumns[1] = fieldName;
    }
    
    /**
    * getter for result col 3
    * @return String
    */
    public String getResultCol3(){
        return SearchConfig.getResultColumns().get(2);
    }
    
    /**
    * setter for result col 3
    * @param fieldName
    */
    public void setResultCol3( String fieldName ){
        resultColumns[2] = fieldName;
    }
    
    /**
    * getter for result col 4
    * @return String
    */
    public String getResultCol4(){
        return SearchConfig.getResultColumns().get(3);
    }
    
    /**
    * setter for result col 4
    * @param fieldName
    */
    public void setResultCol4( String fieldName ){
        resultColumns[3] = fieldName;
    }
    
    /**
    * getter for result col 5
    * @return String
    */
    public String getResultCol5(){
        return SearchConfig.getResultColumns().get(4);
    }
    
    /**
    * setter for result col 5
    * @param fieldName
    */
    public void setResultCol5( String fieldName ){
        resultColumns[4] = fieldName;
    }
    
    /**
    * gets any aditional where clauses
    * @return additionalClauses
    */
    public List<String> getAdditionalWhereClauses(){
        
        Map<String, String> defaultClauses = new Map<String, String>();//SearchConfig.getDefaultWhereClauses();
        if( getField5Value() == 'false' ){
        	defaultClauses = SearchConfig.getDefaultWhereClauses();
        }else{
        	defaultClauses = SearchConfig.getActivityWhereClauses();
        }
        
        List<String> additionalClauses = new List<String>();
        for( String fieldName : defaultClauses.keyset() ){
            if( fieldValueMap.get( fieldName ) == null ){
            	additionalClauses.add( defaultClauses.get( fieldName ) );
            }
        }
        
        return additionalClauses;
    }
    
    /**
    * getter for record set size
    * @return Integer
    */
    public Integer getRecordsetSize(){
        return SearchConfig.getSizeLimit();
    }
     
    /**
    * getter for sort column
    * @return String
    */
    public String getSortColumn(){
    	if( getField5Value() == 'false' ){
    		return SearchConfig.getEventSortColumn(); 
    	}
        return SearchConfig.getActivitySortColumn();
    } 
    
    /**
    * Dump method
    */
    public void dump(){
        System.debug(Logginglevel.DEBUG, 'Input Object Dump');
        System.debug(Logginglevel.DEBUG, 'Target Search Object: ' + targetObject);
        System.debug(Logginglevel.DEBUG, 'Search Text');
        System.debug(Logginglevel.DEBUG, '>>' + getField1Label() + ': ' + getField1Value());
        System.debug(Logginglevel.DEBUG, '>>' + getField2Label() + ': ' + getField2Value());
        System.debug(Logginglevel.DEBUG, '>>' + getField3Label() + ': ' + getField3Value());
        System.debug(Logginglevel.DEBUG, '>>' + getField4Label() + ': ' + getField4Value());
        System.debug(Logginglevel.DEBUG, 'Search Filters');
        System.debug(Logginglevel.DEBUG, '>>' + getFilter1Label() + ': ' + getFilter1Value());
        System.debug(Logginglevel.DEBUG, 'Search Result Columns');
        System.debug(Logginglevel.DEBUG, '>> Result Column 1: '+ + getResultCol1());
        System.debug(Logginglevel.DEBUG, '>> Result Column 2: '+ + getResultCol2());
        System.debug(Logginglevel.DEBUG, '>> Result Column 3: '+ + getResultCol3());
        System.debug(Logginglevel.DEBUG, '>> Result Column 4: '+ + getResultCol4());
        System.debug(Logginglevel.DEBUG, '>> Result Column 5: '+ + getResultCol5());
    }
}