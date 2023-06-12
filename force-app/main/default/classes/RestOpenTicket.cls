global class RestOpenTicket {
    public static HelpDesk_Ticket__c getTicketById(Id ticketId) {
        HelpDesk_Ticket__c ticket=[
                        SELECT Id, 
                            Name,
                            Ticket_ID__c,
                            Ticket_Number__c,
                            Fila__c
                            FROM HelpDesk_Ticket__c 
                            WHERE Id = :ticketId
                        ];
         ticket.Status_Sincronizacao__c = 'Iniciado';
        update ticket;
        return ticket;
    }

    public static HelpDesk_Nota__c getNotaByTicketId(Id ticketId) {
        HelpDesk_Nota__c nota = [SELECT Name, Descricao__c FROM HelpDesk_Nota__c WHERE HelpDesk_Ticket__c =: ticketId];
        return nota;
    }

    @future (callout=true)
    public static void createTicketInOtrs(String ticketString, String notaString) {
        HelpDesk_Ticket__c ticket = (HelpDesk_Ticket__c) System.JSON.deserialize(ticketString, HelpDesk_Ticket__c.class);
        HelpDesk_Nota__c nota = (HelpDesk_Nota__c) System.JSON.deserialize(notaString, HelpDesk_Nota__c.class);

        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://app.opus.inc/apis/rest-otrs/create-ticket');
        req.setMethod('POST');
        String body = '{ \"Ticket\": { \"Title\": \"' + ticket.Name + '\", \"Queue\": \"' + ticket.Fila__c + '\", \"ServiceID\": 600, \"SLAID\": 4, \"CustomerUser\": \"atendimento@opus.inc\", \"State\": \"new\", \"PriorityID\": 3, \"Type\": \"Solicitação\", \"Solicitante\": \"Opera - Administração\" }, \"Article\": { "ArticleTypeID\": 2, \"SenderTypeID\": 1, \"Subject\": \"' + nota.Name + '\", \"Body\": \"' + nota.Descricao__c.replaceAll('\r\n|\n|\r', ' ** ') + '\", \"ContentType\": \"text/plain; charset=utf8\", \"Charset\": \"utf8\", \"MimeType\": \"text/plain\", \"From\": \"atendimento@opus.inc\" } }';

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
            ticket.Ticket_ID__c = String.valueOf(ticketResponse.TicketID);
            ticket.Ticket_Number__c = String.valueOf(ticketResponse.TicketNumber);
            ticket.Status_Sincronizacao__c = 'Concluido';
            nota.Ticket_ID__c = String.valueOf(ticketResponse.TicketID);
            nota.Nota_ID__c = String.valueOf(ticketResponse.ArticleID);
            nota.Status_Sincronizacao__c = 'Concluido';
            
            update nota;
            update ticket;
        } catch (Exception e) {
            // TicketResponseError ticketResponseError = (TicketResponseError) System.JSON.deserialize(responseBody, TicketResponseError.class);
            ticket.Status_Sincronizacao__c = 'Erro';
            update ticket;
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