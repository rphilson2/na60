public class AccountNavigateController1 {
    
    
    public boolean showFirstPage{get;set;}
    public boolean showSecPage{get;set;}
    public boolean showThirdPage{get;set;}
    public AccountNavigateController1(ApexPages.StandardController controller) {
        showFirstPage = true;
        showSecPage = false;
        showThirdPage = false;
        
    }
    
    public void goToPrevnext1(){
        showFirstPage = true;
        showSecPage = false;
        showThirdPage = false;
    }
    
    public void next1(){
        showFirstPage = false;
        showSecPage = true;
        showThirdPage = false;
    }
    
     
     public void goToPrevnext2(){
        showFirstPage = false;
        showSecPage = true;
        showThirdPage = false;
    }
     
    public void next2(){
        showFirstPage = false;
        showSecPage = false;
        showThirdPage = true;
    }
    
    public void next3(){
    
    }

}