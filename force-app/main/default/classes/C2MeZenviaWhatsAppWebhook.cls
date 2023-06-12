@RestResource(urlMapping='/Chatt2MeWhatsAppWebhook/*')
global without sharing class C2MeZenviaWhatsAppWebhook {
    @httpGet
    global static String isWorking() {
        return 'Everything is working!';
    }

    @HttpPost
    global static void webhook() {
        try {
            C2Me.C2MeWebhookHandler.webhook(RestContext.request);            
        } catch(Exception ex) {
            Organization org = [SELECT Id, Name, InstanceName, IsSandbox, OrganizationType FROM Organization];
            
            Map<String, Object> mapResult = new Map<String, Object>();
            mapResult.put('OrgId', org.Id);
            mapResult.put('OrgName', org.Name);
            mapResult.put('OrgInstanceName', org.InstanceName);
            mapResult.put('IsSandbox', org.IsSandbox);
            mapResult.put('OrganizationType', org.OrganizationType);
            mapResult.put('RequestBody', RestContext.request.requestBody.toString());
            
            mapResult.put('errorMessage', ex.getMessage());
            mapResult.put('stackTrace', ex.getStackTraceString());
            mapResult.put('lineNumber', ex.getLineNumber());
            mapResult.put('typeName', ex.getTypeName());
            mapResult.put('cause', ex.getCause());
            
            String errorBody = JSON.serialize(mapResult);
            
            sendEmail(errorBody, org.Name);
            RestContext.response.statuscode = 500;
            RestContext.response.responseBody = Blob.valueOf(errorBody);
        }
    }
    
    private static void sendEmail(String errorBody, String orgName) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new List<String>{ 'salesforceteam@soublox.com' };
        message.optOutPolicy = 'FILTER';
        message.subject = 'Error on Chatt2.me Webhook:' + orgName;
        message.setPlainTextBody(errorBody);
        Messaging.SingleEmailMessage[] emailMessages = new List<Messaging.SingleEmailMessage>{ message };

        if (!Test.isRunningTest()) {
            Messaging.SendEmailResult[] result = Messaging.sendEmail(emailMessages, false);
            System.debug(result);
        }
    }
}