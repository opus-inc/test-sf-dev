@isTest
public class UnidadeServiceTest {

    private static UnidadeServiceImpl service = new UnidadeServiceImpl();
    private static UnidadeUtil util = new UnidadeUtil();
    
    @isTest
    static void getAll(){
        UnidadeUtil.getUnidade();   
        List<Unidade__c> unidades = service.getAll();
        System.assert(unidades.size() > 0);
    }
}