public class ItauApiClientHttpCalloutMockImpl implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        // Crie uma nova resposta HTTP
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');

        // Use o switch para verificar a URL do callout e determinar qual resposta retornar
        String endpoint = req.getEndpoint();

        if(endpoint.contains('/api/jwt')) {
            res.setBody('{"access_token":"simulated_token"}');
            res.setStatusCode(200);
        } else if(endpoint.contains('/cash_management_ext_v2/v2/boletos')) {
            res.setBody('{"codigo_canal_operacao":"BKL","codigo_operador":"889911348","etapa_processo_boleto":"efetivacao","beneficiario":{"id_beneficiario":"150000052061","nome_cobranca":"MUNDI EMPRRENDIMENTOS E L ME","tipo_pessoa":{"codigo_tipo_pessoa":"J","numero_cadastro_nacional_pessoa_juridica":"08867659000151"},"endereco":{"nome_logradouro":"R PORTUGAL, 13, EDF T NOVO 1 AN","nome_bairro":"COMERCIO","nome_cidade":"SALVADOR","sigla_UF":"BA","numero_CEP":"40015000"}},"dado_boleto":{"descricao_instrumento_cobranca":"boleto","forma_envio":"impressao","tipo_boleto":"a vista","pagador":{"pessoa":{"nome_pessoa":"Nubibat","tipo_pessoa":{"codigo_tipo_pessoa":"F","numero_cadastro_pessoa_fisica":"05201005225"}},"endereco":{"nome_logradouro":"Av Hilario Pereira de Souza, 492","nome_bairro":" ","nome_cidade":"Osasco","sigla_UF":"SP","numero_CEP":"04131020"},"pagador_eletronico_DDA":false,"praca_protesto":true},"sacador_avalista":{"pessoa":{"nome_pessoa":"Sacador Teste","nome_fantasia":"Empresa A","tipo_pessoa":{"codigo_tipo_pessoa":"F","numero_cadastro_pessoa_fisica":"38365972840"}},"endereco":{"nome_logradouro":"Av do Estado, 55343","nome_bairro":"Ipiranga","nome_cidade":"São Paulo","sigla_UF":"SP","numero_CEP":"06120100"}},"codigo_carteira":"157","codigo_tipo_vencimento":3,"valor_total_titulo":"00000000000010001","dados_individuais_boleto":[{"id_boleto_individual":"8835353e-ecb5-43f8-adeb-4cbf796f6be4","numero_nosso_numero":"00001056","dac_titulo":"8","data_vencimento":"2021-06-01","valor_titulo":"00000000000010001","codigo_barras":"34192863800000100011570000105681500052061000","numero_linha_digitavel":"34191570070010568150600520610007286380000010001","data_limite_pagamento":"2031-06-01","lista_mensagens_cobranca":[]}],"codigo_especie":"01","data_emissao":"2021-05-25","pagamento_parcial":false,"quantidade_maximo_parcial":"0","lista_mensagem_cobranca":[{"mensagem":"jaime3 desconto fixo percentual"},{"mensagem":"teste2"}],"recebimento_divergente":{"codigo_tipo_autorizacao":"03","codigo_tipo_recebimento":"P","percentual_minimo":"00000000000000000","percentual_maximo":"00000000000000000"},"desconto_expresso":true}}');
            res.setStatusCode(200);
        } else {
            res.setBody('{"error":"unexpected endpoint"}');
            res.setStatusCode(400);
        }


        return res;
    }
}