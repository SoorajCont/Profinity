public with sharing class MockServerAPI {
  public static Mock_Server__mdt data = [
    SELECT id, Base_Url__c
    FROM Mock_Server__mdt
  ];

  public static void register() {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(data.Base_Url__c + '/api/auth/register');
    request.setHeader('Content-Type', 'application/json');
    request.setMethod('POST');
    String body = '{"username":"Kishan Kumar",    "email":"development9943@gmail.com",    "password":"12345678"}';
    request.setBody(body);
    HttpResponse res = http.send(request);
    Logger.info(JSON.serialize(res.getBody()));
    try {
      HttpResponse response = http.send(request);
      if (response.getStatusCode() == 200) {
        String responseBody = response.getBody();
        Logger.info('Success: ' + responseBody);
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
  }
}
