public interface ICorretorService {
	
    List<Corretores__c> getAll();
    Corretores__c getCorretorByCPF(String cpf);
    List<Corretores__c> getCorretoresByImobiliariaName(String Imobiliaria);
    List<Corretores__c> getCorretoresByCRECI(String creciNumber);
}