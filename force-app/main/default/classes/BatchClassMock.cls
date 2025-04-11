global class BatchClassMock implements Database.Batchable<SObject> {
  global Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator(
      'SELECT Id, Last_Name__c FROM Candidate_Profile__c'
    );
  }

  global void execute(Database.BatchableContext BC, List<SObject> scope) {
    for (SObject record : scope) {
      Candidate_Profile__c con = (Candidate_Profile__c) record;
      System.debug('Processing record: ' + con.Name);
    }
  }

  global void finish(Database.BatchableContext BC) {
    System.debug('Batch process complete!');
  }
}
