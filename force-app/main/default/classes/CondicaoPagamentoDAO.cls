/**
* Classe responsável por manipular dados do Objeto Condi_o_de_Pagamento__c
* @Since 17/02/2021
* @author Douglas Eleutério | Ohana Consultoria
* @version 1.0
*/

public class CondicaoPagamentoDAO {

 	public static List<Condi_o_de_Pagamento__c> getCondicaoPagamentoByPropostaDeVendas(Proposta_de_Vendas__c propostaDeVendas){
         System.debug('Classe DAO: propostaDeVendas Paramentro' + propostaDeVendas);
        List<Condi_o_de_Pagamento__c> conds = [
            SELECT Periodicidade__c, Periodicidade_Condicao__c, Intervalo_das_Parcelas__c, In_cio_do_Vencimento__c, Total_das_Parcelas__c, Correcao__c, Quantidade_de_parcelas__c, Valor_Total_das_Parcelas__c,
            Valor_Opus__c, Tabela_de_Vendas__r.Name, Tabela_de_Vendas__r.Id
            FROM Condi_o_de_Pagamento__c 
            WHERE Tabela_de_Vendas__c =: propostaDeVendas.Tabela_da_Proposta__c];
            System.debug('Classe DAO: conds ' + conds);
            return conds;
    }

    public static List<Condi_o_de_Pagamento__c> getCondicaoDePagamentoByTabelaDeVendasId(Id id){
        List<Condi_o_de_Pagamento__c> conds = [
            SELECT  Periodicidade__c, Periodicidade_Condicao__c, Intervalo_das_Parcelas__c, In_cio_do_Vencimento__c, Total_das_Parcelas__c, Correcao__c, Quantidade_de_parcelas__c, Valor_Total_das_Parcelas__c,
                    Valor_Opus__c, Tabela_de_Vendas__r.Name, Tabela_de_Vendas__r.Id
            FROM    Condi_o_de_Pagamento__c 
            WHERE   Tabela_de_Vendas__r.Id =: id ];
            return conds;
    }
    
    public static List<Condi_o_de_Pagamento__c> getCondicaoDePagamentoFinanciamento(Id id){
        List<Condi_o_de_Pagamento__c> conds = [
            SELECT  Periodicidade__c, Periodicidade_Condicao__c, Intervalo_das_Parcelas__c, In_cio_do_Vencimento__c, Total_das_Parcelas__c, Correcao__c, Quantidade_de_parcelas__c, Valor_Total_das_Parcelas__c,
                    Valor_Opus__c, Tabela_de_Vendas__r.Name, Tabela_de_Vendas__r.Id
            FROM    Condi_o_de_Pagamento__c 
            WHERE   Tabela_de_Vendas__r.Id =: id AND Periodicidade_Condicao__c = 'Financiamento'];
            return conds;
    }

    public static List<Condi_o_de_Pagamento__c> getAll(){
        List<Condi_o_de_Pagamento__c> conds = [
            SELECT  Periodicidade__c, Periodicidade_Condicao__c, Intervalo_das_Parcelas__c, In_cio_do_Vencimento__c, Total_das_Parcelas__c, Correcao__c, Quantidade_de_parcelas__c, Valor_Total_das_Parcelas__c,
                    Valor_Opus__c, Tabela_de_Vendas__r.Name, Tabela_de_Vendas__r.Id
            FROM    Condi_o_de_Pagamento__c]; 
            return conds;
    }
}