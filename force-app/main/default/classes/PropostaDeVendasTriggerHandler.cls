public with sharing class PropostaDeVendasTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob;
    public static boolean isFromUploadAPI = false;

    public PropostaDeVendasTriggerHandler(boolean isExecuting, integer size) {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnBeforeInsert(List<Proposta_de_Vendas__c> newPropostaVendas) {
        for (Proposta_de_Vendas__c p : newPropostaVendas) {
            this.NumbersPropostaToText(p);
        }
    }

    public void OnAfterInsert(List<Proposta_de_Vendas__c> newPropostaVendas) {
        system.debug('PropostaVendas Trigger On After Insert');
    }

    public void OnAfterUpdate(List<Proposta_de_Vendas__c> newPropostaVendas) {
    }

    public void OnBeforeUpdate(List<Proposta_de_Vendas__c> newPropostaVendas, List<Proposta_de_Vendas__c> oldPropostaVendas, Map<ID, Proposta_de_Vendas__c> newPropostaVendasMap , Map<ID, Proposta_de_Vendas__c> oldPropostaVendasMap ) {
        for (Proposta_de_Vendas__c p : newPropostaVendas) {
            this.NumbersPropostaToText(p);
        }
    }

    public Proposta_de_Vendas__c NumbersPropostaToText(Proposta_de_Vendas__c propostaVenda) {
        if (propostaVenda.Valor_da_Proposta__c	!= null && propostaVenda.Valor_da_Proposta__c >= 0) {
            Long n = propostaVenda.Valor_da_Proposta__c.longValue();
            propostaVenda.Valor_Proposta_Extenso__c = NumberToWord.portuguese_number(n);
        } else {
            propostaVenda.Valor_Proposta_Extenso__c = null;
        }

        if (propostaVenda.Valor_Total_Grupo_A__c	!= null && propostaVenda.Valor_Total_Grupo_A__c >= 0) {
            Long n = propostaVenda.Valor_Total_Grupo_A__c.longValue();
            propostaVenda.Valor_Total_Grupo_A_Extenso__c = NumberToWord.portuguese_number(n);
        } else {
            propostaVenda.Valor_Total_Grupo_A_Extenso__c = null;
        }

        if (propostaVenda.Valor_Total_Grupo_B__c	!= null && propostaVenda.Valor_Total_Grupo_B__c >= 0) {
            Long n = propostaVenda.Valor_Total_Grupo_B__c.longValue();
            propostaVenda.Valor_Total_Grupo_B_Extenso__c = NumberToWord.portuguese_number(n);
        } else {
            propostaVenda.Valor_Total_Grupo_B_Extenso__c = null;
        }

        if (propostaVenda.Valor_Total_Grupo_C__c	!= null && propostaVenda.Valor_Total_Grupo_C__c >= 0) {
            Long n = propostaVenda.Valor_Total_Grupo_C__c.longValue();
            propostaVenda.Valor_Total_Grupo_C_Extenso__c = NumberToWord.portuguese_number(n);
        } else {
            propostaVenda.Valor_Total_Grupo_C_Extenso__c = null;
        }        

        if (propostaVenda.Valor_Comiss_o_Destacada__c	!= null && propostaVenda.Valor_Comiss_o_Destacada__c >= 0) {
            Long n = propostaVenda.Valor_Comiss_o_Destacada__c.longValue();
            propostaVenda.Valor_Comiss_o_Destacada_Extenso__c = NumberToWord.portuguese_number(n);
        } else {
            propostaVenda.Valor_Comiss_o_Destacada_Extenso__c = null;
        }        

        if (propostaVenda.Valor_Comiss_o_Faturada__c	!= null && propostaVenda.Valor_Comiss_o_Faturada__c >= 0) {
            Long n = propostaVenda.Valor_Comiss_o_Faturada__c.longValue();
            propostaVenda.Valor_Comiss_o_Faturada_Extenso__c = NumberToWord.portuguese_number(n);
        } else {
            propostaVenda.Valor_Comiss_o_Faturada_Extenso__c = null;
        }

        if (propostaVenda.Valor_financiamento__c        != null && propostaVenda.Valor_financiamento__c >= 0) {
            Long n = propostaVenda.Valor_financiamento__c.longValue();
            propostaVenda.Valor_financiamento_Extenso__c = NumberToWord.portuguese_number(n);
        }
        
        return propostaVenda;
       
    }

    

}