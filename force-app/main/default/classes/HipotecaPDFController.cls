/**
 * @author   : Matheus de Castro Sousa
 * @since    : 2022-03-09
 * Porpouse  : Classe para gerar PDF do contrato de Hipoteca
 */

public class HipotecaPDFController {
    
    
    public String unidade{get; set;}
    public String localizacao{get; set;}
    public String garagem{get; set;}
    public String cliente{get; set;}
    public String razaoSocial{get; set;}
    public String empreendimento{get; set;}
    public String propostaId{get; set;}
    public String conjugue{get; set;}
    public String propId{get; set;}
    public String contratoName{get; set;}

    public HipotecaPDFController(ApexPages.StandardController sc) {
        Contrato_Opus__c contrato = [SELECT Id,Name,Empreendimento__c, Unidade__c,Garagem_CHK__c,Cliente__c, Numero_da_Proposta__c,Proposta__c FROM Contrato_Opus__c WHERE Id=:ApexPages.currentPage().getParameters().get('id') LIMIT 1];
        Empreendimento__c empreendimentos = [SELECT Name,Razao_social__c, Localizacao__c,Total_de_Vagas__c FROM Empreendimento__c WHERE Name=:contrato.Empreendimento__c LIMIT 1];
        Proposta_de_Vendas__c proposta = [SELECT Name,Garagem__c FROM Proposta_de_Vendas__c WHERE Id=:contrato.Proposta__c LIMIT 1];
       
        this.conjugue = ' ';
		this.contratoName = contrato.Name;
        this.propId=contrato.Proposta__c;
        this.unidade = contrato.Unidade__c;
        this.cliente = contrato.Cliente__c;
        this.propostaId = contrato.Numero_da_Proposta__c;
        this.razaoSocial=empreendimentos.Razao_social__c;
    	this.localizacao=empreendimentos.Localizacao__c;
    	this.empreendimento=empreendimentos.Name;
        this.garagem=proposta.Garagem__c;
      
    }
    

    public HipotecaPDFController() {
        /**
         * 
         * Executa um SELECT no banco buscando os dados necessários
         * para renderizar a Visual Force Page.
         * 
         */
        Contrato_Opus__c contrato = [SELECT Id,Name,Empreendimento__c, Unidade__c,Garagem_CHK__c,Cliente__c, Numero_da_Proposta__c,Proposta__c FROM Contrato_Opus__c WHERE Id=:ApexPages.currentPage().getParameters().get('id') LIMIT 1];
        Empreendimento__c empreendimentos = [SELECT Name,Razao_social__c, Localizacao__c,Total_de_Vagas__c FROM Empreendimento__c WHERE Name=:contrato.Empreendimento__c LIMIT 1];
        Proposta_de_Vendas__c proposta = [SELECT Name,Garagem__c FROM Proposta_de_Vendas__c WHERE Id=:contrato.Proposta__c LIMIT 1];
       
       
        
        /**
         * 
         * Atribui os dados retornados anteriormente para as
         * variáveis necessárias na Visual Force Page
         * 
         */
        this.conjugue = ' ';
		this.contratoName = contrato.Name;
        this.propId=contrato.Proposta__c;
        this.unidade = contrato.Unidade__c;
        this.cliente = contrato.Cliente__c;
        this.propostaId = contrato.Numero_da_Proposta__c;
        this.razaoSocial=empreendimentos.Razao_social__c;
    	this.localizacao=empreendimentos.Localizacao__c;
    	this.empreendimento=empreendimentos.Name;
        this.garagem=proposta.Garagem__c;

    }

    public List<Proponentes__c> getProponentes() {
        List<Proponentes__c> proponents= [SELECT  Name, Nome_Completo_CJ__c,Raz_o_Social__c,RecordTypeId FROM Proponentes__c WHERE Proposta_de_Vendas__c=:propId];
        List<Proponentes__c> proponentesPj =new List<Proponentes__c>();

        for(Proponentes__c proponente : proponents) {
            if(proponente.Nome_Completo_CJ__c !=null && proponente.Nome_Completo_CJ__c !=''){
                this.conjugue = ', '+ proponente.Nome_Completo_CJ__c;
            }else{
                this.conjugue = ' ';
            }

            if(proponente.RecordTypeId=='0124A000001IuzOQAS'){

                this.cliente = proponente.Raz_o_Social__c;
                proponentesPj.add(proponente);
                return proponentesPj;
            }
            
        }
        return proponents;
    }
}