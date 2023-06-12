public interface ICartaPropostaService{

    Double getTotalParcelamento(List<Condi_o_de_Pagamento__c> condicoes);
    Double getValorTotalDaProposta(Proposta_de_Vendas__c proposta);
}