@RestResource(urlMapping='/treinamentos/*')
global class REST_Treinamento {
	@HttpPost
    global static String createTreinamento(String nome, String empreendimento, Datetime data, String ministrante, String local) {
        Treinamento__c treinamento;
        
        try{
			treinamento = [SELECT Id FROM Treinamento__c WHERE Treinamento__c =: nome LIMIT 1];
		} catch(Exception ex) {
            treinamento = new Treinamento__c(Treinamento__c=nome);
        }
        
        try{
        	treinamento.Empreendimento__c = [SELECT Id FROM Empreendimento__c WHERE Name =: empreendimento LIMIT 1].Id;
        } catch(Exception ex) {
            treinamento.Empreendimento__c = null;
        }

       	treinamento.Data__c = data;
        treinamento.Ministrante__c = ministrante;
        treinamento.Local__c = local;
        
        upsert treinamento;
        return System.JSON.serialize(treinamento);
    }
}