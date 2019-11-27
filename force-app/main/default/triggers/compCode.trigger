trigger compCode on Account (after update) {

    List<Account>compCodeAccounts = new List<Account>();
    for (Account acct : Trigger.new){
        Account oldAcct = Trigger.oldMap.get(acct.Id);
        if (acct.recordTypeId == '012a0000001ZVU7' && acct.Comp_Package_Code__c != oldAcct.Comp_Package_Code__c){
            compCodeAccounts.add(acct);
        }
    }
    
        
    Set<String>acctCompCodes = new set<String>();
    for(Account acct : [SELECT Id, Comp_Package_Code__c 
                        FROM Account 
                        WHERE Id IN: compCodeAccounts]){
        
    acctCompCodes.add(acct.Comp_Package_Code__c);
    }
    
    List<Account>acctstoupdate = new List<Account>();
    for(Account acct : [SELECT Id 
                        FROM Account
                        WHERE Id IN: compCodeAccounts]){
    acctstoupdate.add(acct);
    }
    
    List<Comp_Code__c>compCodes = new List<Comp_Code__c>();
    for(Comp_Code__c comp : [SELECT Id, Net_Purchase_Volume__c, Renewal__c, On_Us__c, Off_Us__c 
                             FROM Comp_Code__c 
                             WHERE Name IN: acctCompCodes]){
                        
    compCodes.add(comp);
    }
    
    for(Account acct : acctstoupdate){
        for(Comp_Code__c comp : compCodes){
            acct.Net_Purchase_Volume__c = comp.Net_Purchase_Volume__c;
            acct.Renewal__c = comp.Renewal__c;
            acct.On_Us__c = comp.On_Us__c;
            acct.Off_Us__c = comp.Off_Us__c;
        }
    }
    
    update acctstoupdate;
}