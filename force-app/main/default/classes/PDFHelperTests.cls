@isTest
private class PDFHelperTests {
    
    @TestSetup
    static void setup(){
        
        ObjectBuilderForTests.getNewParcelaMega(true);
    }

    @isTest
    static void testBuildEnqueueJobs() {

        Parcela_Mega__c parcelaMega = [SELECT Id, Status__c, Codigo_de_Barras_Mega__c FROM Parcela_Mega__c LIMIT 1];

        Boolean isInsert = true;
        List<Parcela_Mega__c> listNew = new List<Parcela_Mega__c>();
        Map<Id, Parcela_Mega__c> mapOldValues = new Map<Id, Parcela_Mega__c>();

        listNew.add(parcelaMega);

        Test.startTest();
        PDFHelper.getInstance().buildEnqueueJobs(isInsert, listNew, mapOldValues);
        Test.stopTest();
    }
}