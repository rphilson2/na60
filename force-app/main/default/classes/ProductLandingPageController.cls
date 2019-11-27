public without sharing class ProductLandingPageController {
    public PageReference redirect() {
        User newUser = getUser(System.UserInfo.getUserId());
        String productCode = newUser.Product_Code__c;
        Account acct = getAccount(newUser.AccountId);
		String customerTier = getValidCustomerTier(acct==null ? null : acct.Customer_Tier__c);
        String subProductCode = getSubProductCode(productCode, customerTier);
		Id productId = getProductId(subProductCode);
        return getPage(productId); 
    }
    
    @TestVisible 
    private PageReference getPage(Id productId){
    	PageReference pr = Page.nPORTAL__OnlineApplication;
        String prefUrl = pr.getUrl();
        if(productId != null){
            prefUrl += '?new=true&productId=' + productId;
        }
        PageReference p = new PageReference(prefUrl); 
        p.setRedirect(true);
        return p;
    }
    
    @TestVisible
    private static String getSubProductCode(String productCode, String customerTier){
		String subProductCode = null;
        if(productCode != null && productCode != ''){
            switch on productCode {
                when 'CHK-BAS' {
                    subProductCode = '73';
                }
                when 'CHK-PRM' {
                    subProductCode = '99';
                }
                when 'SAV-DEP' {
                    switch on customerTier {
                        when '0' {
                            subProductCode = 'S2';
                        }
                        when '1' {
                            subProductCode = 'S4';
                        }
                        when '2' {
                            subProductCode = 'E4';
                        }
                        when else {
                            subProductCode = null;
                        }
                    }
                }
                when 'SAV-MMA' {
                    switch on customerTier {
                        when '0' {
                            subProductCode = 'M3';
                        }
                        when '1' {
                            subProductCode = 'M4';
                        }
                        when '2' {
                            subProductCode = 'E7';
                        }
                        when else {
                            subProductCode = null;
                        }
                    }
                } 
                when else {
                    subProductCode = null;
                }
            }
        }
        return subProductCode;
    }
    
    public static User getUser(Id userId){
        User newUser = [ 
           SELECT 
              AccountId
            , Bank_Number__c
            , ContactId
            , FederationIdentifier
            , Product_Code__c 
           FROM User 
           WHERE Id = :userId            
        ];
        return newUser;
    }
    
    @TestVisible
    private static Account getAccount(Id accountId){
        Account acct;
        if(accountId != null){
            acct = [
                SELECT 
                  ID
                , Customer_Tier__c
                FROM Account
                WHERE ID = :accountId            
            ];
        }
        return acct;
    }
    
	@TestVisible
    private static String getValidCustomerTier(String customerTier){
        Set<String> validCustomerTierSet = new Set<String> {'0','1','2'};
        if(!validCustomerTierSet.contains(customerTier))
            customerTier = '0';
        return customerTier;
    }
    
    @TestVisible
    private static Id getProductId(String subProductCode){
        Id productId = null;
        if(subProductCode != null){
            List<LLC_BI__Product__c> pList = new List<LLC_BI__Product__c>([
                SELECT 
                ID 
                FROM LLC_BI__Product__c  
                WHERE SubProduct_Code__c = :subProductCode
                LIMIT 1
            ]);
            if(pList.size() > 0)
                productId = pList[0].Id;
        }
       	return productId;
    }

}