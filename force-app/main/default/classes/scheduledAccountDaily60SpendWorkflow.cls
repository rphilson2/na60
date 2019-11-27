// Author: Alexander Nourbakhsh
// Date Created/Modified: 06.28.2016
// Project: Card Spend
// Purpose: Implements Schedulable Interface for accountDaily60SpendWorkflow class
// 

global class scheduledAccountDaily60SpendWorkflow implements Schedulable {
   global void execute(SchedulableContext SC) {
      accountDaily60SpendWorkflow a60 = new accountDaily60SpendWorkflow();
      a60.accountDaily60SpendWorkflow();
   }
}