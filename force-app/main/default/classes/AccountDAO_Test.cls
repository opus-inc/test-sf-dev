@isTest
public class AccountDAO_Test {
    
    @TestSetup
    static void setup(){
        Account accTeste = new Account();
        accTeste.Name = 'Teste de conta';
        accTeste.Telefone_Todos__c = 'CEL 62 98765-4321';
        insert accTeste;
    }
    
    @isTest
    public static void testGetAccountByPhone_Sucesso(){
        
        List<String> telefones = Util.getListaTelefonesParaBusca('(62)987654321');
        Account contaEncontrada = AccountDAO.getInstance().getAccountByPhone(telefones);
        //System.debug(contaEncontrada);
        System.assertEquals('Teste de conta', contaEncontrada.Name);
    }
    
    @isTest
    public static void testGetAccountByPhone_Falha(){
        
        List<String> telefones = Util.getListaTelefonesParaBusca('(62)987654322');
        Account contaEncontrada = AccountDAO.getInstance().getAccountByPhone(telefones);
        //System.debug(contaEncontrada);
        System.assertEquals(null, contaEncontrada);
    }
    
}