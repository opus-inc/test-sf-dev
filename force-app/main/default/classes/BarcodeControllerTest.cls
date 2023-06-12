@isTest
private class BarcodeControllerTest {
    
    @TestSetup
    static void setup(){
        
        ObjectBuilderForTests.getNewParcelaMega(true);
    }

    @isTest
    static void testBuildEnqueueJobs() {

        Parcela_Mega__c parcelaMega = [SELECT Id, Status__c, Codigo_de_Barras_Mega__c FROM Parcela_Mega__c LIMIT 1];

        Test.startTest();
        PageReference pageRef = Page.ItauBoletoPDF;
        pageRef.getParameters().put('parcelaMegaId', parcelaMega.Id);
        Test.setCurrentPage(pageRef);
        
        BarcodeController testBarcodeController = new BarcodeController();
        Test.stopTest();
    }
}