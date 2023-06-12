public Interface ICondicaoPagamentoService {
	
    List<Condi_o_de_Pagamento__c> getCondicaoPagamentoSemFinanciamento (Id id);
    List<Condi_o_de_Pagamento__c> getAll();
    List<Condi_o_de_Pagamento__c> getCondicaoPagamentoByPropostaDeVendas(Proposta_de_Vendas__c proposta);
}