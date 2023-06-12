@isTest
public class CartaPropostaTest {
    
    @isTest
    static void deveObterListaDeProponentes(){
        List<Proponentes__c> proponentes = SimulaDadosProposta.createProponentes();
        
//		String idPropostaVendas =         
		System.assertNotEquals(proponentes, null);
    }
}