@isTest
public class TabelaDeVendasServiceImplTest {

    static TabelaDeVendasServiceImpl service = new TabelaDeVendasServiceImpl();
    static TabelaDeVendasUtil util = new TabelaDeVendasUtil();
    
    @isTest
    static void getAll(){
        TabelaDeVendasUtil.buildtabelaDaProposta();
        TabelaDeVendasUtil.buildtabelaDeVendas();
        List<Tabela_de_Vendas__c> tabelas = service.getAll();
        System.assert(tabelas.size() > 0);
    }
    
    @isTest
    static void  getTabelaDeVendasById(){
        Id idCreated = TabelaDeVendasUtil.buildtabelaDeVendas().Id;
        Id idSearched = service.getTabelaDeVendasById(idCreated).Id;
        System.assertEquals(idCreated, idSearched);
    }
    
    @isTest
    static void getByPropostaDeVendas(){
        Id idProposta = PropostaDeVendasUtil.buildPropostaDeVendas().Id;
        List<Tabela_de_Vendas__c> tabelas = service.getByPropostaDeVendas(idProposta);
        
    }
}