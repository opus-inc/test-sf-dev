@isTest
public class CartaPropostaControllerTest {
    
    private static PropostaVendasServiceImpl service = new PropostaVendasServiceImpl();
    private static Id idTabelaDeVendas = buildTabelaDeVendas().Id;
    private static List<Condi_o_de_Pagamento__c> condicoes = CondicaoPagamentoUtil.getCondicoes();

    private static Tabela_de_Vendas__c buildTabelaDeVendas(){
        return TabelaDeVendasUtil.buildtabelaDeVendas();
    }
    
    private static Proposta_de_Vendas__c buildPropostaDeVendas(){
        return PropostaDeVendasUtil.buildPropostaDeVendas();
    }
    
    private static List<Condi_o_de_Pagamento__c> getCondicoesDePagamento(Id idTabelaDeVendas){
        return CondicaoPagamentoServiceImpl.getCondicaoPagamentoSemFinanciamento(idTabelaDeVendas);
    }
    
    @isTest
    static void getAll(){
        buildPropostaDeVendas();
        System.assert(service.getAll().size() > 0);
    }
    
    @isTest
    private static void getTotalParcelamento(){
        System.assert( Double.valueOf(CartaPropostaServiceImpl.getTotalParcelamento(condicoes)) == Double.valueOf(545260.87));
    }
    
    @isTest
    private static void getValotTotalDaProposta(){
        IntermediacaoUtils.createIntermediacao(buildPropostaDeVendas().Id);
        List<Proposta_de_Vendas__c> propostaDeVendas = service.getAll();
		Double valor = CartaPropostaServiceImpl.getValorTotalDaProposta(propostaDeVendas.get(0));
        System.debug('Valor da Proposta De Vendas: ' + propostaDeVendas);
        //Valor da tabela: 1029345.42
        //Percentual da intermediação: 0.02 
        // 1029345.42 * 0.02 = 1049932,3284
        System.assertEquals(Double.valueOf(1049932.33), Double.valueOf(valor));
    }

    @isTest 
    static void deveFormatarMoeda(){
        CartaPropostaController.formatarValorMoeda(529.38);
        CartaPropostaController.formatarValorMoeda(400000);
        CartaPropostaController.formatarValorMoeda(400000.00);
        CartaPropostaController.formatarValorMoeda(400000.1);
    }

    @isTest 
    static void testaController(){

        Proposta_de_Vendas__c prop = PropostaDeVendasUtil.buildPropostaDeVendas();
        TabelaDeVendasUtil.buildtabelaDaProposta();
        List<Condi_o_de_Pagamento__c> conds = CondicaoPagamentoUtil.getCondicoes();
        
		Test.startTest();
        Pagereference pageRef = Page.CartaProposta;
        
        pageRef.getParameters().put('propostaId', String.valueOf(prop.Id));
        Test.setCurrentPage(pageRef);

        CartaPropostaController testController = new CartaPropostaController();
        Test.stopTest();
    }
    

}