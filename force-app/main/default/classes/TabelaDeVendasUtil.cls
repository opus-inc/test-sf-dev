public class TabelaDeVendasUtil {

    static UnidadeServiceImpl service = new UnidadeServiceImpl();
    
    //Devo construir uma Estrutura para Unidade.
    //Construir um Objeto 'Unidade' dentro do método buildTabelaDeVendas, pegar respectivo Id, usa-lo para atribuir ao objeto 'tabelaDaProposta'.

    private static Unidade__c buildUnidade(){
        return UnidadeUtil.getUnidade();
    }


    private static List<Unidade__c> getUnidade(){
        buildUnidade();
        return service.getAll();
    }

    
    
    public static Tabela_de_Vendas__c buildtabelaDaProposta(){
        
        Tabela_de_Vendas__c tabelaDaProposta = new Tabela_de_Vendas__c(
        	Data_da_Tabela__c = Date.newInstance(2020, 11, 12), Empreendimento__c = null, 
            Status__c = 'Inativa', Unidade__c = null, Chave_Tabela__c = null, 
            Tipo__c = 'Proposta', VP_Tabela__c = 0, Proposta_de_Vendas__c = null
        );
            
        insert tabelaDaProposta;
        return tabelaDaProposta;
    }
    
    public static Tabela_de_Vendas__c buildtabelaDeVendas(){
        
        Tabela_de_Vendas__c tabelaDeVendas = new Tabela_de_Vendas__c(
        	Data_da_Tabela__c = Date.newInstance(2020, 11, 05), Empreendimento__c = null, 
            Status__c = 'Inativa', Unidade__c = getUnidade().get(0).Id, Chave_Tabela__c = null, 
            Tipo__c = 'Tabela', VP_Tabela__c = 1029345.42, Proposta_de_Vendas__c = null
        );
         
        //Descomentar para testes unitários.
        insert tabelaDeVendas;
        return tabelaDeVendas;
    }
}