public class CondicaoPagamentoUtil {

    public static Tabela_de_Vendas__c tabela = TabelaDeVendasUtil.buildtabelaDaProposta();
    //public static Tabela_de_Vendas__c tabela = TabelaDeVendasDAO.getAll().get(0);
    
    private static Condi_o_de_Pagamento__c cond1 = buildCondicaoDePagamento(
        Double.valueOf(1), Double.valueOf(1), Double.valueOf(39130.9), Date.newInstance(2020, 11, 05),
        tabela.Id, 'Sinal', 'Sim', Double.valueOf(0), 'Não', Double.valueOf(0), Double.valueOf(39130.9), 'Não'	
    );

    private static Condi_o_de_Pagamento__c cond2 = buildCondicaoDePagamento(
        Double.valueOf(1), Double.valueOf(1), Double.valueOf(15335.08), Date.newInstance(2020, 12, 05),
        tabela.Id, 'Sinal', 'Sim', Double.valueOf(0), 'Não', Double.valueOf(0), Double.valueOf(15335.08), 'Não'	
    );

    private static Condi_o_de_Pagamento__c cond3 = buildCondicaoDePagamento(
        Double.valueOf(1), Double.valueOf(1), Double.valueOf(94125.69), Date.newInstance(2021, 01, 05),
        tabela.Id, 'Única', 'Sim', Double.valueOf(0), 'Não', Double.valueOf(0), Double.valueOf(0), 'Sim'	
    );
    
    private static Condi_o_de_Pagamento__c cond4 = buildCondicaoDePagamento(
        Double.valueOf(1), Double.valueOf(1), Double.valueOf(15335.08), Date.newInstance(2021, 01, 05),
        tabela.Id, 'Sinal', 'Sim', Double.valueOf(0), 'Não', Double.valueOf(0), Double.valueOf(0), 'Sim'	
    );

    private static Condi_o_de_Pagamento__c cond5 = buildCondicaoDePagamento(
        Double.valueOf(1), Double.valueOf(11), Double.valueOf(15000), Date.newInstance(2021, 02, 05),
        tabela.Id, 'Mensal', 'Sim', Double.valueOf(0), 'Não', Double.valueOf(0), Double.valueOf(0), 'Sim'	
    );

    private static Condi_o_de_Pagamento__c cond6 = buildCondicaoDePagamento(
        Double.valueOf(6), Double.valueOf(2), Double.valueOf(58167.56), Date.newInstance(2021, 05, 05),
        tabela.Id, 'Semestral', 'Sim', Double.valueOf(0), 'Não', Double.valueOf(0), Double.valueOf(0), 'Sim'	
    );

    private static Condi_o_de_Pagamento__c cond7 = buildCondicaoDePagamento(
        Double.valueOf(12), Double.valueOf(1), Double.valueOf(99999), Date.newInstance(2021, 11, 05),
        tabela.Id, 'Anual', 'Sim', Double.valueOf(0), 'Não', Double.valueOf(0), Double.valueOf(0), 'Não'	
    );

    private static Condi_o_de_Pagamento__c cond8 = buildCondicaoDePagamento(
        Double.valueOf(1), Double.valueOf(1), Double.valueOf(565782.55), Date.newInstance(2022, 01, 05),
        tabela.Id, 'Financiamento', 'Sim', Double.valueOf(0), 'Não', Double.valueOf(0), Double.valueOf(0), 'Sim'	
    );

    public static List<Condi_o_de_Pagamento__c> getCondicoes(){
   	    
        List<Condi_o_de_Pagamento__c> condicoes = new List<Condi_o_de_Pagamento__c>();
        condicoes.add(cond1);
        condicoes.add(cond2);
        condicoes.add(cond3);
        condicoes.add(cond4);
        condicoes.add(cond5);
        condicoes.add(cond6);
        condicoes.add(cond7);
        condicoes.add(cond8);
        //insert condicoes;
        return condicoes;
    }
    
    public static Condi_o_de_Pagamento__c buildCondicaoDePagamento(
        
        Double intervaloDasParcelas, Double quantidadeDeParcelas,
        Double valorTotalDasParcelas, Date inicioDoVencimento,
        Id tabelaDeVendas, String periodicidadeDaCondicao, 
        String aplicaDesconto, Double percComissao, String atualizaFluxo, 
        Double valorComissao, Double valorOpus, String atualizaComissao
    ){ 
        Condi_o_de_Pagamento__c cond = new Condi_o_de_Pagamento__c(
            
        	Intervalo_das_Parcelas__c = intervaloDasParcelas, Quantidade_de_parcelas__c = quantidadeDeParcelas,
            Valor_Total_das_Parcelas__c = valorTotalDasParcelas, In_cio_do_Vencimento__c = inicioDoVencimento, Tabela_de_Vendas__c = tabelaDeVendas, 
            Periodicidade_Condicao__c = periodicidadeDaCondicao, AplicaDesconto__c = aplicaDesconto,  Perc_Comissao__c = percComissao, Atualiza_Fluxo__c = atualizaFluxo, 
            Valor_Comissao__c = valorComissao, Valor_Opus__c = valorOpus, Atualiza_Comiss_o__c = atualizaComissao
        );
        insert cond;
        System.debug('Condicao de Pagamento Debug: ' + cond);
        return cond;
    }
}