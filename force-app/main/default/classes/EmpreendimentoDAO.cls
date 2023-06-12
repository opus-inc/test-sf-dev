public class EmpreendimentoDAO {
    
    public List<Empreendimento__c> getAll(){
        List<Empreendimento__c> empreendimentos = [
            SELECT Id, Unidades__c, Caracteristicas_do_empreendimento__c, Data_Assembleia_Patrimonio_Afetacaoo__c, 
            Natureza__c, Endere_o__c, Data_de_lan_amento__c, Previs_o_de_entrega__c, Data_de_vistoria_da_area_comum__c, 
            Data_do_Habite_se__c, Data_de_averba_o_do_Habite_se__c, Data_de_entrega_da_area_comum__c, 
            CNPJ__c, Razao_social__c, Construtora__c, Engenheiro_respons_vel__c, Vistoria_da_area_comum__c, 
            Personalizar_kits__c, Kits_de_Personalizacao_definidos__c, Layouts_dos_kits_definidos__c, 
            CD_de_Projetos_em_producao__c, Imagem_Empreendimento__c, data_de_RI_do_empreendimento__c, 
            Cronograma_de_entrega_aprovado__c, Comunicado_de_entrega_enviado__c, Assembleia_de_condominio_realizada__c, 
            Data_cronograma_de_entrega__c, Data_da_assembleia__c, Levantamento_de_saldo_pos_chaves__c, Contato_a_empresa_terceirizada__c, 
            Data_de_revistoria__c, Arquiteto_de_Interiores_pago__c, Projetos_compatibilizados__c, CD_de_Projetos_enviado_aos_clientes__c, 
            Carta_de_Personaliza_o_enviada_clientes__c, Valida_o_do_Cronograma_dePersonaliza_o__c, Kits_Opcionais_definidos__c, 
            Kits_Opcionais_corrigidos__c, Kit_orcado__c, Confer_ncia_de_projetos_e_Memorial_Desc__c, Respons_vel_Personaliza_o__c, 
            Elaboracao_do_CD_do_Cliente__c, Reuni_o_definicao_Kit__c, Elaboracao_Projetos_simplificados__c, CD_de_Projetos_arquivado__c, 
            Datas_conferidas_pelo_CRC__c, Data_de_envio_da_Carta__c, Responsavel_pela_validacao_do_cronograma__c, Data_CND__c, 
            Data_Inclus_o_do_IGPM_e_Price__c, Cart_rio_de_Registro__c, Banco_Financiador_da_Obra__c, Data_Previs_o_de_Entrega__c, 
            Sindico__c, SubSindico__c, Data_Patrim_nio_de_Afeta_o__c, data_prevista_entrega_de_kits__c, data_entrega_de_kits__c, 
            Conselho1__c, Conselho2__c, Conselho3__c, Conselho1_Contato__c, Conselho2_Contato__c, Conselho3_Contato__c, Codigo_Estrutura__c, 
            Habite_se_Confirmado__c, data_do_evento_de_entrega__c, data_prevista_entrega_de_or_amento_de_ki__c, 
            data_entrega_de_or_amento_de_kits__c, Vigencia_Apolice_Seguro_Stand__c, Mostra_PV__c, Gerente_Comercial_Respons_vel__c, 
            Data_Envio_ltimo_Relat_rio__c, Representante1_Afeta_o__c, Representante2_Afeta_o__c, Representante3_Afeta_o__c, 
            Procura_o_Ativa__c, Validade_da_Procura_o__c, PV_Taxa__c, Notas_da_Tabela_de_Vendas__c, Realizacao__c, Incorporacao__c, 
            Construcao__c, Arquitetura__c, Paisagismo__c, Decoracao__c, Localizacao__c, Pre_Lancamento__c, Previsao_de_Entrega__c, 
            Estilo__c, Sistema_de_Vendas__c, Area_do_Terreno__c, Numero_de_Torres__c, Numero_de_Pavimentos__c, Unidades_por_Andar__c, 
            Total_de_Unidades__c, Numero_de_Elevadores__c, Total_de_Vagas__c, Numero_do_RI__c, Numero_da_Matricula__c, N_mero_do_Habite_se__c, 
            Gerente_Comercial_Email__c, Exibe_Escaninho_no_quadro_de_Garagens__c, Utiliza_Tabela_Especial__c, Utiliza_Garagem_Combo__c, 
            Socios_do_Empreendimento__c, NC_A_vista__c, Memorial__c, NC_A_Prazo__c, Brindes_Entregues_ao_CRC__c 
            FROM Empreendimento__c
        ];
        return empreendimentos;
    }
    
    public List<Empreendimento__c> getEmpreendimentoByName(String name){
        
        List<Empreendimento__c> empreendimentos = [
            SELECT Id, Name, Unidades__c, Caracteristicas_do_empreendimento__c, Data_Assembleia_Patrimonio_Afetacaoo__c, 
            Natureza__c, Endere_o__c, Data_de_lan_amento__c, Previs_o_de_entrega__c, Data_de_vistoria_da_area_comum__c, 
            Data_do_Habite_se__c, Data_de_averba_o_do_Habite_se__c, Data_de_entrega_da_area_comum__c, 
            CNPJ__c, Razao_social__c, Construtora__c, Engenheiro_respons_vel__c, Vistoria_da_area_comum__c, 
            Personalizar_kits__c, Kits_de_Personalizacao_definidos__c, Layouts_dos_kits_definidos__c, 
            CD_de_Projetos_em_producao__c, Imagem_Empreendimento__c, data_de_RI_do_empreendimento__c, 
            Cronograma_de_entrega_aprovado__c, Comunicado_de_entrega_enviado__c, Assembleia_de_condominio_realizada__c, 
            Data_cronograma_de_entrega__c, Data_da_assembleia__c, Levantamento_de_saldo_pos_chaves__c, Contato_a_empresa_terceirizada__c, 
            Data_de_revistoria__c, Arquiteto_de_Interiores_pago__c, Projetos_compatibilizados__c, CD_de_Projetos_enviado_aos_clientes__c, 
            Carta_de_Personaliza_o_enviada_clientes__c, Valida_o_do_Cronograma_dePersonaliza_o__c, Kits_Opcionais_definidos__c, 
            Kits_Opcionais_corrigidos__c, Kit_orcado__c, Confer_ncia_de_projetos_e_Memorial_Desc__c, Respons_vel_Personaliza_o__c, 
            Elaboracao_do_CD_do_Cliente__c, Reuni_o_definicao_Kit__c, Elaboracao_Projetos_simplificados__c, CD_de_Projetos_arquivado__c, 
            Datas_conferidas_pelo_CRC__c, Data_de_envio_da_Carta__c, Responsavel_pela_validacao_do_cronograma__c, Data_CND__c, 
            Data_Inclus_o_do_IGPM_e_Price__c, Cart_rio_de_Registro__c, Banco_Financiador_da_Obra__c, Data_Previs_o_de_Entrega__c, 
            Sindico__c, SubSindico__c, Data_Patrim_nio_de_Afeta_o__c, data_prevista_entrega_de_kits__c, data_entrega_de_kits__c, 
            Conselho1__c, Conselho2__c, Conselho3__c, Conselho1_Contato__c, Conselho2_Contato__c, Conselho3_Contato__c, Codigo_Estrutura__c, 
            Habite_se_Confirmado__c, data_do_evento_de_entrega__c, data_prevista_entrega_de_or_amento_de_ki__c, 
            data_entrega_de_or_amento_de_kits__c, Vigencia_Apolice_Seguro_Stand__c, Mostra_PV__c, Gerente_Comercial_Respons_vel__c, 
            Data_Envio_ltimo_Relat_rio__c, Representante1_Afeta_o__c, Representante2_Afeta_o__c, Representante3_Afeta_o__c, 
            Procura_o_Ativa__c, Validade_da_Procura_o__c, PV_Taxa__c, Notas_da_Tabela_de_Vendas__c, Realizacao__c, Incorporacao__c, 
            Construcao__c, Arquitetura__c, Paisagismo__c, Decoracao__c, Localizacao__c, Pre_Lancamento__c, Previsao_de_Entrega__c, 
            Estilo__c, Sistema_de_Vendas__c, Area_do_Terreno__c, Numero_de_Torres__c, Numero_de_Pavimentos__c, Unidades_por_Andar__c, 
            Total_de_Unidades__c, Numero_de_Elevadores__c, Total_de_Vagas__c, Numero_do_RI__c, Numero_da_Matricula__c, N_mero_do_Habite_se__c, 
            Gerente_Comercial_Email__c, Exibe_Escaninho_no_quadro_de_Garagens__c, Utiliza_Tabela_Especial__c, Utiliza_Garagem_Combo__c, 
            Socios_do_Empreendimento__c, NC_A_vista__c, Memorial__c, NC_A_Prazo__c, Brindes_Entregues_ao_CRC__c 
            FROM Empreendimento__c
            WHERE Name =: name
        ];
        return empreendimentos;
    }
}