@isTest
public class HipotecaPDFControllerTest {

    
    
    @isTest
    static void testaController(){
        
        Empreendimento__c emp = EmpreendimentoUtil.buildEmpreendimento();
        Proposta_de_Vendas__c prop = PropostaDeVendasUtil.buildPropostaDeVendas();
        Proponentes__c proponent = ProponentesUtil.buildProponente();
        Unidade__c unid = UnidadeUtil.getUnidade();

        Contrato_Opus__c contopus = new Contrato_Opus__c(
            Aproveitamento_Distrato__c='Upgrade',
            Status_do_Contrato__c='Aprovado',
            Proposta__c=prop.Id

        );
        
        insert contopus;



        
        Pagereference pageRef = Page.HipotecaPDF;
        
        System.debug('What is the profile id ' + contopus);
        
        
        
        contopus = [SELECT Id, Unidade__c FROM Contrato_Opus__c ];
        
        
        
        
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', String.valueOf(contopus.Id));
        Test.startTest();
		HipotecaPDFController controler = new HipotecaPDFController();
        ApexPages.StandardController sc = new ApexPages.StandardController(contopus);
        HipotecaPDFController testAccPlan = new HipotecaPDFController(sc);
        testAccPlan.getProponentes();
        System.assert(controler.unidade == contopus.Unidade__c);
        Test.stopTest();
    }
}