public interface IPropostaVendasService {
	
	List<Proposta_de_Vendas__c> getAll();
    Proposta_de_Vendas__c getPropostaVendas(Id propostaId);
}