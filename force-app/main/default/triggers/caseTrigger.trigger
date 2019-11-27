trigger caseTrigger on Case (before insert, before update) {
        if(Trigger.isBefore) {
            System.Debug(LoggingLevel.DEBUG, 'Entering before case Trigger. Trigger.isBefore=' + Trigger.isBefore );

            if(Trigger.isInsert || Trigger.isUpdate) {
                List<Case> newCasevalue = Trigger.new;
                System.Debug(LoggingLevel.DEBUG, 'Entering case Trigger. Trigger.isInsert=' + Trigger.isInsert + ', Trigger.isUpdate=' + Trigger.isUpdate
                             +', Trigger.new=' + newCasevalue);
                caseTriggerUpdateHandler.beforeInsertUpdateCase(newCasevalue);
            } 
        } 

}