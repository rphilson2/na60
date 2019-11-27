// Author: Alexander Nourbakhsh
// Date: 06.07.2016
// Project: Talent Referral
// Purpose: This controller saves the record and redirects the user to the InnerCircle homepage.
//

public class innerCircleController {

    public ApexPages.StandardController controller;

    public innerCircleController(ApexPages.StandardController controller) {
    
        this.controller = controller;
    }
       
    public pageReference saveAndDirect() {
        

        controller.save();

        pageReference innerCircle = new pageReference('https://connect.fnni.com/homepage/web/gettingStarted/');
        innerCircle.setRedirect(true);
        return innerCircle;
        
    }
}