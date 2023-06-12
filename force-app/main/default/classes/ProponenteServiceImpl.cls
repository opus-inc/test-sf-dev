public class ProponenteServiceImpl implements IProponenteService {

    public static List<Proponentes__c> getAll(){
        List<Proponentes__c> proponentes = ProponentesDAO.getAll();
        return proponentes;
    }

    public static List<Proponentes__c> getProponentesListByPropostaDeVendasId(String id){
        List<Proponentes__c> proponentes = ProponentesDAO.getProponentesListByPropostaDeVendasId(id);
        return proponentes;
    }

}