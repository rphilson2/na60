/**
* Used for the search feature.
*/
public class SearchConfig{
	
    private static final Schema.SObjectType TARGET_OBJECT = volunteer_activity__c.sobjectType;
    private static final List<Schema.SObjectField> SEARCH_FIELDS = new Schema.SObjectField[] {
                                volunteer_activity__c.organization_name__c,
                                volunteer_activity__c.name,
                                volunteer_activity__c.city__c,
                                volunteer_activity__c.state_province__c,
                                volunteer_activity__c.isOpportunity__c};
                                
    private static final List<Schema.SObjectField> FILTERS = new Schema.SObjectField[] {
                                volunteer_activity__c.volunteer_events__c};
                                
    private static final List<Schema.SObjectField> COL_DEFAULTS = new Schema.SObjectField[] {
                                volunteer_activity__c.name,
                                volunteer_activity__c.organization_name__c,
                                volunteer_activity__c.volunteer_events__c,
                                volunteer_activity__c.city__c,
                                volunteer_activity__c.date_and_time__c};
                                
    private static final Map<String, String> DEFAULT_SEARCH_CLAUSES = new Map<String, String>{
                                volunteer_activity__c.date_and_time__c.getDescribe().getName() 
                                => 'date_and_time__c > YESTERDAY',
                                volunteer_activity__c.status__c.getDescribe().getName() 
                                => 'status__c NOT IN (\'Cancelled\',\'Completed\')' };
                                
	private static final Map<String, String> ACTIVITY_SEARCH_CLAUSES = new Map<String, String>{
                                volunteer_activity__c.status__c.getDescribe().getName() 
                                => 'status__c NOT IN (\'Cancelled\',\'Completed\')' };                                
    
    private static final Integer RESULTSET_SIZE_LIMIT = 50;
    private static final String EVENT_SORT_COLUMN = 'date_and_time__c';
    private static final String ACTIVITY_SORT_COLUMN = 'name';
    
    private static final List<String> SEARCH_FIELD_NAMES = new List<String>();
    private static final List<String> FILTER_NAMES = new List<String>();
    private static final List<String> COL_DEFAULT_NAMES = new List<String>();
    static {
        for(Schema.SObjectField field: SEARCH_FIELDS) {
            SEARCH_FIELD_NAMES.add(field.getDescribe().getName());
        }
        for(Schema.SObjectField field: FILTERS) {
            FILTER_NAMES.add(field.getDescribe().getName());
        }
        for(Schema.SObjectField field: COL_DEFAULTS) {
            COL_DEFAULT_NAMES.add(field.getDescribe().getName());
        }
    }
    
    /**
    * Getter method for Search fields
    * @return SEARCH_FIELD_NAMES
    */
    public static List<String> getSearchFields(){
        return SEARCH_FIELD_NAMES;
    }
    
    /**
    * Getter method for Filter fields
    * @return FILTER_NAMES
    */    
    public static List<String> getFilterFields(){
        return FILTER_NAMES;
    }
    
    /**
    * Getter method for Result columns
    * @return COL_DEFAULT_NAMES
    */
    public static List<String> getResultColumns(){
        return COL_DEFAULT_NAMES;
    }
    
    /**
    * Getter method for target Object
    * @return TARGET_OBJECT
    */
    public static Schema.SObjectType getTargetObject(){
        return TARGET_OBJECT;
    }
    
    /**
    * Getter method for default where clauses
    * @return DEFAULT_SEARCH_CLAUSES
    */
    public static Map<String, String> getDefaultWhereClauses(){
        return DEFAULT_SEARCH_CLAUSES;
    }
    
    /**
    * Getter method for size Limit
    * @return RESULTSET_SIZE_LIMIT
    */
    public static Integer getSizeLimit(){
        return RESULTSET_SIZE_LIMIT;
    }
    
    /**
    * Getter method for event sort column
    * @return EVENT_SORT_COLUMN
    */
    public static String getEventSortColumn(){
        return EVENT_SORT_COLUMN;
    }
    
    /**
    * Getter method for activity sort column
    * @return ACTIVITY_SORT_COLUMN
    */
    public static String getActivitySortColumn(){
    	return ACTIVITY_SORT_COLUMN;
    }
    
    /**
    * Getter method for activity where clause
    * @return ACTIVITY_SEARCH_CLAUSES
    */
    public static Map<String, String> getActivityWhereClauses(){
        return ACTIVITY_SEARCH_CLAUSES;
    }
}