// Author: Alexander Nourbakhsh
// Date: 05.25.2016
// Project: Card Spend
// Purpose: This controller returns information about the most recent Card_Spend__c record by date,
// and calculates YTD and PYTD spend data. This controller is a companion to the cardSpendMonthChartController. 
//
//

public class cardSpendChartStatController {

    public Card_Spend__c calcRecord;
    public Decimal ytdSpendSum = 0;
    public Decimal pytdSpendSum = 0;
    public Decimal ytdAvgPerUtil = 0;
    public Decimal pytdAvgPerUtil = 0;
    Boolean renderPage = True;
    
    public cardSpendChartStatController(ApexPages.StandardController stdController) {
    }
       
    public cardSpendChartStatController() {
    
                    
        Decimal ytdCreditLimitSum = 0;
        Decimal pytdCreditLimitSum = 0;
        Decimal ytdAvgPerUtilRound = 0;
        Decimal pytdAvgPerUtilRound = 0;
        Set<Integer> ytdMonths = new Set<integer>();
        Date calcDate = date.today().addMonths(-1);
        

        try{
        
            calcRecord = [SELECT Id, Month_End__c, Company_ID__c, Company_Name__c, Partnering_Bank__c, Product_Code__c, Multiple_Product_Flag__c, Managed_Flag__c, Live_Account_Count__c, Active_Cards__c, Company_Credit_limit__c
                          FROM Card_Spend__c
                          WHERE Parent_Account__c = :ApexPages.currentPage().getParameters().get('id')
                          ORDER BY Month_End__c 
                          DESC 
                          LIMIT 1];
                                 
    
            
            for(Card_Spend__c cspend : [SELECT Id, Month_End__c, Month_Spend__c, Company_Credit_Limit__c
                                        FROM Card_Spend__c
                                        WHERE Parent_Account__c = :ApexPages.currentPage().getParameters().get('id')
                                        ORDER BY Month_End__c
                                        DESC
                                        LIMIT 24]) {
                                        
                                                   
                                        
                if(cspend.Month_End__c.Year() == calcDate.Year()) {
                    
                   ytdMonths.add(cspend.Month_End__c.Month());
                   ytdSpendSum += cspend.Month_Spend__c;
                   ytdCreditLimitSum += cspend.Company_Credit_Limit__c;
                   
                } else if (ytdMonths.contains(cspend.Month_End__c.Month())){
                   pytdSpendSum += cspend.Month_Spend__c;
                   pytdCreditLimitSum += cspend.Company_Credit_Limit__c;
                   
                } else {
                
                }
                        
            }
            
            if(ytdCreditLimitSum > 0){
            ytdAvgPerUtilRound = (ytdSpendSum/ytdCreditLimitSum)*100;
            } else {
            //do nothing
            }
    
    
            if(pytdCreditLimitSum > 0){
            pytdAvgPerUtilRound = (pytdSpendSum/pytdCreditLimitSum)*100;
            
            } else {
            //do nothing
            }
    
            pytdAvgPerUtil = pytdAvgPerUtilRound.setScale(2);
            ytdAvgPerUtil = ytdAvgPerUtilRound.setScale(2);
 
           
        } Catch (Exception e) {
            renderPage = False;
        }
    
    }

    public Card_Spend__c getCalcRecord() {
        return calcRecord;

    }
    
    public Boolean getRenderPage() {
        return renderPage;
    }
    
    public Date getLastMonthEndDate() {
        return calcRecord.Month_End__c;
    }
    
    public String getCompanyID() {
        return calcRecord.Company_ID__c;
    }
    
    public Decimal getCompanyCreditLimit() {
        return calcRecord.Company_Credit_Limit__c;
    }
    
    public String getTBSCompanyName() {
        return calcRecord.Company_Name__c;
    }
    
    public String getTBSPartneringBank() {
        return calcRecord.Partnering_Bank__c;
    }
    
    public String getProductCode() {
        return calcRecord.Product_Code__c;
    }
    
    public String getMultipleProductFlag() {
        return calcRecord.Multiple_Product_Flag__c;
    }
    
    public String getManagedFlag() {
        return calcRecord.Managed_Flag__c;
    }
    
    public String getLiveAccountCount() {
        return calcRecord.Live_Account_Count__c;
    }
    
    public String getActiveCards() {
        return calcRecord.Active_Cards__c;
    }
    
    public Decimal getYtdSpendSum() {
        return ytdSpendSum;
    }
    
    public Decimal getPytdSpendSum() {
        return pytdSpendSum;
    }
    
    public Decimal getYtdAvgPerUtil() {
        return ytdAvgPerUtil;
    }
    
    public Decimal getPytdAvgPerUtil() {
        return pytdAvgPerUtil;
    }
    
}