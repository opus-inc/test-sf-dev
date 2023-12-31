public class UnidadeDAO {

    public List<Unidade__c> getAll(){
    	 List<Unidade__c> unidades = [
         	SELECT	Id, Empreendimento__c, Data_Emiss_o_Termo_de_Quita_o__c, Lista_de_valores__c, Reserva__c, 
             Corretor__c, Gerente__c, Data_da_reserva__c, Valor_pago__c, Segunda_Reserva__c, Corretor_Segunda_Reserva__c, 
             Gerente_Segunda_Reserva__c, M_s_de_venda__c, Area_privada__c, Area_comum__c, N_mero_de_vagas_de_garagem__c, 
             Data_de_entrega_da_unidade_ao_cliente__c, Hoje_2_DIAS__c, Valor_de_tabela__c, Matricula_CRI__c, 
             Proprietario__c, Telefone__c, Reparos__c, Banco__c, FGTS__c, Entrega_das_chaves__c, Valor_em_Aberto__c, 
             Unidade_liberada_pela_obra__c, Unidade_foi_Entregue__c, Saldo_p_s_chaves__c, Op_o_Financiamento__c, 
             Saldo_Contrato__c, Vistoria__c, Percentual_pago__c, Area_total__c, Data_Libera_o__c, Personalizar_kit__c, 
             Entrega_com_Aditivo_de_Escritura__c, Notifica_o_de_vistoria_encaminhada__c, 
             Data_de_envio_de_Notifica_o_da_Vistoria__c, Enviar_carta_de_personalizacao__c, Status_da_unidade__c, 
             Data_da_Reserva_48h__c, Escritura__c, Situa_o_da_escritura__c, Observacao__c, Data_de_entrega_manual_do_proprietario__c, 
             Data_de_entrega_termos_garantias_equip__c, Nome_do_bloco__c, Texto__c, Nome_da_tipologia__c, 
             Status_do_contrato__c, Data_da_assinatura_do_contrato__c, Data_da_escritura_do_contrato__c, Valor_do_contrato__c, 
             Valor_Inadimplente__c, Campo_Chave_ERP_Mega__c, Status_contrato__c, Escritura_assinada_Opus__c, 
             Escritura_assinada_Socios__c, Registrada__c, Protocolo_de_registro__c, Prazo_final_Aditivo__c, Data_da_vistoria__c, 
             Posse_das_chaves__c, Humor_do_Cliente__c, Est_causando_danos_aos_m_veis__c, Elaboracao_de_Projeto_de_Personalizacao__c, 
             data_aceite_incorporadora__c, Orcamenta_o_e_Aprovacao_do_orcaamento__c, OBRA_Data_Prevista_de_Libera_o__c, 
             OBRA_Qtde_de_Remarca_es__c, OBRA_Data_Libera_o_Obra__c, OBRA_Unidade_Personalizada__c, PSN_Data_da_Vistoria__c, 
             PSN_Qtde_de_itens_Pendentes__c, PSN_Qtde_de_Vistorias_j_realizadas__c, PSN_Data_prevista_de_Libera_o_da_Obra__c, 
             PSN_Qtde_de_Remarca_es__c, SGQ_Data_da_Vistoria__c, SGQ_Qtde_de_itens_Pendentes__c, SGQ_Qtde_de_vistorias_j_realizadas__c, 
             SGQ_Data_Prevista_de_Libera_o_da_Obra__c, SGQ_Qtde_de_Remarca_es__c, Data_de_Envio_Pesquisa_Vistoria__c, 
             CRC_Qtde_de_itens_Pendentes__c, CRC_Qtde_de_vistorias_j_realizadas__c, CRC_Data_Prevista_da_Libera_o_da_Obra__c, 
             CRC_Qtde_de_Remarca_es__c, Data_de_Envio_Pesquisa_Indica_o__c, Inscri_o_IPTU__c, SGQ_Data_da_revistoria__c, 
             CLI1_Qtde_de_itens_Pendentes__c, CLI2_Qtde_de_itens_Pendentes__c, CLI3_Qtde_de_itens_Pendentes__c, 
             CLI1_Data_Prevista_de_Libera_o_da_Obra__c, CLI2_Data_Prevista_de_Libera_o_da_Obra__c, 
             CLI3_Data_Prevista_de_Libera_o_da_Obra__c, CLI1_Qtde_de_Remarca_es__c, CLI2_Qtde_de_Remarca_es__c, 
             CLI3_Qtde_de_Remarca_es__c, Status_Atual_Vistoria__c, Data_Aceite_Cliente__c, Data_Prevista_Libera_o_Obra__c, 
             CLI1_Data_da_Vistoria__c, CLI2_Data_da_Vistoria__c, CLI3_Data_da_Vistoria__c, Condom_nio_Vencimento__c, 
             Status_Financiamento__c, CRC_Data_Vistoria_CRC__c, CRC_Data_da_Vistoria__c, Unidade_Hipotecada__c, 
             Termo_solicitado_ao_Banco__c, Hipoteca_Averbada__c, Data_de_Entrega_do_Contrato_de_Compra_e__c, Nome_do_Cart_rio__c, 
             Data_de_Entrega_do_Brinde_de_Compra_e_Ve__c, Entrega__c, Entrega_de_Brindes__c, Data_da_Revistoria1__c, Revistoria1__c, 
             Andamento_da_Vistoria__c, Data_de_ajustes_construtora__c, Libera_o_da_Obra_para_Revistoria_2__c, Data_da_Revistoria2__c, 
             Securitiza_o__c, Revistoria2__c, Libera_o_da_Obra_para_Revistoria_3__c, Data_da_Revistoria3__c, Revistoria3__c, 
             Unidade_Decorada__c, Condom_nio_Telefone__c, Observacao_Sec__c, Valor_Securitiza_o__c, Data_de_Rec_Securitiza_o__c, 
             Possui_Voucher__c, Condom_nio_Possui__c, Condom_nio_Contato__c, gua_Vencimento__c, gua_Possui__c, 
             gua_C_digo_Consumidor__c, gua_CPF_CNPJ__c, Energia_Possui__c, Energia_Vencimento__c, Energia_Unidade_Consumidora__c, 
             Energia_CPF_CNPJ__c, IPTU_ITU_Unidade__c, IPTU_ITU_Parcelas_Ano__c, IPTU_ITU_Vencimento__c, Condom_nio_Vaga_1_Possui__c, 
             Condom_nio_Vaga_2_Possui__c, Condom_nio_Vaga_3_Possui__c, Condom_nio_Vaga_4_Possui__c, Condom_nio_Vaga_5_Possui__c, 
             Condom_nio_Vaga_6_Possui__c, IPTU_ITU_Vaga_1__c, IPTU_ITU_Vaga_2__c, IPTU_ITU_Vaga_3__c, 
             IPTU_ITU_Vaga_4__c, IPTU_ITU_Vaga_5__c, IPTU_ITU_Vaga_6__c, Unidade_com_bem_de_terceiro__c, 
             Data_de_Desocupa_o_do_Im_vel__c, agua_venc_2_teste__c, Energia_Dia_Vencimento__c, gua_Dia_Vencimento__c, 
             Condom_nio_Dia_Vencimento__c, IPTU_ITU_Dia_Vencimento__c, Data_atualiza_o_Status__c, 
             Tipo_da_unidade__c, Tipo_de_Bem__c, Data_de_Pagamento_para_SPE__c, Data_da_Venda__c, Valor_de_permuta__c, 
             Valor_de_Venda__c, Percentual_de_Comiss_o__c, SGQ_Observa_es__c, Vig_ncia_do_Aluguel__c, X1_Aditivo_ok__c, 
             X2_Aditivo_ok__c, Prazo_Entrega_Doc_s_2_aditivo__c, Cl_usula_Especial__c, Prazo_Cl_usula_Especial__c, 
             Observa_o_Aditivo__c, Anexo_desocupa_o__c, G_s__c, G_s_Dia_Vencimento__c, G_s_C_digo_da_Unidade__c, 
             Recebimento_das_Chaves__c, Data_de_Vistoria_de_Recebimento__c, Nada_Consta_Energia__c, Nada_Consta_gua__c, 
             Nada_Consta_G_s__c, Nada_Consta_IPTU_ITU__c, Nada_Consta_Condom_nio__c, Check_List_Completo__c, Validado_Auditoria__c, 
             Email_Gerente_da_Venda__c, Status_Secund_rio__c, Caracter_stica__c, Data_Limite_da_Reserva__c, Observacao_Mega__c, 
             Unidade_origem__c, Procura_o_Entregue__c, Im_vel_Desocupado__c, Observa_o_da_Despesa__c, Aluguel_Pr_prio__c, 
             Limpeza_Possui__c, Limpeza_Dia_Vencimento__c, Quem_deve_receber_o_contrato__c, Resumo_PSN__c, 
             Nova_Data_de_Desocupa_o_do_Im_vel__c, Mostra_PV__c, Data_de_Entrega_do_Decorado_DPRO__c, 
             Data_de_Recebimento_do_Decorado_CRC__c, Fracao_Ideal__c, Localizacao__c, Total_Sinais__c, Total_Mensais__c, 
             Total_Semestrais__c, Total_Pre_Chaves__c 
            FROM 	Unidade__c             
         ];
        
        return unidades;
        
    }
    
    public Unidade__c getUnidadeById(Id id){
            Unidade__c unidade = [
                SELECT	Id, Empreendimento__c, Data_Emiss_o_Termo_de_Quita_o__c, Lista_de_valores__c, Reserva__c, 
                 Corretor__c, Gerente__c, Data_da_reserva__c, Valor_pago__c, Segunda_Reserva__c, Corretor_Segunda_Reserva__c, 
                 Gerente_Segunda_Reserva__c, M_s_de_venda__c, Area_privada__c, Area_comum__c, N_mero_de_vagas_de_garagem__c, 
                 Data_de_entrega_da_unidade_ao_cliente__c, Hoje_2_DIAS__c, Valor_de_tabela__c, Matricula_CRI__c, 
                 Proprietario__c, Telefone__c, Reparos__c, Banco__c, FGTS__c, Entrega_das_chaves__c, Valor_em_Aberto__c, 
                 Unidade_liberada_pela_obra__c, Unidade_foi_Entregue__c, Saldo_p_s_chaves__c, Op_o_Financiamento__c, 
                 Saldo_Contrato__c, Vistoria__c, Percentual_pago__c, Area_total__c, Data_Libera_o__c, Personalizar_kit__c, 
                 Entrega_com_Aditivo_de_Escritura__c, Notifica_o_de_vistoria_encaminhada__c, 
                 Data_de_envio_de_Notifica_o_da_Vistoria__c, Enviar_carta_de_personalizacao__c, Status_da_unidade__c, 
                 Data_da_Reserva_48h__c, Escritura__c, Situa_o_da_escritura__c, Observacao__c, Data_de_entrega_manual_do_proprietario__c, 
                 Data_de_entrega_termos_garantias_equip__c, Nome_do_bloco__c, Texto__c, Nome_da_tipologia__c, 
                 Status_do_contrato__c, Data_da_assinatura_do_contrato__c, Data_da_escritura_do_contrato__c, Valor_do_contrato__c, 
                 Valor_Inadimplente__c, Campo_Chave_ERP_Mega__c, Status_contrato__c, Escritura_assinada_Opus__c, 
                 Escritura_assinada_Socios__c, Registrada__c, Protocolo_de_registro__c, Prazo_final_Aditivo__c, Data_da_vistoria__c, 
                 Posse_das_chaves__c, Humor_do_Cliente__c, Est_causando_danos_aos_m_veis__c, Elaboracao_de_Projeto_de_Personalizacao__c, 
                 data_aceite_incorporadora__c, Orcamenta_o_e_Aprovacao_do_orcaamento__c, OBRA_Data_Prevista_de_Libera_o__c, 
                 OBRA_Qtde_de_Remarca_es__c, OBRA_Data_Libera_o_Obra__c, OBRA_Unidade_Personalizada__c, PSN_Data_da_Vistoria__c, 
                 PSN_Qtde_de_itens_Pendentes__c, PSN_Qtde_de_Vistorias_j_realizadas__c, PSN_Data_prevista_de_Libera_o_da_Obra__c, 
                 PSN_Qtde_de_Remarca_es__c, SGQ_Data_da_Vistoria__c, SGQ_Qtde_de_itens_Pendentes__c, SGQ_Qtde_de_vistorias_j_realizadas__c, 
                 SGQ_Data_Prevista_de_Libera_o_da_Obra__c, SGQ_Qtde_de_Remarca_es__c, Data_de_Envio_Pesquisa_Vistoria__c, 
                 CRC_Qtde_de_itens_Pendentes__c, CRC_Qtde_de_vistorias_j_realizadas__c, CRC_Data_Prevista_da_Libera_o_da_Obra__c, 
                 CRC_Qtde_de_Remarca_es__c, Data_de_Envio_Pesquisa_Indica_o__c, Inscri_o_IPTU__c, SGQ_Data_da_revistoria__c, 
                 CLI1_Qtde_de_itens_Pendentes__c, CLI2_Qtde_de_itens_Pendentes__c, CLI3_Qtde_de_itens_Pendentes__c, 
                 CLI1_Data_Prevista_de_Libera_o_da_Obra__c, CLI2_Data_Prevista_de_Libera_o_da_Obra__c, 
                 CLI3_Data_Prevista_de_Libera_o_da_Obra__c, CLI1_Qtde_de_Remarca_es__c, CLI2_Qtde_de_Remarca_es__c, 
                 CLI3_Qtde_de_Remarca_es__c, Status_Atual_Vistoria__c, Data_Aceite_Cliente__c, Data_Prevista_Libera_o_Obra__c, 
                 CLI1_Data_da_Vistoria__c, CLI2_Data_da_Vistoria__c, CLI3_Data_da_Vistoria__c, Condom_nio_Vencimento__c, 
                 Status_Financiamento__c, CRC_Data_Vistoria_CRC__c, CRC_Data_da_Vistoria__c, Unidade_Hipotecada__c, 
                 Termo_solicitado_ao_Banco__c, Hipoteca_Averbada__c, Data_de_Entrega_do_Contrato_de_Compra_e__c, Nome_do_Cart_rio__c, 
                 Data_de_Entrega_do_Brinde_de_Compra_e_Ve__c, Entrega__c, Entrega_de_Brindes__c, Data_da_Revistoria1__c, Revistoria1__c, 
                 Andamento_da_Vistoria__c, Data_de_ajustes_construtora__c, Libera_o_da_Obra_para_Revistoria_2__c, Data_da_Revistoria2__c, 
                 Securitiza_o__c, Revistoria2__c, Libera_o_da_Obra_para_Revistoria_3__c, Data_da_Revistoria3__c, Revistoria3__c, 
                 Unidade_Decorada__c, Condom_nio_Telefone__c, Observacao_Sec__c, Valor_Securitiza_o__c, Data_de_Rec_Securitiza_o__c, 
                 Possui_Voucher__c, Condom_nio_Possui__c, Condom_nio_Contato__c, gua_Vencimento__c, gua_Possui__c, 
                 gua_C_digo_Consumidor__c, gua_CPF_CNPJ__c, Energia_Possui__c, Energia_Vencimento__c, Energia_Unidade_Consumidora__c, 
                 Energia_CPF_CNPJ__c, IPTU_ITU_Unidade__c, IPTU_ITU_Parcelas_Ano__c, IPTU_ITU_Vencimento__c, Condom_nio_Vaga_1_Possui__c, 
                 Condom_nio_Vaga_2_Possui__c, Condom_nio_Vaga_3_Possui__c, Condom_nio_Vaga_4_Possui__c, Condom_nio_Vaga_5_Possui__c, 
                 Condom_nio_Vaga_6_Possui__c, IPTU_ITU_Vaga_1__c, IPTU_ITU_Vaga_2__c, IPTU_ITU_Vaga_3__c, 
                 IPTU_ITU_Vaga_4__c, IPTU_ITU_Vaga_5__c, IPTU_ITU_Vaga_6__c, Unidade_com_bem_de_terceiro__c, 
                 Data_de_Desocupa_o_do_Im_vel__c, agua_venc_2_teste__c, Energia_Dia_Vencimento__c, gua_Dia_Vencimento__c, 
                 Condom_nio_Dia_Vencimento__c, IPTU_ITU_Dia_Vencimento__c, Data_atualiza_o_Status__c, 
                 Tipo_da_unidade__c, Tipo_de_Bem__c, Data_de_Pagamento_para_SPE__c, Data_da_Venda__c, Valor_de_permuta__c, 
                 Valor_de_Venda__c, Percentual_de_Comiss_o__c, SGQ_Observa_es__c, Vig_ncia_do_Aluguel__c, X1_Aditivo_ok__c, 
                 X2_Aditivo_ok__c, Prazo_Entrega_Doc_s_2_aditivo__c, Cl_usula_Especial__c, Prazo_Cl_usula_Especial__c, 
                 Observa_o_Aditivo__c, Anexo_desocupa_o__c, G_s__c, G_s_Dia_Vencimento__c, G_s_C_digo_da_Unidade__c, 
                 Recebimento_das_Chaves__c, Data_de_Vistoria_de_Recebimento__c, Nada_Consta_Energia__c, Nada_Consta_gua__c, 
                 Nada_Consta_G_s__c, Nada_Consta_IPTU_ITU__c, Nada_Consta_Condom_nio__c, Check_List_Completo__c, Validado_Auditoria__c, 
                 Email_Gerente_da_Venda__c, Status_Secund_rio__c, Caracter_stica__c, Data_Limite_da_Reserva__c, Observacao_Mega__c, 
                 Unidade_origem__c, Procura_o_Entregue__c, Im_vel_Desocupado__c, Observa_o_da_Despesa__c, Aluguel_Pr_prio__c, 
                 Limpeza_Possui__c, Limpeza_Dia_Vencimento__c, Quem_deve_receber_o_contrato__c, Resumo_PSN__c, 
                 Nova_Data_de_Desocupa_o_do_Im_vel__c, Mostra_PV__c, Data_de_Entrega_do_Decorado_DPRO__c, 
                 Data_de_Recebimento_do_Decorado_CRC__c, Fracao_Ideal__c, Localizacao__c, Total_Sinais__c, Total_Mensais__c, 
                 Total_Semestrais__c, Total_Pre_Chaves__c 
                FROM 	Unidade__c 
                WHERE Id =: id
                LIMIT 1 
       	 	];
          return unidade;
    }
}