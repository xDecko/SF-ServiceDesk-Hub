public with sharing class ServiceRequestHandler {

    public static void beforeInsert(List<Service_Request__c> newList) {
        // Ejemplo de bulk pattern con Set/Map a User
        getAssignedUsers(newList);

        for (Service_Request__c sr : newList) {
            // Default de Status
            if (String.isBlank(sr.Status__c)) {
                sr.Status__c = 'New';
            }

            // Default de Due Date
            if (sr.Due_Date__c == null) {
                sr.Due_Date__c = Date.today().addDays(3);
            }

            // Keywords -> Priority High
            String subjectText = sr.Subject__c == null ? '' : sr.Subject__c.toLowerCase();
            String descriptionText = sr.Description__c == null ? '' : sr.Description__c.toLowerCase();

            if (containsUrgencyKeywords(subjectText, descriptionText)) {
                sr.Priority__c = 'High';
            }
        }
    }

    public static void beforeUpdate(
        List<Service_Request__c> newList,
        Map<Id, Service_Request__c> oldMap
    ) {
        // Ejemplo de bulk pattern con Set/Map a User
        getAssignedUsers(newList);

        for (Service_Request__c sr : newList) {
            Service_Request__c oldSr = oldMap.get(sr.Id);

            Boolean changedToHigh =
                oldSr.Priority__c != 'High' &&
                sr.Priority__c == 'High';

            Boolean notClosed = sr.Status__c != 'Closed';

            if (changedToHigh && notClosed) {
                sr.Due_Date__c = Date.today().addDays(1);
            }
        }
    }

    private static Boolean containsUrgencyKeywords(String subjectText, String descriptionText) {
        return subjectText.contains('urgent') ||
               subjectText.contains('critical') ||
               descriptionText.contains('urgent') ||
               descriptionText.contains('critical');
    }

    private static Map<Id, User> getAssignedUsers(List<Service_Request__c> records) {
        Set<Id> userIds = new Set<Id>();

        for (Service_Request__c sr : records) {
            if (sr.Assigned_To__c != null) {
                userIds.add(sr.Assigned_To__c);
            }
        }

        if (userIds.isEmpty()) {
            return new Map<Id, User>();
        }

        return new Map<Id, User>([
            SELECT Id, Name, Email
            FROM User
            WHERE Id IN :userIds
        ]);
    }
}