public class CorretorDAO {
	
    public List<Corretores__c> getAll(){
		List<Corretores__c> corretores = [
            SELECT Id, CPF__c, Email__c, Telefone__c, Telefone_2__c, CRECI__c, CRECI_UF__c, 
            Imobiliaria__c, Origem__c, Equipe__c, Gerente__c, ID_externo_usuario__c, Status__c, 
            Perfil__c, E_mail_do_Gerente__c, CPF_Numeros__c 
            FROM Corretores__c
        ];
		return corretores;        
    }
    
    public Corretores__c getCorretorByCPF(String cpf){
        Corretores__c corretor = [
            SELECT Id, CPF__c, Email__c, Telefone__c, Telefone_2__c, CRECI__c, CRECI_UF__c, 
            Imobiliaria__c, Origem__c, Equipe__c, Gerente__c, ID_externo_usuario__c, Status__c, 
            Perfil__c, E_mail_do_Gerente__c, CPF_Numeros__c 
            FROM Corretores__c
            WHERE CPF__c =: cpf
            LIMIT 1
        ];
        return corretor;
    }
    
    public List<Corretores__c> getCorretoresByImobiliariaName(String imobiliaria){
        List<Corretores__c> corretores = [
            SELECT Id, CPF__c, Email__c, Telefone__c, Telefone_2__c, CRECI__c, CRECI_UF__c, 
            Imobiliaria__c, Origem__c, Equipe__c, Gerente__c, ID_externo_usuario__c, Status__c, 
            Perfil__c, E_mail_do_Gerente__c, CPF_Numeros__c 
            FROM Corretores__c
            WHERE Imobiliaria__c =: imobiliaria
        ];
       	return corretores;
    }
    
    public List<Corretores__c> getCorretoresByCRECI(String creciNumber){
        List<Corretores__c> corretores = [
             SELECT Id, CPF__c, Email__c, Telefone__c, Telefone_2__c, CRECI__c, CRECI_UF__c, 
            Imobiliaria__c, Origem__c, Equipe__c, Gerente__c, ID_externo_usuario__c, Status__c, 
            Perfil__c, E_mail_do_Gerente__c, CPF_Numeros__c 
            FROM Corretores__c
            WHERE CRECI__c =: creciNumber
        ];
        return corretores;
    }
}