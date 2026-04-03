public with sharing class OpenRequestsController {

    @AuraEnabled(cacheable=true)
    public static List<Service_Request__c> getOpenRequests(Integer limitSize) {
        Integer safeLimit = (limitSize == null || limitSize <= 0) ? 20 : limitSize;

        return [
            SELECT
                Id,
                Name,
                Subject__c,
                Status__c,
                Priority__c,
                Due_Date__c,
                Is_Overdue__c,
                Assigned_To__c
            FROM Service_Request__c
            WHERE Status__c != 'Closed'
            ORDER BY Due_Date__c ASC, CreatedDate DESC
            LIMIT :safeLimit
        ];
    }
}