@isTest
public class IntermediacaoServiceTest {


    private static Id propostaVendasId = PropostaDeVendasUtil.buildPropostaDeVendas().Id;

    //Preciso de uma proposta de vendas para inserir
    static void createIntermediacaoFromTest(){
        IntermediacaoUtils.createIntermediacao(propostaVendasId);
    }

@isTest
    static void getAll(){
        createIntermediacaoFromTest();
        List<Intermediacao__c> inters = IntermediacaoServiceImpl.getAll();
        System.assert(inters.size() > 0);
    }
@isTest
    static void getFromPropostaDeVendasId(){ 
        createIntermediacaoFromTest();
        List<Intermediacao__c> inters = IntermediacaoServiceImpl.getFromPropostaDeVendasId(propostaVendasId);
        System.assert(inters.size() > 0);
    }

    @isTest
    static void getFromId(){
        createIntermediacaoFromTest();
        Id id = IntermediacaoServiceImpl.getAll().get(0).Id;
        List<Intermediacao__c> interSearched = IntermediacaoServiceImpl.getFromId(id);
        System.assertEquals(id, interSearched.get(0).Id);        
    }

    @isTest
    static void getTotalServiceIntermediacao(){
        createIntermediacaoFromTest();
        Intermediacao__c inter = IntermediacaoServiceImpl.getAll().get(0);
        List<Intermediacao__c> inters = new List<Intermediacao__c>();
        inters.add(inter);
        Double value = IntermediacaoServiceImpl.getTotalServiceIntermediacao(inters);
        System.debug('Value: ' + value);
        System.debug('Inters: ' + inters);
        System.assertEquals(value, 20586.91);
    }
    
    @isTest
    static void testDTO(){
        createIntermediacaoFromTest();
        IntermediacaoDTO.formatarValorMoeda(389.39);
        IntermediacaoDTO.formatarValorMoeda(38939);
        IntermediacaoDTO dto = new IntermediacaoDTO();
        //IntermediacaoServiceImpl.getAll().get(0);
        IntermediacaoDTO dto2 = new IntermediacaoDTO(IntermediacaoServiceImpl.getAll().get(0));
    }

}