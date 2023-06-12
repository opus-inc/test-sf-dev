@RestResource(urlMapping='/DocuSignWebhook/*')
global class DocuSignWebhook {
    @HttpPost
    global static void handlePost() {
        String requestBody = RestContext.request.requestBody.toString();
        RestResponse res = RestContext.response;

        // Se o objeto RestResponse for nulo, nós o inicializamos
        if(res == null){
            res = new RestResponse();
            RestContext.response = res;
        }

        try {
            Map<String, Object> requestBodyMap = (Map<String, Object>) JSON.deserializeUntyped(requestBody);

            String envelopeId = (String)((Map<String, Object>)requestBodyMap.get('data')).get('envelopeId');
            dfsle__Envelope__c envelope = [
                SELECT 
                    Id, 
                    dfsle__SourceId__c, 
                    dfsle__DocuSignId__c 
                FROM dfsle__Envelope__c 
                WHERE dfsle__DocuSignId__c =:envelopeId 
                LIMIT 1
            ];

            if (envelope == null) {
                res.statusCode = 200;
                res.responseBody = Blob.valueOf('{"mensagem":"Envelope não encontrado"}');
                return;
            }

            Id sourceId = Id.valueOf(envelope.dfsle__SourceId__c);
            String objectName = sourceId.getSObjectType().getDescribe().getName();

            Evento_de_Envelope__c evento = new Evento_de_Envelope__c(
                Nome__c = (String)requestBodyMap.get('event'),
                DocuSign_Envelope__c = envelope.Id,
                sourceId__c = (String) sourceId,
                sourceObject__c = objectName,
                eventData__c = String.valueOf(requestBodyMap.get('data'))
            );

            insert evento;

            if((String)requestBodyMap.get('event') == 'recipient-completed') {
                Map<String, Object> data = (Map<String, Object>)requestBodyMap.get('data');
                dfsle__Recipient__c recipient = [
                    SELECT 
                        Id, 
                        dfsle__SourceId__c, 
                        dfsle__EnvelopeRecipientId__c 
                    FROM dfsle__Recipient__c 
                    WHERE 
                        dfsle__Envelope__c =:envelope.Id AND
                        dfsle__EnvelopeRecipientId__c =:(String)data.get('recipientId')
                    LIMIT 1
                ];

                recipient.Status__c = 'Concluído';
                update recipient;
            }

            res.statusCode = 201;
            res.responseBody = Blob.valueOf('{"mensagem":"Evento criado com sucesso!"}');
            
            return;
        } catch (Exception e) {
            System.debug(e);
            res.statusCode = 400;
            res.responseBody = Blob.valueOf('{"mensagem":"'+ e.getMessage() +'"}');
            
            return;
        }
    }
}