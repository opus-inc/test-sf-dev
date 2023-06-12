public without sharing class PagamentoAvulsoController {
    @AuraEnabled
    public static List<Parcela_Mega__c> getParcelaByContrato(List<Id> contratosId) {
        return [SELECT Id, Name, Valor__c FROM Parcela_Mega__c WHERE Contrato_Mega__c IN :contratosId];
    }

    @AuraEnabled
    public static List<AggregateResult> getEmpreendimentosByConta(Id contaId){
        try {
            return [
                SELECT
                    Count(Name),
                    Unidade__r.Empreendimento__r.Id,
                    Unidade__r.Empreendimento__r.Name
                FROM Contrato_Mega__c
                WHERE Conta__c =: contaId
                GROUP BY 
                    Unidade__r.Empreendimento__r.Id, 
                    Unidade__r.Empreendimento__r.Name
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}