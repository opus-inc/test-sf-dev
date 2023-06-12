/**
* Classe responsável por manipular dados do Objeto Proposta_de_Vendas__c
* @Since 17/02/2021
* @author Douglas Eleutério | Ohana Consultoria
* @version 1.0
*/

public class PropostaVendasDAO {
    Proposta_de_Vendas__c propostaVendas;
    
    public List<Proposta_de_Vendas__c> getAll(){
        List<Proposta_de_Vendas__c> propostas = [
            SELECT 	Id, Empreendimento__c, Unidade__c, VPL_Tabela__c, Tabela_de_Vendas_Proposta__c, 
            VPL_Proposta__c, Valor_de_Venda__c, Vagas_da_Unidade__c, Data_de_Entrega_do_Empreendimento__c, 
            Corretor__c, Nome_do_Corretor__c, Imobili_ria_do_Corretor__c, Equipe_do_Corretor__c, E_mail_do_Corretor__c, 
            Tabela_da_Proposta__c, Nome_Unidade__c, Nome_do_Empreendimento__c, Valor_da_Proposta__c, Valor_Tabela__c, 
            Area_da_Unidade__c, CPF__c, Perc_Comissao_Faturada__c, Perc_Comissao_Destacada__c, Numero_pasta_Facilita__c, 
            Gerente__c, Email__c, Em_Processo_de_Aprovacao__c, E_mail_do_Gerente__c, Nome_do_Cliente__c, 
            E_mail_do_Cliente__c, Telefone_do_Cliente__c, CPF_do_Cliente__c, Valor_da_Premiacao__c, Fase_da_Proposta__c, 
            Contador_Proponentes__c, Contador_Intermediacao__c, Contrato_Elaborado__c, Soma_Intermediacao__c, 
            Comentarios_e_Clausulas__c, Codigo_Gerente__c, Soma_de_Intermediacao_Fat__c, Soma_de_Intermediacao_Des__c, 
            Garagem__c, Valor_M2__c, Valor_M2_Tabela__c, Observacao_do_Cliente__c, Area_da_unidade_tabela__c, 
            Variacao_Nominal__c, Variacao_VPL__c, Pecentual_Variacao_Nominal__c, Percentual_Variacao_VPL__c, 
            Qtde_Series_Proposta__c, Condicoes_html__c, Rejeitado_em_Processo_de_Aprovacao__c, Garagem1__c, Garagem2__c, 
            Garagem3__c, Garagem4__c, Garagem5__c, Garagem6__c, Mostra_alerta_Comissao__c, Data_de_Sinal_Mais_Antiga__c 
            FROM 	Proposta_de_Vendas__c
            LIMIT 1];
            
            if(propostas.size() > 0){
            propostaVendas = propostas[0];
        }
        return propostas;
    }
    
    public Proposta_de_Vendas__c getPropostaVendas(Id propostaId) {
        List<Proposta_de_Vendas__c> propostas =  [
            SELECT 	Nome_Unidade__c, Id, Nome_do_Empreendimento__c, Valor_de_Venda__c, Garagem__c, Valor_Tabela__c,Tabela_da_Proposta__r.Name, Tabela_de_Vendas_Proposta__r.Name, Valor_da_Proposta__c ,
            Unidade__r.Nome_do_bloco__c, Unidade__r.Name, Unidade__r.N_mero_de_vagas_de_garagem__c,
            Tabela_da_Proposta__r.Chave_Tabela__c, Tabela_da_Proposta__r.Status__c, Tabela_da_Proposta__r.Tipo__c, Tabela_da_Proposta__r.Id, Nome_do_Corretor__c, Gerente__c, Corretor__r.Imobiliaria__c
            FROM Proposta_de_Vendas__c
            WHERE Id =: propostaId
            LIMIT 1];
        return propostas.get(0);
    }
    
}