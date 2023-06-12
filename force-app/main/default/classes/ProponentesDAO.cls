/**
* Classe responsável por manipular dados do Objeto Proponentes__c
* @Since 17/02/2021
* @author Douglas Eleutério | Ohana Consultoria
* @version 1.0
*/

public class ProponentesDAO {
    
    public static List<Proponentes__c> getProponentesListByPropostaDeVendasId(String id){
        //1ª Linha da Consulta = Primeira Coluna da Tabela do Proponente
        //...
        //4ª Linha da Consulta = Segunda Coluna da Tabela do Cônjuge
        List<Proponentes__c> proponentesList = [
            SELECT 	Name, Estado_Civil__c, Tipo_de_Uniao__c, Endereco_Residencial__c, E_mail__c, Telefone__c,
            Data_de_Nascimento__c, RG__c, Orgao_Expedidor__c, CPF__c, Profissao__c, Celular__c,
            Nome_Completo_CJ__c, Estado_Civil_CJ__c, Tipo_de_Uniao_CJ__c, Endereco_Residencial_CJ__c, E_mail_CJ__c, Telefone_CJ__c, Celular_CJ__c,
            Data_de_Nascimento_CJ__c, RG_CJ__c, Orgao_Expedidor_CJ__c, CPF_CJ__c, Profissao_CJ__c, Proposta_de_Vendas__c, Telefone_Residencial__c , Telefone_Celular__c
            FROM Proponentes__c
            WHERE Proposta_de_Vendas__r.Id =: id
        ];
        return proponentesList;
    }

    public static  List<Proponentes__c> getAll(){
        List<Proponentes__c> proponentesList = [
            SELECT 	Name, Estado_Civil__c, Tipo_de_Uniao__c, Endereco_Residencial__c, E_mail__c, Telefone__c,
            Data_de_Nascimento__c, RG__c, Orgao_Expedidor__c, CPF__c, Profissao__c, Celular__c,
            Nome_Completo_CJ__c, Estado_Civil_CJ__c, Tipo_de_Uniao_CJ__c, Endereco_Residencial_CJ__c, E_mail_CJ__c, Telefone_CJ__c,
            Data_de_Nascimento_CJ__c, RG_CJ__c, Orgao_Expedidor_CJ__c, CPF_CJ__c, Profissao_CJ__c, Celular_CJ__c, Proposta_de_Vendas__c
            FROM Proponentes__c
        ];
        return proponentesList;
    }

}