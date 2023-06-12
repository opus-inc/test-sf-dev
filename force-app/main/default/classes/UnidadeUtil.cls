public class UnidadeUtil {

    static UnidadeDAO dao = new UnidadeDAO();
    
    public static Unidade__c buildUnidade(){
    
        Empreendimento__c emp = EmpreendimentoUtil.buildEmpreendimento();
        Corretores__c corretor = CorretorUtil.buildCorretorForTest();
        Unidade__c unidade = new Unidade__c(
        	
             Empreendimento__c = emp.Id, Data_Emiss_o_Termo_de_Quita_o__c = null, Lista_de_valores__c = null, Reserva__c = 'Nenhuma', 
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
        
        return unidade;
    }

    public static Unidade__c getUnidade(){
        List<Unidade__c> getUnidade = dao.getAll();
        if(getUnidade.size() > 0){
            return getUnidade.get(0);
        } else{
            insert buildUnidade();
            return buildUnidade();
        }
    }


}