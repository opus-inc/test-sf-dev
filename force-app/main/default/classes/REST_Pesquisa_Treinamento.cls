@RestResource(urlMapping='/pesquisa-treinamentos/*')
global class REST_Pesquisa_Treinamento {
	@HttpPost
    global static String createPesquisaTreinamento(
    	String nome,
        String telefone,
        String email,
        String cpf,
        String treinamento,
        String obs,
        String resposta1,
        String resposta2,
        String resposta3,
        String resposta4,
        String resposta5
    ) {
        Treinamento__c findTreinamento;
        Corretores__c corretor;
        Pesquisa__c pesquisa = new Pesquisa__c();

        try{
			findTreinamento = [SELECT Id FROM Treinamento__c WHERE Treinamento__c =: treinamento LIMIT 1];
		} catch(Exception ex) {
            return '"{" "error" : "Treinamento não existe" "}"';
        }
        
        try{
			corretor = [SELECT Id FROM Corretores__c WHERE CPF__c =: cpf LIMIT 1];
		} catch(Exception ex) {
            corretor = new Corretores__c();
        	corretor.CPF__c=cpf;
        	corretor.Email__c=email;
        	corretor.Telefone__c=telefone;
        	corretor.Name=nome;
        	corretor.Origem__c = 'Salesforce';
            insert corretor;
        }
        
        pesquisa.Tipo_da_Pesquisa__c = 'Treinamento Corretores';
        pesquisa.Corretor__c = corretor.Id;
        pesquisa.Nota__c = resposta1;
        pesquisa.Nota_2__c = resposta2;
        pesquisa.Nota_3__c = resposta3;
        pesquisa.Nota_4__c = resposta4;
        pesquisa.Nota_5__c = resposta5;
        pesquisa.Treinamento__c = findTreinamento.Id;
		pesquisa.Status__c = 'Respondido';
        pesquisa.Data_da_Resposta__c = datetime.now();
        pesquisa.Comentarios__c = obs;
        insert pesquisa;
        return System.JSON.serialize(pesquisa);
    }
}