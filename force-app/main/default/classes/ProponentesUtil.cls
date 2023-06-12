public class ProponentesUtil {


    public static PropostaVendasServiceImpl propostaService = new PropostaVendasServiceImpl();

    public static Proponentes__c buildProponente(){
        //PropostaDeVendasUtil.buildPropostaDeVendas();
        Proposta_de_Vendas__c propostaDeVendas = PropostaDeVendasUtil.buildPropostaDeVendas();

        Proponentes__c proponente = buildProponente(
            'ANDERSON BARBOSA DE VASCONCELOS', 'CASADO', 'Comunhão Parcial de Bens',
            'RUA 148, NR 196, APTO. 3100, SETOR MARISTA, GOIÂNIA-GO, CEP.74170-110',
            'andersonb@tendasecia.com.br', '62 99999-8888', Date.newInstance(1973, 04, 02), 
            '2.113.320 / 2ª VIA',  'SSP-GO', '548.313.421-49', 'EMPRESÁRIO', '(62) 9.9611-9541',
            'ADRIANA VIEIRA VAZ VASCONCELOS', 'CASADO', 'Comunhão Parcial de Bens',
            'RUA 148, NR 196, APTO. 3100, SETOR MARISTA, GOIÂNIA-GO, CEP.74170-110',
            ' ', '62 99999-8888', Date.newInstance(1974, 05, 07), 
            '3.141.313',  'SSP-GO', '643.631.201-34', 'EMPRESÁRIA', ' ', propostaDeVendas
        );
        insert proponente;
		return proponente;
    }

    private static Proponentes__c buildProponente(
        String name, String estadoCivil, String tipoDeUniao, String endereco, String email, 
        String telefone, Date dataNascimento, String rg, String orgaoExpedidor, String cpf, 
        String profissao, String celular,
        String nameCJ, String estadoCivilCJ, String tipoDeUniaoCJ, String enderecoCJ, String emailCJ, 
        String telefoneCJ, Date dataNascimentoCJ, String rgCJ, String orgaoExpedidorCJ, String cpfCJ, 
        String profissaoCJ, String celularCJ, Proposta_de_Vendas__c propostaDeVendas

        ){
        Proponentes__c prop = new Proponentes__c(
            Name = name,
            Estado_Civil__c = estadoCivil,
            Tipo_de_Uniao__c = tipoDeUniao,
            Endereco_Residencial__c = endereco,
            E_mail__c  = email,
            Telefone__c = telefone,
            Data_de_Nascimento__c = dataNascimento,
            RG__c = rg,
            Orgao_Expedidor__c = orgaoExpedidor,
            CPF__c = cpf,
            Profissao__c = profissao,
            Celular__c = celular,
            //
            Nome_Completo_CJ__c = nameCJ,
            Estado_Civil_CJ__c = estadoCivilCJ,
            Tipo_de_Uniao_CJ__c = tipoDeUniaoCJ,
            Endereco_Residencial_CJ__c = enderecoCJ,
            E_mail_CJ__c  = emailCJ,
            Telefone_CJ__c = telefoneCJ,
            Data_de_Nascimento_CJ__c = dataNascimentoCJ,
            RG_CJ__c = rgCJ,
            Orgao_Expedidor_CJ__c = orgaoExpedidorCJ,
            CPF_CJ__c = cpfCJ,
            Profissao_CJ__c = profissaoCJ,
            Celular_CJ__c = celularCJ,
            Proposta_de_Vendas__c = propostaDeVendas.Id
        );
        return prop;
    }
}