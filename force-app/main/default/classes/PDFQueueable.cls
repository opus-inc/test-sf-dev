public class PDFQueueable implements Queueable, Database.AllowsCallouts {
    private List<Id> recordIds;
    private String PDFType = 'Parcela_Mega__c';
    private Pagamento_Avulso_Boleto__c pagamentoAvulsoBoleto;
    private Pagamento_Avulso__c pagamentoAvulso;

    public PDFQueueable(List<Id> recordIds, String pdfType) {
        this.recordIds = recordIds;
        this.PDFType = pdfType;
    }

    public void setPagamentoAvulsoBoletoVariables(Pagamento_Avulso_Boleto__c boleto, Pagamento_Avulso__c pagamentoAvulso) {
        this.pagamentoAvulsoBoleto = boleto;
        this.pagamentoAvulso = pagamentoAvulso;
    }

    public void execute(QueueableContext context) {
        if(this.PDFType == 'Parcela_Mega__c') {
            PDFHelper.getInstance().generateAndSavePDF(recordIds);
        } else if(this.PDFType == 'Pagamento_Avulso_Boleto__c') {
            ItauApiClient.generateAndSavePDF(this.pagamentoAvulsoBoleto, this.pagamentoAvulso);
        }
    }
}