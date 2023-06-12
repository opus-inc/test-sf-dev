@isTest
public class Test_REST_PvExcel {
    public class PvUtil {
		REST_PvExcel.Pv pv = new REST_PvExcel.Pv();
        String Empreendimento_Nome;
        String Unidade_Nome;
        String CPF_Corretor;
        String RecordTypeId = '0124A000001IuzOQAS';
        List<REST_PvExcel.Condicoes_PvExcel> condicoes = new List<REST_PvExcel.Condicoes_PvExcel>();
        List<REST_PvExcel.Intermediacao> intermediacao = new List<REST_PvExcel.Intermediacao>();
        REST_PvExcel.PJ pessoa_juridica = new REST_PvExcel.PJ();
        REST_PvExcel.PF pessoa_fisica = new REST_PvExcel.PF();
        
        public PvUtil () {
            
            Empreendimento__c empreendimento = new Empreendimento__c(
                Name = 'CONDOMINIO DECK 23',
                Unidades__c = null, 
                Caracteristicas_do_empreendimento__c = 'Caracteristicas de Teste', 
                Data_Assembleia_Patrimonio_Afetacaoo__c = null, 
                Natureza__c = 'Residencial', 
                Endere_o__c = 'T-0053, QD. 87, LT. 08/12, SETOR BUENO, CEP: 74.215-150, GOIANIA-GO', 
                Data_de_lan_amento__c = Date.Today().addDays(5), 
                Previs_o_de_entrega__c = null, 
                Data_de_vistoria_da_area_comum__c = null, 
                Data_do_Habite_se__c = Date.Today().addDays(2000), 
                Data_de_averba_o_do_Habite_se__c = null, 
                Data_de_entrega_da_area_comum__c = null, 
                CNPJ__c = '14.550.694/0001-45', 
                Razao_social__c = 'SPE INCORPORAÇÃO OPUS BUENO 1 LTDA', Construtora__c = '', 
                Engenheiro_respons_vel__c = '', 
                Vistoria_da_area_comum__c = '', 
                Personalizar_kits__c = false, 
                Kits_de_Personalizacao_definidos__c = false, 
                Layouts_dos_kits_definidos__c = false, 
                CD_de_Projetos_em_producao__c = false, 
                Imagem_Empreendimento__c = '<p><img src="https://opus--homolog--c.documentforce.com/servlet/rtaImage?eid=a074A00000r88L3&amp;feoid=00NA00000070bFT&amp;refid=0EM4A0000010Ciy" alt="DCK.png"></img></p>', 
                data_de_RI_do_empreendimento__c = null, 
                Cronograma_de_entrega_aprovado__c = false, 
                Comunicado_de_entrega_enviado__c = false, 
                Assembleia_de_condominio_realizada__c = false, 
                Data_cronograma_de_entrega__c = Date.Today().addDays(2000), 
                Data_da_assembleia__c = null, 
                Levantamento_de_saldo_pos_chaves__c = false, Contato_a_empresa_terceirizada__c = false, Data_de_revistoria__c = null, 
                Arquiteto_de_Interiores_pago__c = false, Projetos_compatibilizados__c = false, CD_de_Projetos_enviado_aos_clientes__c = false, 
                Carta_de_Personaliza_o_enviada_clientes__c = false, Valida_o_do_Cronograma_dePersonaliza_o__c = false, Kits_Opcionais_definidos__c = false, 
                Kits_Opcionais_corrigidos__c = false, Kit_orcado__c = false, Confer_ncia_de_projetos_e_Memorial_Desc__c = false, 
                Respons_vel_Personaliza_o__c = '', Elaboracao_do_CD_do_Cliente__c = false, Reuni_o_definicao_Kit__c = null, 
                Elaboracao_Projetos_simplificados__c = false, CD_de_Projetos_arquivado__c = false, Datas_conferidas_pelo_CRC__c = false, 
                Data_de_envio_da_Carta__c = null, Responsavel_pela_validacao_do_cronograma__c = '', Data_CND__c = null, 
                Data_Inclus_o_do_IGPM_e_Price__c = null, Cart_rio_de_Registro__c = 'Cartório de Registro de Imóveis da 1ª Circunscrição de Goiânia-GO', Banco_Financiador_da_Obra__c = '', 
                Data_Previs_o_de_Entrega__c = date.parse('10/07/2022'), Sindico__c = null, SubSindico__c = null, 
                Data_Patrim_nio_de_Afeta_o__c = null, data_prevista_entrega_de_kits__c = null, data_entrega_de_kits__c = null, 
                Conselho1__c = null, Conselho2__c = null, Conselho3__c = null, 
                Conselho1_Contato__c = '', Conselho2_Contato__c = '', Conselho3_Contato__c = '', 
                Codigo_Estrutura__c = null, Habite_se_Confirmado__c = false, data_do_evento_de_entrega__c = null, 
                data_prevista_entrega_de_or_amento_de_ki__c = null, data_entrega_de_or_amento_de_kits__c = null, Vigencia_Apolice_Seguro_Stand__c = null, 
                Mostra_PV__c = 'Sim', Gerente_Comercial_Respons_vel__c = 'Gabriel Souza dos Santos', Data_Envio_ltimo_Relat_rio__c = null, 
                Representante1_Afeta_o__c = null, Representante2_Afeta_o__c = null, Representante3_Afeta_o__c = null, 
                Procura_o_Ativa__c = '', Validade_da_Procura_o__c = null, PV_Taxa__c = 0.0025, 
                Notas_da_Tabela_de_Vendas__c = 'A. O preço da unidade constante na tabela está expresso em Reais, sem juros e sem correção e já inclui as vagas de garagem definidas para a unidade		<br><br> B. Na área privativa da unidade autônoma esta incluso a unidade, varanda, laje técnica, escaninho e hall social. Não está incluso vagas de garagem.  br><br> C. Todas as despesas cartorárias (escritura, ISTI, registro, Fundesp, etc)  e despesas de financiamento, quando houver, serão de responsabilidade do adquirente	<br><br> D. As respectivas parcelas serão pagas pelo adquirente diretamente à SPE INCORPORAÇÃO OPUS BUENO 1 LTDA ou à empresa Securitizadora / Agente Financeiro<br><br> E. O vencimento da 1a. Parcela mensal será no mês seguinte ao da proposta e a primeira semestral será no sexto mes após o mes da proposta. A data de vencimento das parcelas mensais e semestrais poderá ser dia 05, 10 ou 15 .<br><br> F.Todas as obrigações contratuais estão sujeitas a reajustamento e revisão na menor periodicidade admitida por lei, sendo até a expedição do Habite-se incidirá a variação do INCC-FGV com base no valor correspondente ao segundo mês anterior à assinatura do contrato, até o segundo mês anterior a cada pagamento. Após expedição do habite-se as parcelas do saldo devedor serão corrigidas monetariamente pela variação do IGP-M, tomando-se como base o mês do habite-se;	<br><br> G.As parcelas e prestações vincendas após o habite-se, serão acrescidas de juros de 1% ao mês Tabela Price;<br><br> H.<span style="text-decoration: underline;">CONDIÇÕES PARA FINANCIAMENTO BANCARIO: </span><br><br> •após a expedição do "habite-se" previsto para Junho de 2026, devendo o cliente buscar o agente financeiro de sua preferência.<br><br> •O Cliente deverá enquadrar-se nas condições contratuais do contrato de compra e venda do empreendimento, especificamente a clausula 2.6 das Normas Contratuais.<br>	<br> •O saldo referente ao financiamento depende da aprovação de crédito pelo agente financeiro. Se não for aprovado na sua totalidade, o saldo remanescente incorrerá em uma parcela atualizada com vencimento concomitante à data da assinatura do contrato de financiamento 	<br>	<br> •As condições acima são meramente exemplificativas, as alterações que ocorrerem serão aplicadas aos financiamentos a serem concedidos, de acordo com a época da efetiva concessão <br><br> I.A proposta assinada mesmo com cheque não garante reserva da unidade. Somente a assinatura do contrato de compra e venda garante a compra<br><br> J.A presente tabela poderá ser alterada sem prévio aviso<br><br> K.Todas as condições acima e demais condições de venda estão explicitadas no contrato de Compromisso de Compra e Venda<br><br> L.A entrega da unidade está condicionada ao cumprimento de obrigações contratuais',
                Realizacao__c = 'OPUS Inteligência Construtiva', Incorporacao__c = 'OPUS Inteligência Construtiva', 
                Construcao__c = 'OPUS Inteligência Construtiva' , Arquitetura__c  = 'Bretones e Carvalho Arquitetura' , Paisagismo__c = 'EKF Arquitetura de exteriores', 
                Decoracao__c = 'Léo Romano Arquitetura' , Localizacao__c = 'Rua T53 e Rua T27, Qd 87 Lotes 08/12 - Setor Bueno, Goiânia-GO', Pre_Lancamento__c = 'Outubro de 2020', 
                Previsao_de_Entrega__c = 'Junho de 2026' , Estilo__c = 'Contemporâneo', Sistema_de_Vendas__c = 'Fechado,com financiamento direto pelo Incorporador', 
                Area_do_Terreno__c = '3.537,50m²', Numero_de_Torres__c = '1', Numero_de_Pavimentos__c = '29, sendo 28 pavimentos tipo e 1 penthouse', 
                Unidades_por_Andar__c = '3. Nomeados finais 1, 2 e 3, e um Pavimento Penthouse', Total_de_Unidades__c = '86, sendo 84 aptos tipo + 2 Coberturas Penthouse', Numero_de_Elevadores__c = '5', 
                Total_de_Vagas__c = '184 vagas com capacidade para 269 veículos', Numero_do_RI__c = 'R-3', Numero_da_Matricula__c = 348544, 
                N_mero_do_Habite_se__c = '', Gerente_Comercial_Email__c = 'gabriel.santos@opus.inc', Exibe_Escaninho_no_quadro_de_Garagens__c = 'Não', 
                Utiliza_Tabela_Especial__c = 'Não', Utiliza_Garagem_Combo__c = 'Sim', Socios_do_Empreendimento__c = '', 
                NC_A_vista__c = 'https://opusic.force.com/servlet/servlet.FileDownload?file=00P4w000013C2Ud', Memorial__c = 'https://opusic.force.com/servlet/servlet.FileDownload?file=00P4w000013C2UY', 
                NC_A_Prazo__c = 'https://opusic.force.com/servlet/servlet.FileDownload?file=00P4w000013C2Ud', Brindes_Entregues_ao_CRC__c = false
            );
            insert empreendimento;
            Corretores__c corretor = CorretorUtil.buildCorretorForTest();
            
            Unidade__c unidade = new Unidade__c(
        	 Name = '1501',
             Empreendimento__c = empreendimento.Id, Data_Emiss_o_Termo_de_Quita_o__c = null, Lista_de_valores__c = null, Reserva__c = 'Nenhuma', 
             Corretor__c = corretor.Id, Gerente__c = null, Data_da_reserva__c = null, 
             Valor_pago__c = 0, Segunda_Reserva__c = 'Nenhuma', Corretor_Segunda_Reserva__c = null, 
             Gerente_Segunda_Reserva__c = null, M_s_de_venda__c = null, Area_privada__c = 157.6, 
             Area_comum__c = 54.885, N_mero_de_vagas_de_garagem__c = '33/33A e 35', 
             Data_de_entrega_da_unidade_ao_cliente__c = Date.newInstance(2021, 12, 31), 
             Valor_de_tabela__c = 1097273.27, Matricula_CRI__c = null, 
             Proprietario__c = null, Telefone__c = null, Reparos__c = null, Banco__c = null, FGTS__c = null, 
             Entrega_das_chaves__c = null, Valor_em_Aberto__c = 0, 
             Unidade_liberada_pela_obra__c = false, Unidade_foi_Entregue__c = false, Saldo_p_s_chaves__c = null, Op_o_Financiamento__c = null, 
             Saldo_Contrato__c = null, Vistoria__c = null, Percentual_pago__c = null, 
             Data_Libera_o__c = null, Personalizar_kit__c = false, 
             Entrega_com_Aditivo_de_Escritura__c = false, Notifica_o_de_vistoria_encaminhada__c = false, 
             Data_de_envio_de_Notifica_o_da_Vistoria__c = null, Enviar_carta_de_personalizacao__c = false, Status_da_unidade__c = 'Disponível', 
             Escritura__c = null, Situa_o_da_escritura__c = null, 
             Observacao__c = null, Data_de_entrega_manual_do_proprietario__c = null, 
             Data_de_entrega_termos_garantias_equip__c = null, Nome_do_bloco__c = 'OPUS ARAGUAYA', Texto__c = null, Nome_da_tipologia__c = null, 
             Status_do_contrato__c = null, Data_da_assinatura_do_contrato__c = null, Data_da_escritura_do_contrato__c = null, Valor_do_contrato__c = 0, 
             Valor_Inadimplente__c = 0, Campo_Chave_ERP_Mega__c = '878887908872OHN', Escritura_assinada_Opus__c = false, 
             Escritura_assinada_Socios__c = false, Registrada__c = false, Protocolo_de_registro__c = null, Prazo_final_Aditivo__c = null, Data_da_vistoria__c = null, 
             Posse_das_chaves__c = 'Obra', Humor_do_Cliente__c = null, Est_causando_danos_aos_m_veis__c = null, Elaboracao_de_Projeto_de_Personalizacao__c = false, 
             data_aceite_incorporadora__c = null, Orcamenta_o_e_Aprovacao_do_orcaamento__c = false, OBRA_Data_Prevista_de_Libera_o__c = null, 
             OBRA_Qtde_de_Remarca_es__c = null, OBRA_Data_Libera_o_Obra__c = null, OBRA_Unidade_Personalizada__c = 'Não', PSN_Data_da_Vistoria__c = null, 
             PSN_Qtde_de_itens_Pendentes__c = null, PSN_Qtde_de_Vistorias_j_realizadas__c = null, PSN_Data_prevista_de_Libera_o_da_Obra__c = null, 
             PSN_Qtde_de_Remarca_es__c = null, SGQ_Data_da_Vistoria__c = null, SGQ_Qtde_de_itens_Pendentes__c = null , SGQ_Qtde_de_vistorias_j_realizadas__c = null, 
             SGQ_Data_Prevista_de_Libera_o_da_Obra__c = null, SGQ_Qtde_de_Remarca_es__c = null, Data_de_Envio_Pesquisa_Vistoria__c = null, 
             CRC_Qtde_de_itens_Pendentes__c = null, CRC_Qtde_de_vistorias_j_realizadas__c = null, CRC_Data_Prevista_da_Libera_o_da_Obra__c = null, 
             CRC_Qtde_de_Remarca_es__c = null, Data_de_Envio_Pesquisa_Indica_o__c = null, Inscri_o_IPTU__c = null, SGQ_Data_da_revistoria__c = null, 
             CLI1_Qtde_de_itens_Pendentes__c = null, CLI2_Qtde_de_itens_Pendentes__c = null, CLI3_Qtde_de_itens_Pendentes__c = null, 
             CLI1_Data_Prevista_de_Libera_o_da_Obra__c = null, CLI2_Data_Prevista_de_Libera_o_da_Obra__c = null, 
             CLI3_Data_Prevista_de_Libera_o_da_Obra__c = null, CLI1_Qtde_de_Remarca_es__c = null, CLI2_Qtde_de_Remarca_es__c = null, 
             CLI3_Qtde_de_Remarca_es__c = null, Status_Atual_Vistoria__c = 'Não iniciada', Data_Aceite_Cliente__c = null, 
             CLI1_Data_da_Vistoria__c = null, CLI2_Data_da_Vistoria__c = null, CLI3_Data_da_Vistoria__c = null, Condom_nio_Vencimento__c = null, 
             Status_Financiamento__c = null, CRC_Data_Vistoria_CRC__c = null, CRC_Data_da_Vistoria__c = null, Unidade_Hipotecada__c = 'Sim', 
             Termo_solicitado_ao_Banco__c = null, Hipoteca_Averbada__c = null, Data_de_Entrega_do_Contrato_de_Compra_e__c = null, Nome_do_Cart_rio__c = null, 
             Data_de_Entrega_do_Brinde_de_Compra_e_Ve__c = null, Entrega__c = null, Entrega_de_Brindes__c = null, Data_da_Revistoria1__c = null, Revistoria1__c = null, 
             Andamento_da_Vistoria__c = null, Data_de_ajustes_construtora__c = null, Libera_o_da_Obra_para_Revistoria_2__c = null, Data_da_Revistoria2__c = null, 
             Securitiza_o__c = null, Revistoria2__c = null, Libera_o_da_Obra_para_Revistoria_3__c = null, Data_da_Revistoria3__c = null, Revistoria3__c = null, 
             Unidade_Decorada__c = false, Condom_nio_Telefone__c = null, Observacao_Sec__c = 'Não Preenchido', Valor_Securitiza_o__c = null, Data_de_Rec_Securitiza_o__c = null, 
             Possui_Voucher__c = false, Condom_nio_Possui__c = null, Condom_nio_Contato__c = null, gua_Vencimento__c = null, gua_Possui__c = null, 
             gua_C_digo_Consumidor__c = null, gua_CPF_CNPJ__c = null, Energia_Possui__c = null, Energia_Vencimento__c = null, Energia_Unidade_Consumidora__c = null, 
             Energia_CPF_CNPJ__c = null, IPTU_ITU_Unidade__c = null, IPTU_ITU_Parcelas_Ano__c = null, IPTU_ITU_Vencimento__c = null, Condom_nio_Vaga_1_Possui__c = null, 
             Condom_nio_Vaga_2_Possui__c = null, Condom_nio_Vaga_3_Possui__c = null, Condom_nio_Vaga_4_Possui__c = null, Condom_nio_Vaga_5_Possui__c = null, 
             Condom_nio_Vaga_6_Possui__c = null, IPTU_ITU_Vaga_1__c = null, IPTU_ITU_Vaga_2__c = null, IPTU_ITU_Vaga_3__c = null, 
             IPTU_ITU_Vaga_4__c = null, IPTU_ITU_Vaga_5__c = null, IPTU_ITU_Vaga_6__c = null, Unidade_com_bem_de_terceiro__c = false, 
             Data_de_Desocupa_o_do_Im_vel__c = null, agua_venc_2_teste__c = null, Energia_Dia_Vencimento__c = null, gua_Dia_Vencimento__c = null, 
             Condom_nio_Dia_Vencimento__c = null, IPTU_ITU_Dia_Vencimento__c = null, Data_atualiza_o_Status__c = DateTime.newInstance(2018, 04, 19, 16, 39, 23), 
             Tipo_da_unidade__c = 'Unidade', Tipo_de_Bem__c = null, Data_de_Pagamento_para_SPE__c = null, Data_da_Venda__c = null, Valor_de_permuta__c = null, 
             Valor_de_Venda__c = null, Percentual_de_Comiss_o__c = null, SGQ_Observa_es__c = null, Vig_ncia_do_Aluguel__c = null, X1_Aditivo_ok__c = null, 
             X2_Aditivo_ok__c = null, Prazo_Entrega_Doc_s_2_aditivo__c = null, Cl_usula_Especial__c = null, Prazo_Cl_usula_Especial__c = null, 
             Observa_o_Aditivo__c = null, Anexo_desocupa_o__c = null, G_s__c = null, G_s_Dia_Vencimento__c = null, G_s_C_digo_da_Unidade__c = null, 
             Recebimento_das_Chaves__c = null, Data_de_Vistoria_de_Recebimento__c = null, Nada_Consta_Energia__c = null, Nada_Consta_gua__c = null, 
             Nada_Consta_G_s__c = null, Nada_Consta_IPTU_ITU__c = null, Nada_Consta_Condom_nio__c = null, Check_List_Completo__c = null, Validado_Auditoria__c = null, 
             Email_Gerente_da_Venda__c = null, Status_Secund_rio__c = 'Disponível', Caracter_stica__c = 'Padrão', Data_Limite_da_Reserva__c = null, Observacao_Mega__c = 'Não Preenchido', 
             Unidade_origem__c = null, Procura_o_Entregue__c = null, Im_vel_Desocupado__c = null, Observa_o_da_Despesa__c = null, Aluguel_Pr_prio__c = null, 
             Limpeza_Possui__c = null, Limpeza_Dia_Vencimento__c = null, Quem_deve_receber_o_contrato__c = null, Resumo_PSN__c = null, 
             Nova_Data_de_Desocupa_o_do_Im_vel__c = null, Mostra_PV__c = 'Sim', Data_de_Entrega_do_Decorado_DPRO__c = null, 
             Data_de_Recebimento_do_Decorado_CRC__c = null, Fracao_Ideal__c = 1.0547972, Localizacao__c = '11', Total_Sinais__c = null, Total_Mensais__c = null, 
             Total_Semestrais__c = null, Total_Pre_Chaves__c = null 
        	);
            insert unidade;
            
            Tabela_de_Vendas__c tabelaDeVendas = new Tabela_de_Vendas__c(
                Data_da_Tabela__c = Date.newInstance(2020, 11, 05), Empreendimento__c = empreendimento.Id, 
                Status__c = 'Inativa', Unidade__c = unidade.Id, Chave_Tabela__c = null, 
                Tipo__c = 'Tabela', VP_Tabela__c = 1029345.42, Proposta_de_Vendas__c = null
            );
            insert tabelaDeVendas;

            Condi_o_de_Pagamento__c condicaoPagamento = new Condi_o_de_Pagamento__c();
            condicaoPagamento.Tabela_de_Vendas__c = tabelaDeVendas.Id;
            condicaoPagamento.Periodicidade_Condicao__c = 'Única';
            condicaoPagamento.Intervalo_das_Parcelas__c = 1;
            condicaoPagamento.Quantidade_de_parcelas__c = 1;
            condicaoPagamento.In_cio_do_Vencimento__c =date.parse('10/07/2021');
            condicaoPagamento.Valor_Total_das_Parcelas__c = 134159.140304323;
            insert condicaoPagamento;            
            
            tabelaDeVendas.Status__c = 'Ativa';
            update tabelaDeVendas;
            
            Empreendimento_Nome = empreendimento.Name;
            Unidade_Nome = unidade.Name;
            CPF_Corretor = corretor.CPF__c;

            pv.Numero_pasta_Facilita = '1';
            pv.Garagem = '180; 164 e 181';
            pv.Valor_Tabela = 2063986.7739126615;
            pv.VPL_Tabela = 2020633.9680485486;
            pv.Valor_da_Proposta = 2068986.7739126615;
            pv.VPL_Proposta = 2024520.5137497715;
            pv.Nome_do_Cliente = 'Rosângela Liz Isabella Aparício';
            pv.Telefone_do_Cliente = '(68) 98827-8086';
            pv.CPF_do_Cliente = '389.252.366-56';
            pv.E_mail_do_Cliente = 'rrosangelalizisabellaaparicio@numero.com.br';
            pv.Perc_Comissao_Destacada = 5;
            pv.Perc_Comissao_Faturada = 0;
            pv.Valor_da_Premiacao = 0;
            pv.Observacao_do_Cliente = 'obs';
            
            pessoa_juridica.Raz_o_Social = 'Empresa';
            pessoa_juridica.Telefone_Comercial = '(62) 3242526282';
            pessoa_juridica.CNPJ = '17.769.393/0001-03';
            pessoa_juridica.Endereco_Comercial = 'endereço 1';
            pessoa_juridica.Name = 'Rosângela Liz Isabella Aparício';
            pessoa_juridica.Estado_Civil = 'Casado';
            pessoa_juridica.CPF = '389.252.366-56';
            pessoa_juridica.Tipo_de_Uniao = 'Comunhão Parcial de Bens';
            pessoa_juridica.Nacionalidade = 'Brasileira';
            pessoa_juridica.Profissao = 'Analista';
            pessoa_juridica.RG = '44.346.471-6';
            pessoa_juridica.E_mail = 'email@email.com';
            pessoa_juridica.Data_de_Nascimento = date.parse('18/01/2001');
            pessoa_juridica.Telefone_Residencial = '(62) 3242526282';
            pessoa_juridica.Orgao_Expedidor = 'ssp';
            pessoa_juridica.Telefone_Celular = '(62) 3242526282';
            pessoa_juridica.Endereco_Residencial = 'Rua Domingos Olímpio 258';
            
            pessoa_fisica.Nacionalidade = 'sasasa';
            pessoa_fisica.Name = 'sassa';
            pessoa_fisica.E_mail = 'sasasa';
            pessoa_fisica.Data_de_Nascimento = date.parse('01/01/2001');
            pessoa_fisica.Telefone_Residencial = '1111';
            pessoa_fisica.CPF = '1111';
            pessoa_fisica.Telefone_Celular = '1111';
            pessoa_fisica.RG = '1111';
            pessoa_fisica.Profissao = 'aaaa';
            pessoa_fisica.Orgao_Expedidor = 'aaa';
            pessoa_fisica.Estado_Civil = 'aaaa';
            pessoa_fisica.Endereco_Residencial = '1111';
            pessoa_fisica.Tipo_de_Uniao = 'aaaa';
            pessoa_fisica.Nome_Completo_CJ = 'aaaaaa';
            pessoa_fisica.E_mail_CJ = 'aaaaaa';
            pessoa_fisica.Data_de_Nascimento_CJ = date.parse('01/01/2001');
            pessoa_fisica.Telefone = '5454';
            pessoa_fisica.CPF_CJ = '211212';
            pessoa_fisica.Celular_CJ = '1212';
            pessoa_fisica.RG_CJ = '1221';
            pessoa_fisica.Profissao_CJ = 'asdsda';
            pessoa_fisica.Orgao_Expedidor_CJ = 'adads';
            pessoa_fisica.Estado_Civil_CJ = 'adsasd';
            pessoa_fisica.Endereco_Residencial_CJ = 'dasdsa';
            pessoa_fisica.Tipo_de_Uniao_CJ = 'dasdsa';
            
            REST_PvExcel.Intermediacao intermediacao1 = new REST_PvExcel.Intermediacao();
            intermediacao1.Tipo = 'Corretor';
            intermediacao1.Name = 'Duane';
            intermediacao1.Telefone_para_Contato = '999';
            intermediacao1.CPF_CNPJ = '123091309';
            intermediacao1.Email = 'email@email.com';
            intermediacao1.CRECI = '1111';
            intermediacao1.Tipo_de_Comissao = 'Destacado';
            intermediacao1.Razao_Social = 'aaaa';
            intermediacao1.Porcentagem = 2;
            REST_PvExcel.Intermediacao intermediacao2 = new REST_PvExcel.Intermediacao();
            intermediacao2.Tipo = 'Corretor';
            intermediacao2.Name = 'My Broker';
            intermediacao2.Telefone_para_Contato = '999';
            intermediacao2.CPF_CNPJ = '033.881.320-97';
            intermediacao2.Email = 'email@email.com';
            intermediacao2.CRECI = '1111';
            intermediacao2.Tipo_de_Comissao = 'Destacado';
            intermediacao2.Razao_Social = 'aaaa';
            intermediacao2.Porcentagem = 3 ;
            
            intermediacao.add(intermediacao1);
            intermediacao.add(intermediacao2);
            REST_PvExcel.Condicoes_PvExcel condicao1 = new REST_PvExcel.Condicoes_PvExcel();
            condicao1.Periodicidade_Condicao = 'Única';
            condicao1.Intervalo_das_Parcelas = 1;
            condicao1.Quantidade_de_parcelas = 1;
            condicao1.Inicio_do_Vencimento = date.parse('10/07/2021');
            condicao1.Valor_Total_das_Parcelas = 134159.140304323;
            condicao1.Tipo_Tabela = 'Vendas';
                
             
            
            REST_PvExcel.Condicoes_PvExcel condicao7 = new REST_PvExcel.Condicoes_PvExcel();
            condicao7.Periodicidade_Condicao = 'Única';
            condicao7.Intervalo_das_Parcelas = 1;
            condicao7.Quantidade_de_parcelas = 1;
            condicao7.Inicio_do_Vencimento = date.parse('10/07/2021');
            condicao7.Valor_Total_das_Parcelas = 134159.140304323;
            condicao7.Tipo_Tabela = 'Proposta';

            
            condicoes.add(condicao1);
            condicoes.add(condicao7);
        }
    }
    
    static testMethod void test_doInvoice(){
        
        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/PvExcel';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.addHeader('Accept', 'application/json');
		
        PvUtil pvUtil = new PvUtil();
       
        String body = JSON.serialize(pvUtil);

        req.requestBody = Blob.valueof(body);

        Test.startTest();
        	string newPv = REST_PvExcel.createNewPv(
                pvUtil.pv, 
                pvUtil.condicoes, 
                pvUtil.intermediacao, 
                pvUtil.Empreendimento_Nome, 
                pvUtil.Unidade_Nome, 
                pvUtil.CPF_Corretor, 
                pvUtil.RecordTypeId, 
                pvUtil.pessoa_juridica, 
                pvUtil.pessoa_fisica
            );
        try {
            string sucess = newPv.substring(30, 37);
            System.assertEquals(sucess, 'sucesso');
        } catch (Exception e) {}
        Test.stopTest(); 
    }
}