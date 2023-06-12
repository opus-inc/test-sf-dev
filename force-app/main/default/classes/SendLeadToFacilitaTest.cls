@isTest
private class SendLeadToFacilitaTest {
    @isTest 
    static void TestTrigger() {
        Lead lead = new Lead(FirstName='test', LastName='test', Phone='+5562999999999');
        insert lead;
        
        Test.setMock(HttpCalloutMock.class, new SendLeadToFacilitaMock()); 
        
        Test.startTest();
        
        Lead_Atendimento_Facilita__c lead_facilita = new Lead_Atendimento_Facilita__c(Lead__c=lead.Id, Status__c='Pendente', Observacao__c='fkjfdssd');
        insert lead_facilita;
    
        Test.stopTest();
    
        Lead_Atendimento_Facilita__c updatedLead = [SELECT Id, Status__c from Lead_Atendimento_Facilita__c where Id =: lead_facilita.Id];
        System.assertEquals(updatedLead.Status__c, 'Concluído');
    }
}