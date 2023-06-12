public class TabelaDeVendasServiceImpl implements ITabelaDeVendasService{
    
    public List<Tabela_de_Vendas__c> getAll(){
        List<Tabela_de_Vendas__c> tabelas = TabelaDeVendasDAO.getAll();
        return tabelas;
    }
    
    public Tabela_de_Vendas__c getTabelaDeVendasById(Id id){
        Tabela_de_Vendas__c tabela = TabelaDeVendasDAO.getTabelaDeVendasById(id);
        return tabela;
    }
    
    //TODO instanciar uma propostaDeVendas para usar como teste.
    public List<Tabela_de_Vendas__c> getByPropostaDeVendas(Id propostaDeVendasId){
        List<Tabela_de_Vendas__c> tabelas = TabelaDeVendasDAO.getByPropostaDeVendas(propostaDeVendasId);
        return tabelas;
    }
    
}