@IsTest
public without sharing class PropostaCadastroControllerTest {
    
    @TestSetup
    private static void testSetup(){        
        Empreendimento__c empreendimento = new Empreendimento__c(
            Name = 'Rosa dos Ventos',
            Data_de_lan_amento__c = date.today()
        );
        insert empreendimento;

        List<Bloco__c> blocos = new List<Bloco__c>();
        Bloco__c bloco1 = new Bloco__c(
            Name='Bloco 1',
            Disponivel_no_PV__c = 'Sim',
            Empreendimento__c = empreendimento.Id,
            Utiliza_Tabela_Especial__c = 'Sim'
        );
        blocos.add(bloco1);

        Bloco__c bloco2 = new Bloco__c(
            Name='Bloco 2',
            Disponivel_no_PV__c = 'Não',
            Empreendimento__c = empreendimento.Id
        );
        blocos.add(bloco2);

        insert blocos;

        Tipologia__c tipologia = new Tipologia__c(
            Name='Tipologia Final 1',
            Bloco__c=blocos[0].Id,
            Empreendimento__c=empreendimento.Id,
            Valor_Descontado_na_Garagem__c=0
        );
        insert tipologia;

        Tabela_de_Vendas__c tabelaVendasTab = new Tabela_de_Vendas__c(
            Status__c = 'Ativa',
            Tipo__c = 'Tabela',
            Data_da_Tabela__c = date.today(),
            Empreendimento__c = empreendimento.Id,
            Bloco__c = blocos[0].Id,
            Valor_Climatiza_o__c = 100
        );
        insert tabelaVendasTab;

        Tabela_de_Vendas__c tabelaVendasProp = new Tabela_de_Vendas__c(
            Status__c = 'Ativa',
            Tipo__c = 'Proposta',
            Data_da_Tabela__c = date.today(),
            Empreendimento__c = empreendimento.Id,
            Valor_Climatiza_o__c = 100
        );
        insert tabelaVendasProp;

        Condi_o_de_Pagamento__c paymentConditionMensal = new Condi_o_de_Pagamento__c();
        paymentConditionMensal.Tabela_de_Vendas__c = tabelaVendasTab.Id;        
        paymentConditionMensal.Atualiza_Fluxo__c = 'Não';
        paymentConditionMensal.Quantidade_de_parcelas__c = 2;
        paymentConditionMensal.Valor_Total_das_Parcelas__c = 100;
        paymentConditionMensal.Periodicidade_Condicao__c = 'Mensal';        
        paymentConditionMensal.Intervalo_das_Parcelas__c = 1;
        paymentConditionMensal.In_cio_do_Vencimento__c = date.today();      
        
        Condi_o_de_Pagamento__c paymentConditionSemestral = new Condi_o_de_Pagamento__c();
        paymentConditionSemestral.Tabela_de_Vendas__c = tabelaVendasTab.Id;        
        paymentConditionSemestral.Atualiza_Fluxo__c = 'Não';
        paymentConditionSemestral.Quantidade_de_parcelas__c = 2;
        paymentConditionSemestral.Valor_Total_das_Parcelas__c = 100;
        paymentConditionSemestral.Periodicidade_Condicao__c = 'Semestral';        
        paymentConditionSemestral.Intervalo_das_Parcelas__c = 1;
        paymentConditionSemestral.In_cio_do_Vencimento__c = date.today();     

        Condi_o_de_Pagamento__c paymentConditionSinal = new Condi_o_de_Pagamento__c();
        paymentConditionSinal.Tabela_de_Vendas__c = tabelaVendasTab.Id;        
        paymentConditionSinal.Atualiza_Fluxo__c = 'Não';
        paymentConditionSinal.Quantidade_de_parcelas__c = 3;
        paymentConditionSinal.Valor_Total_das_Parcelas__c = 100;
        paymentConditionSinal.Periodicidade_Condicao__c = 'Sinal';        
        paymentConditionSinal.Intervalo_das_Parcelas__c = 1;
        paymentConditionSinal.In_cio_do_Vencimento__c = date.today();

        Condi_o_de_Pagamento__c paymentConditionUnica = new Condi_o_de_Pagamento__c();
        paymentConditionUnica.Tabela_de_Vendas__c = tabelaVendasTab.Id;        
        paymentConditionUnica.Atualiza_Fluxo__c = 'Não';
        paymentConditionUnica.Quantidade_de_parcelas__c = 2;
        paymentConditionUnica.Valor_Total_das_Parcelas__c = 100;
        paymentConditionUnica.Periodicidade_Condicao__c = 'Única';        
        paymentConditionUnica.Intervalo_das_Parcelas__c = 1;
        paymentConditionUnica.In_cio_do_Vencimento__c = date.today();

        Condi_o_de_Pagamento__c paymentConditionFinanciamento = new Condi_o_de_Pagamento__c();
        paymentConditionFinanciamento.Tabela_de_Vendas__c = tabelaVendasTab.Id;        
        paymentConditionFinanciamento.Atualiza_Fluxo__c = 'Não';
        paymentConditionFinanciamento.Quantidade_de_parcelas__c = 2;
        paymentConditionFinanciamento.Valor_Total_das_Parcelas__c = 100;
        paymentConditionFinanciamento.Periodicidade_Condicao__c = 'Financiamento';      
        paymentConditionFinanciamento.Intervalo_das_Parcelas__c = 1;  
        paymentConditionFinanciamento.In_cio_do_Vencimento__c = date.today();

        List<Condi_o_de_Pagamento__c> paymentConditionsToInsert = new  List<Condi_o_de_Pagamento__c>();
        paymentConditionsToInsert.add(paymentConditionMensal);
        paymentConditionsToInsert.add(paymentConditionSinal);
        paymentConditionsToInsert.add(paymentConditionUnica);
        paymentConditionsToInsert.add(paymentConditionFinanciamento);
        paymentConditionsToInsert.add(paymentConditionSemestral);

        insert paymentConditionsToInsert;

        List<Corretores__c> corretores = new List<Corretores__c>();
        
        Corretores__c corretor = new Corretores__c(
            Origem__c = 'Salesforce',
            Name = 'ASAP',
            Usuario_Master__c = true
        );
        corretores.add(corretor);
        Corretores__c corretor1 = new Corretores__c(
            Origem__c = 'Salesforce',
            Name = 'Jorge',
            Usuario_Master__c = true
        );
        corretores.add(corretor1);

        insert corretores;

        Unidade__c unidade = new Unidade__c(
            Name = 'UN-1', 
            Empreendimento__c=empreendimento.Id,
            Bloco__c = blocos[0].Id,
            Mostra_PV__c = 'Sim',
            Tipo_da_unidade__c = 'Unidade',
            Status_Secund_rio__c = 'Disponível',
            Total_Mensais__c = 1000,
            Total_Pre_Chaves__c = 1000,
            Total_Semestrais__c = 1000,
            Total_Sinais__c = 1000,
            Tipologia__c=tipologia.Id
        );
        insert unidade;

        Unidade__c unidadeGaragem = new Unidade__c(
            Name = 'GR-1', 
            Empreendimento__c=empreendimento.Id,
            Mostra_PV__c = 'Sim',
            Tipo_da_unidade__c = 'Garagem',
            Status_Secund_rio__c = 'Disponível'
        );
        insert unidadeGaragem;
        
        Proposta_de_Vendas__c propostaVenda = new Proposta_de_Vendas__c(
            Nome_do_Cliente__c='with image',
        	VPL_Proposta__c = 1000.00,
            Empreendimento__c = empreendimento.Id,
            Valor_da_Proposta__c = 100000.00,
            Tabela_da_Proposta__c = tabelaVendasProp.Id,
            Tabela_de_Vendas_Proposta__c = tabelaVendasTab.Id,
            Versao_PV__c = '2',
            Corretor__c = corretores[0].Id,
            Corretor_Criacao__c = corretores[0].Id,
            Bloco__c = blocos[0].Id,
            Valor_Total_Grupo_A__c=100,
            Valor_Total_Grupo_B__c=100,
            Valor_Total_Grupo_C__c=100
        );
        insert propostaVenda;

        tabelaVendasProp.Proposta_de_Vendas__c = propostaVenda.Id;
        tabelaVendasTab.Proposta_de_Vendas__c = propostaVenda.Id;
        update tabelaVendasProp;
        update tabelaVendasTab;
        
        ContentVersion contentVersion = new ContentVersion(
            ContentLocation = 'S', 
            PathOnClient = 'image.jpeg', 
            Title = 'image test',
            VersionData = Blob.valueOf('Teste')
        ); 
        insert contentVersion;

        ContentVersion contentVersionInserted = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id];

        ContentDocumentLink contentDocumentLink = new ContentDocumentLink(
            LinkedEntityId = propostaVenda.Id, 
            ContentDocumentId = contentVersionInserted.ContentDocumentId,  
            shareType = 'I'
        ); 
        insert contentDocumentLink;
        
        Condi_o_de_Pagamento__c paymentCondition = new Condi_o_de_Pagamento__c(
            Quantidade_de_parcelas__c = 10,
            Proposta_de_Vendas__c = propostaVenda.Id,
            Tabela_de_Vendas__c = tabelaVendasTab.Id,
            Valor_Total_das_Parcelas__c = 100
        );
        insert paymentCondition;       
    }
    
    @IsTest
    static void shouldGetPropostaById(){
        Test.startTest();
        Proposta_de_Vendas__c propostaVenda = new Proposta_de_Vendas__c();
        insert propostaVenda;

        Proposta_de_Vendas__c recordFounded = PropostaCadastroController.getPropostaById(propostaVenda.Id);
        System.assert(recordFounded != null);
        Test.stopTest(); 
    }

    @IsTest
    static void shouldGetEmpreendimentoById(){
        Test.startTest();
        Empreendimento__c empreendimento = new Empreendimento__c(Data_de_lan_amento__c = Date.newInstance(2030, 01, 01));
        insert empreendimento;

        Empreendimento__c recordFounded = PropostaCadastroController.getEmpreendimentoById(empreendimento.Id);
        System.assert(recordFounded != null);
        Test.stopTest(); 
    }

    @IsTest
    static void shouldGetCondicoesById(){
        Test.startTest();
        List<Id> condicoesIds = new List<Id>();

        Condi_o_de_Pagamento__c condicao = new Condi_o_de_Pagamento__c(
            Quantidade_de_parcelas__c=10,
            Valor_Total_das_Parcelas__c=100
        );
        insert condicao;
        condicoesIds.add(condicao.Id);

        List<Condi_o_de_Pagamento__c> recordFounded = PropostaCadastroController.getCondicoesById(condicoesIds);
        System.assert(recordFounded != null);
        Test.stopTest(); 
    }

    @IsTest
    static void shouldUpdatePropostaVenda(){
        Test.startTest();
        Proposta_de_Vendas__c propostaVenda = new Proposta_de_Vendas__c(
            Nome_do_Cliente__c ='Proposta1'
        );
        insert propostaVenda;

        propostaVenda.Nome_do_Cliente__c = 'Name Updated';
        
        Proposta_de_Vendas__c recordUpdated = PropostaCadastroController.updatePropostaVenda(JSON.serialize(propostaVenda));
        System.assert(recordUpdated.Nome_do_Cliente__c == propostaVenda.Nome_do_Cliente__c);
        Test.stopTest(); 
    }

    @IsTest
    static void shouldGetPickListOptions(){
        Test.startTest();
        List<Map<String,String>> options = PropostaCadastroController.getPickListOptions('Fase_da_Proposta__c');
        System.assert(!options.isEmpty());
        Test.stopTest();
    }

    @IsTest
    static void shouldGetContentVersion(){
        Test.startTest();
        Proposta_de_Vendas__c proposta = [SELECT Id FROM Proposta_de_Vendas__c WHERE Nome_do_Cliente__c = 'with image'];
        Set<String> propostasIds = new Set<String>();
        propostasIds.add(proposta.Id);
        List<String> contentVersions = PropostaCadastroController.getContentVersion(JSON.serialize(propostasIds));
        System.assert(!contentVersions.isEmpty());
        Test.stopTest();
    }
    
    @IsTest
    static void shouldGetPaymentConditions(){
        Test.startTest();
        Proposta_de_Vendas__c proposta = [SELECT Id FROM Proposta_de_Vendas__c WHERE Nome_do_Cliente__c = 'with image'];
        List<Condi_o_de_Pagamento__c> paymentConditions = PropostaCadastroController.getPaymentConditionsByProposta(proposta.Id);
        System.assert(!paymentConditions.isEmpty());            
        Test.stopTest();
    }

    @IsTest
    static void shouldSavePaymentCondition(){
        Test.startTest();
        Proposta_de_Vendas__c proposta = [SELECT Id FROM Proposta_de_Vendas__c WHERE Nome_do_Cliente__c = 'with image'];
        
        Condi_o_de_Pagamento__c paymentConditionMensal = new Condi_o_de_Pagamento__c();
        paymentConditionMensal.Atualiza_Fluxo__c = 'Não';
        paymentConditionMensal.Quantidade_de_parcelas__c = 2;
        paymentConditionMensal.Valor_Total_das_Parcelas__c = 100;
        paymentConditionMensal.Periodicidade_Condicao__c = 'Mensal';        
        paymentConditionMensal.Proposta_de_Vendas__c = proposta.Id;        
        paymentConditionMensal.In_cio_do_Vencimento__c = date.today();      
        
        Condi_o_de_Pagamento__c paymentConditionSinal = new Condi_o_de_Pagamento__c();
        paymentConditionSinal.Atualiza_Fluxo__c = 'Não';
        paymentConditionSinal.Quantidade_de_parcelas__c = 1;
        paymentConditionSinal.Valor_Total_das_Parcelas__c = 100;
        paymentConditionSinal.Periodicidade_Condicao__c = 'Sinal';        
        paymentConditionSinal.Proposta_de_Vendas__c = proposta.Id;        
        paymentConditionSinal.In_cio_do_Vencimento__c = date.today();

        Condi_o_de_Pagamento__c paymentConditionAnual = new Condi_o_de_Pagamento__c();
        paymentConditionAnual.Atualiza_Fluxo__c = 'Não';
        paymentConditionAnual.Quantidade_de_parcelas__c = 2;
        paymentConditionAnual.Valor_Total_das_Parcelas__c = 100;
        paymentConditionAnual.Periodicidade_Condicao__c = 'Anual';        
        paymentConditionAnual.Proposta_de_Vendas__c = proposta.Id;        
        paymentConditionAnual.In_cio_do_Vencimento__c = date.today();

        List<Condi_o_de_Pagamento__c> paymentConditionsToInsert = new  List<Condi_o_de_Pagamento__c>();
        paymentConditionsToInsert.add(paymentConditionMensal);
        paymentConditionsToInsert.add(paymentConditionSinal);
        paymentConditionsToInsert.add(paymentConditionAnual);

        List<Condi_o_de_Pagamento__c> paymentConditions = PropostaCadastroController.saveCondicoes(JSON.serialize(paymentConditionsToInsert));
        System.assert(!paymentConditions.isEmpty());  
        Test.stopTest();
    }
    
    @IsTest
    static void shouldUpdatePaymentDiscount(){
        Test.startTest();
        Proposta_de_Vendas__c proposta = [SELECT Id FROM Proposta_de_Vendas__c WHERE Nome_do_Cliente__c='with image'];
        
        Condi_o_de_Pagamento__c paymentConditionInsert = new Condi_o_de_Pagamento__c();
        paymentConditionInsert.Atualiza_Fluxo__c = 'Não';
        paymentConditionInsert.Quantidade_de_parcelas__c = 2;
        paymentConditionInsert.Valor_Total_das_Parcelas__c = 100;
        paymentConditionInsert.Periodicidade_Condicao__c = 'Mensal';
        paymentConditionInsert.Proposta_de_Vendas__c = proposta.Id;
        paymentConditionInsert.In_cio_do_Vencimento__c = date.today();    
		insert paymentConditionInsert;
        
		paymentConditionInsert.Quantidade_de_parcelas__c = 6;
        paymentConditionInsert.Valor_Total_das_Parcelas__c = 90;
        
        Decimal returnValue = PropostaCadastroController.updateCondicaoDiscount(paymentConditionInsert.Id,'10.0');
        System.assert(returnValue != 0);  
        Test.stopTest();
    }
    
    @IsTest
    static void shouldGetTabelaVendas(){
        Test.startTest();
        Proposta_de_Vendas__c proposta = [SELECT Id FROM Proposta_de_Vendas__c WHERE Nome_do_Cliente__c = 'with image'];
        List<Condi_o_de_Pagamento__c> paymentConditions = PropostaCadastroController.getTabelaDeVendas(proposta.Id);
        System.assert(!paymentConditions.isEmpty());            
        Test.stopTest();
    }
    
    @IsTest
    static void shouldUpsertProponente(){
        Test.startTest();
        Proposta_de_Vendas__c proposta = [SELECT Id FROM Proposta_de_Vendas__c WHERE Nome_do_Cliente__c = 'with image'];
        
        Proponentes__c proponente = new Proponentes__c(
        	Proposta_de_Vendas__c = proposta.Id
        );
        insert proponente;

        proponente.Name = 'New Name';
        
        Proponentes__c proponenteReturn = PropostaCadastroController.upsertProponentes(JSON.serialize(proponente));
        System.assert(proponenteReturn.Name == proponente.Name );            
        Test.stopTest();
    }
    
    @IsTest
    static void shouldGetProponenteByProposta(){
        Test.startTest();
        Proposta_de_Vendas__c proposta = [SELECT Id FROM Proposta_de_Vendas__c WHERE Nome_do_Cliente__c = 'with image'];
        
        Proponentes__c proponente = new Proponentes__c(
        	Proposta_de_Vendas__c = proposta.Id
        );
        insert proponente;
              
        List<Proponentes__c> proponents = PropostaCadastroController.getProponentesByProposta(proposta.Id);
        System.assert(!proponents.isEmpty());            
        Test.stopTest();
    }
    
    @IsTest
    static void shouldUpsertIntermediacao(){
        Test.startTest();
        Proposta_de_Vendas__c proposta = [SELECT Id FROM Proposta_de_Vendas__c WHERE Nome_do_Cliente__c = 'with image'];
        
        Intermediacao__c intermediacao = new Intermediacao__c(
        	Proposta_de_Vendas__c = proposta.Id,
            Razao_Social__c = 'teste ltda',
            Telefone_para_Contato__c = '080010001010',
            Tipo_de_Comissao__c = 'Destacado'
        );
        insert intermediacao;

        intermediacao.Name = 'New Name';
        
        Intermediacao__c intermediacaoReturn = PropostaCadastroController.upsertIntermediacao(JSON.serialize(intermediacao));
        System.assert(intermediacaoReturn.Name == intermediacao.Name );            
        Test.stopTest();
    }
    
    @IsTest
    static void shouldGetIntermediacaoByProposta(){
        Test.startTest();
        Proposta_de_Vendas__c proposta = [SELECT Id FROM Proposta_de_Vendas__c WHERE Nome_do_Cliente__c = 'with image'];
        
        Intermediacao__c intermediacao = new Intermediacao__c(
        	Proposta_de_Vendas__c = proposta.Id,
            Razao_Social__c = 'teste ltda',
            Telefone_para_Contato__c = '080010001010'
        );
        insert intermediacao;
        
        List<Intermediacao__c> intermediatons = PropostaCadastroController.getIntermediacaoByProposta(proposta.ID);
        System.assert(!intermediatons.isEmpty());            
        Test.stopTest();
    }
    
    @IsTest
    static void shouldGetValorProposta(){
        Test.startTest();
        Proposta_de_Vendas__c proposta = [SELECT Id,Valor_da_Proposta__c FROM Proposta_de_Vendas__c WHERE Nome_do_Cliente__c = 'with image'];       
        Proposta_de_Vendas__c propVendas = PropostaCadastroController.getValorTotal(proposta.Id);
        System.assert(propVendas != null);            
        Test.stopTest();
    }
    @IsTest
    static void shouldGetPropostasByCorretor(){
        Test.startTest();
        Corretores__c corretor  = [SELECT Id FROM Corretores__c WHERE Name = 'ASAP'];       
        List<Proposta_de_Vendas__c> propostas = PropostaCadastroController.getPropostaByCorretor(corretor.Id);
        System.assert(!propostas.isEmpty());            
        Test.stopTest();
    }
    
    @IsTest
    static void shouldCheckIsCorretorMaster() {
        Test.startTest();
        Corretores__c corretor  = [SELECT Id FROM Corretores__c WHERE Name = 'ASAP'];       

        Corretores__c corretorMaster = PropostaCadastroController.isCorretorMaster(corretor.Id);
        
        System.assert(corretorMaster != null);            
        
        Test.stopTest();
    }

    @IsTest
    static void shouldGetCorretoresMaster() {
        Test.startTest();
        Corretores__c corretor  = [SELECT Id FROM Corretores__c WHERE Name = 'ASAP'];       

        List<Corretores__c> corretoresMaster = PropostaCadastroController.getCorretoresMaster(corretor.Id);

        System.assert(!corretoresMaster.isEmpty());            

        Test.stopTest();
    }

    @IsTest
    static void changeCorretorProposta() {
        Test.startTest();
        Corretores__c corretor1  = [SELECT Id FROM Corretores__c WHERE Name = 'ASAP'];       
        Corretores__c corretor2  = [SELECT Id FROM Corretores__c WHERE Name = 'Jorge'];       
        Proposta_de_Vendas__c proposta = [SELECT Id FROM Proposta_de_Vendas__c WHERE Nome_do_Cliente__c = 'with image'];

        Proposta_de_Vendas__c changedProposta = PropostaCadastroController.changeCorretorProposta(corretor1.Id, proposta.Id, corretor2.Id);

        System.assert(changedProposta != null);            

        Test.stopTest();
    }

    @IsTest
    static void shouldChangeUnidadeProposta() {
        Test.startTest();

        Empreendimento__c empreendimento = [SELECT Id FROM Empreendimento__c WHERE Name = 'Rosa dos Ventos'];
        Bloco__c bloco = [SELECT Id FROM Bloco__c WHERE Name = 'Bloco 1'];
        
        Corretores__c corretores = [SELECT Id FROM Corretores__c WHERE Name = 'Jorge'];
        Tipologia__c tipologia = [SELECT Id FROM Tipologia__c WHERE Name = 'Tipologia Final 1'];
        
        List<Unidade__c> garagens = SelectPropertyController.getGaragensByEmpreendimento(empreendimento.Id);
        List<Map<String,String>> garagensListMap = new List<Map<String,String>>();
        garagensListMap.add(new Map<String,String>{'Id'=> String.valueOf(garagens[0].Id)});

        List<Unidade__c> unidades = SelectPropertyController.getUnidadesByEmpreendimento(bloco.Id, corretores.Id, tipologia.Id);
        List<Map<String,String>> unidadesListMap = new List<Map<String,String>>();
        unidadesListMap.add(new Map<String,String>{'Id'=> String.valueOf(unidades[0].Id), 'label'=> String.valueOf(unidades[0].Name)});

        Proposta_de_Vendas__c proposta = SelectPropertyController.saveProposal(
            corretores.Id,
            empreendimento.Id,
            bloco.Id,
            JSON.serialize(unidadesListMap),
            JSON.serialize(garagensListMap),
            '',
            '598374.48376',
            '100.8347'
        );

        Proposta_de_Vendas__c cloneProp = PropostaCadastroController.changeUnidadeProposta(
            proposta.Id,
            JSON.serialize(unidadesListMap),
            JSON.serialize(garagensListMap),
            '598374.48376',
            '100.8347',
            bloco.Id
        );

        System.assert(cloneProp != null);

        Test.stopTest();
    }
    
    @IsTest
    static void shouldGetClimatValues() {
        Test.startTest();
        Proposta_de_Vendas__c proposta = [SELECT Id FROM Proposta_de_Vendas__c WHERE Nome_do_Cliente__c = 'with image'];
        System.assert(PropostaCadastroController.getClimatValueTabelaVenda(proposta.Id) != null);
        System.assert(PropostaCadastroController.getClimatValueTabelaProposta(proposta.Id) != null);
    }

    @IsTest
    static void shouldDeleteProponentesByProposta(){
        Test.startTest();
        Proposta_de_Vendas__c proposta = [SELECT Id FROM Proposta_de_Vendas__c WHERE Nome_do_Cliente__c = 'with image'];
        Proponentes__c proponente = new Proponentes__c(
        	Proposta_de_Vendas__c = proposta.Id
        );
        insert proponente;
              
        List<Proponentes__c> proponents = PropostaCadastroController.getProponentesByProposta(proposta.Id);        
        delete proponents;

        System.assert(PropostaCadastroController.getProponentesByProposta(proposta.Id).isEmpty() == true);
    }

    @IsTest
    static void shouldDeleteIntermediacaoByProposta(){
        Test.startTest();
        Proposta_de_Vendas__c proposta = [SELECT Id FROM Proposta_de_Vendas__c WHERE Nome_do_Cliente__c = 'with image'];

        Intermediacao__c intermediacao = new Intermediacao__c(
        	Proposta_de_Vendas__c = proposta.Id,
            Razao_Social__c = 'teste ltda',
            Telefone_para_Contato__c = '080010001010',
            Tipo_de_Comissao__c = 'Destacado'
        );
        insert intermediacao;
        
        List<Intermediacao__c> intermediatons = PropostaCadastroController.getIntermediacaoByProposta(proposta.Id);
        delete intermediatons;
        
        System.assert(PropostaCadastroController.getIntermediacaoByProposta(proposta.Id).isEmpty() == true);

    }
    
    // class recordInfo {
    //     public String recordId;
    // }

    @IsTest
    static void shouldCreateContactsForProponentes(){
        Test.startTest();
        Proposta_de_Vendas__c proposta = [SELECT Id FROM Proposta_de_Vendas__c WHERE Nome_do_Cliente__c = 'with image'];
        
        Intermediacao__c intermediacao = new Intermediacao__c(
        	Proposta_de_Vendas__c = proposta.Id,
            Razao_Social__c = 'teste ltda',
            Telefone_para_Contato__c = '080010001010',
            Tipo_de_Comissao__c = 'Destacado',
            Email__c = 'ti@opus.inc'
        );
        insert intermediacao;

         Proponentes__c proponente = new Proponentes__c(
        	Proposta_de_Vendas__c = proposta.Id,
            Name = 'New Name',
            E_mail__c = 'ti@opus.inc'
        );
        insert proponente;


        List<Id> propostas = new List<Id>();
        propostas.add(proposta.Id);

        List<Id> r = PropostaCadastroController.createContactsForProponentesAndIntermediacao(propostas);
        System.assert(r[0] == propostas[0]);
    }
    

}