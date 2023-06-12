@IsTest
public with sharing class C2MeZenviaWhatsAppWebhookTest {
    @IsTest
    public static void testGet() {
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Demourl'; //Request url
        req.httpMethod = 'POST'; //HTTP Request Type

        RestContext.request = req;
        RestContext.response = res;

        System.assertEquals('Everything is working!', C2MeZenviaWhatsAppWebhook.isWorking());
        Test.stopTest();
    }

    @IsTest
    public static void testPost() {
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Demourl'; //Request url
        req.httpMethod = 'POST'; //HTTP Request Type

        req.requestBody = Blob.valueof(JSON.serialize(getTextMessage()));
        RestContext.request = req;
        RestContext.response = res;

        C2MeZenviaWhatsAppWebhook.webhook();
        Test.stopTest();

        List<C2Me__Conversation__c> allRows = [SELECT Id FROM C2Me__Conversation__c];
        System.assert(allRows.size() == 1);
    }
    
    @IsTest
    public static void testPostFail() {
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Demourl'; //Request url
        req.httpMethod = 'POST'; //HTTP Request Type

        req.requestBody = Blob.valueof('Cause an error Please!');
        RestContext.request = req;
        RestContext.response = res;

        C2MeZenviaWhatsAppWebhook.webhook();
        Test.stopTest();

        List<C2Me__Conversation__c> allRows = [SELECT Id FROM C2Me__Conversation__c];
        System.assert(allRows.size() == 0);
    }

    private static Map<String, Object> getTextMessage() {
        Map<String, Object> body = new Map<String, Object>();
        body.put('type', 'MESSAGE');
        body.put('channel', 'whatsapp');
        body.put('timestamp', '2020-12-06T21:00:04.889Z');

        Map<String, Object> messsageBody = new Map<String, Object>();
        messsageBody.put('id', 'asd-123-asd');
        messsageBody.put('direction', 'IN');
        messsageBody.put('from', 'fromNumber');
        messsageBody.put('to', 'toNumber');
        Map<String, Object> visitorBody = new Map<String, Object>();
        visitorBody.put('firstName', 'Fernando');
        visitorBody.put('lastName', 'Sousa');

        messsageBody.put('visitor', visitorBody);

        Map<String, Object> contentBody = new Map<String, Object>();
        contentBody.put('type', 'text');
        contentBody.put('text', 'Hellow World');

        messsageBody.put('contents', new List<Object>{ contentBody });

        body.put('message', messsageBody);

        return body;
    }

    @TestSetup
    static void setup() {
        C2Me__Chatt2meNumber__c chatt2meNumber = new C2Me__Chatt2meNumber__c();
        chatt2meNumber.C2Me__Phone__c = 'toNumber';
        chatt2meNumber.C2Me__Status__c = 'Active';
        chatt2meNumber.C2Me__Default__C = true;

        insert chatt2meNumber;
        
        C2Me__Chatt2me_Contact__c chatt2MeContact = new C2Me__Chatt2me_Contact__c();
        chatt2MeContact.C2Me__Phone__c = 'fromNumber';
        chatt2MeContact.Step__c = 'Em Atendimento';
        chatt2MeContact.C2Me__Chatt2me_Number__c = chatt2meNumber.Id;
        insert chatt2MeContact;
        
        C2Me__Chatt2MeSettings__c custom = new C2Me__Chatt2MeSettings__c();
        custom.C2Me__ZenviaAPI_Token__c = '123';
        custom.C2Me__ZenviaAPI_Endpoint__c = 'https://api.zenvia.com';
        custom.C2Me__WhatsApp_Expiration_in_Minutes__c = 1600;

        insert custom;
    }
}