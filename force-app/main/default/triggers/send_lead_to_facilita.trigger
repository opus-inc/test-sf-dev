trigger send_lead_to_facilita on Lead_Atendimento_Facilita__c (after insert) {
    for(Lead_Atendimento_Facilita__c lead:Trigger.New) {
         Send_Lead_To_Facilita.send_lead(lead.Id); 
    }
}