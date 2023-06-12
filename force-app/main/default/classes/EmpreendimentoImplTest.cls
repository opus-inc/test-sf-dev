@isTest
public class EmpreendimentoImplTest {
	
    static EmpreendimentoServiceImpl service = new EmpreendimentoServiceImpl();
    
    @isTest
    static void getAll(){
        EmpreendimentoUtil.buildEmpreendimento();
        List<Empreendimento__c> empreendimentos = service.getAll();
        
        System.assert(empreendimentos.size() > 0);
    }

    @isTest
    static void getEmpreendimentoByName(){
        Empreendimento__c emp = EmpreendimentoUtil.buildEmpreendimento();
		Empreendimento__c empAux = service.getEmpreendimentoByName(emp.Name).get(0);
        System.assertEquals(emp.Name, empAux.Name);
    }
}