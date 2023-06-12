@isTest
public class UnidadeServiceImplTest {
    
    static UnidadeServiceImpl service = new UnidadeServiceImpl();
    
    static Unidade__c buildUnidade(){
        return UnidadeUtil.getUnidade();
    }
    
    @isTest
    static void getAll(){
        buildUnidade();
        List<Unidade__c> services = service.getAll();
        System.assert(services.size() > 0);     
    }
    
    @isTest
    static void getUnidadeById(){
        buildUnidade();
        Id id = service.getAll().get(0).Id;
        System.assertEquals(id, service.getUnidadeById(id).Id);
    }
}