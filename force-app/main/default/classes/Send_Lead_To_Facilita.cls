global class Send_Lead_To_Facilita {
    @future (callout=true)
    public static void send_lead(Id lead_id) {
		Lead_Atendimento_Facilita__c updlead=[select Id, 
                                              Lead__r.Name, 
                                              Lead__r.Whatsapp__c, 
                                              Observacao__c 
                                              from Lead_Atendimento_Facilita__c where Id = :lead_id];
		
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://app.opus.inc/apis/leads/worker/create-lead-whatsapp');
        req.setMethod('POST');
        String body = '{ ' +
              '            "name": "' + updlead.Lead__r.Name + '", ' +
              '            "telefone": "' + updlead.Lead__r.Whatsapp__c + '",' +
              '            "observacao": "' + updlead.Observacao__c + '"' +
              '        }';

        req.setBody(body);
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
                
        updlead.Status__c='Concluído';
        update updlead;
    }
}