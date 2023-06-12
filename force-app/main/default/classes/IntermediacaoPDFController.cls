/**
 * @author   : Matheus de Castro Sousa
 * @since    : 2022-03-09
 * Porpouse  : Classe para gerar PDF do contrato de Hipoteca
 */

public with sharing class IntermediacaoPDFController {
	public String unidade { get; set; }
	public String empreendimento { get; set; }
	public String propostaId { get; set; }
	public Decimal valorProposta { get; set; }
	public String contratoName { get; set; }
	public Decimal pctComissao { get; set; }
	public Decimal comissao { get; set; }
	public String propId { get; set; }

	public String inttext { get; set; }
	public String convert { get; set; }
	public String format { get; set; }
	public String valorTotalComissao { get; set; }
	public Boolean isCpf= true;
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

	public IntermediacaoPDFController(ApexPages.StandardController sc) {
		Contrato_Opus__c contrato = [
			SELECT Id, Name, Empreendimento__c, Unidade__c, Garagem_CHK__c, Cliente__c, Numero_da_Proposta__c,Proposta__c
			FROM Contrato_Opus__c
			WHERE Id = :ApexPages.currentPage().getParameters().get('id')
			LIMIT 1
		];
		Empreendimento__c empreendimentos = [
			SELECT Name, Razao_social__c, Localizacao__c, Total_de_Vagas__c
			FROM Empreendimento__c
			WHERE Name = :contrato.Empreendimento__c
			LIMIT 1
		];
		Proposta_de_Vendas__c proposta = [
			SELECT Name, Garagem__c, Perc_Comissao_Destacada__c, Valor_da_Proposta__c
			FROM Proposta_de_Vendas__c
			WHERE Id = :contrato.Proposta__c
			LIMIT 1
		];
		this.contratoName = contrato.Name;
		this.propId = contrato.Proposta__c;
		this.unidade = contrato.Unidade__c;
		this.propostaId = contrato.Numero_da_Proposta__c;
		this.empreendimento = empreendimentos.Name;
		this.comissao = proposta.Perc_Comissao_Destacada__c;
		this.valorProposta = proposta.Valor_da_Proposta__c * (proposta.Perc_Comissao_Destacada__c / 100);
		this.convert = valorPorExtenso(valorProposta);
		this.valorTotalComissao = valorTotal(valorProposta);

		this.inttext = (valorProposta.format().contains(',')
			? valorProposta.format()
			: (valorProposta.format() + ',00'));
	}

	public IntermediacaoPDFController() {
		/**
		 *
		 * Executa um SELECT no banco buscando os dados necessários
		 * para renderizar a Visual Force Page.
		 *
		 */
		Contrato_Opus__c contrato = [
			SELECT Id, Name, Empreendimento__c, Unidade__c, Garagem_CHK__c, Cliente__c, Numero_da_Proposta__c,Proposta__c
			FROM Contrato_Opus__c
			WHERE Id = :ApexPages.currentPage().getParameters().get('id')
			LIMIT 1
		];
		Empreendimento__c empreendimentos = [
			SELECT Name, Razao_social__c, Localizacao__c, Total_de_Vagas__c
			FROM Empreendimento__c
			WHERE Name = :contrato.Empreendimento__c
			LIMIT 1
		];
		Proposta_de_Vendas__c proposta = [
			SELECT Name, Garagem__c, Perc_Comissao_Destacada__c, Valor_da_Proposta__c
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
		this.contratoName = contrato.Name;
		this.propId = contrato.Proposta__c;
		this.unidade = contrato.Unidade__c;
		this.propostaId = contrato.Numero_da_Proposta__c;
		this.empreendimento = empreendimentos.Name;
		this.comissao = proposta.Perc_Comissao_Destacada__c;
		this.valorProposta = proposta.Valor_da_Proposta__c * (proposta.Perc_Comissao_Destacada__c / 100);
		//valor da comissao por extenso
		this.convert = valorPorExtenso(valorProposta);
		this.valorTotalComissao = valorTotal(valorProposta);

		this.inttext = (valorProposta.format().contains(',')
			? valorProposta.format()
			: (valorProposta.format() + ',00'));
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
		

	public List<Intermediacao__c> getIntermediacao() {
		return [SELECT Razao_social__c, Name, Tipo_de_Comissao__c,Valor__c,CPF_CNPJ__c FROM Intermediacao__c WHERE Proposta_de_Vendas__c = :propId];
	}

   public static String valorTotal(Decimal vlr) {
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
		System.debug(inteiro);
		Decimal resto = vlr - inteiro; // parte fracionária do valor

		String vlrS = String.valueOf(inteiro);

		if (vlrS.length() > 15)
			return ('Erro: valor superior a 999 trilhões.');

		String s = '', saux, vlrP;

		String centavos = args[1].substring(0, 2);
		String total = valorTotal(vlr);
      if(total.substring(0,1).contains('.')){
			total = total.substring(1,total.length());
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