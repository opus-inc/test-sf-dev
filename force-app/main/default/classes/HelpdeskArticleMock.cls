@isTest
global class HelpdeskArticleMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('https://app.opus.inc/apis/rest-otrs/create-article/1', req.getEndpoint());
        System.assertEquals('PUT', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{}');
        res.setStatusCode(201);
        return res;
    }
}