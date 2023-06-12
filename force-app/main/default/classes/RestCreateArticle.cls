global class RestCreateArticle {
    public static HelpDesk_Nota__c getNotaById(Id articleId) {
        HelpDesk_Nota__c nota = [SELECT Name, Descricao__c, Status_Sincronizacao__c, HelpDesk_Ticket__r.Ticket_ID__c FROM HelpDesk_Nota__c WHERE Id =: articleId];
        nota.Status_Sincronizacao__c = 'Iniciado';
        update nota;
        return nota;
    }

    @future (callout=true)
    public static void createArticleInOtrs(String notaString) {
        HelpDesk_Nota__c nota = (HelpDesk_Nota__c) System.JSON.deserialize(notaString, HelpDesk_Nota__c.class);

        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://app.opus.inc/apis/rest-otrs/create-article/' + nota.HelpDesk_Ticket__r.Ticket_ID__c);
        req.setMethod('PUT');
        String body = '{ \"Article\": { "ArticleTypeID\": 2, \"SenderTypeID\": 1, \"Subject\": \"' + nota.Name + '\", \"Body\": \"' + nota.Descricao__c.replaceAll('\r\n|\n|\r', ' ** ') + '\", \"ContentType\": \"text/plain; charset=utf8\", \"Charset\": \"utf8\", \"MimeType\": \"text/plain\", \"From\": \"atendimento@opus.inc\" } }';

        req.setBody(JSON.serialize(body));
        req.setHeader('Content-Type', 'application/json; charset=utf-8');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-length', string.valueOf(body.length()));
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String responseBody = res.getBody();
        System.debug(responseBody);

        try {
            TicketResponse ticketResponse = (TicketResponse) System.JSON.deserialize(responseBody, TicketResponse.class);
            nota.Ticket_ID__c = String.valueOf(ticketResponse.TicketID);
            nota.Nota_ID__c = String.valueOf(ticketResponse.ArticleID);
            nota.Status_Sincronizacao__c = 'Concluido';
            
            update nota;
        } catch (Exception e) {
            // TicketResponseError ticketResponseError = (TicketResponseError) System.JSON.deserialize(responseBody, TicketResponseError.class);
            nota.Status_Sincronizacao__c = 'Erro';
            update nota;
        }             
    }

    public class TicketResponse {
        public Integer ArticleID;
        public Integer TicketNumber;
        public Integer TicketID;
    }
    
    public class TicketResponseError {
        public Error error;
    }

    public class Error {
        public String ErrorCode; // "TicketCreate.AccessDenied",
        public String ErrorMessage; // "TicketCreate: Can not create tickets in given Queue or QueueID!"
    }

}