// Author: Alexander Nourbakhsh
// Date Created/Modified: 09/29/2016
// Project: Unfunded Trust
// Purpose: Helper class to handle scope creep requirements

public without sharing class unfundedTrustHelper {

    private final Map<Id, Unfunded_Trust__c> oldMap;
    private final List<Unfunded_Trust__c> newVer;
    
    public static void preventUpdates(Map<Id, Unfunded_Trust__c> oldMap, List<Unfunded_Trust__c> newVer) {
    
        for(Unfunded_Trust__c unfundT : NewVer) {
            
            Unfunded_Trust__c oldUnfundT = oldMap.get(unfundT.Id);  
            if (unfundT.COI__c != oldUnfundT.COI__c) {
                unfundT.addError(' Changes to the Source COI field are not allowed.');
            }
        }
    }
}