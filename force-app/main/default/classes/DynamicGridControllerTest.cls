@isTest
public with sharing class DynamicGridControllerTest {
    @TestSetup
 private static void testSetup(){
        Empreendimento__c empreendimento = new Empreendimento__c(
            Name='Empire State',
            Data_de_lan_amento__c = date.today(),
            Mostra_PV__c = 'Sim'
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
            Bloco__c = blocos[0].Id
        );
        insert tabelaVendasTab;

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

        Corretores__c corretores = new Corretores__c(Name='Corretor1',Origem__c='Salesforce');
        insert corretores;

        ContentVersion contentVersion = new ContentVersion(
            ContentLocation = 'S', 
            PathOnClient = 'image.jpeg', 
            Title = 'image test',
            VersionData = Blob.valueOf('Teste')
        ); 
        insert contentVersion;

        ContentVersion contentVersionInserted = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id];

        ContentDocumentLink contentDocumentLink = new ContentDocumentLink(
            LinkedEntityId = empreendimento.Id, 
            ContentDocumentId = contentVersionInserted.ContentDocumentId,  
            shareType = 'I'
        ); 
        insert contentDocumentLink;

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
        
    }

    @isTest 
    public static void testGrid(){
        Empreendimento__c empreendimento = [SELECT Id FROM Empreendimento__c WHERE Name = 'Empire State'];
        
        Bloco__c bloco = [SELECT Id FROM Bloco__c WHERE Name = 'Bloco 1'];
        
        Corretores__c corretores = [SELECT Id FROM Corretores__c WHERE Name = 'Corretor1'];
        Tipologia__c tipologia = [SELECT Id FROM Tipologia__c WHERE Name = 'Tipologia Final 1'];
        
        List<Unidade__c> garagens = SelectPropertyController.getGaragensByEmpreendimento(empreendimento.Id);
        List<Map<String,String>> garagensListMap = new List<Map<String,String>>();
        garagensListMap.add(new Map<String,String>{'Id'=> String.valueOf(garagens[0].Id)});

        List<Unidade__c> unidades = SelectPropertyController.getUnidadesByEmpreendimento(bloco.Id, corretores.Id, tipologia.Id);
        List<Map<String,String>> unidadesListMap = new List<Map<String,String>>();
        unidadesListMap.add(new Map<String,String>{'Id'=> String.valueOf(unidades[0].Id), 'label'=> String.valueOf(unidades[0].Name)});

        List<Proposta_de_Vendas__c> listaProposta = new List<Proposta_de_Vendas__c>();

        Proposta_de_Vendas__c proposta1 = SelectPropertyController.saveProposal(
            corretores.Id,
            empreendimento.Id,
            bloco.Id,
            JSON.serialize(unidadesListMap),
            JSON.serialize(garagensListMap),
            '',
            '598374.48376',
            '100.8347'
        );

        listaProposta.add(proposta1);

        Proposta_de_Vendas__c proposta2 = SelectPropertyController.saveProposal(
            corretores.Id,
            empreendimento.Id,
            bloco.Id,
            JSON.serialize(unidadesListMap),
            JSON.serialize(garagensListMap),
            '',
            '6546',
            '54.12'
        );

        listaProposta.add(proposta2);

        String sObjectName = 'Account';
        String fieldsNames = 'Name,PersonBirthdate,CreatedDate,PersonMobilePhone,NumberOfEmployees,AnnualRevenue';
        String whereCondition = 'Name = \'Test\'';
        String adicionalConditions = '';
        String searchValue = 'test';
        Integer pagenumber = 1;
        Integer pagesize = 10;
        List<String> ids = new List<String>();

        for(Proposta_de_Vendas__c proposta : listaProposta){
            ids.add(proposta.Id);
        }

        test.startTest();
        DynamicGridController.getData(sObjectName, fieldsNames, whereCondition, adicionalConditions, searchValue, pagesize, pagenumber);
        DynamicGridController.getRecordListCount(sObjectName ,whereCondition, searchValue, pagenumber);
        DynamicGridController.getColumns(sObjectName, fieldsNames);
        DynamicGridController.deleteData(ids);
        DynamicGridController.deleteOne(ids[0]);
        test.stopTest();
    }
}