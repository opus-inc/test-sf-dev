public class IntermediacaoDAO {

    public static List<Intermediacao__c> ints = new List<Intermediacao__c> ();
    	
    public static List<Intermediacao__c> getAll(){
        ints = [SELECT 	Proposta_de_Vendas__c, CPF_CNPJ__c, CRECI__c, Razao_Social__c, Observacoes__c,
            	Tipo_de_Comissao__c, Porcentagem__c, Valor__c, Comissao_Faturada_Proposta__c, 
            	Comissao_Destacada_Proposta__c, Fase_da_Proposta__c, Telefone_para_Contato__c, Name, Id 
        FROM 	Intermediacao__c];
        return ints;
    }
    
    public static List<Intermediacao__c> getFromId(Id id){
        ints = [
            SELECT 	Proposta_de_Vendas__c, CPF_CNPJ__c, CRECI__c, Razao_Social__c, Observacoes__c,
            		Tipo_de_Comissao__c, Porcentagem__c, Valor__c, Comissao_Faturada_Proposta__c, 
            		Comissao_Destacada_Proposta__c, Fase_da_Proposta__c, Telefone_para_Contato__c, Name, Id 
        	FROM 	Intermediacao__c
        	WHERE 	Id =: id
        ];
        return ints;
    }
    
    public static List<Intermediacao__c> getFromPropostaDeVendasId(Id propostaDeVendasid){
        ints = [
            SELECT 	Proposta_de_Vendas__c, CPF_CNPJ__c, CRECI__c, Razao_Social__c,Observacoes__c,
            		Tipo_de_Comissao__c, Porcentagem__c, Valor__c, Comissao_Faturada_Proposta__c, 
            		Comissao_Destacada_Proposta__c, Fase_da_Proposta__c, Telefone_para_Contato__c, Name, Id
        	FROM 	Intermediacao__c
        	WHERE 	Proposta_de_Vendas__c =: propostaDeVendasid
        ];
        return ints;
    }

    public static Intermediacao__c insertIntermediacao(Intermediacao__c inter){
    insert inter;
    return inter;
    }
}