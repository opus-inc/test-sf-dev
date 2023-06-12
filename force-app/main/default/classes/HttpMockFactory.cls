@isTest
global class HttpMockFactory implements HttpCalloutMock {
    protected Integer code;
    protected String status;
    protected String body;
    protected Map<String, String> responseHeaders;
    
    public HttpMockFactory(Integer code, String status, String body, Map<String, String> responseHeaders) {
        this.code = code;
        this.status = status;
        this.body = body;
        this.responseHeaders = responseHeaders;
    }
    
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(code);
        res.setStatus(status);
        res.setBody(body);
        if(responseHeaders != null){
            for(String headerKey : responseHeaders.keySet()){
                res.setHeader(headerKey, responseHeaders.get(headerKey));
            }
        }
        
        return res;
    }
}