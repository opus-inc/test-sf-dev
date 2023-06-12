public interface IEmpreendimentoService {

    List<Empreendimento__c> getAll();
    List<Empreendimento__c> getEmpreendimentoByName(String name);
}