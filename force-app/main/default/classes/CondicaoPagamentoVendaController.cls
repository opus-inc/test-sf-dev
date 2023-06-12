public class CondicaoPagamentoVendaController {
	@AuraEnabled
    public static List<Condi_o_de_Pagamento__c> getCondicaoPagamentoTabelaVenda(Id propostaVendaId){
        List<Proposta_de_Vendas__c> propostas = new List<Proposta_de_Vendas__c>([Select 
                                   Id, 
                                   Tabela_de_Vendas_Proposta__c,
                                   Tabela_da_Proposta__c
                                   from Proposta_de_Vendas__c 
                                   where Id =: propostaVendaId ]);
        if(propostas != null && propostas.size() > 0){
            System.debug('Não foi encontrado Condição de pagamento');
        }
        if(propostas != null && propostas.size() > 0){
            
            return new List<Condi_o_de_Pagamento__c>([SELECT 
                                                      Id, 
                                                      Tipo_de_Parcela__c, 
                                                      Quantidade_de_parcelas__c, 
                                                      Periodicidade__c, 
                                                      Periodicidade_Condicao__c,
                                                      In_cio_do_Vencimento__c, 
                                                      Percentual_Parcela__c,
                                                      Valor_Total_Parcela__c,
                                                      Valor_Total_das_Parcelas__c,
                                                      Intervalo_das_Parcelas__c,
                                                      Correcao__c,
                                                      Valor_Comissao__c,
                                                      Perc_Comissao__c,
                                                      Valor_Opus__c,
                                                      Termino_do_Vencimento__c
                                                      FROM Condi_o_de_Pagamento__c 
                                                      where Tabela_de_Vendas__c =: propostas[0].Tabela_da_Proposta__c
                                                      ORDER BY In_cio_do_Vencimento__c]
                                                      );
            
            
        }
		return new List<Condi_o_de_Pagamento__c>();
    }

    @AuraEnabled
    public static void updateCondicaoPagamento(List<Condi_o_de_Pagamento__c> lstCondPagto){   
        string dec = '';
        System.debug(lstCondPagto);
        
        for(Condi_o_de_Pagamento__c cond : lstCondPagto){
            if(cond.Valor_Total_das_Parcelas__c != null){
            	dec = cond.Valor_Total_das_Parcelas__c.toPlainString();
        		System.debug(dec);        
              
                cond.Valor_Total_das_Parcelas__c = cond.Valor_Total_das_Parcelas__c / 100; 
                System.debug('dividiu' + cond.Valor_Total_das_Parcelas__c);                         
            }            
        }
        
        update lstCondPagto;
    }
    
    @AuraEnabled
    public static void addCondicaoPagamento(Id propostaVendaId, Id tabelaVendasId){
        Condi_o_de_Pagamento__c condicao = new Condi_o_de_Pagamento__c();
        condicao.Tabela_de_Vendas__c = tabelaVendasId;
        condicao.Proposta_de_Vendas__c = propostaVendaId;   
        condicao.Quantidade_de_parcelas__c = 0;
        condicao.In_cio_do_Vencimento__c = Date.newInstance(Date.today().year(), Date.today().month(), 5);
        condicao.Valor_Total_das_Parcelas__c = 0;
        condicao.Tipo_de_Parcela__c = 'Mensal';
        condicao.Atualiza_Fluxo__c = 'Sim';
        
        
        if(propostaVendaId != null && tabelaVendasId != null){
        	insert condicao;    
        }        
    } 
    
    @AuraEnabled
    public static void deleteCondicaoPagamento(Id condPagtoId){
        List<Condi_o_de_Pagamento__c> condicoes = [Select id from Condi_o_de_Pagamento__c where Id =: condPagtoId ];
        System.debug(condicoes);
        if(condicoes != null && condicoes.size() > 0){
        	delete condicoes[0];    
        }        
    }
    
    @AuraEnabled
    public static void updatePeriodicidade(Id id, string periodicidade){
        Condi_o_de_Pagamento__c c = new Condi_o_de_Pagamento__c();
        
        c.Periodicidade_Condicao__c = periodicidade;
        c.Id = id;
        if(id != null){
        	update c;    
        }                                
    }
}