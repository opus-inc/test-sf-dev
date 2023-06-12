@isTest
private class PagamentoAvulsoControllerTest {
    
    @TestSetup
    static void testSetup() {
        // Crie o registro de Conta
        Account conta = new Account(
            FirstName = 'nome',
            LastName = 'sobrenome',
            Email__c = 'nomesobrenome@email.com'
        );
        insert conta;
        
        // Crie o registro de Empreendimento
        Empreendimento__c empreendimento = new Empreendimento__c(
            Name = 'Rosa dos Ventos',
            Data_de_lan_amento__c = date.today(),
            Razao_social__c = 'spe',
            CNPJ__c = '50.188.082/0001-18'
        );
        insert empreendimento;

        // Crie o registro de Unidade
        Unidade__c unidade = new Unidade__c(
            Name = 'UN-1', 
            Empreendimento__c=empreendimento.Id,
            Mostra_PV__c = 'Sim',
            Tipo_da_unidade__c = 'Unidade',
            Status_Secund_rio__c = 'Disponível',
            Total_Mensais__c = 1000,
            Total_Pre_Chaves__c = 1000,
            Total_Semestrais__c = 1000,
            Total_Sinais__c = 1000
        );        
        insert unidade;

        // Crie o registro de Contrato
        Contrato_Mega__c contrato = new Contrato_Mega__c(
            Conta__c = conta.Id,
            Unidade__c = unidade.Id,
            Name = '1080'
        );
        insert contrato;

        // Crie o registro de Parcela
        List<Parcela_Mega__c> parcelas = new List<Parcela_Mega__c>();
        for (Integer i = 0; i < 4; i++) {
            Parcela_Mega__c parc = new Parcela_Mega__c(
                Contrato_Mega__c = contrato.Id,
                Valor__c = 10 * (i+1),
                Data_Vencimento__c = Date.today(),
                Contrato__c = '1080'
            );
            parcelas.add(parc);
        }
        insert parcelas;
    }

    @isTest
    static void testGetParcelaByContrato() {
        List<Contrato_Mega__c> testContratos = [SELECT Id FROM Contrato_Mega__c];
        List<Id> contratosIdTest = new List<Id>();
        for(Contrato_Mega__c contrato : testContratos) {
            contratosIdTest.add(contrato.Id);
        }

        Test.startTest();
        List<Parcela_Mega__c> result = PagamentoAvulsoController.getParcelaByContrato(contratosIdTest);
        Test.stopTest();

        System.assertNotEquals(null, result, 'O resultado não deve ser nulo');
        System.assertNotEquals(0, result.size(), 'O resultado não deve ser vazio');
    }

    @isTest
    static void testGetEmpreendimentosByConta() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        List<AggregateResult> result;
        try {
            result = PagamentoAvulsoController.getEmpreendimentosByConta(testAccount.Id);
        } catch (AuraHandledException e) {
            System.assertEquals('Ocorreu um erro', e.getMessage(), 'A mensagem da exceção não é a esperada');
        }
        Test.stopTest();

        System.assertNotEquals(null, result, 'O resultado não deve ser nulo');
    }
}