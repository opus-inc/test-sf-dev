@isTest
public class ItauApiClientTest {

    @TestSetup
    private static void testSetup(){
        Account conta = new Account(
            FirstName = 'nome',
            LastName = 'sobrenome',
            Email__c = 'nomesobrenome@email.com'
        );
        insert conta;

        Conta_Bancaria__c contaBancaria = new Conta_Bancaria__c(
            Agencia__c = '44445', 
            Conta__c = '84554-5',
            Carteira__c = '109'
        );
        insert contaBancaria;

        Empreendimento__c empreendimento = new Empreendimento__c(
            Name = 'Rosa dos Ventos',
            Data_de_lan_amento__c = date.today(),
            Conta_Bancaria__c = contaBancaria.Id,
            Razao_social__c = 'spe',
            CNPJ__c = '50.188.082/0001-18'
        );
        insert empreendimento;

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

        Contrato_Mega__c contrato = new Contrato_Mega__c(
            Conta__c = conta.Id,
            Unidade__c = unidade.Id,
            Name = '1080'
        );
        insert contrato;

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
    static void testEmitirPagamentoWrapper() {
        // Define test data
        Date dataVencimento = Date.today();
        String tipoPagamento = 'Boleto';
        String clienteId = [SELECT Id FROM Account LIMIT 1].Id; 
        String contratoId = [SELECT Id FROM Contrato_Mega__c LIMIT 1].Id; 
        List<String> parcelasIds = new List<String>();
        
        for (Parcela_Mega__c parcela : [SELECT Id, Contrato_Mega__r.Name FROM Parcela_Mega__c]) {
            parcelasIds.add(parcela.Id); 
        }
        
        // Create a test RequestPayload
        ItauApiClient.RequestPayload request = new ItauApiClient.RequestPayload();
        request.dataVencimento = dataVencimento;
        request.tipoPagamento = tipoPagamento;
        request.clienteId = clienteId;
        request.contratoId = contratoId;
        request.parcelasIds = String.join(parcelasIds, ';');
        
        // Add the request to a list
        List<ItauApiClient.RequestPayload> requests = new List<ItauApiClient.RequestPayload>{ request };
        
        // Configure o mock para simular respostas HTTP
        Test.setMock(HttpCalloutMock.class, new ItauApiClientHttpCalloutMockImpl());

        // Run the invocable method
        Test.startTest();
        List<Pagamento_Avulso__c> result = ItauApiClient.emitirPagamentoWrapper(requests);
        Test.stopTest();
        
        // Add assertions to verify the result
        System.assertEquals(1, result.size(), 'Expected one Pagamento_Avulso__c record');
        // Add more assertions as needed
    }

    @isTest
    static void testMakeHttpRequest() {
        String url = 'https://devportal.itau.com.br/api/jwt';
        String method = 'POST';
        Map<String, String> headers = new Map<String, String>{'Content-Type' => 'application/json'};
        Map<String, String> params = new Map<String, String>{'param1' => 'val1', 'param2' => 'val2'};
        String payload = JSON.serialize(new Map<String, String>{
            'field1' => 'value1',
            'field2' => 'value2'
        });

        Test.setMock(HttpCalloutMock.class, new ItauApiClientHttpCalloutMockImpl());

        Test.startTest();
        String jsonResponse = HttpRequestHelper.makeHttpRequest(url, method, headers, params, payload);
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
        Test.stopTest();

        System.assertEquals(responseMap.get('access_token'), 'simulated_token');

    }


}