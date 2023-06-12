trigger Cobranca_Trigger on Cobranca_v2__c (after insert, after update) {
    //DELETE
    List<Id> recordIds = new List<Id>();

    for (Cobranca_v2__c record : Trigger.new) {
        // Adicione uma condição, se necessário, para determinar quando o PDF deve ser gerado
        recordIds.add(record.Id);
    }

    if (!recordIds.isEmpty()) {
        //System.enqueueJob(new PDFQueueable(recordIds));
    }
}