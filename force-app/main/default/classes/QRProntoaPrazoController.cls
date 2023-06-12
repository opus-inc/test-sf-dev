/**
 * @author   : Matheus de Castro Sousa
 * @since    : 2022-03-09
 * Porpouse  : Classe para gerar PDF do contrato de Hipoteca
 */

public with sharing class QRProntoaPrazoController {
	public String unidade { get; set; }
	public String unidadeNome { get; set; }
	public String unidadeValor { get; set; }
	public String empreendimento { get; set; }
	public String empreendimentoLocalizacao { get; set; }
	public String razaoSocial { get; set; }
	public String socioEmpreendimento { get; set; }
	public String enderecoEmpreendimento { get; set; }
	public Decimal matriculaEmpreendimento { get; set; }
	public String numRIEmpreendimento { get; set; }
	public Date dataHabitEmpreendimento { get; set; }
	public String numHabitEmpreendimento { get; set; }
	public String cartEmpreendimento { get; set; }
	public String propostaId { get; set; }
	public String contratoId { get; set; }
	public String empreendimentoId { get; set; }
	public Decimal valorProposta { get; set; }
	public Decimal pctComissao { get; set; }
	public Decimal comissao { get; set; }
	public String propId { get; set; }
	public String cnpj { get; set; }
	public String areaTerreno { get; set; }
	public Boolean comissaoDestacadoExists { get; set; }
	public Boolean comissaoFaturadoExists { get; set; }
	public String numPavimentos { get; set; }
	public Decimal unidadeValorReal { get; set; }

	public String inttext { get; set; }
	public String propostaName { get; set; }
	public String convert { get; set; }
	public String convertSinal { get; set; }
	public String convertTotal { get; set; }
	public String convertUnitario { get; set; }
	public String convertUnitarioFinanciamento { get; set; }
	public String convertTotalParcela { get; set; }
	public String convertTotalParcelaFinanciamento { get; set; }
	public String convertQuantidadeParcela { get; set; }
	public String convertIntermediacaoFaturada { get; set; }
	public String convertIntermediacaoDestacada { get; set; }
	public String format { get; set; }
	public Date vencimentoSinal { get; set; }
	public Date vencimentoOutra { get; set; }
	public Date vencimentoFinanciamento { get; set; }
	public Decimal valorTotalParcela { get; set; }
	public Decimal valorTotalParcelaSinal { get; set; }
	public Decimal valorTotalParcelaOutra { get; set; }
	public Decimal valorTotalParcelaFinanciamento { get; set; }
	public String valorTotalComissao { get; set; }
	public Decimal quantidadeParcelas { get; set; }
	public Decimal valorUnitario { get; set; }
	public Decimal valorUnitarioFinanciamento { get; set; }
	public String periodicidade { get; set; }
	public String escaninho { get; set; }

	private Decimal num;

	private List<List<String>> qualificadores = new List<List<String>>{
		new List<String>{ 'Centavo', 'Centavos' },
		new List<String>{ '', '' },
		new List<String>{ 'Mil', 'Mil' },
		new List<String>{ 'Milhão', 'Milhões' },
		new List<String>{ 'Septilhão', 'Septilhões' }
	};
	private List<List<String>> numeros = new List<List<String>>{
		new List<String>{
			'Zero',
			'Um',
			'Dois',
			'Três',
			'Quatro',
			'Cinco',
			'Seis',
			'Sete',
			'Oito',
			'Nove',
			'Dez',
			'Onze',
			'Doze',
			'Treze',
			'Quatorze',
			'Quinze',
			'Desesseis',
			'Desessete',
			'Dezoito',
			'Desenove'
		},
		new List<String>{ 'Vinte', 'Trinta', 'Quarenta', 'Cinquenta', 'Sessenta', 'Setenta', 'Oitenta', 'Noventa' },
		new List<String>{
			'Cem',
			'Cento',
			'Duzentos',
			'Trezentos',
			'Quatrocentos',
			'Quinhentos',
			'Seiscentos',
			'Setecentos',
			'Oitocentos',
			'Novecentos'
		}
	};

	public QRProntoaPrazoController(ApexPages.StandardController sc) {
		Contrato_Opus__c contrato = [
			SELECT
				Id,
				Name,
				Empreendimento__c,
				Unidade__c,
				Garagem_CHK__c,
				Cliente__c,
				Numero_da_Proposta__c,
				Proposta__c
			FROM Contrato_Opus__c
			WHERE Id = :ApexPages.currentPage().getParameters().get('id')
			LIMIT 1
		];

		Empreendimento__c empreendimentos = [
			SELECT
				Name,
				Unidades__c,
				Numero_de_Pavimentos__c,
				CNPJ__c,
				Area_do_Terreno__c,
				N_mero_do_Habite_se__c,
				Data_de_averba_o_do_Habite_se__c,
				Cart_rio_de_Registro__c,
				Numero_da_Matricula__c,
				Numero_do_RI__c,
				Endere_o__c,
				Socios_do_Empreendimento__c,
				Razao_social__c,
				Localizacao__c,
				Total_de_Vagas__c,
				Exibe_Escaninho_no_quadro_de_Garagens__c
			FROM Empreendimento__c
			WHERE Name = :contrato.Empreendimento__c
			LIMIT 1
		];

		Proposta_de_Vendas__c proposta = [
			SELECT Name, Garagem__c, Valor_Tabela__c, Nome_Unidades__c, Perc_Comissao_Destacada__c, Valor_da_Proposta__c
			FROM Proposta_de_Vendas__c
			WHERE Id = :contrato.Proposta__c
			LIMIT 1
		];

		this.escaninho=empreendimentos.Exibe_Escaninho_no_quadro_de_Garagens__c;
		this.valorTotalParcelaFinanciamento=0;
		this.valorTotalParcelaOutra=0;
		this.valorUnitarioFinanciamento=0;
		this.valorUnitario=0;
		this.quantidadeParcelas = 0;
		this.valorTotalParcela = 0;
		this.valorTotalParcelaSinal = 0;
		this.empreendimentoId = empreendimentos.Id;
		this.propostaName = proposta.Name;
		this.contratoId = contrato.Id;
		this.unidadeValorReal = proposta.Valor_Tabela__c;
		this.empreendimentoLocalizacao = empreendimentos.Localizacao__c;
		this.unidadeValor = valorUnidade(proposta.Valor_Tabela__c);
		this.unidadeNome = proposta.Nome_Unidades__c;
		this.numPavimentos = empreendimentos.Numero_de_Pavimentos__c;
		this.areaTerreno = empreendimentos.Area_do_Terreno__c;
		this.cnpj = empreendimentos.CNPJ__C;
		this.cartEmpreendimento = empreendimentos.Cart_rio_de_Registro__c;
		this.dataHabitEmpreendimento = empreendimentos.Data_de_averba_o_do_Habite_se__c;
		this.numHabitEmpreendimento = empreendimentos.N_mero_do_Habite_se__c;
		this.matriculaEmpreendimento = empreendimentos.Numero_da_Matricula__c;
		this.numRIEmpreendimento = empreendimentos.Numero_do_RI__c;
		this.enderecoEmpreendimento = empreendimentos.Endere_o__c;
		this.razaoSocial = empreendimentos.Razao_social__c;
		this.propId = contrato.Proposta__c;
		this.unidade = contrato.Unidade__c;
		this.propostaId = contrato.Numero_da_Proposta__c;
		this.empreendimento = empreendimentos.Name;
		this.socioEmpreendimento = empreendimentos.Socios_do_Empreendimento__c;

		this.comissao = proposta.Perc_Comissao_Destacada__c;
		if (comissao == null) {
			this.valorProposta = proposta.Valor_da_Proposta__c;
		} else {
			this.valorProposta = proposta.Valor_da_Proposta__c * (proposta.Perc_Comissao_Destacada__c / 100);
		}
		this.convert = valorPorExtenso(valorProposta);

		this.inttext = (valorProposta.format().contains(',')
			? valorProposta.format()
			: (valorProposta.format() + ',00'));
		this.format = valorProposta.format();
		this.valorTotalComissao = valorUnidade(valorProposta);
	}

	public QRProntoaPrazoController() {
		/**
		 *
		 * Executa um SELECT no banco buscando os dados necessários
		 * para renderizar a Visual Force Page.
		 *
		 */
		Contrato_Opus__c contrato = [
			SELECT
				Id,
				Name,
				Empreendimento__c,
				Unidade__c,
				Garagem_CHK__c,
				Cliente__c,
				Numero_da_Proposta__c,
				Proposta__c
			FROM Contrato_Opus__c
			WHERE Id = :ApexPages.currentPage().getParameters().get('id')
			LIMIT 1
		];
		Empreendimento__c empreendimentos = [
			SELECT
				Name,
				CNPJ__c,
				Unidades__c,
				Area_do_Terreno__c,
				Numero_de_Pavimentos__c,
				N_mero_do_Habite_se__c,
				Data_de_averba_o_do_Habite_se__c,
				Cart_rio_de_Registro__c,
				Numero_do_RI__c,
				Numero_da_Matricula__c,
				Razao_social__c,
				Endere_o__c,
				Socios_do_Empreendimento__c,
				Localizacao__c,
				Total_de_Vagas__c,
				Exibe_Escaninho_no_quadro_de_Garagens__c
			FROM Empreendimento__c
			WHERE Name = :contrato.Empreendimento__c
			LIMIT 1
		];
		Proposta_de_Vendas__c proposta = [
			SELECT Name, Garagem__c, Valor_Tabela__c, Nome_Unidades__c, Perc_Comissao_Destacada__c, Valor_da_Proposta__c
			FROM Proposta_de_Vendas__c
			WHERE Id = :contrato.Proposta__c
			LIMIT 1
		];

		/**
		 *
		 * Atribui os dados retornados anteriormente para as
		 * variáveis necessárias na Visual Force Page
		 *
		 */
		this.escaninho=empreendimentos.Exibe_Escaninho_no_quadro_de_Garagens__c;
		this.valorTotalParcelaFinanciamento=0;
		this.valorTotalParcelaOutra=0;
		this.valorUnitarioFinanciamento=0;
		this.valorUnitario=0;
		this.quantidadeParcelas = 0;
		this.valorTotalParcela = 0;
		this.valorTotalParcelaSinal = 0;
		this.propostaName = proposta.Name;
		this.empreendimentoId = empreendimentos.Id;
		this.contratoId = contrato.Id;
		this.unidadeValorReal = proposta.Valor_Tabela__c;
		this.empreendimentoLocalizacao = empreendimentos.Localizacao__c;
		this.unidadeValor = valorUnidade(proposta.Valor_Tabela__c);
		this.unidadeNome = proposta.Nome_Unidades__c;
		this.unidadeNome = empreendimentos.Unidades__c;
		this.numPavimentos = empreendimentos.Numero_de_Pavimentos__c;
		this.areaTerreno = empreendimentos.Area_do_Terreno__c;
		this.cnpj = empreendimentos.CNPJ__C;
		this.dataHabitEmpreendimento = empreendimentos.Data_de_averba_o_do_Habite_se__c;
		this.numHabitEmpreendimento = empreendimentos.N_mero_do_Habite_se__c;
		this.cartEmpreendimento = empreendimentos.Cart_rio_de_Registro__c;
		this.matriculaEmpreendimento = empreendimentos.Numero_da_Matricula__c;
		this.numRIEmpreendimento = empreendimentos.Numero_do_RI__c;
		this.enderecoEmpreendimento = empreendimentos.Endere_o__c;
		this.razaoSocial = empreendimentos.Razao_social__c;
		this.propId = contrato.Proposta__c;
		this.unidade = contrato.Unidade__c;
		this.propostaId = contrato.Numero_da_Proposta__c;
		this.empreendimento = empreendimentos.Name;

		this.comissao = proposta.Perc_Comissao_Destacada__c;
		if (comissao == null) {
			this.valorProposta = proposta.Valor_da_Proposta__c;
		} else {
			this.valorProposta = proposta.Valor_da_Proposta__c * (proposta.Perc_Comissao_Destacada__c / 100);
		}
		//valor da comissao por extenso
		this.convert = valorPorExtenso(valorProposta);

		this.inttext = (valorProposta.format().contains(',')
			? valorProposta.format()
			: (valorProposta.format() + ',00'));

		this.valorTotalComissao = valorUnidade(valorProposta);
	}

	// public Unidade__c getUnidades() {
	// 	return [
	// 		SELECT Area_comum__c, Area_privada__c, Area_total__c, Fracao_Ideal__c, Localizacao__c, Name
	// 		FROM Unidade__c
	// 		WHERE Empreendimento__c = :empreendimentoId
	// 	];
	// }

	public List<Unidade_da_Proposta__c> getUnidadeProposta() {
		return [
			SELECT
				Name,
				Porcentagem_f__c,
				Unidade__c,
				Valor_Tabela__c,
				Tipo__c,
				Unidade__r.Area_privada__c,
				Unidade__r.Area_total__c,
				Unidade__r.Fracao_Ideal__c,
				Unidade__r.Area_comum__c,
				Unidade__r.Localizacao__c,
				Unidade__r.Name,
				Proposta_de_Vendas__r.Valor_da_Proposta__c				
			FROM Unidade_da_Proposta__c
			WHERE Proposta_de_Vendas__c = :propId
		];
	}

	public List<Proponentes__c> getProponentes() {
		List<Proponentes__c> proponents = [
			SELECT
				Name,
				Nome_Completo_CJ__c,
				RecordTypeId,
				Nacionalidade__c,
				Orgao_Expedidor__c,
				Estado_Civil_CJ__c,
				Profissao_CJ__c,
				Estado_Civil__c,
				Profissao__c,
				RG__c,
				CPF__c,
				Endereco__c,
				Orgao_Expedidor_CJ__c,
				RG_CJ__c,
				Endereco_Residencial_CJ__c,
				CPF_CJ__c,
				Telefone_Residencial__c,
				Tipo_de_Uniao__c,
				Telefone_CJ__c,
				Telefone_Celular__c,
				CNPJ__c,
				Raz_o_Social__c,
				Endereco_Comercial__c
			FROM Proponentes__c
			WHERE Proposta_de_Vendas__c = :propId
		];

		List<Proponentes__c> proponentesPj =new List<Proponentes__c>();
		


		for(Proponentes__c proponente : proponents) {

            if(proponente.RecordTypeId=='0124A000001IuzOQAS'){

                proponentesPj.add(proponente);
                return proponentesPj;
            }
            
        }
        return proponents;
	}

	public List<Garagem_do_Contrato__c> getGaragem() {
		return [
			SELECT Name, Garagem__r.Nome_da_Garagem__c, Valor__c,Valor_Garagem__c, Garagem__r.Localizacao__c, Garagem__r.Area__c
			FROM Garagem_do_Contrato__c
			WHERE Contrato_Opus__c = :ApexPages.currentPage().getParameters().get('id')
			
		];
	}

	public List<Intermediacao__c> getIntermediacao() {
		List<Intermediacao__c> intermediacoes = [
			SELECT Razao_social__c, Name, Tipo_de_Comissao__c,Valor__c,CPF_CNPJ__c
			FROM Intermediacao__c
			WHERE Proposta_de_Vendas__c = :propId
		];

		for (Intermediacao__c intermed : intermediacoes) {
	
			if(intermed.Tipo_de_Comissao__c == 'Faturado'){

				this.convertIntermediacaoFaturada= valorPorExtenso(intermed.Valor__c);
				this.comissaoFaturadoExists = true;
			}

			if(intermed.Tipo_de_Comissao__c == 'Destacado'){

				this.convertIntermediacaoDestacada= valorPorExtenso(intermed.Valor__c);
				this.comissaoDestacadoExists = true;
			}
		}


		return intermediacoes;
	}

	public List<Condi_o_de_Pagamento__c> getCondicaoPagamento() {
		List<Condi_o_de_Pagamento__c> x = [
			SELECT
				Periodicidade_Condicao__c,
				Quantidade_de_parcelas__c,
				Valor_Total_Parcela__c,
				Valor_Total_das_Parcelas__c,
				In_cio_do_Vencimento__c,
				Correcao__c,
				Valor_Opus__c
			FROM Condi_o_de_Pagamento__c
			WHERE Proposta_de_Vendas__c = :propId
		];

		for (Condi_o_de_Pagamento__c condicao : x) {
			if (condicao.Valor_Opus__c == null || condicao.Valor_Opus__c == 0) {
				this.valorTotalParcela += condicao.Valor_Total_Parcela__c;
			} else {
				this.valorTotalParcela += condicao.Valor_Opus__c;
			}

			if (condicao.Periodicidade_Condicao__c == 'Sinal') {
				this.valorTotalParcelaSinal = condicao.Valor_Total_Parcela__c;
				this.vencimentoSinal = condicao.In_cio_do_Vencimento__c;
			}
			if (
				condicao.Periodicidade_Condicao__c != 'Sinal' &&
				condicao.Periodicidade_Condicao__c != 'Financiamento'
			) {
				this.quantidadeParcelas = condicao.Quantidade_de_parcelas__c;
				this.periodicidade = condicao.Periodicidade_Condicao__c;
				this.valorUnitario = condicao.Valor_Total_das_Parcelas__c;
				this.valorTotalParcelaOutra = condicao.Valor_Total_Parcela__c;
				this.vencimentoOutra = condicao.In_cio_do_Vencimento__c;
			}
			if (condicao.Periodicidade_Condicao__c == 'Financiamento') {
				this.valorUnitarioFinanciamento = condicao.Valor_Total_das_Parcelas__c;
				this.valorTotalParcelaFinanciamento = condicao.Valor_Total_Parcela__c;
				this.vencimentoFinanciamento = condicao.In_cio_do_Vencimento__c;
			}
		}
		this.convertSinal = valorPorExtenso(valorTotalParcelaSinal);
		this.convertTotal = valorPorExtenso(valorTotalParcela);
		this.convertUnitario = valorPorExtenso(valorUnitario);
		this.convertUnitarioFinanciamento = valorPorExtenso(valorUnitarioFinanciamento);
		this.convertTotalParcela = valorPorExtenso(valorTotalParcelaOutra);
		this.convertTotalParcelaFinanciamento = valorPorExtenso(valorTotalParcelaFinanciamento);
		// this.convertQuantidadeParcela = valorPorExtenso(quantidadeParcelas);
		return x;
	}

	// public String getEmpreendimentoSemGaragem() {
	// 	List<Garagem_do_Contrato__c> garagemContrato = [
	// 		SELECT Valor_Garagem__c
	// 		FROM Garagem_do_Contrato__c
	// 		WHERE Contrato_Opus__c = :contratoId
	// 	];
	// 	Decimal valores = 0.0;
	// 	Integer i = 0;
	// 	if (garagemContrato.size() > 0) {
	// 		for (Garagem_do_Contrato__c garagem : garagemContrato) {
	// 			valores += garagem.Valor_Garagem__c;
	// 		}
	// 		Decimal total = unidadeValorReal - valores;
	// 		return valorUnidade(total);
	// 	} else {
	// 		valores = unidadeValorReal - garagemContrato[i].Valor_Garagem__c;
	// 		return valorUnidade(valores);
	// 	}
	// }

	public static String valorUnidade(Decimal vlr) {
		List<String> args;

		String valr = String.valueOf(vlr);
		args = valr.split('\\.');
		List<String> tsex = args[0].split('');
		String aux = '';
		for (Integer i = args[0].length() - 1; i >= 0; i--) {
			aux = tsex[i] + aux;
			if (aux.length() == 3 || aux.length() == 7) {
				aux = '.' + aux;
			}
			tsex[i] = '';
		}

		String centavos = args[1].substring(0, 2);
		String total = aux + ',' + centavos;

		if (total.substring(0, 1).contains('.')) {
			total = total.substring(1, total.length());
			return (total);
		} else {
			return (total);
		}
	}

	public static String valorPorExtenso(Decimal vlr) {
		if (vlr == 0)
			return ('zero');

		List<String> args;

		String valr = String.valueOf(vlr);
		args = valr.split('\\.');

		Decimal inteiro = Integer.valueOf(args[0]); // parte inteira do valor
		Decimal resto = vlr - inteiro; // parte fracionária do valor

		String vlrS = String.valueOf(inteiro);

		if (vlrS.length() > 15)
			return ('Erro: valor superior a 999 trilhões.');

		String s = '', saux, vlrP;

		String centavos = args[1].substring(0, 2);
		String total = valorUnidade(vlr);
		if (total.substring(0, 1).contains('.')) {
			total = total.substring(1, total.length());
		}

		List<String> unidade = new List<String>{
			'zero',
			'um',
			'dois',
			'três',
			'quatro',
			'cinco',
			'seis',
			'sete',
			'oito',
			'nove',
			'dez',
			'onze',
			'doze',
			'treze',
			'quatorze',
			'quinze',
			'dezesseis',
			'dezessete',
			'dezoito',
			'dezenove'
		};
		List<String> centena = new List<String>{
			'',
			'cento',
			'duzentos',
			'trezentos',
			'quatrocentos',
			'quinhentos',
			'seiscentos',
			'setecentos',
			'oitocentos',
			'novecentos'
		};
		List<String> dezena = new List<String>{
			'',
			'',
			'vinte',
			'trinta',
			'quarenta',
			'cinquenta',
			'sessenta',
			'setenta',
			'oitenta',
			'noventa'
		};
		List<String> qualificaS = new List<String>{ '', 'mil', 'milhão', 'bilhão' };
		List<String> qualificaP = new List<String>{ '', 'mil', 'milhões', 'bilhões', 'trilhões' };

		// definindo o extenso da parte inteira do valor
		Integer n, unid, dez, cent, tam, i = 0;
		Boolean umReal = false, tem = false;
		while (!vlrS.equals('0')) {
			tam = vlrS.length();
			// retira do valor a 1a. parte, 2a. parte, por exemplo, para 123456789:
			// 1a. parte = 789 (centena)
			// 2a. parte = 456 (mil)
			// 3a. parte = 123 (milhões)
			if (tam > 3) {
				vlrP = vlrS.substring(tam - 3, tam);
				vlrS = vlrS.substring(0, tam - 3);
			} else {
				// última parte do valor
				vlrP = vlrS;
				vlrS = '0';
			}
			if (!vlrP.equals('000')) {
				saux = '';
				if (vlrP.equals('100'))
					saux = 'cem';
				else {
					n = Integer.valueOf(vlrP); // para n = 371, tem-se:
					cent = n / 100; // cent = 3 (centena trezentos)
					dez = Math.mod(n, 100) / 10; // dez  = 7 (dezena setenta)
					unid = Math.mod(Math.mod(n, 100), 10); // unid = 1 (unidade um)
					if (cent != 0)
						saux = centena[cent];
					if (Math.mod(n, 100) <= 19) {
						if (saux.length() != 0)
							saux = saux + ' e ' + unidade[Math.mod(n, 100)];
						else
							saux = unidade[Math.mod(n, 100)];
					} else {
						if (saux.length() != 0)
							saux = saux + ' e ' + dezena[dez];
						else
							saux = dezena[dez];
						if (unid != 0) {
							if (saux.length() != 0)
								saux = saux + ' e ' + unidade[unid];
							else
								saux = unidade[unid];
						}
					}
				}
				if (vlrP.equals('1') || vlrP.equals('001')) {
					if (
						i == 0 // 1a. parte do valor (um real)
					)
						umReal = true;
					else
						saux = saux + ' ' + qualificaS[i];
				} else if (i != 0)
					saux = saux + ' ' + qualificaP[i];
				if (s.length() != 0)
					s = saux + ', ' + s;
				else
					s = saux;
			}
			if (((i == 0) || (i == 1)) && s.length() != 0)
				tem = true; // tem centena ou mil no valor
			i = i + 1; // próximo qualificador: 1- mil, 2- milhão, 3- bilhão, ...
		}

		if (s.length() != 0) {
			if (umReal)
				s = s + ' real';
			else if (tem)
				s = s + ' reais';
			else
				s = s + ' de reais';
		}

		// definindo o extenso dos centavos do valor
		if (!centavos.equals(null)) {
			// valor com centavos
			if (
				s.length() != 0 // se não é valor somente com centavos
			)
				s = s + ' e ';
			Integer cents = Integer.valueOf(centavos);
			if (cents <= 19) {
				s = s + unidade[cents];
			} else {
				// para n = 37, tem-se:
				unid = Math.mod(cents, 10); // unid = 37 % 10 = 7 (unidade sete)
				dez = cents / 10; // dez  = 37 / 10 = 3 (dezena trinta)
				if (dez <= 10) {
					s = s + dezena[dez];
				}
				if (unid > 0 && unid < 100) {
					s = s + ' e ' + unidade[unid];
				}
			}
			if (centavos.equals('01')) {
				s = s + ' centavo';
			} else {
				s = s + ' centavos';
			}
		} else {
			Integer cents = Integer.valueOf(centavos);
			if (cents <= 19) {
				s = s + unidade[cents];
			} else {
				// para n = 37, tem-se:
				unid = Math.mod(cents, 10); // unid = 37 % 10 = 7 (unidade sete)
				dez = cents / 10; // dez  = 37 / 10 = 3 (dezena trinta)
				if (dez <= 10) {
					s = s + dezena[dez];
				}
				if (unid > 0 && unid < 100) {
					s = s + ' e ' + unidade[unid];
				}
			}
			if (centavos.equals('01')) {
				s = s + ' centavo';
			} else {
				s = s + ' centavos';
			}
		}

		return total + ' ( ' + s + ' ) ';
	}
}