/**
 * Ao construir a Proposta não conseguimos inserir dados na aplicação devido falta de espaço para armazenamento.
 * Objeto criado para simular dados.
 * 
 * @author Douglas Eleutério | Ohana Consultoria
 * @since 17/02/2021
 */
  
public class SimulaDadosProposta {

    public static List<Proponentes__c> createProponentes(){
    	List<Proponentes__c> props = new List<Proponentes__c>();
        
        Proponentes__c prop = new Proponentes__c();
    	prop.Name = 'ANDERSON BARBOSA DE VASCONCELOS';
        prop.Estado_Civil__c = 'Casado';
        prop.Endereco_Residencial__c = 'RUA 148, NR 196, APTO. 3100, SETOR MARISTA, GOIÂNIA-GO, CEP. 74170-110.';
		prop.E_mail__c = 'andersonb@tendasecia.com.br';
        prop.Data_de_Nascimento__c = Date.newInstance(1973, 04, 02);
        prop.RG__c = '2.113.320 / 2ª VIA';
        prop.Orgao_Expedidor__c = 'SSP-GO';
        prop.CPF__c = '548.313.421-49';
        prop.Profissao__c = 'EMPRESÁRIO';
        prop.Celular__c = '(62) 9.9611-9541';
        
        //Cônjugue
        prop.Nome_Completo_CJ__c = 'ADRIANA VIEIRA VAZ VASCONCELOS';
        prop.Estado_Civil_CJ__c = prop.Estado_Civil__c;
        prop.Tipo_de_Uniao_CJ__c = prop.Tipo_de_Uniao__c;
        prop.Endereco_Residencial_CJ__c = prop.Endereco_Residencial__c;
        prop.Data_de_Nascimento_CJ__c = Date.newInstance(1974, 05, 07);
        prop.RG_CJ__c = '3.141.313';
        prop.Orgao_Expedidor_CJ__c = 'SSP-GO';
        prop.CPF_CJ__c = '643.631.201-34';
        prop.Profissao_CJ__c = 'EMPRESARIA';

		Corretores__c corretor = new Corretores__c();
        corretor.Name = 'Alberto';
        corretor.CPF__c = '878.585.171-04';
        corretor.Email__c = 'alberto@teste.com';
        corretor.Imobiliaria__c = 'Opus Vendas';
        corretor.Gerente__c = '3.899';
        corretor.Origem__c = 'Facilita';
        insert corretor;
        
        Proposta_de_Vendas__c proposta = new Proposta_de_Vendas__c();
        proposta.Corretor__c = corretor.Id;
        
        insert proposta;
        
        prop.Proposta_de_Vendas__c = proposta.Id;
        
        
        props.add(prop);

        insert props;
        return props;
    }
}