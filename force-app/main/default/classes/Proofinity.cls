public with sharing class Proofinity {
  @AuraEnabled
  public static String fetchToken(String code) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();

    // Set the endpoint URL
    request.setEndpoint(
      'https://digilocker.meripehchaan.gov.in/public/oauth2/2/token'
    );
    request.setMethod('POST');

    // Set headers
    request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
    request.setHeader('Accept', 'application/json');

    // Set encoded parameters
    String grantType = 'authorization_code';
    String redirectUri = 'http://contrivers--dev.sandbox.my.salesforce-sites.com/proofinity';
    String codeVerifier = 'BajUevvzBC3RaVLOGw.R8Q~y9d9WYDJCa0w11ehKW5W8A~r~GI0kmj10dYsr9Gb-dwHwFMm8Gp4zZflcB';
    String clientId = 'LF405089BA';
    String clientSecret = '48cf3d2a2da0598d6627';

    String requestBody =
      'grant_type=' +
      grantType +
      '&code=' +
      code +
      '&redirect_uri=' +
      redirectUri +
      '&code_verifier=' +
      codeVerifier +
      '&client_id=' +
      clientId +
      '&client_secret=' +
      clientSecret;
    request.setBody(requestBody);

    try {
      // Send the request
      HttpResponse response = http.send(request);

      if (response.getStatusCode() == 200) {
        System.debug('Success: ' + response.getStatusCode());

        Map<String, Object> responseData = (Map<String, Object>) JSON.deserializeUntyped(
          response.getBody()
        );

        return responseData.get('access_token').toString();
      } else {
        System.debug('Failure: ' + response.getStatusCode());
      }
      // Return the response body
      return '';
    } catch (Exception e) {
      System.debug('Error: ' + e.getMessage());
      return null;
    }
  }
}
