public without sharing class PropostaCadastroController {
    @AuraEnabled
    public static Proposta_de_Vendas__c getPropostaById (Id propostaVendaId){
        try {
            Proposta_de_Vendas__c proposta =  [SELECT Name, 	
                                                    Nome_Unidade__c, 
                                                    Id,
                                                    Empreendimento__c, 
                                                    Bloco__c,
                                                    Bloco__r.Data_Previsao_de_Entrega__c,
                                                    Bloco__r.PV_Taxa_c__c,
                                                    Bloco__r.Name,
                                                    Nome_do_Empreendimento__c, 
                                                    Valor_de_Venda__c, 
                                                    Garagem__c, 
                                                    Valor_Tabela__c,
                                                    Tabela_da_Proposta__r.Name, 
                                                    Tabela_de_Vendas_Proposta__r.Name, 
                                                    Valor_da_Proposta__c ,
                                                    Unidade__r.Nome_do_bloco__c, 
                                                    Unidade__r.Name, 
                                                    Unidade__r.N_mero_de_vagas_de_garagem__c,
                                                    Tabela_da_Proposta__r.Chave_Tabela__c, 
                                                    Tabela_da_Proposta__r.Status__c, 
                                                    Tabela_da_Proposta__r.Tipo__c, 
                                                    Tabela_da_Proposta__r.Id,
                                               		Tabela_de_Vendas_Proposta__r.Valor_Climatiza_o__c,
                                                    Nome_do_Corretor__c, 
                                                    Gerente__c, 
                                                    Corretor__r.Imobiliaria__c,
                                                    Fase_da_Proposta__c,
                                                    Data_Entrega_Empreendimento__c,
                                                    Nome_do_Cliente__c,
                                                    CPF_do_Cliente__c,
                                                    E_mail_do_Cliente__c,
                                                    Telefone_do_Cliente__c,
                                                    Observacao_do_Cliente__c,
                                                    Empreendimento__r.Imagem_Empreendimento__c,
                                                    Numero_pasta_Facilita__c,
                                                    Comentarios_e_Clausulas__c,
                                                    Valor_da_Premiacao__c,
                                                    Perc_Comissao_Destacada__c,
                                                    Perc_Comissao_Faturada__c,
                                                    VPL_Proposta__c,
                                                    Variacao_VPL__c,
                                                    VPL_Tabela__c,
                                                    Percentual_Variacao_VPL__c,
                                                    Percentual_Captacao__c,
                                                    Empreendimento__r.Area_do_Terreno__c,
                                                    Valor_M2__c,
                                                    Valor_M2_Tabela__c,
                                                    Area_Privativa__c,
                                                    Pecentual_Variacao_Nominal__c,
                                                    Variacao_Nominal__c,
                                                    CreatedDate,
                                                    Corretor__r.E_mail_do_Gerente__c,
                                                    E_mail_do_Gerente__c,
                                               		Gerente_Empreendimento__c,
                                               		Gerente_Empreendimento_Email__c,
                                                    Codigo_Gerente__c,
                                                    Empreendimento__r.Data_do_Habite_se__c,
                                                    Empreendimento__r.Data_Previs_o_de_Entrega__c,
                                                    Empreendimento__r.Numero_Blocos__c,
                                                    Data_de_Entrega_do_Empreendimento__c,
                                                    Data_Limite_Aprovacao__c,
                                                    Status_Transferencia__c,
                                                    (SELECT Id, Unidade__r.Id, Unidade__r.Tipo_da_unidade__c, Unidade__r.Name, Unidade__r.N_mero_de_vagas_de_garagem__c, Unidade__r.Status_Secund_rio__c FROM Unidades_da_Proposta__r),
                                                    (SELECT Id, Item_Adicional__r.Id, Item_Adicional__r.Name, Item_Adicional__r.Valor__c FROM Itens_Adicionais_da_Proposta__r),
                                                    Possui_Valor_Climat__c,
                                                    Proponente_1__c, 
                                                    Proponente_2__c, 
                                                    Proponente_3__c, 
                                                    Proponente_4__c, 
                                                    Proponente_5__c,
                                                    Intermediacao_1__c, 
                                                    Intermediacao_2__c, 
                                                    Intermediacao_3__c, 
                                                    Intermediacao_4__c, 
                                                    Intermediacao_5__c
                                                    FROM Proposta_de_Vendas__c
                                                    WHERE Id =: propostaVendaId];
            
            return proposta;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Empreendimento__c getEmpreendimentoById(Id empreendimentoId){
        try {
            Empreendimento__c empreendimento =  [SELECT Name, 	
                                                    Id,
                                                    PV_Taxa__c
                                                    FROM Empreendimento__c
                                                    WHERE Id =: empreendimentoId];

            return empreendimento;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Condi_o_de_Pagamento__c> getCondicoesById(List<Id> ids){
        try {
            List<Condi_o_de_Pagamento__c> condicoes =  [SELECT Id, 	
                                                        Quantidade_de_parcelas__c,
                                                        In_cio_do_Vencimento__c,
                                                        Intervalo_das_Parcelas__c,
                                                        Valor_Total_das_Parcelas__c
                                                        FROM Condi_o_de_Pagamento__c
                                                        WHERE Id IN :ids];

            return condicoes;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    

    @AuraEnabled
    public static Proposta_de_Vendas__c updatePropostaVenda(String fields){
        try {
            Proposta_de_Vendas__c propostaVenda = (Proposta_de_Vendas__c) JSON.deserialize(fields,Proposta_de_Vendas__c.class);

            update propostaVenda;
            return propostaVenda;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Map<String,String>> getPickListOptions(String fieldName){
        Map<String, Schema.SObjectField> fieldsMap = Schema.SObjectType.Proposta_de_Vendas__c.fields.getMap();
        List<Map<String,String>> optionListMap = new  List<Map<String,String>>();
        Schema.SObjectField field = fieldsMap.get(fieldName);
        List<Schema.PicklistEntry> pickListEntries = field.getDescribe().getPicklistValues();
        
        for( Schema.PicklistEntry pickListEntry : pickListEntries){
            optionListMap.add(new Map<String,String> {'label' => pickListEntry.getLabel(),'value' => pickListEntry.getValue()});
        }  
        return optionListMap;
    }

    @AuraEnabled
    public static List<String> getContentVersion(String recordIds){
        Set<String> recordList = (Set<String>) JSON.deserialize(recordIds, Set<String>.class);
        try {
            List<ContentDocumentLink> contentDocumentLinks = [
                SELECT
                ContentDocumentId
                FROM ContentDocumentLink
                WHERE LinkedEntityId =: recordList
            ];
            
            Set<Id> contentDocumentIds = new Set<Id>();
            for(ContentDocumentLink contentDocumentLink: contentDocumentLinks){
                contentDocumentIds.add(contentDocumentLink.ContentDocumentId);
            }          
        
            List<ContentVersion> contentVersions = [
                SELECT 
                Id,
                FileType,
                FirstPublishLocationId,
                FirstPublishLocation.Name,
                VersionData 
                FROM 
                ContentVersion 
                WHERE FileType IN ('JPG','JPEG','PNG') AND ContentDocumentId =: contentDocumentIds];
            
            List<String> versionsData = new List<String>();
            for(contentVersion contentVersion : contentVersions){
                versionsData.add(EncodingUtil.base64Encode(contentVersion.VersionData));
            }

            return versionsData;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Condi_o_de_Pagamento__c> getPaymentConditionsByProposta(Id propostaVendaId){        
        try {
            List<Condi_o_de_Pagamento__c> condicoes = [
                SELECT 
                Id, 
                Name, 
                Proposta_de_Vendas__c,
                Periodicidade__c,
                Periodicidade_Condicao__c,
                Quantidade_de_parcelas__c,
                Correcao__c,
                In_cio_do_Vencimento__c,
                Valor_Total_Parcela__c,
                Valor_Total_das_Parcelas__c,
                Valor_Opus__c,
                Valor_Comissao__c,
                Proposta_de_Vendas__r.Fase_da_Proposta__c
                FROM Condi_o_de_Pagamento__c
                WHERE Proposta_de_Vendas__c =: propostaVendaId
                ORDER BY In_cio_do_Vencimento__c ASC
            ];

            return condicoes;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Condi_o_de_Pagamento__c> saveCondicoes(String condicoes){
       
        List<Condi_o_de_Pagamento__c> condicoesPagamentoLst = (List<Condi_o_de_Pagamento__c>) JSON.deserialize(condicoes,List<Condi_o_de_Pagamento__c>.class);
        Id propostaVendaId = condicoesPagamentoLst[0].Proposta_de_Vendas__c;

        System.debug(propostaVendaId);
        Proposta_de_Vendas__c propostaVenda = [SELECT Id,
                                                    Tabela_da_Proposta__c,
                                                    Fase_da_Proposta__c,
                                                    Valor_Comiss_o_Destacada__c,
                                                    Valor_Comiss_o_Faturada__c,
                                                    Valor_da_Proposta__c,
                                                (SELECT Id FROM Condicoes_de_Pagamento__r)
                                            FROM Proposta_de_Vendas__c
                                            WHERE Id =: propostaVendaId];

        if(
            propostaVenda.Fase_da_Proposta__c == 'Aprovação da Proposta' | 
            propostaVenda.Fase_da_Proposta__c == 'Proponentes e Intermediação' | 
            propostaVenda.Fase_da_Proposta__c == 'Confecção do Contrato' | 
            propostaVenda.Fase_da_Proposta__c == 'Contrato Elaborado'
         ) {
            throw new AuraHandledException('Nâo foi possível atualizar as condições de pagamento. Fase da Proposta: ' +  propostaVenda.Fase_da_Proposta__c);
        }
        
        List<Condi_o_de_Pagamento__c> oldCondicoesPagamentoLst = new List<Condi_o_de_Pagamento__c>();
        oldCondicoesPagamentoLst = propostaVenda.Condicoes_de_Pagamento__r;

        if(oldCondicoesPagamentoLst.size() > 0) {
            delete oldCondicoesPagamentoLst;
        }

        for(Condi_o_de_Pagamento__c cond : condicoesPagamentoLst) {
            cond.Tabela_de_Vendas__c = propostaVenda.Tabela_da_Proposta__c;
        }

        upsert condicoesPagamentoLst;

        Tabela_de_Vendas__c tabVendasProposta = [SELECT Id,
                                                    (SELECT Id FROM Fluxo_de_Pagamentos__r)
                                                FROM Tabela_de_Vendas__c
                                                WHERE Id =: propostaVenda.Tabela_da_Proposta__c];

        List<Fluxo_de_Pagamento__c> fluxoPagamentoList = new List<Fluxo_de_Pagamento__c>();
        fluxoPagamentoList = tabVendasProposta.Fluxo_de_Pagamentos__r;

        if(fluxoPagamentoList.size() > 0) {
            delete fluxoPagamentoList;
        }    

        Decimal valorVPL = calcFluxoPagamento(condicoesPagamentoLst, propostaVenda.Tabela_da_Proposta__c,'Proposta', 'VPL');
        Decimal valorProposta = calcFluxoPagamento(condicoesPagamentoLst, propostaVenda.Tabela_da_Proposta__c,'Proposta', 'Proposta');
        
        propostaVenda.VPL_Proposta__c = valorVPL;
        propostaVenda.Valor_da_Proposta__c = valorProposta;
        propostaVenda.Atualizar_Distribuicao_Comissao__c = true;
        propostaVenda = calcValoresTotais(propostaVenda);
        // PropostaDeVendasTriggerHandler triggerHandler = new PropostaDeVendasTriggerHandler(false, 0);
        // propostaVenda = triggerHandler.CalcValoresTotais(propostaVenda);
        // propostaVenda = triggerHandler.NumbersPropostaToText(propostaVenda);
        // propostaVenda = triggerHandler.NumbersPropostaToText(triggerHandler.CalcValoresTotais(propostaVenda));
        update propostaVenda;

        return condicoesPagamentoLst;
    
    }

    public static Proposta_de_Vendas__c calcValoresTotais(Proposta_de_Vendas__c propostaVenda) {

        propostaVenda.Valor_Total_Grupo_A__c = 0;
        propostaVenda.Valor_Total_Grupo_B__c = 0;
        propostaVenda.Valor_Total_Grupo_C__c = 0;
        propostaVenda.Percentual_Total_Grupo_A__c = 0;
        propostaVenda.Percentual_Total_Grupo_B__c = 0;
        propostaVenda.Percentual_Total_Grupo_C__c = 0;
        
        List<Condi_o_de_Pagamento__c> condicoesPagamentoLst = [SELECT Periodicidade_Condicao__c, Valor_Total_das_Parcelas__c, Status_do_Empreendimento__c FROM Condi_o_de_Pagamento__c WHERE Tabela_de_Vendas__c =: propostaVenda.Tabela_da_Proposta__c];
        for(Condi_o_de_Pagamento__c condPag : condicoesPagamentoLst) {
            if(condPag.Periodicidade_Condicao__c == 'Sinal') {
                propostaVenda.Valor_Total_Grupo_A__c += condPag.Valor_Total_das_Parcelas__c;
            } else if (condPag.Periodicidade_Condicao__c != 'Sinal' && condPag.Status_do_Empreendimento__c == 'Em construção') {
                propostaVenda.Valor_Total_Grupo_B__c += condPag.Valor_Total_das_Parcelas__c;
            } else if (condPag.Periodicidade_Condicao__c != 'Sinal' && condPag.Status_do_Empreendimento__c != 'Em construção') {
                propostaVenda.Valor_Total_Grupo_C__c += condPag.Valor_Total_das_Parcelas__c;
            }
        }
        
        if(propostaVenda.Valor_da_Proposta__c > 0) {
            propostaVenda.Percentual_Total_Grupo_A__c = propostaVenda.Valor_Total_Grupo_A__c * 100 / propostaVenda.Valor_da_Proposta__c;
            propostaVenda.Percentual_Total_Grupo_B__c = propostaVenda.Valor_Total_Grupo_B__c * 100 / propostaVenda.Valor_da_Proposta__c;
            propostaVenda.Percentual_Total_Grupo_C__c = propostaVenda.Valor_Total_Grupo_C__c * 100 / propostaVenda.Valor_da_Proposta__c;
        }

        return propostaVenda;
    }

    public static Decimal calcFluxoPagamento(List<Condi_o_de_Pagamento__c> condicoesPagamentoLst, Id tabelaPropostaId, String origemPagamento, String valorRetorno) {
        List<FluxoPagamentoCompare> listC = new List<FluxoPagamentoCompare>();
        
        for(Condi_o_de_Pagamento__c condPag : condicoesPagamentoLst) {
            if(condPag.Periodicidade_Condicao__c == 'Sinal' || condPag.Periodicidade_Condicao__c == 'Única' ||  condPag.Periodicidade_Condicao__c == 'Financiamento') {
                Fluxo_de_Pagamento__c flxPag = new Fluxo_de_Pagamento__c();
                
                flxPag.Data_Pagamento__c = condPag.In_cio_do_Vencimento__c;
                flxPag.Valor__c = condPag.Valor_Total_das_Parcelas__c;

                flxPag.Valor__c = condPag.Valor_Total_das_Parcelas__c;
                flxPag.Tabela_de_Vendas__c = tabelaPropostaId;
                flxPag.Origem_Fluxo_de_Pagamento__c = origemPagamento;

                listC.add(new FluxoPagamentoCompare(flxPag));
            } else if (condPag.Periodicidade_Condicao__c == 'Mensal'){
                for(Integer i = 0; i < condPag.Quantidade_de_parcelas__c; i++){
                    Fluxo_de_Pagamento__c flxPag = new Fluxo_de_Pagamento__c();
                    flxPag.Data_Pagamento__c = condPag.In_cio_do_Vencimento__c.addMonths(i);

                    flxPag.Valor__c = condPag.Valor_Total_das_Parcelas__c;
                    flxPag.Tabela_de_Vendas__c = tabelaPropostaId;
                    flxPag.Origem_Fluxo_de_Pagamento__c = origemPagamento;

                    listC.add(new FluxoPagamentoCompare(flxPag));
                }
            } else if (condPag.Periodicidade_Condicao__c == 'Semestral'){
                for(Integer i = 0; i < condPag.Quantidade_de_parcelas__c; i++){
                    Fluxo_de_Pagamento__c flxPag = new Fluxo_de_Pagamento__c();
                    flxPag.Data_Pagamento__c = condPag.In_cio_do_Vencimento__c.addMonths(i*6);

                    flxPag.Valor__c = condPag.Valor_Total_das_Parcelas__c;
                    
                    flxPag.Tabela_de_Vendas__c = tabelaPropostaId;
                    flxPag.Origem_Fluxo_de_Pagamento__c = origemPagamento;

                    listC.add(new FluxoPagamentoCompare(flxPag));
                }
            } else if (condPag.Periodicidade_Condicao__c == 'Anual'){
                for(Integer i = 0; i < condPag.Quantidade_de_parcelas__c; i++){
                    Fluxo_de_Pagamento__c flxPag = new Fluxo_de_Pagamento__c();
                    flxPag.Data_Pagamento__c = condPag.In_cio_do_Vencimento__c.addMonths(i*12);

                    flxPag.Valor__c = condPag.Valor_Total_das_Parcelas__c;

                    flxPag.Tabela_de_Vendas__c = tabelaPropostaId;
                    flxPag.Origem_Fluxo_de_Pagamento__c = origemPagamento;

                    listC.add(new FluxoPagamentoCompare(flxPag));
                }
            }
        }

        listC.sort();
        Map<Date, Fluxo_de_Pagamento__c> mapDataParcela = new Map<Date, Fluxo_de_Pagamento__c>();
        
        for(FluxoPagamentoCompare c : listC) {
            if (mapDataParcela.containsKey(c.flxPag.Data_Pagamento__c)) {
                mapDataParcela.get(c.flxPag.Data_Pagamento__c).Valor__c += c.flxPag.Valor__c;
            } else {
                mapDataParcela.put(c.flxPag.Data_Pagamento__c, c.flxPag);
            }
        }
        
        List<Fluxo_de_Pagamento__c> fluxoPagamentoLst = mapDataParcela.values();
        Integer count = 0;

        for(Fluxo_de_Pagamento__c flxPag : fluxoPagamentoLst) {
            flxPag.Ordem_Parcela__c = count++;
        }

        insert fluxoPagamentoLst;

        Set<Id> fpSetId = new Set<Id>();
        for(Fluxo_de_Pagamento__c fpValor : fluxoPagamentoLst) {
            fpSetId.add(fpValor.Id);
        }

        List<Fluxo_de_Pagamento__c> flxPagLst = [SELECT VPL_Parcela_Fluxo_2__c, Valor__c 
                                                FROM Fluxo_de_Pagamento__c
                                                WHERE Id IN: fpSetId];

        Decimal valorVpl = 0;
        Decimal valorProposta = 0;
        
        for(Fluxo_de_Pagamento__c flxPagValor : flxPagLst) {
            valorVpl += flxPagValor.VPL_Parcela_Fluxo_2__c > 0 ? flxPagValor.VPL_Parcela_Fluxo_2__c : 0;
            valorProposta += flxPagValor.Valor__c > 0 ? flxPagValor.Valor__c : 0;
        }
		
        if(valorRetorno == 'VPL') {
            return valorVpl;
        } else {
        	return valorProposta;    
        }
    }

    @AuraEnabled
    public static Decimal updateCondicaoDiscount(String condicao, String desconto){
        Decimal descontoDec = Decimal.valueOf(desconto);
        Id propVendasId = [SELECT Proposta_de_Vendas__c FROM Condi_o_de_Pagamento__c WHERE Id =:condicao].Proposta_de_Vendas__c;

        Proposta_de_Vendas__c propVendas = [SELECT VPL_Proposta__c,
                                                Tabela_da_Proposta__c,
                                                (SELECT Id, 
                                                        Periodicidade_Condicao__c,
                                                        In_cio_do_Vencimento__c,
                                                        Quantidade_de_parcelas__c,
                                                        Valor_Total_das_Parcelas__c 
                                                FROM Condicoes_de_Pagamento__r)
                                            FROM Proposta_de_Vendas__c 
                                            WHERE Id =: propVendasId];

        List<Condi_o_de_Pagamento__c> condicoesPagamentoLst = (List<Condi_o_de_Pagamento__c>)propVendas.Condicoes_de_Pagamento__r;

        for(Condi_o_de_Pagamento__c cond : condicoesPagamentoLst) {
            if(String.valueOf(cond.Id) == condicao && descontoDec > 0) {
                cond.Valor_Total_das_Parcelas__c = cond.Valor_Total_das_Parcelas__c - ((descontoDec / 100) * cond.Valor_Total_das_Parcelas__c);
            }
        }

        update condicoesPagamentoLst;

        Tabela_de_Vendas__c tabVendasProposta = [SELECT Id,
                                                (SELECT Id FROM Fluxo_de_Pagamentos__r)
                                                FROM Tabela_de_Vendas__c
                                                WHERE Id =: propVendas.Tabela_da_Proposta__c];

        List<Fluxo_de_Pagamento__c> fluxoPagamentoList = new List<Fluxo_de_Pagamento__c>();
        fluxoPagamentoList = tabVendasProposta.Fluxo_de_Pagamentos__r;

        if(fluxoPagamentoList.size() > 0) {
            delete fluxoPagamentoList;
        }

        Decimal valorVPL = calcFluxoPagamento(condicoesPagamentoLst, propVendas.Tabela_da_Proposta__c,'Proposta', 'VPL');
  		Decimal valorProposta = calcFluxoPagamento(condicoesPagamentoLst, propVendas.Tabela_da_Proposta__c,'Proposta', 'Proposta');
        
        propVendas.VPL_Proposta__c = valorVPL;
        propVendas.Valor_da_Proposta__c = valorProposta;
        update propVendas;

        return propVendas.VPL_Proposta__c;
    }

    @AuraEnabled
    public static List<Condi_o_de_Pagamento__c> getTabelaDeVendas(String propostaVendaId) {
        String tabelaId = [SELECT Tabela_de_Vendas_Proposta__c FROM Proposta_de_Vendas__c WHERE Id =:propostaVendaId].Tabela_de_Vendas_Proposta__c;

        return [SELECT Id, 
                        Name, 
                        Periodicidade_Condicao__c,
                        Quantidade_de_parcelas__c,
                        In_cio_do_Vencimento__c,
                        Valor_Total_das_Parcelas__c,
                        Valor_Total_Parcela__c,
                        Correcao__c
                FROM Condi_o_de_Pagamento__c 
                WHERE Tabela_de_Vendas__c =: tabelaId
                ORDER BY In_cio_do_Vencimento__c ASC
                ];
        
    }

    @AuraEnabled
    public static Decimal getClimatValueTabelaVenda(String propostaVendaId) {
        Proposta_de_Vendas__c tabelaVendas = [SELECT Tabela_de_Vendas_Proposta__r.Id, Tabela_de_Vendas_Proposta__r.Valor_Climatiza_o__c FROM Proposta_de_Vendas__c WHERE Id =:propostaVendaId];

        return tabelaVendas.Tabela_de_Vendas_Proposta__r.Valor_Climatiza_o__c;
        
    }

    @AuraEnabled
    public static Decimal getClimatValueTabelaProposta(String propostaVendaId) {
        Proposta_de_Vendas__c tabelaVendas = [SELECT Tabela_da_Proposta__r.Id, Tabela_da_Proposta__r.Valor_Climatiza_o__c FROM Proposta_de_Vendas__c WHERE Id =:propostaVendaId];

        return tabelaVendas.Tabela_da_Proposta__r.Valor_Climatiza_o__c;
        
    }

    @AuraEnabled
    public static Proposta_de_Vendas__c getValorTotal(String propostaVendaId) {
        Proposta_de_Vendas__c propvendas = [SELECT Valor_da_Proposta__c,
                                                Fase_da_Proposta__c 
                                            FROM Proposta_de_Vendas__c 
                                            WHERE Id =:propostaVendaId];

        return propvendas;
    }

    @AuraEnabled
    public static List<Proposta_de_Vendas__c> getPropostaByCorretor(Id corretorId){
        try {
            List<Proposta_de_Vendas__c> propostas =  [
                SELECT
                Name,                
                Id,
                Empreendimento__c, 
                Nome_do_Empreendimento__c, 
                Valor_de_Venda__c, 
                Garagem__c, 
                Valor_Tabela__c,
                Tabela_da_Proposta__r.Name, 
                Tabela_de_Vendas_Proposta__r.Name, 
                Valor_da_Proposta__c ,
                Nome_do_Corretor__c, 
                Gerente__c, 
                Corretor__r.Imobiliaria__c,
                Fase_da_Proposta__c,
                Data_Entrega_Empreendimento__c,
                Nome_do_Cliente__c,
                CPF_do_Cliente__c,
                E_mail_do_Cliente__c,
                Telefone_do_Cliente__c,
                Observacao_do_Cliente__c,
                Numero_pasta_Facilita__c,
                Comentarios_e_Clausulas__c,
                VPL_Proposta__c,
                Variacao_VPL__c,
                VPL_Tabela__c,
                Percentual_Variacao_VPL__c,
                Empreendimento__r.Area_do_Terreno__c,
                Valor_M2__c,
                Valor_M2_Tabela__c,
                Area_Privativa__c,
                Pecentual_Variacao_Nominal__c,
                Variacao_Nominal__c,
                E_mail_do_Gerente__c,
                (SELECT Id, Unidade__r.Id, Unidade__r.Tipo_da_unidade__c, Unidade__r.Name FROM Unidades_da_Proposta__r)
                FROM Proposta_de_Vendas__c
                WHERE Corretor__c =: corretorId AND Versao_PV__c = '2'               
            ];
            return propostas;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Proponentes__c> getProponentesByProposta(Id propostaVendaId){
        try {
            List<Proponentes__c> proponentes = [
                SELECT
                Celular__c,
                Celular_CJ__c,
                CNPJ__c,
                CPF__c,
                CPF_CJ__c,
                Data_de_Nascimento__c,
                Data_de_Nascimento_CJ__c,
                E_mail__c,
                E_mail_CJ__c,
                Endereco__c,
                Endereco_Comercial__c,
                Endereco_Residencial__c,
                Endereco_Residencial_CJ__c,
                Estado_Civil__c,
                Estado_Civil_CJ__c,
                Fase_da_Proposta__c,
                Nacionalidade__c,
                Nome_Completo_CJ__c,
                Name,
                Profissao__c,
                Profissao_CJ__c,
                Raz_o_Social__c,
                RG__c,
                RG_CJ__c,
                Telefone__c,
                Telefone_CJ__c,
                Telefone_Celular__c,
                Telefone_Comercial__c,
                Telefone_Residencial__c,
                Tipo_de_Uniao__c,
                Tipo_de_Uniao_CJ__c,
                Orgao_Expedidor__c,
                Orgao_Expedidor_CJ__c,
                RecordTypeId
                FROM Proponentes__c
                WHERE Proposta_de_Vendas__c =: propostaVendaId
            ];

            return proponentes;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    

    @AuraEnabled
    public static List<Intermediacao__c> getIntermediacaoByProposta(Id propostaVendaId){
        try {
            List<Intermediacao__c> intermediacoes = [
                SELECT
                Pessoa_Fisica__c,
                Porcentagem__c,
                Comissao_Destacada_Proposta__c,
                Comissao_Faturada_Proposta__c,
                CPF_CNPJ__c,
                CRECI__c,
                Email__c,
                Fase_da_Proposta__c,
                Name,
                Observacoes__c,
                Razao_Social__c,
                Telefone_para_Contato__c,
                Tipo__c,
                Tipo_de_Comissao__c,
                Valor__c
                FROM Intermediacao__c
                WHERE Proposta_de_Vendas__c =: propostaVendaId
            ];

            return intermediacoes;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Proponentes__c upsertProponentes(String fields){
        try {
            Proponentes__c proponente = (Proponentes__c) JSON.deserialize(fields,Proponentes__c.class);
            upsert proponente;
            return proponente;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Intermediacao__c upsertIntermediacao(String fields){
        try {
            Intermediacao__c intermediacao = (Intermediacao__c) JSON.deserialize(fields,Intermediacao__c.class);
            upsert intermediacao;
            return intermediacao;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Proponentes__c deleteProponenteById(Id proponenteId){
        try {
            Proponentes__c proponente = new Proponentes__c(
                Id = proponenteId
            );
            delete proponente;
            return proponente;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Intermediacao__c deleteIntermediacaoById(Id intermediacaoId){
        try {
            Intermediacao__c intermediacao = new Intermediacao__c(
                Id = intermediacaoId
            );
            delete intermediacao;
            return intermediacao;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Corretores__c getLoggedCorretor(Id corretorId){
        try {
            Corretores__c corretor = [
                SELECT 
                    Id,    
                    Name, 
                    Pin__c,
                    CPF__c,
                    Email__c,
                    Usuario_Master__c 
                FROM Corretores__c 
                WHERE Id = :corretorId
            ];
            return corretor;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Corretores__c isCorretorMaster(Id corretorId){
        try {
            Corretores__c corretor = [SELECT Name, Usuario_Master__c FROM Corretores__c WHERE Id =: corretorId AND Usuario_Master__c = true];
            return corretor;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Corretores__c> getCorretoresMaster(Id corretorId){
        try {
           return [
                SELECT 
                    Id, 
                    Name, 
                    CPF__c,
                    Usuario_Master__c
                FROM Corretores__c
                WHERE Usuario_Master__c = true AND Id != :corretorId
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Proposta_de_Vendas__c changeCorretorProposta(Id corretorId, Id propostaId, Id corretorSelectedId){
        try {
            Proposta_de_Vendas__c proposta = [SELECT Id, Name, Corretor__c FROM Proposta_de_Vendas__c WHERE Id =:propostaId];
            proposta.Corretor__c = corretorSelectedId;
            proposta.Corretor_Anterior__c = corretorId;
            update proposta;
            return proposta;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Proposta_de_Vendas__c changeUnidadeProposta(Id propostaId, String unidades, String garagens, String valorTotal, String areaTotal, Id blocoId) {
        try {
            Proposta_de_Vendas__c proposta = [SELECT 
                                                Id, 
                                                Name, 
                                                Corretor__c,
                                                Corretor_Anterior__c,
                                                Corretor_Criacao__c,
                                                Bloco__c,
                                                Bloco__r.Id,
                                                Bloco__r.Gerente_Comercial_Responsavel__c,
                                                Bloco__r.Gerente_Comercial_E_mail__c,
                                                Bloco__r.Utiliza_Tabela_Especial__c,
                                                Perc_Comissao_Destacada__c,
                                                Perc_Comissao_Faturada__c,
                                                Versao_PV__c,
                                                Comentarios_e_Clausulas__c,
                                                Nome_do_Cliente__c,
                                                E_mail_do_Cliente__c,
                                                CPF_do_Cliente__c,
                                                Observacao_do_Cliente__c,
                                                Telefone_do_Cliente__c,
                                                Numero_pasta_Facilita__c,
                                                Empreendimento__c
                                            FROM Proposta_de_Vendas__c WHERE Id =:propostaId];

            List<Map<String,String>> unidadeList = (List<Map<String,String>>) JSON.deserialize(unidades, List<Map<String,String>>.class);
            List<Map<String,String>> garagemList = (List<Map<String,String>>) JSON.deserialize(garagens, List<Map<String,String>>.class);

            Bloco__c bloco = [SELECT 
                                Gerente_Comercial_Responsavel__c, 
                                Gerente_Comercial_E_mail__c,
                                Utiliza_Tabela_Especial__c
                                               	FROM Bloco__c
                                               	WHERE Id = :blocoId];

            Proposta_de_Vendas__c cloneProp = proposta.clone(false, true);

            cloneProp.Corretor_Anterior__c = null;
            cloneProp.Corretor_Criacao__c = proposta.Corretor__c;
            cloneProp.Tabela_da_Proposta__c = null;
            cloneProp.Tabela_de_Vendas_Proposta__c = null;
            cloneProp.VPL_Tabela__c = null;
            cloneProp.Valor_Tabela__c = Decimal.valueOf(valorTotal);
            cloneProp.Area_Privativa__c = Decimal.valueOf(areaTotal);
            cloneProp.Gerente_Empreendimento__c = bloco.Gerente_Comercial_Responsavel__c;
            cloneProp.Gerente_Empreendimento_Email__c = bloco.Gerente_Comercial_E_mail__c;
            cloneProp.Perc_Comissao_Destacada__c = null;
            cloneProp.Perc_Comissao_Faturada__c = null;
            cloneProp.Bloco__c = blocoId;

            insert cloneProp;
            
            Tabela_de_Vendas__c tabVendasPadrao = [SELECT Id, Valor_Climatiza_o__c 
                                                    FROM Tabela_de_Vendas__c
                                                    WHERE Bloco__c = :blocoId
                                                    AND Status__c = 'Ativa'
                                                    AND Tipo__c = 'Tabela'];

            cloneProp = SelectPropertyController.createTabelasDeVenda(tabVendasPadrao,cloneProp,bloco,unidadeList, '');
            
            Tabela_de_Vendas__c newtabVendas = new Tabela_de_Vendas__c();
            newtabVendas.Tipo__c = 'Proposta';
            newtabVendas.Data_da_Tabela__c = date.today();
            newtabVendas.Proposta_de_Vendas__c = cloneProp.Id;
            insert newtabVendas;

            cloneProp.Tabela_da_Proposta__c = newtabVendas.Id;
            
            List<Unidade_da_Proposta__c> unidadesProposta = new List<Unidade_da_Proposta__c>();
            String unidadeProposta = '';
            for(Map<String,String> unidadeMap : unidadeList){
                unidadesProposta.add(new Unidade_da_Proposta__c(
                    Proposta_de_Vendas__c = cloneProp.Id,
                    Unidade__c = unidadeMap.get('Id')
                ));
                unidadeProposta += unidadeMap.get('label') + ', ';
            }
            for(Map<String,String> garagemMap : garagemList){
                unidadesProposta.add(new Unidade_da_Proposta__c(
                    Proposta_de_Vendas__c = cloneProp.Id,
                    Unidade__c = garagemMap.get('Id')
                ));
            }
            insert unidadesProposta;
            
            unidadeProposta = unidadeProposta.replaceFirst('..$', '') ;
            cloneProp.Nome_Unidades__c = unidadeProposta;

            update cloneProp;

            List<Condi_o_de_Pagamento__c> condicoesPagamentoLst = getPaymentConditionsByProposta(propostaId);

            List<Condi_o_de_Pagamento__c> cloneCondicoesPagamentoLst = condicoesPagamentoLst.deepClone(false, false, false);

            for(Condi_o_de_Pagamento__c cond : cloneCondicoesPagamentoLst) {
                cond.Tabela_de_Vendas__c = cloneProp.Tabela_da_Proposta__c;
                cond.Proposta_de_Vendas__c = cloneProp.Id;
            }

            upsert cloneCondicoesPagamentoLst;

            Tabela_de_Vendas__c tabVendasProposta = [SELECT Id,
                                                        (SELECT Id FROM Fluxo_de_Pagamentos__r)
                                                    FROM Tabela_de_Vendas__c
                                                    WHERE Id =: cloneProp.Tabela_da_Proposta__c];

            List<Fluxo_de_Pagamento__c> fluxoPagamentoList = new List<Fluxo_de_Pagamento__c>();
            fluxoPagamentoList = tabVendasProposta.Fluxo_de_Pagamentos__r;

            if(fluxoPagamentoList.size() > 0) {
                delete fluxoPagamentoList;
            }    

            Decimal valorVPL = calcFluxoPagamento(cloneCondicoesPagamentoLst, cloneProp.Tabela_da_Proposta__c,'Proposta', 'VPL');
            Decimal valorProposta = calcFluxoPagamento(cloneCondicoesPagamentoLst, cloneProp.Tabela_da_Proposta__c,'Proposta', 'Proposta');
            
            cloneProp.VPL_Proposta__c = valorVPL;
            cloneProp.Valor_da_Proposta__c = valorProposta;
            cloneProp.Atualizar_Distribuicao_Comissao__c = true;
            
            List<Intermediacao__c> intermediacoes = getIntermediacaoByProposta(propostaId);
            List<Proponentes__c> proponentes = getProponentesByProposta(propostaId);
            
            List<Intermediacao__c> cloneIntermediacao = intermediacoes.deepClone(false, false, false);
            List<Proponentes__c> cloneProponentes = proponentes.deepClone(false, false, false);
            
            for(Intermediacao__c inter : cloneIntermediacao) {
                inter.Proposta_de_Vendas__c = cloneProp.Id;
            }
            
            for(Proponentes__c prop : cloneProponentes) {
                prop.Proposta_de_Vendas__c = cloneProp.Id;
            }
            
            upsert cloneIntermediacao;
            upsert cloneProponentes;
            
            cloneProp.Perc_Comissao_Destacada__c = proposta.Perc_Comissao_Destacada__c;
            cloneProp.Perc_Comissao_Faturada__c = proposta.Perc_Comissao_Faturada__c;
            update cloneProp;
            
            return cloneProp;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    class FluxoPagamentoCompare implements Comparable {

        public Fluxo_de_Pagamento__c flxPag;
        
        public FluxoPagamentoCompare(Fluxo_de_Pagamento__c flx) {
            flxPag = flx;
        }
        
        // Compare opportunities based on the opportunity amount.
        public Integer compareTo(Object compareTo) {
            FluxoPagamentoCompare compareToObj = (FluxoPagamentoCompare)compareTo;
            
            // The return value of 0 indicates that both elements are equal.
            Integer returnValue = 0;
            if (compareToObj.flxPag.Data_Pagamento__c > flxPag.Data_Pagamento__c) {
                returnValue = -1;
            } else if (compareToObj.flxPag.Data_Pagamento__c < flxPag.Data_Pagamento__c) {
                returnValue = 1;
            }      
            return returnValue;       
        }
    }

    @InvocableMethod(label='Criar contatos dos proponentes e intermediação' description='Cria contatos a partir dos proponentes e intermediação')
    public static List<Id> createContactsForProponentesAndIntermediacao(List<Id> recordId) {
        List<Contact> contatos = new List<Contact>();
        List<Contact> contatosProponentes = PropostaCadastroController.createContactsForProponentes(recordId.get(0));
        List<Contact> contatosIntermediacao = PropostaCadastroController.createContactsForIntermediacao(recordId.get(0));

        // contatos.addAll(contatosIntermediacao);
        // contatos.addAll(contatosProponentes);
        // return contatos;
        return recordId;
    }

    public static List<Contact> createContactsForProponentes(String propostaVendasId) {
        Map<Integer, String> fieldNames = new Map<Integer, String>();
        fieldNames.put(1, 'Proponente_1__c');
        fieldNames.put(2, 'Proponente_2__c');
        fieldNames.put(3, 'Proponente_3__c');
        fieldNames.put(4, 'Proponente_4__c');
        fieldNames.put(5, 'Proponente_5__c');    
        List<Contact> contatos = new List<Contact>();
        
        Proposta_de_Vendas__c propostaVendas = PropostaCadastroController.getPropostaById(propostaVendasId);
        List<Proponentes__c> proponentes = PropostaCadastroController.getProponentesByProposta(propostaVendasId);
        
        for(Proponentes__c proponente : proponentes) {
            List<Contact> contatos_proponente = [
                SELECT 
                    Id, 
                    LastName, 
                    Email, 
                    Id_Proponente__c 
                FROM Contact Where Id_Proponente__c =: proponente.Id
            ];
            if(contatos_proponente.size() > 0) {

                for(Contact contato : contatos_proponente) {
                    if(contato.Email == proponente.E_mail__c && contato.Lastname == proponente.Name) {
                        contato.Email = proponente.E_mail__c;
                        contato.Lastname = proponente.Name;
                    }
                    
                    if(contato.Email == proponente.E_mail_CJ__c && contato.Lastname == proponente.Nome_Completo_CJ__c) {
                        contato.Email = proponente.E_mail_CJ__c;
                        contato.Lastname = proponente.Nome_Completo_CJ__c;
                    }
                }

                contatos.addAll(contatos_proponente);
            } else {
                Contact contato_principal  = new Contact(
                    Email = proponente.E_mail__c,
                    Lastname = proponente.Name,
                    Id_Proponente__c = proponente.Id
                );
                
                contatos.add(contato_principal);
                
                if(proponente.RecordTypeId == '0124A000001IuzJQAS' && proponente.Estado_Civil__c == 'Casado' && (proponente.Tipo_de_Uniao__c == 'Comunhão Universal de Bens' || proponente.Tipo_de_Uniao__c == 'Comunhão Parcial de Bens')) {
                    Contact contato_conjuge  = new Contact(
                        Email = proponente.E_mail_CJ__c,
                        Lastname = proponente.Nome_Completo_CJ__c,
                        Id_Proponente__c = proponente.Id
                    );
                    contatos.add(contato_conjuge);
                }
            }
        }

        upsert contatos;

        for(Contact contato : contatos) {
            String proponenteKey = PropostaCadastroController.findFieldOnProposta(contato.Id, propostaVendas, fieldNames);
    
            if(proponenteKey != null & proponenteKey != '') {
                propostaVendas.put(proponenteKey, contato.Id);
            } else {
                proponenteKey = PropostaCadastroController.findFieldOnProposta(null, propostaVendas, fieldNames);
                if(proponenteKey != null) {
                    propostaVendas.put(proponenteKey, contato.Id);
                }
            }
        }

        update propostaVendas;

        return contatos;
    }

    public static List<Contact> createContactsForIntermediacao(String propostaVendasId) {
        Map<Integer, String> fieldNames = new Map<Integer, String>();
        fieldNames.put(1, 'Intermediacao_1__c');
        fieldNames.put(2, 'Intermediacao_2__c');
        fieldNames.put(3, 'Intermediacao_3__c');
        fieldNames.put(4, 'Intermediacao_4__c');
        fieldNames.put(5, 'Intermediacao_5__c');  
        List<Contact> contatos = new List<Contact>();
        
        Proposta_de_Vendas__c propostaVendas = PropostaCadastroController.getPropostaById(propostaVendasId);
        List<Intermediacao__c> intermediadores = PropostaCadastroController.getIntermediacaoByProposta(propostaVendasId);
        
        for(Intermediacao__c intermediacao : intermediadores) {
            if(intermediacao.Tipo_de_Comissao__c == 'Destacado') {
                List<Contact> contatos_intermediacao = [
                    SELECT 
                        Id, 
                        LastName, 
                        Email, 
                        Id_Intermediacao__c 
                    FROM Contact Where Id_Intermediacao__c =: intermediacao.Id
                ];
                if(contatos_intermediacao.size() > 0) {
                    for(Contact contato : contatos_intermediacao) {
                        if(contato.Email == intermediacao.Email__c && contato.Lastname == intermediacao.Name) {
                            contato.Email = intermediacao.Email__c;
                            contato.Lastname = intermediacao.Name;
                        }
                    }

                    contatos.addAll(contatos_intermediacao);
                } else {
                    Contact contato_principal  = new Contact(
                        Email = intermediacao.Email__c,
                        Lastname = intermediacao.Name,
                        Id_Intermediacao__c = intermediacao.Id
                    );
                    
                    contatos.add(contato_principal);
                }
            }
        }

        if(contatos.size() > 0) {
            upsert contatos;
    
            for(Contact contato : contatos) {
                String intermediacaoKey = PropostaCadastroController.findFieldOnProposta(contato.Id, propostaVendas, fieldNames);
        
                if(intermediacaoKey != null & intermediacaoKey != '') {
                    propostaVendas.put(intermediacaoKey, contato.Id);
                } else {
                    intermediacaoKey = PropostaCadastroController.findFieldOnProposta(null, propostaVendas, fieldNames);
                    if(intermediacaoKey != null) {
                        propostaVendas.put(intermediacaoKey, contato.Id);
                    }
                }
            }
            update propostaVendas;
        }

        return contatos;

    }

    public static String findFieldOnProposta(Id contatoId, Proposta_de_Vendas__c propostaVenda, Map<Integer, String> fieldNames) {
        String objectKey = null;
        for (Integer key : fieldNames.keySet()) {
            Id objectId = (Id)propostaVenda.get(fieldNames.get(key));
            if(objectId == contatoId) {
                objectKey = fieldNames.get(key);
                break;
            }
        }
        return objectKey;
    }

    public class recordInfo {
        @InvocableVariable
        public String recordId;
    }
    
}