/**
* Classe responsável por manipular dados do Objeto Tabela_de_Vendas__c
* @Since 29/03/2021
* @author Douglas Eleutério | Ohana Consultoria
* @version 1.0
*/

public class TabelaDeVendasDAO {
    
    public static List<Tabela_de_Vendas__c> getAll(){
        List<Tabela_de_Vendas__c> tabelas = [
            SELECT 	Id, Name, Data_da_Tabela__c, Empreendimento__c, Status__c, 
            		Unidade__c, Chave_Tabela__c, Tipo__c, VP_Tabela__c, Proposta_de_Vendas__c 
        	FROM 	Tabela_de_Vendas__c
            ];

        return tabelas;
    }
    
    public static Tabela_de_Vendas__c getTabelaDeVendasById(Id id) {
        Tabela_de_Vendas__c tab = [	
            SELECT	Id, Chave_Tabela__c, Data_da_Tabela__c, Empreendimento__c, Name, 
            		Proposta_de_Vendas__c, Status__c, Tipo__c, Unidade__c, VP_Tabela__c
			FROM	Tabela_de_Vendas__c 
			WHERE	Id =: id];
            
        return tab;
    }
    
    public static List<Tabela_de_Vendas__c> getByPropostaDeVendas(Id propostaDeVendasId){
        List<Tabela_de_Vendas__c> tabelas = [
            SELECT 	Id, Name, Data_da_Tabela__c, Empreendimento__c, Status__c, 
            		Unidade__c, Chave_Tabela__c, Tipo__c, VP_Tabela__c, Proposta_de_Vendas__c 
        	FROM 	Tabela_de_Vendas__c	
            WHERE 	Proposta_de_Vendas__c =: propostaDeVendasId
        ];

        return tabelas;
    }
}