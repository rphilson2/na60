/**
* Used for the search feature.
*/
public class SearchResultFactory{
    
    /**
    * Creates and builds the result object
    * @param s
    * @param fieldNames
    * @param fieldLabels
    * @return r
    */
    public static ResultObject newResultObject( SObject s, List<String> fieldNames, List<String> fieldLabels ){
        
        ResultObject r = new ResultObject();
        // Set column labels
        r.setField1Label( fieldLabels.get(0) );
        r.setField2Label( fieldLabels.get(1) );
        r.setField3Label( fieldLabels.get(2) );
        r.setField4Label( fieldLabels.get(3) );        
        r.setField5Label( fieldLabels.get(4) );    
        
        // Set column values
        if( s.get( fieldNames.get(0) ) != null ){
            r.setField1Value( String.valueOf( s.get( fieldNames.get(0) ) ) );
        }else{
            r.setField1Value('');
        }
        
        if( s.get( fieldNames.get(1) ) != null ){
            r.setField2Value( String.valueOf( s.get( fieldNames.get(1) ) ) );
        }else{
            r.setField2Value('');
        }

        if( s.get( fieldNames.get(2) ) != null ){
            r.setField3Value( String.valueOf( s.get( fieldNames.get(2) ) ) );
        }else{
            r.setField3Value('');
        }
        
        if( s.get( fieldNames.get(3) ) != null ){
            r.setField4Value( String.valueOf( s.get( fieldNames.get(3) ) ) );
        }else{
            r.setField4Value('');
        }
        
        if( s.get( fieldNames.get(4) ) != null ){
            r.setField5Value( String.valueOf( s.get( fieldNames.get(4) ) ) );
        }else{
            r.setField5Value('');
        }
        
        r.setName( (String) s.get('Name') );
        r.setId( (String) s.get('Id') );
            
        return r;          
    }      
    
    /**
    * Inner Class
    */
    public class ResultObject{
    
        String field1Label;    
        String field2Label;    
        String field3Label;    
        String field4Label;    
        String field5Label;        
    
        String field1Value;
        String field2Value;    
        String field3Value;
        String field4Value;
        String field5Value;
    
        String name;
        String id;
    
        public string getName() 		{ return name; }    
        public void setName(String s)	{ name = s; }
        public string getId() 			{ return id; }
        public void setId(String s) 	{ id = s; }
    
        public String getField1Label() { return field1Label; }
        public String getField2Label() { return field2Label; }
        public String getField3Label() { return field3Label; }
        public String getField4Label() { return field4Label; }
        public String getField5Label() { return field5Label; }
    
        public String getField1Value() { return field1Value; }
        public String getField2Value() { return field2Value; }    
        public String getField3Value() { return field3Value; }
        public String getField4Value() { return field4Value; }
        public String getField5Value() { return field5Value; }
        
        public void setField1Label(String s) { field1Label = s; }
        public void setField2Label(String s) { field2Label = s; }
        public void setField3Label(String s) { field3Label = s; }
        public void setField4Label(String s) { field4Label = s; }
        public void setField5Label(String s) { field5Label = s; }
        
        public void setField1Value(String s) { field1Value = s; }
        public void setField2Value(String s) { field2Value = s; }
        public void setField3Value(String s) { field3Value = s; }    
        public void setField4Value(String s) { field4Value = s; }    
        public void setField5Value(String s) { field5Value = s; }  
        
        public void dump(){
        	
            System.debug( Logginglevel.DEBUG, 'Result Object Dump');    
            System.debug( Logginglevel.DEBUG, '>>' + getField1Label() + ': ' + getField1Value() );    
            System.debug( Logginglevel.DEBUG, '>>' + getField2Label() + ': ' + getField2Value() );    
            System.debug( Logginglevel.DEBUG, '>>' + getField3Label() + ': ' + getField3Value() );    
            System.debug( Logginglevel.DEBUG, '>>' + getField4Label() + ': ' + getField4Value() );    
            System.debug( Logginglevel.DEBUG, '>>' + getField5Label() + ': ' + getField5Value() );    
        }    
    }  
}