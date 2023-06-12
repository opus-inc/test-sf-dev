@isTest
public class QRProntoaPrazoControllerTest {
	@isTest
	static void testaController() {

		Empreendimento__c emp = EmpreendimentoUtil.buildEmpreendimento();
		Proposta_de_Vendas__c prop = PropostaDeVendasUtil.buildPropostaDeVendas();
		Unidade__c unid = UnidadeUtil.buildUnidade();
        Tabela_de_Vendas__c tabela = TabelaDeVendasUtil.buildtabelaDaProposta();

		Condi_o_de_Pagamento__c cond = CondicaoPagamentoUtil.buildCondicaoDePagamento(
			Double.valueOf(1), Double.valueOf(1), Double.valueOf(565782.55), Date.newInstance(2022, 01, 05),
			tabela.Id, 'Financiamento', 'Sim', Double.valueOf(0), 'Não', Double.valueOf(0), Double.valueOf(0), 'Sim'	
		);
		prop = [SELECT Id FROM Proposta_de_Vendas__c];

        Intermediacao__c intermediacao = IntermediacaoServiceImpl.buildIntermediacao(
            '772.557.450-67', '03588-GO', 'Teste', 2, '62 99999-8888', 'Name Test', prop.Id, 'Faturado', 'Teste Observações',
            'Corretor', 'email@email.com'
        );  
		Contrato_Opus__c contopus = new Contrato_Opus__c(
			Aproveitamento_Distrato__c = 'Upgrade',
			Status_do_Contrato__c = 'Aprovado',
			Proposta__c = prop.Id
		);

		insert contopus;
		// insert cond;
		// insert unid;

		Pagereference pageRef = Page.QRProntoaPrazo;

		System.debug('What is the profile id ' + contopus);

		contopus = [SELECT Id, Unidade__c FROM Contrato_Opus__c];

		Test.setCurrentPage(pageRef);
		pageRef.getParameters().put('id', String.valueOf(contopus.Id));
		Test.startTest();
		QRProntoaPrazoController controler = new QRProntoaPrazoController();
		ApexPages.StandardController sc = new ApexPages.StandardController(contopus);
		QRProntoaPrazoController testAccPlan = new QRProntoaPrazoController(sc);
		testAccPlan.getProponentes();
		testAccPlan.getGaragem();
		testAccPlan.getCondicaoPagamento();
		// testAccPlan.getEmpreendimentoSemGaragem();
		testAccPlan.getIntermediacao();
		testAccPlan.getUnidadeProposta();
		// testAccPlan.getUnidades();

		System.assert(controler.unidade == contopus.Unidade__c);

		Test.stopTest();
	}
}