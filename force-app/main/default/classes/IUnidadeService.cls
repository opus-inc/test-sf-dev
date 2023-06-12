public interface IUnidadeService {

    List<Unidade__c> getAll();
   	Unidade__c getUnidadeById(Id id);
}