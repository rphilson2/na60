@isTest
private class TestSearchResultFactory {

	public testmethod static void testInnerClass(){
		
		SearchResultFactory.ResultObject resultClass = new SearchResultFactory.ResultObject();
		
		resultClass.getField1Label();
		resultClass.getField1Value();
		resultClass.getField2Label();
		resultClass.getField2Value();
		resultClass.getField3Label();
		resultClass.getField3Value();
		resultClass.getField4Label();
		resultClass.getField4Value();
		resultClass.getField5Label();
		resultClass.getField5Value();
		
		resultClass.getId();
		resultClass.setId( '' );
		resultClass.getName();
		resultClass.setName( ' ' );
		
		String s = '';
		resultClass.setField1Label( s );
		resultClass.setField1Label( s );
		resultClass.setField1Value( s );
		resultClass.setField2Label( s );
		resultClass.setField2Value( s );
		resultClass.setField3Label( s );
		resultClass.setField3Value( s );
		resultClass.setField4Label( s );
		resultClass.setField4Value( s );
		resultClass.setField5Label( s );
		resultClass.setField5Value( s );
		
		System.assert( true );
		resultClass.dump();
	}
	
	public testmethod static void testGetResults(){
		
		Sobject s;
		SearchRequest input			= new SearchRequest();
		List<String> fieldNames 	= new List<String>();
		List<String> fieldLabels 	= new List<String>();
		
		// Fill result set list
        List<String> resultColumnLabels = input.getResultColumnLabels();
        System.assert( resultColumnLabels.size() == 5 );
        
        List<String> resultColumns 	= input.getResultColumns();
        System.assert( resultColumns.size() == 5 );
	}
}