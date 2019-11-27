/**
* Used for the search feature.
*/
public with sharing class SearchController{
	
    private SearchLib controller;
    String eventType = '0';
    
    List<SearchResultFactory.ResultObject> results;
    public List<SearchResultFactory.ResultObject> getResults() { return results; }

    private SearchRequest searchObject;
    public SearchRequest getSearchObject() { return searchObject; }
    public void setSearchObject(SearchRequest obj) { searchObject = obj; }

    public Boolean getNoResults() { return results.size() == 0; } 

    private boolean showResults = false;
    public Boolean getShowResults() { return showResults; }
    
    /**
    * constructor 
    */
    public SearchController(){
    	
        searchObject = new SearchRequest();
        if( showResults ){ 
        	search();
        }
    }
     
    /**
    * Search Action
    * @return PageReference
    */   
    public PageReference search(){
    	
        controller = new SearchLib();
        if( getEventType() == '0'){
        	searchObject.setField5Value( 'false' );
        }else{
        	searchObject.setField5Value( 'true' );
        }
        
        results 	= controller.getResults( searchObject );
        showResults = true;
        
        return null;
    }    
 	
 	/**
    * Getter method for event type
    * @return eventType
    */
 	public String getEventType(){
		return eventType;
	}
 	
 	/**
    * Setter method for EventType
    * @param
    */
	public void setEventType( String eventType ){
		this.eventType = eventType;
	}
}