public with sharing class MockServerGetRecord {
  @AuraEnabled
  public static Candidate_Profile__c getMockServerById(Id recordId) {
    // Query the custom metadata record based on Id
    Candidate_Profile__c serverRecord = [
      SELECT Id, Last_Name__c, First_Name__c, Email__c
      FROM Candidate_Profile__c
      WHERE Mongo_Id__c = :recordId
      LIMIT 1
    ];
    return serverRecord;
  }
}
