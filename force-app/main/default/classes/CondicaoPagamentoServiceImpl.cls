public class CondicaoPagamentoServiceImpl implements ICondicaoPagamentoService {

	public static List<Condi_o_de_Pagamento__c> getCondicaoPagamentoSemFinanciamento (Id id){
        List<Condi_o_de_Pagamento__c> conds = CondicaoPagamentoDAO.getCondicaoDePagamentoByTabelaDeVendasId(id);
        for(Integer i = 0; i < conds.size(); i++){
            if(conds.get(i).Periodicidade_Condicao__c == 'Financiamento'){
                conds.remove(i);
            }
        }
        return conds;
    }
    
    public static List<Condi_o_de_Pagamento__c> getCondicaoPagamentoFinanciamento (Id id){
        List<Condi_o_de_Pagamento__c> condsFinanciamento = CondicaoPagamentoDAO.getCondicaoDePagamentoFinanciamento(id);
        List<Condi_o_de_Pagamento__c> conds = new List<Condi_o_de_Pagamento__c>();
        if(condsFinanciamento.size() > 0) {
            return condsFinanciamento;
        }else {
          return conds;  
        }
    }

    public static List<Condi_o_de_Pagamento__c> getAll(){
        return CondicaoPagamentoDAO.getAll();
    }

    public static List<Condi_o_de_Pagamento__c> getCondicaoPagamentoByPropostaDeVendas(Proposta_de_Vendas__c proposta){
        return CondicaoPagamentoDAO.getCondicaoPagamentoByPropostaDeVendas(proposta);
    }
      
}