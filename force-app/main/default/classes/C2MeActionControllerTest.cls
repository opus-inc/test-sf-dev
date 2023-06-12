@isTest
public with sharing class C2MeActionControllerTest {
   @isTest
   public static void finishConversation(){
    C2Me__Chatt2meNumber__c chatt2meNumberId = [SELECT Id FROM C2Me__Chatt2meNumber__c WHERE C2Me__Display_Name__c = 'number1'];
    C2Me__Chatt2me_Contact__c chatt2meContactId = [SELECT Id FROM C2Me__Chatt2me_Contact__c];
    
    C2Me.HttpCalloutMockTools globalmock = new C2Me.HttpCalloutMockTools();
    globalmock.setResponseBody('{"id": "1123-abc-123"}');
    globalmock.setMock(globalmock);

    test.startTest();
    C2MeActionController.finishConversation(chatt2meNumberId.Id, chatt2meContactId.Id, 'teste', 'step-test', true);
    test.stopTest();

   }

   @isTest
   public static void getChatt2meNumbers(){
    C2Me__Chatt2meNumber__c chatt2meNumberId = [SELECT Id FROM C2Me__Chatt2meNumber__c WHERE C2Me__Display_Name__c = 'number1'];

    test.startTest();
    List<C2Me__Chatt2meNumber__c>  chatt2meNumberIdLst = C2MeActionController.getChatt2meNumbers(chatt2meNumberId.Id);
    test.stopTest();
   }

   @isTest
   public static void getDepartamentName(){
        C2Me__Chatt2me_Contact__c chatt2meContactId = [SELECT Id FROM C2Me__Chatt2me_Contact__c];

        test.startTest();
        String message = C2MeActionController.getDepartamentName(chatt2meContactId.Id);
        test.stopTest();
   }

   @isTest
   public static void setNewDepartament(){
        C2Me__Chatt2meNumber__c chatt2meNumberId = [SELECT Id FROM C2Me__Chatt2meNumber__c WHERE C2Me__Display_Name__c = 'number1'];
        C2Me__Chatt2meNumber__c newChatt2meNumberId = [SELECT Id FROM C2Me__Chatt2meNumber__c WHERE C2Me__Display_Name__c = 'number2'];
        C2Me__Chatt2me_Contact__c chatt2meContactId = [SELECT Id FROM C2Me__Chatt2me_Contact__c];

        C2Me.HttpCalloutMockTools globalmock = new C2Me.HttpCalloutMockTools();
        globalmock.setResponseBody('{"id": "1123-abc-123"}');
        globalmock.setMock(globalmock);

        test.startTest();
        C2MeActionController.setNewDepartament(chatt2meNumberId.Id, newChatt2meNumberId.Id, chatt2meContactId.Id, 'test message');
        test.stopTest();
   }

   @TestSetup
   static void makeData(){
        C2Me__Chatt2meNumber__c chatt2meNumber = new C2Me__Chatt2meNumber__c();
        chatt2meNumber.C2Me__Phone__c = 'toNumber';
        chatt2meNumber.C2Me__Display_Name__c = 'number1';
        chatt2meNumber.C2Me__SMS_Phone_Number__c = 'toSmsNumber';
        chatt2meNumber.C2Me__Status__c = 'Active';
        chatt2meNumber.C2Me__Default__C = true;
        insert chatt2meNumber;

        C2Me__Chatt2MeSettings__c custom = new C2Me__Chatt2MeSettings__c();
        custom.C2Me__ZenviaAPI_Token__c = '123';
        custom.C2Me__ZenviaAPI_Endpoint__c = 'https://api.zenvia.com';
        custom.C2Me__WhatsApp_Expiration_in_Minutes__c = 1600;
        custom.C2Me__Mapbox_Access_Token__c = 'abcdefg';
        insert custom;

        C2Me__UserToChatt2me__c userChatt = new C2Me__UserToChatt2me__c();
        userChatt.C2Me__User__c = UserInfo.getUserId();
        userChatt.C2Me__Default__c = true;
        userChatt.C2Me__Chatt2me_Number__c = chatt2meNumber.Id;
        insert userChatt;

        C2Me__Chatt2meNumber__c chatt2meNumber2 = new C2Me__Chatt2meNumber__c();
        chatt2meNumber2.C2Me__Phone__c = 'toNumber';
        chatt2meNumber2.C2Me__Display_Name__c = 'number2';
        chatt2meNumber2.C2Me__SMS_Phone_Number__c = 'toSmsNumber';
        chatt2meNumber2.C2Me__Status__c = 'Active';
        chatt2meNumber2.C2Me__Default__C = false;
        insert chatt2meNumber2;

        C2Me__UserToChatt2me__c userChatt2 = new C2Me__UserToChatt2me__c();
        userChatt2.C2Me__User__c = UserInfo.getUserId();
        userChatt2.C2Me__Default__c = true;
        userChatt2.C2Me__Chatt2me_Number__c = chatt2meNumber.Id;
        insert userChatt2;

        C2Me__Chatt2me_Contact__c chatt2MeContact = new C2Me__Chatt2me_Contact__c();
        chatt2MeContact.C2Me__Phone__c = 'fromNumber';
        chatt2MeContact.C2Me__Chatt2me_Number__c = chatt2meNumber.Id;
        insert chatt2MeContact;

        C2Me__Chatt2me_Contact_Share__c contactShare = new C2Me__Chatt2me_Contact_Share__c();
        contactShare.C2Me__Chatt2me_Number__c = chatt2meNumber.Id;
        contactShare.C2Me__Chatt2me_Contact__c = chatt2MeContact.Id;
        contactShare.C2Me__Token__c = C2MeActionController.getMd5((String) contactShare.C2Me__Chatt2me_Number__c + (String) contactShare.C2Me__Chatt2me_Contact__c);
        contactShare.C2Me__Archived__c = false;
        insert contactShare;

        C2Me__Conversation__c conversationMessage = new C2Me__Conversation__c();
        conversationMessage.C2Me__Message__c = 'message!'; 
        conversationMessage.C2Me__Chatt2me_Number__c = chatt2meNumber.Id; 
        conversationMessage.C2Me__Chatt2me_Contact__c = chatt2MeContact.Id; 
        conversationMessage.C2Me__Direction__c = 'Out'; 
        conversationMessage.C2Me__Type__c = 'Text'; 
        conversationMessage.C2Me__Status__c = 'Sent';
        insert conversationMessage;
   }
}