// Author: Alexander Nourbakhsh
// Date: 05.17.2016
// Project: Card Spend
// Purpose: To "hold" Month_End__c and Month_Spend__c record data from the Card_Spend__c sObject.
// This controller is modeled from r the official Salesforce documention chart controller example:
//
//


public class cardSpendMonthChartController {

    public cardSpendMonthChartController(ApexPages.StandardController stdController) {
    }
  
    public List<Data> getData() {
        return cardSpendMonthChartController.getChartData();
    }

    
    public static List<Data> getChartData() {
        integer thousand = 1000;
  
        List<Data> data = new List<data>();
        List<Card_Spend__c> cardSpendList = [SELECT Month_End__c, Month_Spend__c, Company_Credit_Limit__c
                                             FROM Card_Spend__c
                                             WHERE Parent_Account__c = :ApexPages.currentPage().getParameters().get('id')
                                             ORDER BY Month_End__c ASC
                                             LIMIT 24];
                                             
                                             
                                             
        for(Card_Spend__c cardspend : cardSpendList) {
            data.add(new Data(cardSpend.Month_End__c.format(), cardSpend.Month_Spend__c/thousand , cardSpend.Company_Credit_Limit__c/thousand));
        
        }
        

        return data;
    
    }
    
    public class Data {
        public String name {get; set;}
        public Decimal data1 {get; set;}
        public Decimal data2 {get; set;}
        
        public Data(String name, Decimal data1, Decimal data2) {
            this.name = name;
            this.data1 = data1;
            this.data2 = data2;
           
        }
    }
       
}