@isTest
public class ProponenteServiceImplTest {
	
    @isTest
    static void getAll(){
        ProponentesUtil.buildProponente();
        List<Proponentes__c> proponentes = ProponenteServiceImpl.getAll();
        System.assert(proponentes.size() > 0);
    }
    
    @isTest
    static void getProponentesListByPropostaDeVendasId(){
        ProponentesUtil.buildProponente();
        Id propostaId = PropostaDeVendasUtil.buildPropostaDeVendas().Id;
        List<Proponentes__c> proponentes = ProponenteServiceImpl.getProponentesListByPropostaDeVendasId(propostaId);
        System.assertEquals('ANDERSON BARBOSA DE VASCONCELOS', proponentes.get(0).Name);
        //System.assertEquals('ADRIANA VIEIRA VAZ VASCONCELOS', proponentes.get(0).Nome_Completo_CJ__c);
    }
}