public interface IIntermediacao {

    //DAO Class
    List<Intermediacao__c> getAll();
    List<Intermediacao__c> getFromId(Id id);
    List<Intermediacao__c> getFromPropostaDeVendasId(Id propostaDeVendasid);

    //Others Classes.
    Double getTotalServiceIntermediacao(List<Intermediacao__c> inters);
}