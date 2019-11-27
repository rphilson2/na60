trigger COIDuplicateTrigger2 on COI__c (before insert) {

    String COIId = 'n/a';

    Set<String> newKeys = new Set<String>();
    for(COI__c coi : Trigger.new) {
        String key = coi.Name + coi.Company__c;
        if (newKeys.contains(key)) coi.addError('Duplicate COI record found: <a href=\'https://na13.salesforce.com/'+COIId+'\'>Click to access duplicate record</a>', false);
        else newKeys.add(key);
    }

    Set<String> existingKeys = new Set<String>();
    for (COI__c coi : [select Key__c,Id from COI__c where Key__c in :newKeys]) {
        existingKeys.add(coi.Key__c);
        COIId = (coi.Id);
    }

    for(COI__c coi : Trigger.new) {
        String key = coi.Name + coi.Company__c;
        if (existingKeys.contains(key)) coi.addError('Duplicate COI record found: <a href=\'https://na13.salesforce.com/'+COIId+'\'>Click to access duplicate record</a>', false);
    }
}