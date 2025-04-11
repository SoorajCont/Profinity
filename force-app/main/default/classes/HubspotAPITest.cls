@isTest
private class HubspotAPITest {


@IsTest
    public static void fetchContacts_Test() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HubspotAPITest());
        HubspotAPI.fetchContacts();
        Test.stopTest();
    }
}