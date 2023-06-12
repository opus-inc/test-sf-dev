public class CorretorUtil  {

        public static Corretores__c buildCorretorForTest(){
        	Corretores__c corretor = new Corretores__c(
        		CPF__c = '718.068.491-00', Email__c = 'janeoliveira.imoveis@creci.org.br', Telefone__c = '556200000000', 
            	Telefone_2__c = '(62) 98150-8114', CRECI__c = '29297', CRECI_UF__c = 'GO', 
            	Imobiliaria__c = 'URBSRT', Origem__c = 'Facilita', Equipe__c = 'URBSRT', 
            	Gerente__c = 'Gerente - URBSRT', ID_externo_usuario__c = 'F-984', Status__c = 'Ativo', 
            	Perfil__c = 'Corretor', E_mail_do_Gerente__c = 'manager_17@goscore.com.br'
        	);
            insert corretor;
        	return corretor;
    	}
}