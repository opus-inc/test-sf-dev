@isTest
public class CriarChamadaController_Test {
	@TestSetup
    static void setup(){
        Account accTeste = new Account();
        accTeste.Name = 'Teste de conta';
        accTeste.Telefone_Todos__c = 'CEL 62 98765-4321';
        insert accTeste;
    }
    
    @isTest
    public static void testInsereTaskChamadaERedirecUsuario_CriaTaskParaContaDoTeste(){
        
        ApexPages.currentPage().getParameters().put('interlocutor', '(62)987654321');
        CriarChamadaController testController = new CriarChamadaController();
        PageReference PageRefTeste = testController.insereTaskChamadaERedirecUsuario();
        System.debug('Criou a TASK= ' + PageRefTeste.getUrl());
        System.assertNotEquals('/', PageRefTeste.getUrl());
    }
    
    @isTest
    public static void testInsereTaskChamadaERedirecUsuario_CriaTaskPraContaPadrao(){
        
        ApexPages.currentPage().getParameters().put('interlocutor', '321');
        CriarChamadaController testController = new CriarChamadaController();
        PageReference PageRefTeste = testController.insereTaskChamadaERedirecUsuario();
        System.debug('Criou a TASK pra conta padrão= ' + PageRefTeste.getUrl());
        String idTaskCriada = PageRefTeste.getUrl().left(1);
    }
    
    @isTest
    public static void testInsereTaskChamadaERedirecUsuario_RedirecionaParaHome(){
        
        CriarChamadaController testController = new CriarChamadaController();
        PageReference PageRefTeste = testController.insereTaskChamadaERedirecUsuario();
        System.debug('Redirecionou pra HOME= ' + PageRefTeste.getUrl());
        System.assertEquals('/', PageRefTeste.getUrl());
    }
}