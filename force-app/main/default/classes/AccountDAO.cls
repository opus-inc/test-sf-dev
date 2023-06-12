/**
*   @author Felipe Kuninory Akitaya
*   @class Classe para acessar os dados das Accounts
*/
public class AccountDAO {
    
    private static AccountDAO instance = new AccountDAO();
    private AccountDAO(){}
    
    public static AccountDAO getInstance(){
        return instance;
    }
    
    public Account getAccountByPhone(List<String> listTelefones){
        try{
            return [SELECT Id, Name 
                    FROM Account
                    WHERE Telefone_Todos__c LIKE: listTelefones 
                    Limit 1];
        }catch(Exception e){
            return null;
        }
    }
    
}