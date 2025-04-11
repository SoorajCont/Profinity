public class HttpAPIFramework {
  public class HttpException extends Exception {
  }

  public static final String AUTH_TOKEN = new PageReference('/resource/Token')
    .getContent()
    .toString();
  public static final String BASE_URL = 'https://api.hubapi.com/crm/v3/objects';

  // Method to make HTTP requests to multiple endpoints
  public static void callMultipleEndpoints(List<String> endpoints) {
    for (String endpoint : endpoints) {
      makeApiCall(BASE_URL + endpoint); // Call each endpoint
    }
  }

  // Method to handle individual API calls
  @future(callout=true)
  public static void makeApiCall(String fullUrl) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(fullUrl);
    request.setMethod('GET');
    request.setHeader('Authorization', 'Bearer ' + AUTH_TOKEN);

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
