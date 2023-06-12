public interface ITabelaDeVendasService {

    List<Tabela_de_Vendas__c> getAll();
    Tabela_de_Vendas__c getTabelaDeVendasById(Id id);
    List<Tabela_de_Vendas__c> getByPropostaDeVendas(Id propostaDeVendasId);
}