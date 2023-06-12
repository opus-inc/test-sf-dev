@isTest (SeeAllData=true)
public class ChecklistControllerTest {
    	@isTest static void testChecklistController() {
            Proposta_de_Vendas__c testPV = new Proposta_de_Vendas__c();
            testPV.Fase_da_Proposta__c = 'Proposta de Vendas';
            insert testPV;
            String propostaId = testPV.Id;
            
            Test.startTest();
            PageReference pageRef = Page.Checklist; // VF Page testada
            pageRef.getParameters().put('id', String.valueOf(testPV.Id));
            Test.setCurrentPage(pageRef);
            ChecklistController test_ChecklistController = new ChecklistController();
            test_ChecklistController.getPropostaVendas();
            test_ChecklistController.getProponenteProposta();
            Test.stopTest();         
    }
}