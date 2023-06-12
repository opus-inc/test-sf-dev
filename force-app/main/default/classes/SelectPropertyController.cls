public without sharing class SelectPropertyController {

    @AuraEnabled
    public static List<Bloco__c> getEmpreendimentos(Id corretorId){
        try {

            List<Corretores_Lancamento__c> blocosCorretor = new List<Corretores_Lancamento__c>();
            blocosCorretor = [
                SELECT
                    Id,
                    Bloco__c
                FROM Corretores_Lancamento__c 
                WHERE Corretor__c = :corretorId AND Bloco__r.Disponivel_no_PV__c = 'Não'
                ORDER BY Bloco__r.Empreendimento__r.Name ASC
            ];
            
            List<Bloco__c> blocos = new List<Bloco__c>();

            blocos = [
                SELECT 
                Id,
                Name,
                Info_Card__c,
                Utiliza_Garagem_Combo__c,
                Limitar_por_Tipologia__c,
                Empreendimento__r.Id,
                Empreendimento__r.Name,
                Empreendimento__r.Imagem_Empreendimento__c,
                Empreendimento__r.Numero_Blocos__c,
                (SELECT Id FROM Tabelas_de_Vendas__r WHERE Status__c = 'Ativa' AND Tipo__c = 'Tabela')
                FROM Bloco__c
                WHERE Disponivel_no_PV__c = 'Sim'
                ORDER BY Empreendimento__r.Name ASC
            ];

            if(!blocosCorretor.isEmpty()) {
                for(Corretores_Lancamento__c blocoCorretor : blocosCorretor){
                    Bloco__c bloco = [
                        SELECT 
                            Id,
                            Name,
                            Info_Card__c,
                            Utiliza_Garagem_Combo__c,
                            Limitar_por_Tipologia__c,
                            Empreendimento__r.Id,
                            Empreendimento__r.Name,
                            Empreendimento__r.Imagem_Empreendimento__c,
                            Empreendimento__r.Numero_Blocos__c,
                            (SELECT Id FROM Tabelas_de_Vendas__r WHERE Status__c = 'Ativa' AND Tipo__c = 'Tabela')
                        FROM Bloco__c
                        WHERE Id = :blocoCorretor.Bloco__c                        
                    ];
                    blocos.add(bloco);
                }
            }
           
            return blocos;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Bloco__c> getBlocosByEmpreendimento(Id empreendimentoId, Id corretorId){
        try {
            List<Corretores_Lancamento__c> blocosCorretor = new List<Corretores_Lancamento__c>();
            blocosCorretor = [
                SELECT
                    Id,
                    Bloco__c
                FROM Corretores_Lancamento__c 
                WHERE Corretor__c = :corretorId AND Bloco__r.Disponivel_no_PV__c = 'Não'
                ORDER BY Bloco__r.Empreendimento__r.Name ASC
            ];
            
            List<Bloco__c> blocos = new List<Bloco__c>();

            blocos = [
                SELECT 
                Id,
                Name,
                Info_Card__c,
                Utiliza_Garagem_Combo__c,
                Limitar_por_Tipologia__c,
                Empreendimento__r.Id,
                Empreendimento__r.Name,
                Empreendimento__r.Imagem_Empreendimento__c,
                Empreendimento__r.Numero_Blocos__c,
                (SELECT Id FROM Tabelas_de_Vendas__r WHERE Status__c = 'Ativa' AND Tipo__c = 'Tabela')
                FROM Bloco__c
                WHERE Disponivel_no_PV__c = 'Sim' AND Empreendimento__c =: empreendimentoId
                ORDER BY Empreendimento__r.Name ASC
            ];

            if(!blocosCorretor.isEmpty()) {
                for(Corretores_Lancamento__c blocoCorretor : blocosCorretor){
                    Bloco__c bloco = [
                        SELECT 
                            Id,
                            Name,
                            Info_Card__c,
                            Utiliza_Garagem_Combo__c,
                            Limitar_por_Tipologia__c,
                            Empreendimento__r.Id,
                            Empreendimento__r.Name,
                            Empreendimento__r.Imagem_Empreendimento__c,
                            Empreendimento__r.Numero_Blocos__c,
                            (SELECT Id FROM Tabelas_de_Vendas__r WHERE Status__c = 'Ativa' AND Tipo__c = 'Tabela')
                        FROM Bloco__c
                        WHERE Id = :blocoCorretor.Bloco__c                        
                    ];
                    blocos.add(bloco);
                }
            }
            
            return blocos;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Tipologia__c> getTipologiaByEmpreendimento(Id blocoId) {
        try {
            List<Tipologia__c> tipologias = new List<Tipologia__c>();

            tipologias = [
                SELECT 
                Id,
                Name,
                Valor_Descontado_na_Garagem__c
                FROM Tipologia__c 
                WHERE Bloco__c =: blocoId
                ORDER BY Name ASC
            ];

            return tipologias  ;    
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Unidade__c> getUnidadesByEmpreendimento(Id blocoId, Id corretorId, Id tipologiaId) {
        try {
            List<Unidade__c> unidades = new List<Unidade__c>();
            Corretores__c corretor = new Corretores__c(Usuario_Master__c=false);
            
            if(corretorId != null || corretorId != '') {
                corretor = [SELECT Usuario_Master__c FROM Corretores__c WHERE Id =: corretorId];
            }

            String whereClause = '';

            if(corretor.Usuario_Master__c) {
                whereClause += ' AND (Status_Secund_rio__c = \'Disponível\' OR Status_Secund_rio__c = \'Reserva Técnica\' OR Status_Secund_rio__c = \'Reserva Negociação\')';
            } else {
                whereClause += ' AND Status_Secund_rio__c = \'Disponível\' ';
            }

            if(tipologiaId != null) {
                whereClause += 'AND Tipologia__c = \''+ tipologiaId +'\'';
            }

            String query = 'SELECT Id, Name, Valor_de_Venda__c, Area_total__c, Area_comum__c, Area_privada__c, Status_Secund_rio__c, Valor_de_tabela__c, N_mero_de_vagas_de_garagem__c FROM Unidade__c WHERE Bloco__c = \''+ blocoId +'\' AND Mostra_PV__c = \'Sim\' AND Tipo_da_unidade__c = \'Unidade\' ' +  whereClause + ' ORDER BY Name ASC';

            unidades = Database.query(query);
            return unidades;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Tipologia_Garagens__c> getGaragensByEmpreendimentoAndTipologia(Id empreendimentoId, Id tipologiaId) {
        try {
            List<Tipologia_Garagens__c> garagens = new List<Tipologia_Garagens__c>();
                garagens = [
                    SELECT 
                        Unidade_Garagem__r.Id,
                        Unidade_Garagem__r.Name,
                        Unidade_Garagem__r.Valor_de_Venda__c,
                        Unidade_Garagem__r.Area_total__c, 
                        Unidade_Garagem__r.Area_comum__c, 
                        Unidade_Garagem__r.Area_privada__c,
                        Unidade_Garagem__r.Valor_de_tabela__c,
                        Unidade_Garagem__r.ImagemUnidade__c,
                        Unidade_Garagem__r.Garagem_Tipo__c
                    FROM Tipologia_Garagens__c 
                    WHERE 
                            Tipologia__c =: tipologiaId
                        AND Unidade_Garagem__r.Empreendimento__c =: empreendimentoId 
                        AND Unidade_Garagem__r.Mostra_PV__c = 'Sim'
                        AND Unidade_Garagem__r.Tipo_da_unidade__c = 'Garagem'
                        AND Unidade_Garagem__r.Status_Secund_rio__c = 'Disponível'
                    ORDER BY Name ASC
                ];
                return garagens;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Unidade__c> getGaragensByEmpreendimento(Id empreendimentoId){
        try {            
            List<Unidade__c> garagens = new List<Unidade__c>();

            garagens = [
                SELECT 
                Id,
                Name,
                Valor_de_Venda__c,
                Area_total__c, 
                Area_comum__c, 
                Area_privada__c,
                Valor_de_tabela__c,
                ImagemUnidade__c,
                Garagem_Tipo__c
                FROM Unidade__c 
                WHERE Empreendimento__c =: empreendimentoId 
                AND Mostra_PV__c = 'Sim'
                AND Tipo_da_unidade__c = 'Garagem'
                AND Status_Secund_rio__c = 'Disponível'
                ORDER BY Name ASC
            ];
            return garagens;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Item_Adicional__c> getAditionalItensByEmpreendimento(Id empreendimentoId){        
        try {
            List<Item_Adicional__c> itensAdicionais = [
                SELECT 
                Id, 
                Name, 
                Empreendimento__c,
                Final_da_Unidade__c,
                Valor__c                
                FROM Item_Adicional__c
                WHERE 
                    Bloco__c =: empreendimentoId
                AND Status__c =: 'Ativo'
                ORDER BY Name ASC
            ];

            return itensAdicionais;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Proposta_de_Vendas__c saveProposal(String corretorId, String empreendimentoId, String blocoId, String unidades, String garagens, String itensAdicionais, String valorTotal, String areaTotal){        
        // try {
            List<Map<String,String>> unidadeList = (List<Map<String,String>>) JSON.deserialize(unidades, List<Map<String,String>>.class);
            List<Map<String,String>> garagemList = (List<Map<String,String>>) JSON.deserialize(garagens, List<Map<String,String>>.class);

            Tabela_de_Vendas__c tabVendasPadrao = [SELECT Id, Valor_Climatiza_o__c
                                                    FROM Tabela_de_Vendas__c 
                                                    WHERE Bloco__c = :blocoId
                                                    AND Status__c = 'Ativa'
                                                    AND Tipo__c = 'Tabela'];
            Bloco__c bloco = [SELECT 
                                Gerente_Comercial_Responsavel__c, 
                                Gerente_Comercial_E_mail__c,
                                Utiliza_Tabela_Especial__c
                                               	FROM Bloco__c
                                               	WHERE Id = :blocoId];

            Proposta_de_Vendas__c proposta = new Proposta_de_Vendas__c(
                Corretor__c = corretorId,
                Corretor_Criacao__c = corretorId,
                Empreendimento__c = empreendimentoId,
                Bloco__c = blocoId,
                Fase_da_Proposta__c = 'Simulação',
                Valor_da_Proposta__c = 0,
                Valor_Tabela__c = Decimal.valueOf(valorTotal),
                Gerente_Empreendimento__c = bloco.Gerente_Comercial_Responsavel__c,
				Gerente_Empreendimento_Email__c = bloco.Gerente_Comercial_E_mail__c,
                Area_Privativa__c = Decimal.valueOf(areaTotal),
                Versao_PV__c = '2'
            );

            insert proposta;

            proposta = createTabelasDeVenda(tabVendasPadrao,proposta,bloco,unidadeList,itensAdicionais);
            

            Tabela_de_Vendas__c newtabVendas = new Tabela_de_Vendas__c();
            newtabVendas.Tipo__c = 'Proposta';
            newtabVendas.Data_da_Tabela__c = date.today();
            newtabVendas.Proposta_de_Vendas__c = proposta.Id;
            insert newtabVendas;

            proposta.Tabela_da_Proposta__c = newtabVendas.Id;
            update proposta;

            List<Unidade_da_Proposta__c> unidadesProposta = new List<Unidade_da_Proposta__c>();

            String unidadeProposta = '';
            for(Map<String,String> unidadeMap : unidadeList){
                unidadesProposta.add(new Unidade_da_Proposta__c(
                    Proposta_de_Vendas__c = proposta.Id,
                    Unidade__c = unidadeMap.get('Id')
                ));
                unidadeProposta += unidadeMap.get('label') + ', ';
            }
            
            for(Map<String,String> garagemMap : garagemList){
                unidadesProposta.add(new Unidade_da_Proposta__c(
                    Proposta_de_Vendas__c = proposta.Id,
                    Unidade__c = garagemMap.get('Id')
                ));
            }

            insert unidadesProposta;

            unidadeProposta = unidadeProposta.replaceFirst('..$', '') ;
            proposta.Nome_Unidades__c = unidadeProposta;
            proposta.Data_Entrega_Empreendimento__c = proposta.Data_de_Entrega_do_Empreendimento__c;
            
            update proposta;
            
            return proposta;
        // } catch (Exception e) {
            // throw new AuraHandledException(e.getMessage());
        // }
    }

    public static Proposta_de_Vendas__c createTabelasDeVenda(Tabela_de_Vendas__c tabelaPadraoEmpreendimento, Proposta_de_Vendas__c proposta, Bloco__c bloco, List<Map<String,String>> unidadeList, String itensAdicionais){
        Tabela_de_Vendas__c tabelaPadraoProposta = new Tabela_de_Vendas__c(
            Tipo__c = 'Tabela',
            Data_da_Tabela__c = date.today(),
            Proposta_de_Vendas__c = proposta.Id,
            Valor_Climatiza_o__c = tabelaPadraoEmpreendimento.Valor_Climatiza_o__c
        );           
        insert tabelaPadraoProposta;
        
        //proposta.Tabela_de_Vendas_Proposta__c = tabelaPadraoProposta.Id;
        //update proposta;
        
        
        List<Condi_o_de_Pagamento__c> condicoesTabelaEmpreendimento = new List<Condi_o_de_Pagamento__c>();
        condicoesTabelaEmpreendimento = [
            SELECT Id,
            Periodicidade_Condicao__c,
            Total_das_Parcelas__c,
            Quantidade_de_parcelas__c,
            Intervalo_das_Parcelas__c,
            In_cio_do_Vencimento__c,
            Ano_Inicio_Parcela__c,
            Correcao__c,
            Exibicao_condicao__c 
            FROM Condi_o_de_Pagamento__c 
            WHERE Tabela_de_Vendas__c =: tabelaPadraoEmpreendimento.Id
        ];
        
        List<Item_Adicional_da_Proposta__c> itensAdicionalProposta = new List<Item_Adicional_da_Proposta__c>();
        Decimal valorItensAdicionais = 0;

        if(!String.isBlank(itensAdicionais)) {
            List<Map<String,String>> itemAdicionalList = (List<Map<String,String>>) JSON.deserialize(itensAdicionais, List<Map<String,String>>.class);

            for(Map<String,String> itemAdicionalMap : itemAdicionalList){
                itensAdicionalProposta.add(new Item_Adicional_da_Proposta__c(
                    Proposta_de_Vendas__c = proposta.Id,
                    Item_Adicional__c = itemAdicionalMap.get('Id'),
                    Valor__c = Decimal.valueOf(String.valueOf(itemAdicionalMap.get('Valor')))
                ));
                valorItensAdicionais += Decimal.valueOf(String.valueOf(itemAdicionalMap.get('Valor')));
            }

            insert itensAdicionalProposta;
        }

        List<Condi_o_de_Pagamento__c> condicoesNovas = new List<Condi_o_de_Pagamento__c>();

        
        if(bloco.Utiliza_Tabela_Especial__c == 'Sim') {
            Set<Id> unidadesId = new Set<Id>{};

            for(Map<String,String> unidadeMap : unidadeList){
                unidadesId.add(unidadeMap.get('Id'));
            }

            List<Unidade__c> unidadesSelecionadas = [SELECT Id, 
                                                            Name,
                                                            Total_Mensais__c,
                                                            Total_Pre_Chaves__c,
                                                            Total_Semestrais__c,
                                                            Total_Sinais__c
                                                     FROM Unidade__c
                                                     WHERE Id IN :unidadesId];

            Unidade__c valoresSomadosUnidade = new Unidade__c(Total_Mensais__c=0,
                                                        Total_Pre_Chaves__c=0,
                                                        Total_Semestrais__c=0,
                                                        Total_Sinais__c=0
                                                      );

            for(Unidade__c un : unidadesSelecionadas) {
                valoresSomadosUnidade.Total_Mensais__c += un.Total_Mensais__c;
                valoresSomadosUnidade.Total_Pre_Chaves__c += un.Total_Pre_Chaves__c;
                valoresSomadosUnidade.Total_Semestrais__c += un.Total_Semestrais__c;
                valoresSomadosUnidade.Total_Sinais__c += un.Total_Sinais__c;
            }

            Decimal valorSinais = 0;
            Decimal valorMensais = 0;
            Decimal valorSemestrais = 0;
            Decimal valorUnica = 0;
            Decimal valorFinanciamento = 0;

            Condi_o_de_Pagamento__c condicaoFinanciamento = new Condi_o_de_Pagamento__c();

            for(Condi_o_de_Pagamento__c condicao : condicoesTabelaEmpreendimento) {
                switch on condicao.Periodicidade_Condicao__c {
                    when 'Sinal' {
                        valorSinais += (valoresSomadosUnidade.Total_Sinais__c / 3).setScale(2);
                        Condi_o_de_Pagamento__c newCondicao = new Condi_o_de_Pagamento__c(
                            Tabela_de_Vendas__c = tabelaPadraoProposta.Id,
                            Periodicidade_Condicao__c = condicao.Periodicidade_Condicao__c,
                            Total_das_Parcelas__c = condicao.Total_das_Parcelas__c,
                            Quantidade_de_parcelas__c = condicao.Quantidade_de_parcelas__c,
                            In_cio_do_Vencimento__c = condicao.In_cio_do_Vencimento__c,
                            Intervalo_das_Parcelas__c = condicao.Intervalo_das_Parcelas__c,
                            Valor_Total_das_Parcelas__c = (valoresSomadosUnidade.Total_Sinais__c / 3).setScale(2)
                        );
                        //newCondicao.Valor_Total_das_Parcelas__c = getNewValorTotalParcelas(valorItensAdicionais, newCondicao.Valor_Total_das_Parcelas__c).setScale(2);
                        condicoesNovas.add(newCondicao);

                    }
                    when 'Mensal' {
                        valorMensais += (valoresSomadosUnidade.Total_Mensais__c / condicao.Quantidade_de_parcelas__c).setScale(2);
                        Condi_o_de_Pagamento__c newCondicao = new Condi_o_de_Pagamento__c(
                            Tabela_de_Vendas__c = tabelaPadraoProposta.Id,
                            Periodicidade_Condicao__c = condicao.Periodicidade_Condicao__c,
                            Total_das_Parcelas__c = condicao.Total_das_Parcelas__c,
                            Quantidade_de_parcelas__c = condicao.Quantidade_de_parcelas__c,
                            In_cio_do_Vencimento__c = condicao.In_cio_do_Vencimento__c,
                            Intervalo_das_Parcelas__c = condicao.Intervalo_das_Parcelas__c,
                            Valor_Total_das_Parcelas__c = (valoresSomadosUnidade.Total_Mensais__c / condicao.Quantidade_de_parcelas__c).setScale(2)
                        );
                        //newCondicao.Valor_Total_das_Parcelas__c = getNewValorTotalParcelas(valorItensAdicionais, newCondicao.Valor_Total_das_Parcelas__c).setScale(2);
                        condicoesNovas.add(newCondicao);

                    }
                    when 'Semestral' {
                        valorSemestrais += (valoresSomadosUnidade.Total_Semestrais__c / condicao.Quantidade_de_parcelas__c).setScale(2);
                        Condi_o_de_Pagamento__c newCondicao = new Condi_o_de_Pagamento__c(
                            Tabela_de_Vendas__c = tabelaPadraoProposta.Id,
                            Periodicidade_Condicao__c = condicao.Periodicidade_Condicao__c,
                            Total_das_Parcelas__c = condicao.Total_das_Parcelas__c,
                            Quantidade_de_parcelas__c = condicao.Quantidade_de_parcelas__c,
                            In_cio_do_Vencimento__c = condicao.In_cio_do_Vencimento__c,
                            Intervalo_das_Parcelas__c = condicao.Intervalo_das_Parcelas__c,
                            Valor_Total_das_Parcelas__c = (valoresSomadosUnidade.Total_Semestrais__c / condicao.Quantidade_de_parcelas__c).setScale(2)
                        );
                        //newCondicao.Valor_Total_das_Parcelas__c = getNewValorTotalParcelas(valorItensAdicionais, newCondicao.Valor_Total_das_Parcelas__c).setScale(2);
                        condicoesNovas.add(newCondicao);

                    }
                    when 'Única' {
                        valorUnica += (valoresSomadosUnidade.Total_Pre_Chaves__c / condicao.Quantidade_de_parcelas__c).setScale(2);
                        Condi_o_de_Pagamento__c newCondicao = new Condi_o_de_Pagamento__c(
                            Tabela_de_Vendas__c = tabelaPadraoProposta.Id,
                            Periodicidade_Condicao__c = condicao.Periodicidade_Condicao__c,
                            Total_das_Parcelas__c = condicao.Total_das_Parcelas__c,
                            Quantidade_de_parcelas__c = condicao.Quantidade_de_parcelas__c,
                            In_cio_do_Vencimento__c = condicao.In_cio_do_Vencimento__c,
                            Intervalo_das_Parcelas__c = condicao.Intervalo_das_Parcelas__c,
                            Valor_Total_das_Parcelas__c = (valoresSomadosUnidade.Total_Pre_Chaves__c / condicao.Quantidade_de_parcelas__c).setScale(2)
                        );
                        //newCondicao.Valor_Total_das_Parcelas__c = getNewValorTotalParcelas(valorItensAdicionais, newCondicao.Valor_Total_das_Parcelas__c).setScale(2);

                        condicoesNovas.add(newCondicao);

                    }
                    when 'Financiamento' {
                        condicaoFinanciamento.Tabela_de_Vendas__c = tabelaPadraoProposta.Id;
                        condicaoFinanciamento.Periodicidade_Condicao__c = condicao.Periodicidade_Condicao__c;
                        condicaoFinanciamento.Total_das_Parcelas__c = condicao.Total_das_Parcelas__c;
                        condicaoFinanciamento.Quantidade_de_parcelas__c = condicao.Quantidade_de_parcelas__c;
                        condicaoFinanciamento.In_cio_do_Vencimento__c = condicao.In_cio_do_Vencimento__c;
                        condicaoFinanciamento.Intervalo_das_Parcelas__c = condicao.Intervalo_das_Parcelas__c;
                        condicaoFinanciamento.Valor_Total_das_Parcelas__c = proposta.Valor_Tabela__c - (
                            valoresSomadosUnidade.Total_Sinais__c + 
                            valoresSomadosUnidade.Total_Mensais__c + 
                            valoresSomadosUnidade.Total_Semestrais__c + 
                            valoresSomadosUnidade.Total_Pre_Chaves__c
                        );// - valorItensAdicionais;

                        //condicaoFinanciamento.Valor_Total_das_Parcelas__c = getNewValorTotalParcelas(valorItensAdicionais, condicaoFinanciamento.Valor_Total_das_Parcelas__c).setScale(2);
                    }
                    // when 'Anual' {
                        
                    // }
                }
            }

            condicoesNovas.add(condicaoFinanciamento);

        } else if(!condicoesTabelaEmpreendimento.isEmpty()) {
            for(Condi_o_de_Pagamento__c condicao : condicoesTabelaEmpreendimento){
                Condi_o_de_Pagamento__c newCondicao = new Condi_o_de_Pagamento__c(
                    Tabela_de_Vendas__c = tabelaPadraoProposta.Id,
                    Periodicidade_Condicao__c = condicao.Periodicidade_Condicao__c,
                    Total_das_Parcelas__c = condicao.Total_das_Parcelas__c,
                    Quantidade_de_parcelas__c = condicao.Quantidade_de_parcelas__c,
                    In_cio_do_Vencimento__c = condicao.In_cio_do_Vencimento__c,
                    Intervalo_das_Parcelas__c = condicao.Intervalo_das_Parcelas__c
                );
                Decimal valorTotal = (((condicao.Total_das_Parcelas__c / 100) * proposta.Valor_Tabela__c ) / newCondicao.Quantidade_de_parcelas__c).setScale(2);
                newCondicao.Valor_Total_das_Parcelas__c = valorTotal;

                // newCondicao.Valor_Total_das_Parcelas__c = newCondicao.Valor_Total_das_Parcelas__c / newCondicao.Quantidade_de_parcelas__c;
                condicoesNovas.add(newCondicao);
            }
        }
        
        // if(!condicoesTabelaEmpreendimento.isEmpty()){
        //     for(Condi_o_de_Pagamento__c condicao : condicoesTabelaEmpreendimento){
        //         Condi_o_de_Pagamento__c newCondicao = new Condi_o_de_Pagamento__c(
        //             Tabela_de_Vendas__c = tabelaPadraoProposta.Id,
        //             Periodicidade_Condicao__c = condicao.Periodicidade_Condicao__c,
        //             Total_das_Parcelas__c = condicao.Total_das_Parcelas__c,
        //             Quantidade_de_parcelas__c = condicao.Quantidade_de_parcelas__c,
        //             In_cio_do_Vencimento__c = condicao.In_cio_do_Vencimento__c,
        //             Intervalo_das_Parcelas__c = condicao.Intervalo_das_Parcelas__c
        //         );
        //         Decimal valorTotal = (((condicao.Total_das_Parcelas__c / 100) * proposta.Valor_Tabela__c ) / newCondicao.Quantidade_de_parcelas__c).setScale(2);
        //         newCondicao.Valor_Total_das_Parcelas__c = valorTotal;

        //         // newCondicao.Valor_Total_das_Parcelas__c = newCondicao.Valor_Total_das_Parcelas__c / newCondicao.Quantidade_de_parcelas__c;
        //         condicoesNovas.add(newCondicao);
        //     }            
        // }
        insert condicoesNovas;
        
        proposta.Tabela_de_Vendas_Proposta__c = tabelaPadraoProposta.Id;
        proposta.VPL_Tabela__c = PropostaCadastroController.calcFluxoPagamento(condicoesNovas,tabelaPadraoProposta.Id,'Tabela', 'VPL');

        return proposta;
    }

    public static Decimal getNewValorTotalParcelas(Decimal valorItensAdicionais, Decimal valorTotalPcs) {
        return valorTotalPcs + (valorItensAdicionais * 100 / valorTotalPcs);
    }

    @AuraEnabled
    public static List<String> getContentVersion(String recordId){
        try {
            List<ContentDocumentLink> contentDocumentLinks = [
                SELECT
                ContentDocumentId
                FROM ContentDocumentLink
                WHERE LinkedEntityId =: recordId
            ];
            
            Set<Id> contentDocumentIds = new Set<Id>();
            for(ContentDocumentLink contentDocumentLink: contentDocumentLinks){
                contentDocumentIds.add(contentDocumentLink.ContentDocumentId);
            }          
        
            List<ContentVersion> contentVersions = [
                SELECT 
                Id,
                FileType,
                VersionData  
                FROM 
                ContentVersion 
                WHERE FileType IN ('JPG','JPEG','PNG') AND ContentDocumentId =: contentDocumentIds LIMIT 1];
            
            List<String> versionsData = new List<String>();
            for(contentVersion contentVersion : contentVersions){
                versionsData.add(EncodingUtil.base64Encode(contentVersion.VersionData));
            }

            return versionsData;

            //return contentVersions;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}