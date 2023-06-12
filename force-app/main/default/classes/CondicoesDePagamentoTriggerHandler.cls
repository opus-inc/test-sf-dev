public with sharing class CondicoesDePagamentoTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob;
    public static boolean isFromUploadAPI = false;

    public CondicoesDePagamentoTriggerHandler(boolean isExecuting, integer size) {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnBeforeInsert(List<Condi_o_de_Pagamento__c> newCondicoesDePagamento) {
        for (Condi_o_de_Pagamento__c c : newCondicoesDePagamento) {
            this.NumbersCondicaoToText(c);
        }
    }

    public void OnAfterInsert(List<Condi_o_de_Pagamento__c> newCondicoesDePagamento) {
        system.debug('CondicoesDePagamento Trigger On After Insert');
    }

    public void OnAfterUpdate(List<Condi_o_de_Pagamento__c> newCondicoesDePagamento, List<Condi_o_de_Pagamento__c> oldCondicoesDePagamento, Map<ID, Condi_o_de_Pagamento__c> newCondicoesDePagamentoMap , Map<ID, Condi_o_de_Pagamento__c> oldCondicoesDePagamentoMap) {
        system.debug('CondicoesDePagamento Trigger On After Update ');
    }

    public void OnBeforeUpdate(List<Condi_o_de_Pagamento__c> newCondicoesDePagamento, List<Condi_o_de_Pagamento__c> oldCondicoesDePagamento, Map<ID, Condi_o_de_Pagamento__c> newCondicoesDePagamentoMap , Map<ID, Condi_o_de_Pagamento__c> oldCondicoesDePagamentoMap ) {
        for (Condi_o_de_Pagamento__c c : newCondicoesDePagamento) {
            this.NumbersCondicaoToText(c);
        }
    }

    private void NumbersCondicaoToText(Condi_o_de_Pagamento__c condicaoPagamento) {
        if (condicaoPagamento.Valor_Total_das_Parcelas__c	!= null && condicaoPagamento.Valor_Total_das_Parcelas__c >= 0) {
            Long n = condicaoPagamento.Valor_Total_das_Parcelas__c.longValue();
            condicaoPagamento.Valor_Total_das_Parcelas_Extenso__c = NumberToWord.portuguese_number(n);
        } else {
            condicaoPagamento.Valor_Total_das_Parcelas_Extenso__c = null;
        }

        if (condicaoPagamento.Valor_Total_Parcela__c != null && condicaoPagamento.Valor_Total_Parcela__c >= 0) {
            Long n = condicaoPagamento.Valor_Total_Parcela__c.longValue();
            condicaoPagamento.Valor_Total_Parcela_Extenso__c = NumberToWord.portuguese_number(n);
        } else {
            condicaoPagamento.Valor_Total_Parcela_Extenso__c = null;
        }
        
    }

}