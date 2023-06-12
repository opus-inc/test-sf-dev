@isTest
public class CodicaoPagamentoVendaControllerTest {
    @isTest
    public static void getCondicaoPagamentoTabelaVendaTest (){        
        CondicaoPagamentoVendaController.getCondicaoPagamentoTabelaVenda('a0Q4A00000TxcedUAB');
    }
    
    @isTest
    public static void addCondicaoPagamento(){
        CondicaoPagamentoVendaController.addCondicaoPagamento(null, null);
    }
    
    @isTest
    public static void deleteCondicaoPagamento(){
        CondicaoPagamentoVendaController.deleteCondicaoPagamento(null);
    }
    
    @isTest
    public static void updatePeriodicidade(){
        CondicaoPagamentoVendaController.updatePeriodicidade(null, 'Semestral');
    }
    
    @isTest
    public static void updateCondicaoPagamento(){
        List<Condi_o_de_Pagamento__c> conds = new List<Condi_o_de_Pagamento__c>();
        Condi_o_de_Pagamento__c c = new Condi_o_de_Pagamento__c();
        c.Valor_Total_das_Parcelas__c = 22.00;
        
        //conds.add(c);
        CondicaoPagamentoVendaController.updateCondicaoPagamento(conds);
    }
}