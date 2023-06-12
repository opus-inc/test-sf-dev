public class CartaPropostaServiceImpl implements ICartaPropostaService{
    
    public static Double getTotalParcelamento(List<Condi_o_de_Pagamento__c> condicoes){
        Double valorTotalDasParcelas = 0;
        System.debug('Condições' + condicoes);
        for(Condi_o_de_Pagamento__c condicao: condicoes){
            if(condicao.Periodicidade_Condicao__c != 'Financiamento'){
                valorTotalDasParcelas += (condicao.Quantidade_de_parcelas__c * condicao.Valor_Total_das_Parcelas__c);    
            }
        }
        
        return valorTotalDasParcelas;
    }

    public static Double getValorTotalDaProposta(Proposta_de_Vendas__c proposta){
        Double valorProposta = proposta.Valor_da_Proposta__c;
        List<Intermediacao__c> inters = IntermediacaoServiceImpl.getFromPropostaDeVendasId(proposta.Id);
        Double valorIntermediacao = IntermediacaoServiceImpl.getTotalServiceIntermediacao(inters);

        Double valorTotal = valorProposta + valorIntermediacao;
        return valorTotal;
    }
}