@isTest
public class DocusignPersonalizationsTest {
    @TestSetup
    private static void testSetup() {
        Empreendimento__c empreendimento = new Empreendimento__c(
            Name = 'Rosa dos Ventos',
            Data_de_lan_amento__c = date.today(),
            Razao_social__c = 'spe',
            CNPJ__c = '50.188.082/0001-18'
        );
        insert empreendimento;

        Unidade__c unidade = new Unidade__c(
            Name = 'UN-1', 
            Empreendimento__c=empreendimento.Id,
            Mostra_PV__c = 'Sim',
            Tipo_da_unidade__c = 'Unidade',
            Status_Secund_rio__c = 'Disponível',
            Total_Mensais__c = 1000,
            Total_Pre_Chaves__c = 1000,
            Total_Semestrais__c = 1000,
            Total_Sinais__c = 1000
        );
        insert unidade;

        Personaliza_es__c personalizacao = new Personaliza_es__c(
            Empreendimento__c = empreendimento.Id, 
            Unidade__c = unidade.Id, 
            Email_do_Cliente__c = 'cliente@opus.inc'
        );
        insert personalizacao;

        dfsle__Envelope__c envelope = new dfsle__Envelope__c(
            dfsle__SourceId__c = personalizacao.Id,
            dfsle__DocuSignId__c = '5da0415d-d467-4bb0-8918-46671866e499'
        );
        insert envelope;

        dfsle__Recipient__c recipient = new dfsle__Recipient__c(
            dfsle__SourceId__c = personalizacao.Id,
            dfsle__EnvelopeRecipientId__c = '26009',
            dfsle__Envelope__c = envelope.Id
        );
        insert recipient;
    }

    @isTest
    static void testEnvelopeTrigger() {
        Personaliza_es__c personalizacao = [SELECT Id, Name FROM Personaliza_es__c LIMIT 1];

        Test.startTest();
        
        dfsle__Envelope__c envelope = new dfsle__Envelope__c(
            dfsle__SourceId__c = personalizacao.Id,
            dfsle__DocuSignId__c = '12345'
        );
        insert envelope;

        Test.stopTest();

        dfsle__Envelope__c createdEnvelope = [SELECT Id, SourceObjectName__c FROM dfsle__Envelope__c WHERE Id =: envelope.Id];

        System.assertEquals('Personaliza_es__c', createdEnvelope.SourceObjectName__c, 'Object Name not equals');

    }

    @isTest
    static void testWebhook() {
        // Inicializar e configurar a requisição
        RestRequest req = new RestRequest();
        req.requestUri = 'https://seu-instance.salesforce.com/services/apexrest/DocuSignWebhook';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"event": "recipient-completed", "apiVersion": "v2.1", "uri": "/restapi/v2.1/accounts/a49f1077-ec4b-41e4-b682-b937e78aacf1/envelopes/5da0415d-d467-4bb0-8918-46671866e499", "retryCount": 0, "configurationId": 11136672, "generatedDateTime": "2023-06-02T01:45:53.6461044Z", "data": {"accountId": "a49f1077-ec4b-41e4-b682-b937e78aacf1", "userId": "d22fcfb9-345d-471e-98c1-8b369e434570", "envelopeId": "5da0415d-d467-4bb0-8918-46671866e499", "recipientId": "26009", "envelopeSummary": {"status": "sent", "documentsUri": "/envelopes/5da0415d-d467-4bb0-8918-46671866e499/documents", "recipientsUri": "/envelopes/5da0415d-d467-4bb0-8918-46671866e499/recipients", "attachmentsUri": "/envelopes/5da0415d-d467-4bb0-8918-46671866e499/attachments", "envelopeUri": "/envelopes/5da0415d-d467-4bb0-8918-46671866e499", "emailSubject": "CONTRATO OPUS PENTHOUSES MARISTA 146 1601 - PEDRO HENRIQUE FARIA ALBUQUERQUE", "emailBlurb": "Olá, Segue contrato para assinatura conforme alinhado entre as partes.Atenciosamente,Secretaria de Vendas.", "envelopeId": "5da0415d-d467-4bb0-8918-46671866e499", "signingLocation": "online", "customFieldsUri": "/envelopes/5da0415d-d467-4bb0-8918-46671866e499/custom_fields", "notificationUri": "/envelopes/5da0415d-d467-4bb0-8918-46671866e499/notification", "enableWetSign": "false", "allowMarkup": "false", "allowReassign": "true", "createdDateTime": "2023-06-01T13:58:58.827Z", "lastModifiedDateTime": "2023-06-01T14:08:51.653Z", "initialSentDateTime": "2023-06-01T14:08:59.06Z", "sentDateTime": "2023-06-02T01:46:07.52Z", "statusChangedDateTime": "2023-06-02T01:45:52.927Z", "documentsCombinedUri": "/envelopes/5da0415d-d467-4bb0-8918-46671866e499/documents/combined", "certificateUri": "/envelopes/5da0415d-d467-4bb0-8918-46671866e499/documents/certificate", "templatesUri": "/envelopes/5da0415d-d467-4bb0-8918-46671866e499/templates", "brandId": "ac64dee6-b6ae-4d3d-9dda-887b941e58b5", "expireEnabled": "true", "expireDateTime": "2024-05-31T14:08:59.06Z", "expireAfter": "364", "sender": {"userName": "Secretaria de Vendas", "userId": "d22fcfb9-345d-471e-98c1-8b369e434570", "accountId": "a49f1077-ec4b-41e4-b682-b937e78aacf1", "email": "sv@opus.inc", "ipAddress": "177.149.143.170"}, "customFields": {"textCustomFields": [{"fieldId": "8722043342", "name": "templateUsageRestriction", "show": "false", "required": "false", "value": "allOptions"}], "listCustomFields": []}, "recipients": {"signers": [{"creationReason": "sender", "isBulkRecipient": "false", "recipientSignatureProviders": [{"sealDocumentsWithTabsOnly": "false", "signatureProviderName": "universalsignaturepen_imageonly", "signatureProviderOptions": {}}], "requireUploadSignature": "false", "name": "Pedro Henrique Faria Albuquerque", "email": "pedrohfalbuquerque@gmail.com", "recipientId": "1", "recipientIdGuid": "e2cae261-1a4c-4ee3-a508-0944adfc3ecd", "requireIdLookup": "false", "userId": "bb698399-48c4-4ab3-85d3-4e463ee5b362", "routingOrder": "1", "note": "", "roleName": "Signer 1", "status": "completed", "completedCount": "1", "signedDateTime": "2023-06-02T00:40:27.41Z", "deliveredDateTime": "2023-06-02T00:38:16.7Z", "sentDateTime": "2023-06-01T14:08:57.793Z", "deliveryMethod": "email", "recipientType": "signer"}, {"creationReason": "sender", "isBulkRecipient": "false", "recipientSignatureProviders": [{"sealDocumentsWithTabsOnly": "false", "signatureProviderName": "universalsignaturepen_imageonly", "signatureProviderOptions": {}}], "requireUploadSignature": "false", "name": "KALITA AMORIM BRITO ALBUQUERQUE", "email": "kalitaa.brito@gmail.com", "recipientId": "26009", "recipientIdGuid": "e085282c-f698-4356-b002-33e431b7cf25", "requireIdLookup": "false", "userId": "3ee5bab8-b396-435e-be54-048ba0aacba8", "routingOrder": "1", "note": "De lattributeura0: The 2 documents you applied Leuzimar", "roleName": "Signer 2", "status": "completed", "completedCount": "1", "signedDateTime": "2023-06-02T01:45:52.927Z", "deliveredDateTime": "2023-06-02T01:07:59.107Z", "sentDateTime": "2023-06-01T14:08:58.42Z", "deliveryMethod": "email", "recipientType": "signer"}, {"creationReason": "sender", "isBulkRecipient": "false", "recipientSignatureProviders": [{"sealDocumentsWithTabsOnly": "false", "signatureProviderName": "universalsignaturepen_imageonly", "signatureProviderOptions": {}}], "requireUploadSignature": "false", "name": "Armando Gonçalves de Oliveira", "email": "armando.oliveira@opus.inc", "recipientId": "3", "recipientIdGuid": "a42ea03e-14d5-4fc6-a15c-1cd99f2971f0", "requireIdLookup": "false", "userId": "dc8375ec-96d7-4498-a2c1-8fd630f0367b", "routingOrder": "2", "status": "sent", "completedCount": "0", "sentDateTime": "2023-06-02T01:46:06.643Z", "deliveryMethod": "email", "recipientType": "signer"}, {"creationReason": "sender", "isBulkRecipient": "false", "recipientSignatureProviders": [{"sealDocumentsWithTabsOnly": "false", "signatureProviderName": "universalsignaturepen_imageonly", "signatureProviderOptions": {}}], "requireUploadSignature": "false", "name": "Wanessa Moreira da Silva Ferro", "email": "wanmoreira@hormail.com", "recipientId": "98488041", "recipientIdGuid": "7a1df78e-8973-483f-8032-523530c7aae3", "requireIdLookup": "false", "userId": "b3e5561a-6f9c-4230-8808-0db2c6ef831c", "routingOrder": "2", "note": "", "status": "sent", "completedCount": "0", "sentDateTime": "2023-06-02T01:46:07.347Z", "deliveryMethod": "email", "recipientType": "signer"}, {"creationReason": "sender", "isBulkRecipient": "false", "recipientSignatureProviders": [{"sealDocumentsWithTabsOnly": "false", "signatureProviderName": "universalsignaturepen_imageonly", "signatureProviderOptions": {}}], "requireUploadSignature": "false", "name": "Divino Alan de Mendonça", "email": "alan.mendonca@opus.inc", "recipientId": "4", "recipientIdGuid": "b36b9d4a-4256-456a-8d70-f9dfeed77cac", "requireIdLookup": "false", "userId": "5d5b5ee3-891f-4d42-b891-da88df1f27f7", "routingOrder": "2", "roleName": "Signer 3", "status": "sent", "completedCount": "0", "sentDateTime": "2023-06-02T01:46:06.94Z", "deliveryMethod": "email", "recipientType": "signer"}, {"creationReason": "sender", "isBulkRecipient": "false", "recipientSignatureProviders": [{"sealDocumentsWithTabsOnly": "false", "signatureProviderName": "universalsignaturepen_imageonly", "signatureProviderOptions": {}}], "requireUploadSignature": "false", "name": "Maria Lúcia Lopes Costa", "email": "maria.lucia@opus.inc", "recipientId": "5", "recipientIdGuid": "3e977de5-b7d4-476b-acc1-e014f675c00e", "requireIdLookup": "false", "userId": "807539ab-a42d-4113-adef-e812fd46b8b0", "routingOrder": "3", "roleName": "Signer 4", "status": "created", "completedCount": "0", "deliveryMethod": "email", "recipientType": "signer"}], "agents": [], "editors": [], "intermediaries": [], "carbonCopies": [{"name": "LEANDRO ALVES", "email": "leandro.alves@opus.inc", "recipientId": "94818913", "recipientIdGuid": "6ce92581-8de4-4103-b35c-b28395b51398", "requireIdLookup": "false", "userId": "05f4ca58-21bc-43d3-8f94-c094c1c31328", "routingOrder": "1", "note": "", "status": "completed", "completedCount": "0", "deliveredDateTime": "2023-06-01T14:35:38.157Z", "sentDateTime": "2023-06-01T14:08:58.933Z", "deliveryMethod": "email", "recipientType": "carboncopy"}, {"name": "CRC", "email": "crc@opus.inc", "recipientId": "6", "recipientIdGuid": "c375f10b-693a-48fa-b1c2-358cf64e5ff6", "requireIdLookup": "false", "userId": "f3132a32-28c8-4cdd-9fcf-b01f18857a2c", "routingOrder": "4", "roleName": "CC 1", "status": "created", "completedCount": "0", "deliveryMethod": "email", "recipientType": "carboncopy"}], "certifiedDeliveries": [], "inPersonSigners": [], "seals": [], "witnesses": [], "notaries": [], "recipientCount": "8", "currentRoutingOrder": "2"}, "purgeState": "unpurged", "envelopeIdStamping": "true", "is21CFRPart11": "false", "signerCanSignOnMobile": "true", "autoNavigation": "true", "isSignatureProviderEnvelope": "true", "hasFormDataChanged": "false", "allowViewHistory": "true", "disableResponsiveDocument": "false", "envelopeMetadata": {"allowAdvancedCorrect": "true", "enableSignWithNotary": "false", "allowCorrect": "true"}, "anySigner": "false", "envelopeLocation": "current_site", "isDynamicEnvelope": "false", "burnDefaultTabData": "false"}}}');
        
        // Inicia a execução de teste
        Test.startTest();
        
        RestContext.request = req;
        // Chama o seu método que executa a requisição
        DocuSignWebhook.handlePost();
        
        // Fim do bloco de teste
        Test.stopTest();

        // System.assertEquals(true, result);
        System.assertEquals(201, RestContext.response.statusCode);
        System.assertEquals('{"mensagem":"Evento criado com sucesso!"}', RestContext.response.responseBody.toString());

    }
}