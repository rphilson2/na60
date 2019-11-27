// Author: Rick Philson
// Date Created: 2017-05-29
// 
// Project: ResourceOne Leads
// Purpose: Custom class that exposes a Map of User email addresses (key) and the corresponding User.Id (value)
// 
public class UserEmailAndIdMap {
    private Map<String, Id> userEmailIdMap;
    
    //constructor(s)
    public UserEmailAndIdMap() {
        //Get all active Users
        List<User> users = [SELECT Id, email FROM User WHERE isActive = true limit 10000];
        
        //populate the userEmailIdMap
        userEmailIdMap = new Map<String, Id>();
        for(User u: users) {
            userEmailIdMap.put(u.email.toLowerCase(), u.Id);    //ensures emailAddress is in lower case 
        }        
    }
    
    //search the userEmailIdMap for the emailAddress(key)
    //   if found, return the corresponding User.Id
    //   else, return the User.Id for the Service Account
    public Id getUserIdUsingEmailAddress(String emailAddress) {
    
        //if emailAddress is null, return the User.Id for the Service Account
        if (emailAddress == null) {
            return '005a000000COYqX';    //User.Id for Service Account
        }
        
        //if emailAddress isBlank, return the User.Id for the Service Account
        if (String.isBlank(emailAddress)) {
            return '005a000000COYqX';    //User.Id for Service Account
        }
    
        //Map key is emailAddress converted to all lowercase characters
        //  Convert incoming emailAdress string to lowercase before attempting to match
        if (userEmailIdMap.containsKey(emailAddress.toLowerCase())) {
            return userEmailIdMap.get(emailAddress.toLowerCase()); 
        }
        else {
            return '005a000000COYqX';    //User.Id for Service Account
        }
    }
}