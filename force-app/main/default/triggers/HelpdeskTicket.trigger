trigger HelpdeskTicket on HelpDesk_Ticket__c (after update) {
    for( Id ticketId : Trigger.newMap.keySet() ) {
        if(Trigger.newMap.get( ticketId ).Status_Sincronizacao__c == 'Pendente') {
            HelpDesk_Ticket__c ticket = RestOpenTicket.getTicketById(ticketId);
            HelpDesk_Nota__c nota = RestOpenTicket.getNotaByTicketId(ticketId);
            
            RestOpenTicket.createTicketInOtrs(JSON.serialize(ticket), JSON.serialize(nota));
        }
    }
}