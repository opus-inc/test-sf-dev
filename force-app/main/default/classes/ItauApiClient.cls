/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Helper para criação do pagamento avulso, emitindo um Boleto OU Pix no Itaú
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author       João Vitor Borges dos Santos   <joto.x42@gmail.com>
* @version      1.0
* @created      2023-05-08
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

public class ItauApiClient {
    private static String BASE_URL = 'https://devportal.itau.com.br';
    private String clientId;
    private String clientSecret;
    private String jwt;
    private String regex = '[a-zA-Z]|\\-|\\.|\\/';

    public ItauApiClient(String clientId, String clientSecret) {
        this.clientId = clientId;
        this.clientSecret = clientSecret;
        obtainJwt();
    }

    private void obtainJwt() {
        String url = BASE_URL + '/api/jwt';
        String method = 'POST';
        Map<String, String> headers = new Map<String, String>{'Content-Type' => 'application/json'};
        Map<String, String> params = null;
        String payload = JSON.serialize(new Map<String, String>{
            'client_id' => this.clientId,
            'client_secret' => this.clientSecret
        });

        String jsonResponse = HttpRequestHelper.makeHttpRequest(url, method, headers, params, payload);

        System.debug(jsonResponse);
        if (jsonResponse != null) {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
            this.jwt = (String) responseMap.get('access_token');
        } else {
            System.debug('Não foi possível obter o JWT.');
        }
    }

    @future(callout=true)
    public static void makeHttpRequestAsync(String endpoint, String method, String jsonPayload, String jwt, String pagamentoAvulsoId, String boletoId, String pixId, String tipoPagamento, List<String> parcelasIds, String clienteId, String empreendimentoId) {
        String url = BASE_URL + '/sandboxapi' + endpoint;
        Map<String, String> headers = new Map<String, String>{
            'Content-Type' => 'application/json',
            'x-sandbox-token' => jwt
        };
        Map<String, String> params = new Map<String, String>();
        System.debug(jsonPayload);

        String jsonResponse = HttpRequestHelper.makeHttpRequest(url, method, headers, params, jsonPayload);

        processJsonResponse(jsonPayload, jsonResponse, pagamentoAvulsoId, boletoId, pixId, tipoPagamento, parcelasIds, clienteId, empreendimentoId);
    }

    public static void processJsonResponse(String jsonPayload, String jsonResponse, String pagamentoAvulsoId, String boletoId, String pixId, String tipoPagamento, List<String> parcelasIds, String clienteId, String empreendimentoId) {
        Pagamento_Avulso_Boleto__c boleto;
        Pagamento_Avulso__c pagamentoAvulso = new Pagamento_Avulso__c(
            Id = pagamentoAvulsoId
        ); 

        if (jsonResponse != null) {
            //  Writeback
            
            Map<String, Object> payloadMap = (Map<String, Object>) JSON.deserializeUntyped(jsonPayload);
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
            if(tipoPagamento == 'Boleto') {

                List<Object> dadosBoletoPayload = (List<Object>)((Map<String, Object>)payloadMap.get('dado_boleto')).get('dados_individuais_boleto');
                List<String> instrucoesBoleto = new List<String>();

                for (Object mensagem : (List<Object>)((Map<String, Object>)dadosBoletoPayload[0]).get('mensagens_cobranca')) {
                    instrucoesBoleto.add((String)((Map<String, Object>)mensagem).get('mensagem'));
                }

                List<Object> dadosBoleto = (List<Object>)((Map<String, Object>)responseMap.get('dado_boleto')).get('dados_individuais_boleto');

                boleto = new Pagamento_Avulso_Boleto__c(
                    Id = boletoId,
                    Id_Boleto__c = (String)((Map<String, Object>)dadosBoleto[0]).get('id_boleto'),
                    Linha_Digitavel__c = (String)((Map<String, Object>)dadosBoleto[0]).get('numero_linha_digitavel'),
                    Codigo_de_Barras__c = (String)((Map<String, Object>)dadosBoleto[0]).get('codigo_barras'),
                    Instrucoes__c = String.join(instrucoesBoleto, '<br>')
                );
                upsert boleto;
                
            } else if(tipoPagamento == 'Pix') {
                Pagamento_Avulso_Pix__c pix = new Pagamento_Avulso_Pix__c(
                    Id = pixId,
                    Id_Pix__c = (String) responseMap.get('id_pix')
                );
                upsert pix;
            }

            pagamentoAvulso.Status_Api__c = 'Concluído';
            pagamentoAvulso.Resposta_Api__c = jsonResponse;
            pagamentoAvulso.Cliente__c = clienteId;
            pagamentoAvulso.Empreendimento__c = empreendimentoId;
        } else {
            pagamentoAvulso.Status_Api__c = 'Erro';
        }

        List<Parcela_Pagamento_Avulso__c> parcelas = new List<Parcela_Pagamento_Avulso__c>();

        for (String parcId: parcelasIds) {
            Parcela_Pagamento_Avulso__c relacParcPag = new Parcela_Pagamento_Avulso__c(
                Pagamento_Avulso__c = pagamentoAvulsoId,
                Parcela_do_Contrato__c = parcId
            );
            parcelas.add(relacParcPag);
        }

        insert parcelas;
        upsert pagamentoAvulso;

        if(tipoPagamento == 'Boleto') {
            PDFQueueable pdfQueueable = new PDFQueueable(new List<Id>(), 'Pagamento_Avulso_Boleto__c');
            pdfQueueable.setPagamentoAvulsoBoletoVariables(boleto, pagamentoAvulso);
            System.enqueueJob(pdfQueueable);
            //generateAndSavePDF(boleto, pagamentoAvulso);
        }
    }
    
    public static void generateAndSavePDF(Pagamento_Avulso_Boleto__c boleto, Pagamento_Avulso__c pagamentoAvulso) {
        PageReference pg = Page.ItauBoletoPDF;
        pg.getParameters().put('pagamentoAvulsoId', boleto.Id);

        Blob pdf1;
        try {
            pdf1 = pg.getContentAsPDF();
        }
        catch (Exception e) {
            System.debug('generateAndSavePDF>>> Erro ao gerar Blob da página.');
            pdf1 = Blob.valueOf(e.getMessage());
        }

        //Insere o arquivo na lista a ser inserida
        ContentVersion cv = new ContentVersion();
        cv.Title = pagamentoAvulso.Name + '_' + boleto.Name + '.pdf';
        cv.PathOnClient = pagamentoAvulso.Name + '_' + boleto.Name + '.pdf';
        cv.VersionData = pdf1;
        insert cv;

        cv = [SELECT Id, ContentDocumentId, Title FROM ContentVersion WHERE Id =:cv.Id];

        ContentDocumentLink cdl = new ContentDocumentLink();
        //Busca ContentDocumentId do ContentVersion cujo ID é o mesmo que o ContentVersion no mapeamento mapParcelaContVersion na chave Parcela corrente(loopIdParcelas).
        cdl.ContentDocumentId = cv.ContentDocumentId;
        cdl.LinkedEntityId = boleto.Id;
        cdl.ShareType = 'V';
        insert cdl;

        ContentDistribution conDis = new ContentDistribution();
        conDis.Name = cv.Title;
        conDis.ContentVersionId = cv.Id;
        conDis.PreferencesAllowViewInBrowser = true;
        conDis.PreferencesAllowPDFDownload = true;
        conDis.PreferencesPasswordRequired = false;
        //conDis.Password = mapParcCpf.get(loopIdParcelas);
        insert conDis;

        conDis = [SELECT Id, ContentVersionId, DistributionPublicUrl FROM ContentDistribution WHERE Id =:conDis.Id];
        boleto.Link_do_Boleto__c = conDis.DistributionPublicUrl;

        update boleto;
    }

    private Integer random7DigitNumber() {
        Integer max = (Integer)Math.pow(10, 7) - 1; // 10^7 - 1 = 9.999.999
        Integer min = (Integer)Math.pow(10, 6); // 10^6 = 1.000.000
        Integer randomNumber = Math.floor(Math.random() * (max - min + 1) + min).intValue();
        return randomNumber;
    }

    private Date ultimoDiaUtilDoMes(Date data) {
        Integer mes = data.month();
        Date ultimoDiaDoMes;

        if (mes == 12) {
            // Último dia do ano
            ultimoDiaDoMes = Date.newInstance(data.year(), 12, 31);
        } else {
            // Último dia do mês
            ultimoDiaDoMes = data.toStartOfMonth().addMonths(1).addDays(-1);
        }

        
        Datetime ultimoDiaDoMesDatetime = Datetime.newInstance(ultimoDiaDoMes.year(), ultimoDiaDoMes.month(),ultimoDiaDoMes.day(),0,0,0);

        // Verifica o dia da semana do último dia do mês ou ano
        String diaDaSemana = ultimoDiaDoMesDatetime.format('E');

        // Ajusta a data para o último dia útil, se necessário
        if (diaDaSemana == 'Sat') {
            ultimoDiaDoMes = ultimoDiaDoMes.addDays(-1);
        } else if (diaDaSemana == 'Sun') {
            ultimoDiaDoMes = ultimoDiaDoMes.addDays(-2);
        }

        return ultimoDiaDoMes;
    }

    private List<Map<String, Object>> getListMapMensagensCobranca(Parcela_Mega__c contrato, List<Parcela_Mega__c> parcelas, Double valorTotal, Date dataVencimento) {
        List<Map<String, Object>> listMapMensagensCobranca = new List<Map<String, Object>>();

        List<String> nomeUnidades = new List<String>();
        for (Parcela_Mega__c parc : parcelas) {
            nomeUnidades.add(parc.Contrato_Mega__r.Unidade__r.Name);
        }

        List<String> nomeParcelas = new List<String>();
        for (Parcela_Mega__c parc : parcelas) {
            nomeParcelas.add(parc.Name);
        }
        
        listMapMensagensCobranca.add(new Map<String, String>{'mensagem' => 'Empreendimento: ' + contrato.Contrato_Mega__r.Unidade__r.Empreendimento__r.Name});
        
        listMapMensagensCobranca.add(new Map<String, String>{'mensagem' => 'Bloco: ' + contrato.Contrato_Mega__r.Unidade__r.Bloco__r.Name});
        
        listMapMensagensCobranca.add(new Map<String, String>{'mensagem' => 'Unidade: ' + String.join(nomeUnidades, ', ')});
        
        listMapMensagensCobranca.add(new Map<String, String>{'mensagem' => 'Contrato: ' + contrato.Contrato_Mega__r.Name + ' - Referente a parcela: ' + String.join(nomeParcelas, ', ')});
        
        listMapMensagensCobranca.add(new Map<String, String>{'mensagem' => 'APÓS O VENCIMENTO COBRAR MORA DE R$ ............... ' + String.valueOf((valorTotal * 0.00033).setScale(2)) +' AO DIA'});
        Datetime dataVencimentoDatetime = Datetime.newInstance(dataVencimento.year(), dataVencimento.month(),dataVencimento.day(),0,0,0);
        
        listMapMensagensCobranca.add(new Map<String, String>{'mensagem' => 'APÓS ' + dataVencimentoDatetime.format('dd/MM/YYYY') + ' MULTA:....................................... R$ ' + String.valueOf((valorTotal * 0.02).setScale(2))});
        
        listMapMensagensCobranca.add(new Map<String, String>{'mensagem' => 'RECEBER ATE O ULTIMO DIA DO MES DE VENCIMENTO'});
        
        listMapMensagensCobranca.add(new Map<String, String>{'mensagem' => 'COBRANCA ESCRITURAL.'});

        System.debug(listMapMensagensCobranca);
        return listMapMensagensCobranca;
    }

    public Map<String, Object> montaPayloadBoleto(Account cliente, Parcela_Mega__c contrato, Date dataVencimento, List<String> listMensagensCobranca, Double valorTotal, List<Parcela_Mega__c> parcelas) {
        Map<String, Object> payload = new Map<String, Object>();
        payload.put('etapa_processo_boleto', 'efetivacao');
        
        Map<String, Object> beneficiaro = new Map<String, Object>();

        String agencia =  contrato.Contrato_Mega__r.Unidade__r.Empreendimento__r.Conta_Bancaria__r.Agencia__c;
        String conta =  contrato.Contrato_Mega__r.Unidade__r.Empreendimento__r.Conta_Bancaria__r.Conta__c;
        conta = conta.replaceAll(this.regex, '');

        while (conta.length() < 7) {
            conta = '0' + conta;
        }

        beneficiaro.put('id_beneficiario', agencia + conta);
        beneficiaro.put('nome_cobranca', contrato.Contrato_Mega__r.Unidade__r.Empreendimento__r.Razao_social__c);

        Map<String,String> tipoPessoaBeneficiario = new Map<String,String>();
        tipoPessoaBeneficiario.put('codigo_tipo_pessoa', 'J');
        tipoPessoaBeneficiario.put('numero_cadastro_nacional_pessoa_juridica', contrato.Contrato_Mega__r.Unidade__r.Empreendimento__r.CNPJ__c.replaceAll(this.regex, ''));

        // Map<String,String> enderecoBeneficiario = new Map<String,String>();
        // enderecoBeneficiario.put('nome_logradouro', '');
        // enderecoBeneficiario.put('nome_bairro', '');
        // enderecoBeneficiario.put('nome_cidade', '');
        // enderecoBeneficiario.put('sigla_UF', '');
        // enderecoBeneficiario.put('numero_CEP', '');

        beneficiaro.put('tipo_pessoa', tipoPessoaBeneficiario);
        // beneficiaro.put('endereco', enderecoBeneficiario);

        payload.put('beneficiaro', beneficiaro);

        Map<String, Object> dadoBoleto = new Map<String, Object>();
        dadoBoleto.put('tipo_boleto', 'a vista');
        dadoBoleto.put('forma_envio', 'digital');
        dadoBoleto.put('codigo_especie', '95');
        dadoBoleto.put('pagamento_parcial', false);
        dadoBoleto.put('codigo_carteira', '109');

        Map<String, Object> pagador = new Map<String, Object>();

        Map<String, Object> pessoaPagador = new Map<String, Object>();
        Map<String, Object> pagadorTipoPessoa = new Map<String, Object>();

        if(cliente.Tipo_de_pessoa__c == 'Física') {
            pessoaPagador.put('nome_pessoa', cliente.FirstName + ' ' + cliente.LastName);
            pagadorTipoPessoa.put('codigo_tipo_pessoa', 'F');
            pagadorTipoPessoa.put('numero_cadastro_pessoa_fisica', cliente.CPF_CNPJ_numeros__c);
        } else {
            pessoaPagador.put('nome_fantasia', cliente.Name);
            pessoaPagador.put('nome_pessoa', cliente.Representante_Legal__c);
            pagadorTipoPessoa.put('codigo_tipo_pessoa', 'J');
            pagadorTipoPessoa.put('numero_cadastro_nacional_pessoa_juridica', cliente.CPF_CNPJ_numeros__c);
        }
        pessoaPagador.put('tipo_pessoa', pagadorTipoPessoa);
        pagador.put('pessoa', pessoaPagador);
        dadoBoleto.put('pagador', pagador);

        
        List<Map<String, Object>> listMapDadosIndividuaisBoleto = new List<Map<String, Object>>();
        Map<String, Object> dadosIndividuaisBoleto = new Map<String, Object>();
        Datetime dataVencimentoDatetime = Datetime.newInstance(dataVencimento.year(), dataVencimento.month(),dataVencimento.day(),0,0,0);
        dadosIndividuaisBoleto.put('data_vencimento', dataVencimentoDatetime.format('YYYY-MM-dd'));
        dadosIndividuaisBoleto.put('valor_titulo', String.valueOf(valorTotal));
        dadosIndividuaisBoleto.put('desconto_expresso', false);
        dadosIndividuaisBoleto.put('numero_nosso_numero', String.valueOf(this.random7DigitNumber()));   //  Nosso número é obrigatório para carteira 109.
        Datetime ultimoDiaUtilDoMesDatetime = Datetime.newInstance(this.ultimoDiaUtilDoMes(dataVencimento).year(), this.ultimoDiaUtilDoMes(dataVencimento).month(),this.ultimoDiaUtilDoMes(dataVencimento).day(),0,0,0);
        dadosIndividuaisBoleto.put('data_limite_pagamento', ultimoDiaUtilDoMesDatetime.format('YYYY-MM-dd'));
        
        dadosIndividuaisBoleto.put('mensagens_cobranca', this.getListMapMensagensCobranca(contrato, parcelas, valorTotal, dataVencimento));

        listMapDadosIndividuaisBoleto.add(dadosIndividuaisBoleto);
        dadoBoleto.put('dados_individuais_boleto', listMapDadosIndividuaisBoleto);

        Map<String, Object> boletoJuros = new Map<String, Object>();
        boletoJuros.put('codigo_tipo_juros', '91');
        boletoJuros.put('percentual_juros', '0.033');
        dadoBoleto.put('juros', boletoJuros);

        Map<String, Object> boletoMulta = new Map<String, Object>();
        boletoMulta.put('codigo_tipo_multa', '01');
        boletoMulta.put('valor_multa', String.valueOf((valorTotal * 0.02).setScale(2)));
        dadoBoleto.put('multa', boletoMulta);

        Map<String, Object> boletoDesconto = new Map<String, Object>();
        boletoDesconto.put('codigo_tipo_desconto', '00');
        dadoBoleto.put('desconto', boletoDesconto);

        Map<String, Object> boletoRecebimentoDivergente = new Map<String, Object>();
        boletoRecebimentoDivergente.put('codigo_tipo_autorizacao', '03');
        dadoBoleto.put('recebimento_divergente', boletoRecebimentoDivergente);
        
        payload.put('dado_boleto', dadoBoleto);

        Map<String, Object> acoesPermitidas = new Map<String, Object>();
        acoesPermitidas.put('emitir_segunda_via', false);
        acoesPermitidas.put('comandar_instrucao_alterar_dados_cobranca', false);

        payload.put('acoes_permitidas', acoesPermitidas);

        return payload;
    }

    public static Pagamento_Avulso__c emitePagamentoAvulso(Date dataVencimento, String tipoPagamento, String clienteId, String contratoId, List<String> parcelasIds) {
        List<Parcela_Pagamento_Avulso__c> parcelasPagamento = new List<Parcela_Pagamento_Avulso__c>();
        Double valor = 0;

        List<Parcela_Mega__c> parcelas = [
            SELECT 
                Id, 
                Name, 
                Valor__c,
                Contrato_Mega__r.Id, 
                Contrato_Mega__r.Name, 
                Contrato_Mega__r.Unidade__r.Name,
                Contrato_Mega__r.Unidade__r.Bloco__r.Id,
                Contrato_Mega__r.Unidade__r.Bloco__r.Name, 
                Contrato_Mega__r.Unidade__r.Empreendimento__r.Id,
                Contrato_Mega__r.Unidade__r.Empreendimento__r.Name, 
                Contrato_Mega__r.Unidade__r.Empreendimento__r.Razao_social__c, 
                Contrato_Mega__r.Unidade__r.Empreendimento__r.CNPJ__c, 
                Contrato_Mega__r.Unidade__r.Empreendimento__r.Endere_o__c,
                Contrato_Mega__r.Unidade__r.Empreendimento__r.Conta_Bancaria__r.Agencia__c, 
                Contrato_Mega__r.Unidade__r.Empreendimento__r.Conta_Bancaria__r.Conta__c, 
                Contrato_Mega__r.Unidade__r.Empreendimento__r.Conta_Bancaria__r.client_id__c, 
                Contrato_Mega__r.Unidade__r.Empreendimento__r.Conta_Bancaria__r.client_secret__c
            FROM Parcela_Mega__c 
            WHERE Id IN :parcelasIds
        ];

        System.debug(parcelas);

        Parcela_Mega__c dadosContrato = parcelas[0]; 

        Account cliente = [SELECT Id, Name, FirstName, LastName, Representante_Legal__c, CPF_CNPJ_numeros__c, Tipo_de_pessoa__c FROM Account WHERE Id =:clienteId];

        ItauApiClient apiClient = new ItauApiClient(
            dadosContrato.Contrato_Mega__r.Unidade__r.Empreendimento__r.Conta_Bancaria__r.client_id__c, 
            dadosContrato.Contrato_Mega__r.Unidade__r.Empreendimento__r.Conta_Bancaria__r.client_secret__c
        );

        Pagamento_Avulso__c pagamentoAvulso = new Pagamento_Avulso__c(
            Status_Api__c = 'Pendente'
        );

        insert pagamentoAvulso;

        for(Parcela_Mega__c parc : parcelas) {
            valor += parc.Valor__c;
            Parcela_Pagamento_Avulso__c parcelaPagamento = new Parcela_Pagamento_Avulso__c(
                Pagamento_Avulso__c = pagamentoAvulso.Id,
                Parcela_do_Contrato__c = parc.Id
            );
        }

        Map<String, Object> payload;
        String endpoint = '';
        
        Pagamento_Avulso_Boleto__c boleto = new Pagamento_Avulso_Boleto__c();
        Pagamento_Avulso_Pix__c pix = new Pagamento_Avulso_Pix__c();

        if(tipoPagamento == 'Boleto') {
            boleto.Valor__c = valor;
            boleto.Data_de_vencimento__c = dataVencimento;
            boleto.Juros__c = 0;
            boleto.Multa__c = 0;
            boleto.Pagamento_Avulso__c = pagamentoAvulso.Id;
            insert boleto;
            endpoint = '/cash_management_ext_v2/v2/boletos';
            List<String> mensagensCobranca = new List<String>();
            payload = apiClient.montaPayloadBoleto(cliente, dadosContrato, dataVencimento, mensagensCobranca, valor, parcelas);

        } else if(tipoPagamento == 'Pix') {
            pix.Valor__c = valor;
            pix.Pagamento_Avulso__c = pagamentoAvulso.Id;
            insert pix;
            endpoint = '/emitir/pix';
            payload.put('calendario', new Map<String, String>{'expiracao' => ''});
            payload.put('valor', new Map<String, String>{'original' => ''});
            payload.put('devedor', new Map<String, String>{'cpnj' => '', 'nome' => ''});
            payload.put('chave', '');
        }

        String jsonPayload = JSON.serialize(payload);

        ItauApiClient.makeHttpRequestAsync(endpoint, 'POST', jsonPayload, apiClient.jwt, pagamentoAvulso.Id, boleto.Id, pix.Id, tipoPagamento, parcelasIds, clienteId, dadosContrato.Contrato_Mega__r.Unidade__r.Empreendimento__r.Id);

        return pagamentoAvulso;
    }
    
    @InvocableMethod(label='Emite um método de pagamento para pagamento avulso' description='Recebe payload, client_id e client_secret e faz a requisição HTTP.')
    public static List<Pagamento_Avulso__c> emitirPagamentoWrapper(List<RequestPayload> requests) {
        List<Pagamento_Avulso__c> result = new List<Pagamento_Avulso__c>();

        for (RequestPayload request : requests) {
            Pagamento_Avulso__c pagamentoAvulso = ItauApiClient.emitePagamentoAvulso(
                request.dataVencimento,
                request.tipoPagamento,
                request.clienteId,
                request.contratoId,
                request.parcelasIds.split(';')
            );
            result.add(pagamentoAvulso);
        }

        return result;
    }

    public class RequestPayload {
        @InvocableVariable(label='Data de Vencimento' required=true)
        public Date dataVencimento;

        @InvocableVariable(label='Tipo do Pagamento' required=true)
        public String tipoPagamento;

        @InvocableVariable(label='ID da Conta do Cliente' required=true)
        public String clienteId; // ID

        @InvocableVariable(label='ID do Contrato' required=true)
        public String contratoId; // RECEBE O CONTRATO --  // ID

        @InvocableVariable(label='IDs das Parcelas' required=true)
        public String parcelasIds;  // LIST<ID>
    }
}