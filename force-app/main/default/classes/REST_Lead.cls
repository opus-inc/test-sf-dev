@RestResource(urlMapping='/leads/*')
global class REST_Lead {
	@HttpPost
    global static String createLead(
    	String nome,
        String email,
        String cpf,
        String tipo,
        String telefone,
        String produto,
        String stand,
        String aceite,
        DateTime data_visita
    ) {
        Lead lead;
        Empreendimento__c empreendimento = [SELECT Id FROM Empreendimento__c WHERE Name =: produto LIMIT 1];
        
        try {
        	lead = [SELECT Id FROM Lead WHERE Email_new__c =: email LIMIT 1];
            lead.Phone=telefone;
            lead.Whatsapp__c=telefone;
            lead.Celular__c=telefone;
            lead.LastName=nome;
            lead.Enviar_Informa_es_Promocionais__c=aceite;
            lead.CPF__c = cpf;
            lead.LeadSource = tipo;
       } catch (Exception ex) {
        	lead = new Lead(
                LastName=nome,
                Email_new__c=email,
                Phone=telefone,
                Whatsapp__c=telefone,
                Celular__c=telefone,
                Enviar_Informa_es_Promocionais__c=aceite,
                CPF__c=cpf,
                LeadSource=tipo
            );
        }
        upsert lead;
        
        Visita_de_Stand__c visita = new Visita_de_Stand__c(
        	Data_da_Visita__c=data_visita,
            Empreendimento__c=empreendimento.Id,
            Lead__c=lead.Id,
            Stand__c=stand
        );
        
        insert visita;
        
		return System.JSON.serialize(lead);
    }
}