// Author: Alexander Nourbakhsh
// Date Created/Modified: 06.28.2016
// Project: Card Spend
// Purpose: Implements Schedulable Interface for accountDaily180SpendWorkflow class
// 

global class scheduledAccountDaily180SpendWorkflow implements Schedulable {
   global void execute(SchedulableContext SC) {
      accountDaily180SpendWorkflow a180 = new accountDaily180SpendWorkflow();
      a180.accountDaily180SpendWorkflow();
   }
}