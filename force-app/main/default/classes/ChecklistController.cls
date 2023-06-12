public class ChecklistController {
	public String propostaId {get;set;}
    Proposta_de_Vendas__c propostaVendas;
    public List <Proponentes__c> proponente {get;set;}
        
    public ChecklistController(){
        propostaId = ApexPages.currentPage().getParameters().get('propostaId');
    }
    
    public Proposta_de_Vendas__c getPropostaVendas() {
        List<Proposta_de_Vendas__c> propostas =  [
            SELECT Nome_Unidade__c, Id, Nome_do_Empreendimento__c
            FROM Proposta_de_Vendas__c
            WHERE Id =: propostaId
        	LIMIT 1];
        if(propostas.size() > 0){
            propostaVendas = propostas[0];
        }
        return propostaVendas;
    }
    
    public List <Proponentes__c> getProponenteProposta() {
        if(proponente == null){    
         proponente = [
            SELECT Id, Name, Tipo_de_Uniao__c, Nome_Completo_CJ__c
            FROM Proponentes__c
            WHERE Proposta_de_Vendas__c =: propostaId];
        }
        return proponente;
    }
}