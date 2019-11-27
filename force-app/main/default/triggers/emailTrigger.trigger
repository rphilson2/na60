trigger emailTrigger on EmailMessage (before insert, before update) {
        if(Trigger.isBefore) {
            System.Debug(LoggingLevel.DEBUG, 'Entering Before email Trigger. Trigger.isBefore=' + Trigger.isBefore );

            if(Trigger.isInsert || Trigger.isUpdate) {
                List<EmailMessage> newemailvalue = Trigger.new;
                System.Debug(LoggingLevel.DEBUG, 'Entering email Trigger. Trigger.isInsert=' + Trigger.isInsert + ', Trigger.isUpdate=' + Trigger.isUpdate
                             +', Trigger.new=' + newemailvalue);
                emailTriggerUpdateHandler.beforeInsertUpdateEmail(newemailvalue);
            } 
        } 
}