@RestResource(urlMapping='/api/Webhooks/incoming/pushDetails/*')
global with sharing class WebhookClass {
  // Handle POST request - Insert new record
  @HttpPost
  global static String handlePostNotification() {
    RestRequest request = RestContext.request;
    RestResponse response = RestContext.response;

    try {
      // Parse request body (assuming JSON input)
      String requestBody = request.requestBody.toString();
      Map<String, Object> requestData = (Map<String, Object>) JSON.deserializeUntyped(
        requestBody
      );

      // Insert new Account record
      Account acc = new Account(Name = (String) requestData.get('name'));
      insert acc;

      response.statusCode = 201;
      return JSON.serializePretty(
        new Map<String, Object>{
          'message' => 'Account created successfully',
          'id' => acc.Id
        }
      );
    } catch (Exception e) {
      response.statusCode = 500;
      return JSON.serializePretty(
        new Map<String, Object>{ 'error' => e.getMessage() }
      );
    }
  }

  // Handle GET request - Retrieve record details
  @HttpGet
  global static String handleGetRequest() {
    try {
      List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 5];

      return JSON.serializePretty(
        new Map<String, Object>{ 'accounts' => accounts }
      );
    } catch (Exception e) {
      return JSON.serializePretty(
        new Map<String, Object>{ 'error' => e.getMessage() }
      );
    }
  }

  // Handle PUT request - Update record
  @HttpPut
  global static String handlePutRequest() {
    RestRequest request = RestContext.request;
    RestResponse response = RestContext.response;

    try {
      String requestBody = request.requestBody.toString();
      Map<String, Object> requestData = (Map<String, Object>) JSON.deserializeUntyped(
        requestBody
      );
      String userId = (String) requestData.get('Id');

      Account acc = [
        SELECT Id, Name
        FROM Account
        WHERE Id = :userId
      ];
      acc.Name = (String) requestData.get('name');
      update acc;

      response.statusCode = 200;
      return JSON.serializePretty(
        new Map<String, Object>{
          'message' => 'Account updated successfully',
          'id' => acc.Id
        }
      );
    } catch (Exception e) {
      response.statusCode = 500;
      return JSON.serializePretty(
        new Map<String, Object>{ 'error' => e.getMessage() }
      );
    }
  }

  // Handle DELETE request - Delete record
  @HttpDelete
  global static String handleDeleteRequest() {
    RestRequest request = RestContext.request;
    RestResponse response = RestContext.response;

    try {
      String requestBody = request.requestBody.toString();
      Map<String, Object> requestData = (Map<String, Object>) JSON.deserializeUntyped(
        requestBody
      );

      String userId = (String) requestData.get('Id');

      Account acc = [
        SELECT Id, Name
        FROM Account
        WHERE Id = :userId
        LIMIT 1
      ];
      delete acc;

      response.statusCode = 204;
      return JSON.serializePretty(
        new Map<String, Object>{ 'message' => 'Account deleted successfully' }
      );
    } catch (Exception e) {
      response.statusCode = 500;
      return JSON.serializePretty(
        new Map<String, Object>{ 'error' => e.getMessage() }
      );
    }
  }

  // Handle PATCH request - Modify specific fields
  @HttpPatch
  global static String handlePatchRequest() {
    RestRequest request = RestContext.request;
    RestResponse response = RestContext.response;

    try {
      String requestBody = request.requestBody.toString();
      Map<String, Object> requestData = (Map<String, Object>) JSON.deserializeUntyped(
        requestBody
      );

      String userId = (String) requestData.get('userId');

      // Query and check if record exists
      List<Account> accList = [
        SELECT Id, Name
        FROM Account
        WHERE Id = :userId
      ];

      if (accList.isEmpty()) {
        // Safeguard against empty result
        response.statusCode = 404;
        return JSON.serializePretty(
          new Map<String, Object>{ 'error' => 'Account not found' }
        );
      }

      Account acc = accList[0]; // Retrieve the first result safely

      if (requestData.containsKey('name')) {
        acc.Name = (String) requestData.get('name');
      }
      update acc;

      response.statusCode = 200;
      return JSON.serializePretty(
        new Map<String, Object>{
          'message' => 'Account patched successfully',
          'id' => acc.Id,
          'acc' => acc
        }
      );
    } catch (Exception e) {
      response.statusCode = 500;
      return JSON.serializePretty(
        new Map<String, Object>{ 'error' => e.getMessage() }
      );
    }
  }
}
