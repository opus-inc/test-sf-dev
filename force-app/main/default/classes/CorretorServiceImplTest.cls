@isTest
public class CorretorServiceImplTest {

        public static CorretorUtil util = new CorretorUtil();
     	public static CorretorServiceImpl service = new CorretorServiceImpl();
    
    @isTest
    static void buildCorretor(){
        Corretores__c newCorretor = CorretorUtil.buildCorretorForTest();
        Corretores__c corretor = service.getCorretorByCPF(newCorretor.CPF__c);
        
        System.assertEquals(newCorretor.CPF__c, corretor.CPF__c);
    }
    
    @isTest
    static void getAll(){
        CorretorUtil.buildCorretorForTest();
        List<Corretores__c> corretores = service.getAll();
        System.assert(corretores.size() > 0);
    }
    
    @isTest
    static void getCorretoresByImobiliariaId(){
        String imobiliaria = CorretorUtil.buildCorretorForTest().Imobiliaria__c;
        List<Corretores__c> corretores = service.getCorretoresByImobiliariaName(imobiliaria);
        System.assert(corretores.size() > 0 );
    }
    
    @isTest
    static void getCorretoresByCRECI(){
        String creci = CorretorUtil.buildCorretorForTest().CRECI__c;
        List<Corretores__c> corretores = service.getCorretoresByCRECI(creci);
        System.assert(corretores.size() > 0 );
    }
}