@isTest
public class PropostaVendasServiceImplTest {
	
    private static PropostaVendasServiceImpl service = new PropostaVendasServiceImpl();
    
    private static Proposta_de_Vendas__c buildProposta(){
        return PropostaDeVendasUtil.buildPropostaDeVendas();
    }
    
    @isTest
    static void getAll(){
        buildProposta();
        System.assert(service.getAll().size() > 0);
    }
    
    @isTest
    static void getPropostaDeVendasById(){
        Id propostaId = buildProposta().Id;
        System.assertEquals(propostaId, PropostaVendasServiceImpl.getPropostaVendas(propostaId).Id);
    }
}