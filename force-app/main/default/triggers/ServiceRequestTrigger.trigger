trigger ServiceRequestTrigger on Service_Request__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            ServiceRequestHandler.beforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            ServiceRequestHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}

