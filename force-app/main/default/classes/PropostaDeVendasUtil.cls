public class PropostaDeVendasUtil {

    static private PropostaVendasDAO dao = new PropostaVendasDAO();
	
    static private Corretores__c buildCorretor(){
        return CorretorUtil.buildCorretorForTest();
    }
    
    static private Empreendimento__c buildEmpreendimento(){
        return EmpreendimentoUtil.buildEmpreendimento();
    }
    
    static private Tabela_de_Vendas__c buildTabelaDaProposta(){
        return TabelaDeVendasUtil.buildtabelaDaProposta();
    }
    
    static private Tabela_de_Vendas__c buildTabelaDeVendas(){
        return TabelaDeVendasUtil.buildtabelaDeVendas();
        
    }
    
    static private Unidade__c buildUnidade(){
        return UnidadeUtil.getUnidade();
    }
    
    public static Proposta_de_Vendas__c buildPropostaDeVendas(){
        Proposta_de_Vendas__c proposta = new Proposta_de_Vendas__c(
                Empreendimento__c = buildEmpreendimento().Id , VPL_Tabela__c = 1029345.42, 
                Tabela_de_Vendas_Proposta__c = buildTabelaDeVendas().Id , VPL_Proposta__c = null,  
                Corretor__c = buildCorretor().Id, Tabela_da_Proposta__c = buildTabelaDaProposta().Id, Valor_da_Proposta__c = 1029345.42, 
                Valor_Tabela__c = 1057592.03, Perc_Comissao_Faturada__c = 2, Perc_Comissao_Destacada__c = 2, Numero_pasta_Facilita__c = null, 
                Email__c = 'allesson.carvalho@opus.inc', Em_Processo_de_Aprovacao__c = false, E_mail_do_Gerente__c = 'allesson.carvalho@opus.inc', 
                Nome_do_Cliente__c = null, E_mail_do_Cliente__c = null, Telefone_do_Cliente__c = null, CPF_do_Cliente__c = null, 
                Valor_da_Premiacao__c = 0, Fase_da_Proposta__c = 'Simulação', Contrato_Elaborado__c = false, Comentarios_e_Clausulas__c = null, 
                Garagem__c = '33/33A e 35,', Observacao_do_Cliente__c = null, Qtde_Series_Proposta__c = 8, Condicoes_html__c = null, 
                Rejeitado_em_Processo_de_Aprovacao__c = false, Mostra_alerta_Comissao__c = null, Data_de_Sinal_Mais_Antiga__c = Date.NewInstance(2020, 11, 05) 
        );
        if(dao.getAll().size() > 0){
            return dao.getAll().get(0);
        }else {
            //Para testes de sistema, não podemos inserir, pois não existe mais espaço na org.
            //Porem, precisamos inserir no cenário de testes unitários.
            insert proposta;
            return proposta;
        }
    }
    
}