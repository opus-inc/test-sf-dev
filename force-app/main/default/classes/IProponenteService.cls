public interface IProponenteService {

    List<Proponentes__c> getAll();
    List<Proponentes__c> getProponentesListByPropostaDeVendasId(String id);

}