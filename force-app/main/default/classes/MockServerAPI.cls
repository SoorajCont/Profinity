public with sharing class MockServerAPI {
  public class HttpException extends Exception {
  }
  public static Mock_Server__mdt data = [
    SELECT id, Base_Url__c
    FROM Mock_Server__mdt
  ];

  @AuraEnabled
  public static Candidate_Profile__c register(Id recordId, String password) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(data.Base_Url__c + '/api/auth/register');
    request.setHeader('Content-Type', 'application/json');
    request.setMethod('POST');
    Candidate_Profile__c candidate = getCandidate(recordId);
    String username = candidate.Last_Name__c;
    String email = candidate.Email__c;

    String body =
      '{"username":"' +
      username +
      '", "email":"' +
      email +
      '", "password":"' +
      password +
      '"}';
    System.debug(body);

    request.setBody(body);
    HttpResponse response = http.send(request);

    try {
      if (response.getStatusCode() == 201) {
        Map<String, Object> responseData = (Map<String, Object>) JSON.deserializeUntyped(
          response.getBody()
        );
        Map<String, Object> user = (Map<String, Object>) responseData.get(
          'data'
        );
        candidate.Mongo_Id__c = (String) user.get('_id');
        update candidate;
        System.debug(candidate);
      } else {
        throw new HttpException(
          'HTTP error: ' +
            response.getStatusCode() +
            ', Response: ' +
            response.getBody()
        );
      }
    } catch (HttpException ex) {
      Logger.error('HttpException: ' + ex.getMessage());
    } catch (System.CalloutException ex) {
      Logger.error('CalloutException: ' + ex.getMessage());
    } catch (Exception ex) {
      Logger.error('Unexpected exception: ' + ex.getMessage());
    }
    return candidate;
  }

  public static Candidate_Profile__c getCandidate(Id recordId) {
    // Query the custom metadata record based on Id
    Candidate_Profile__c serverRecord = [
      SELECT Id, Last_Name__c, First_Name__c, Email__c
      FROM Candidate_Profile__c
      WHERE Id = :recordId
    ];

    return serverRecord;
  }
}
