@isTest
private class ServiceRequestHandlerTest {

    @isTest
    static void testDefaultsOnInsert() {
        Service_Request__c sr = new Service_Request__c(
            Subject__c = 'Test subject',
            Description__c = 'Test description',
            Priority__c = 'Medium'
        );

        Test.startTest();
        insert sr;
        Test.stopTest();

        Service_Request__c insertedSr = [
            SELECT Status__c, Due_Date__c
            FROM Service_Request__c
            WHERE Id = :sr.Id
        ];

        System.assertEquals('New', insertedSr.Status__c, 'Status should default to New');
        System.assertEquals(Date.today().addDays(3), insertedSr.Due_Date__c, 'Due date should default to today + 3');
    }

    @isTest
    static void testKeywordSetsPriorityHigh() {
        Service_Request__c sr = new Service_Request__c(
            Subject__c = 'urgent printer issue',
            Description__c = 'Printer is failing',
            Priority__c = 'Medium'
        );

        Test.startTest();
        insert sr;
        Test.stopTest();

        Service_Request__c insertedSr = [
            SELECT Priority__c
            FROM Service_Request__c
            WHERE Id = :sr.Id
        ];

        System.assertEquals('High', insertedSr.Priority__c, 'Priority should become High when urgent/critical is present');
    }

    @isTest
    static void testPriorityChangeToHighUpdatesDueDate() {
        Service_Request__c sr = new Service_Request__c(
            Subject__c = 'Normal request',
            Description__c = 'Regular issue',
            Status__c = 'New',
            Priority__c = 'Medium'
        );
        insert sr;

        sr.Priority__c = 'High';

        Test.startTest();
        update sr;
        Test.stopTest();

        Service_Request__c updatedSr = [
            SELECT Priority__c, Due_Date__c
            FROM Service_Request__c
            WHERE Id = :sr.Id
        ];

        System.assertEquals('High', updatedSr.Priority__c, 'Priority should be High after update');
        System.assertEquals(Date.today().addDays(1), updatedSr.Due_Date__c, 'Due date should become today + 1 when priority changes to High');
    }

    @isTest
    static void testBulkInsert200() {
        List<Service_Request__c> requests = new List<Service_Request__c>();

        for (Integer i = 0; i < 200; i++) {
            requests.add(new Service_Request__c(
                Subject__c = 'Bulk subject ' + i,
                Description__c = 'Bulk description ' + i,
                Priority__c = 'Medium'
            ));
        }

        Test.startTest();
        insert requests;
        Test.stopTest();

        List<Service_Request__c> insertedRequests = [
            SELECT Status__c, Due_Date__c
            FROM Service_Request__c
            WHERE Id IN :requests
        ];

        System.assertEquals(200, insertedRequests.size(), 'Should insert 200 records');

        for (Service_Request__c sr : insertedRequests) {
            System.assertEquals('New', sr.Status__c, 'Bulk insert should default Status to New');
            System.assertEquals(Date.today().addDays(3), sr.Due_Date__c, 'Bulk insert should default Due Date to today + 3');
        }
    }

    @isTest
    static void testBulkUpdate200ToHigh() {
        List<Service_Request__c> requests = new List<Service_Request__c>();

        for (Integer i = 0; i < 200; i++) {
            requests.add(new Service_Request__c(
                Subject__c = 'Bulk update subject ' + i,
                Description__c = 'Bulk update description ' + i,
                Status__c = 'New',
                Priority__c = 'Medium'
            ));
        }
        insert requests;

        for (Service_Request__c sr : requests) {
            sr.Priority__c = 'High';
        }

        Test.startTest();
        update requests;
        Test.stopTest();

        List<Service_Request__c> updatedRequests = [
            SELECT Priority__c, Due_Date__c
            FROM Service_Request__c
            WHERE Id IN :requests
        ];

        System.assertEquals(200, updatedRequests.size(), 'Should update 200 records');

        for (Service_Request__c sr : updatedRequests) {
            System.assertEquals('High', sr.Priority__c, 'Bulk update should set Priority to High');
            System.assertEquals(Date.today().addDays(1), sr.Due_Date__c, 'Bulk update should set Due Date to today + 1');
        }
    }
}