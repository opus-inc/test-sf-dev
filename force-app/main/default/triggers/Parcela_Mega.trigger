trigger Parcela_Mega on Parcela_Mega__c (after insert, after update) {

    PDFHelper.getInstance().buildEnqueueJobs(Trigger.isInsert, Trigger.new, Trigger.oldMap);
}