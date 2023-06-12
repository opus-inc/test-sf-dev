@isTest
public class CondicaoPagamentoServiceImplTest {
	
    private static List<Condi_o_de_Pagamento__c> condsFactory = CondicaoPagamentoUtil.getCondicoes();
    static Proposta_de_Vendas__c proposta;
    @isTest
    
    static void getCondicaoPagamentoSemFinanciamento(){
    	TabelaDeVendasServiceImpl service = new TabelaDeVendasServiceImpl();
        Id tabelaDeVendasId = service.getAll().get(0).Id;
        List<Condi_o_de_Pagamento__c> conds = CondicaoPagamentoServiceImpl.getCondicaoPagamentoSemFinanciamento(tabelaDeVendasId);
		System.assert(conds.size() > 0);
    }
    
    @isTest
    static void getCondicaoPagamentoFinanciamento(){
    	TabelaDeVendasServiceImpl service = new TabelaDeVendasServiceImpl();
        Id tabelaDeVendasId = service.getAll().get(0).Id;
        List<Condi_o_de_Pagamento__c> conds = CondicaoPagamentoServiceImpl.getCondicaoPagamentoFinanciamento(tabelaDeVendasId);
		System.assert(conds.size() > 0);
    }
	
    @isTest
    static void getAll(){
        List<Condi_o_de_Pagamento__c> conds = CondicaoPagamentoServiceImpl.getAll();
        System.assert(conds.size() > 0);
    }

    @isTest
    static void getCondicaoPagamentoByPropostaDeVendas(){
        Proposta_de_Vendas__c proposta = PropostaDeVendasUtil.buildPropostaDeVendas(); 
        List<Condi_o_de_Pagamento__c> conds = CondicaoPagamentoServiceImpl.getCondicaoPagamentoByPropostaDeVendas(proposta);
    }
    
    @isTest
    static void getDTO(){
        List<Condi_o_de_Pagamento__c> conds = CondicaoPagamentoServiceImpl.getAll();
        Condi_o_de_Pagamento__c cond = conds.get(0);
        CondicaoPagamentoDTO dto = new CondicaoPagamentoDTO(cond);
    }

    @isTest
    static void getCondicaoPagamentoTabelaVenda(){
        proposta = PropostaDeVendasUtil.buildPropostaDeVendas();
        List<Condi_o_de_Pagamento__c> conds = CondicaoPagamentoVendaController.getCondicaoPagamentoTabelaVenda(proposta.Id);
    }
    
    //A cobertura dos métodos de update e addCoundicaoPagamento está sendo feita na classe 'CodicaoPagamentoVendaControllerTest'
    /*
    @isTest 
    static void updateCondicaoPagamento(){
        List<Condi_o_de_Pagamento__c> lstCondPagto = condsFactory;
        CondicaoPagamentoVendaController.updateCondicaoPagamento(lstCondPagto);
    }
    
    @isTest 
    static void addCondicaoPagamento(){
        Proposta_de_Vendas__c proposta = PropostaDeVendasUtil.buildPropostaDeVendas(); 
        TabelaDeVendasServiceImpl service = new TabelaDeVendasServiceImpl();
        Id tabelaDeVendasId = service.getAll().get(0).Id;
        CondicaoPagamentoVendaController.addCondicaoPagamento(proposta.Id, tabelaDeVendasId);
    }
*/
    
    @isTest 
    static void deleteCondicaoPagamento(){
        Id condPagtoId = condsFactory.get(0).Id;
        CondicaoPagamentoVendaController.deleteCondicaoPagamento(condPagtoId);
    }
}