@isTest
private class HelpdeskTicketTest {
    @TestSetup
    private static void testSetup(){        
        HelpDesk_Ticket__c ticket = new HelpDesk_Ticket__c(
            Name='teste nome', 
            Fila__c='TI',
            Ticket_ID__c='1',
            Ticket_Number__c='1',
            Data_Ticket__c=Date.newInstance(2022, 10, 06)
        );
        insert ticket;

        HelpDesk_Nota__c nota = new HelpDesk_Nota__c(
            Name='teste nome', 
            Descricao__c='teste descrição',
            HelpDesk_Ticket__c=ticket.Id, 
            Autor__c='autor teste', 
            Ticket_ID__c='1',
            Nota_ID__c='1',
            Data_Nota__c=Date.newInstance(2022, 10, 06)
        );
        insert nota;
    }
    
    @isTest 
    static void TestTicketTrigger() {
        HelpDesk_Ticket__c ticket = [SELECT Id, Status_Sincronizacao__c FROM HelpDesk_Ticket__c WHERE Name = 'teste nome'];
        
        Test.setMock(HttpCalloutMock.class, new HelpdeskTicketMock()); 
        
        Test.startTest();
        
        ticket.Status_Sincronizacao__c = 'Pendente';
        update ticket;
    
        Test.stopTest();
    
        HelpDesk_Ticket__c updatedTicket = [SELECT Id, Status_Sincronizacao__c from HelpDesk_Ticket__c where Id =: ticket.Id];
        System.assertEquals(updatedTicket.Status_Sincronizacao__c, 'Concluido');
    }
    
    @isTest 
    static void TestArticleTrigger() {
        HelpDesk_Ticket__c ticket = [SELECT Id FROM HelpDesk_Ticket__c WHERE Name = 'teste nome'];
              
        Test.setMock(HttpCalloutMock.class, new HelpdeskArticleMock()); 
        
        Test.startTest();
        
        HelpDesk_Nota__c nota = new HelpDesk_Nota__c(
            Name='teste nome', 
            Descricao__c='teste descrição',
            HelpDesk_Ticket__c=ticket.Id, 
            Autor__c='autor teste', 
            Status_Sincronizacao__c='Pendente',
            Data_Nota__c=Date.newInstance(2022, 10, 06)
        );
        insert nota;
    
        Test.stopTest();
    
        HelpDesk_Nota__c updatedArticle = [SELECT Id, Status_Sincronizacao__c from HelpDesk_Nota__c where Id =: nota.Id];
        System.assertEquals(updatedArticle.Status_Sincronizacao__c, 'Concluido');
    }
}