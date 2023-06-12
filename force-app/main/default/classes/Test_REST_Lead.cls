@isTest
public class Test_REST_Lead { 
    public class LeadUtil {
    	public String nome = 'teste 1';
        public String email = 'email@email.com';
        public String telefone = '55629841103161';
        public String produto = 'CONDOMINIO DECK 23';
        public String stand = 'Central de Decorados';
        public DateTime data_visita = datetime.now();
        public String aceite = 'Sim';
        public String tipo = 'Stand de Vendas';
        public String cpf = '470.315.950-37';
        
        public LeadUtil() {
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
        }
    }
        
    private static Lead parse(String json) {
		return (Lead) System.JSON.deserialize(json, Lead.class);
	}
    
	static testMethod void test_doInvoice(){
        LeadUtil leadUtil = new LeadUtil();

        Test.startTest();
        	string newLead = REST_Lead.createLead(
                leadUtil.nome,
                leadUtil.email,
                leadUtil.cpf,
                leadUtil.tipo,
                leadUtil.telefone,
                leadUtil.produto,
                leadUtil.stand,
                'Não',
                leadUtil.data_visita
            );
        	string repeatedLead = REST_Lead.createLead(
                leadUtil.nome,
                leadUtil.email,
                leadUtil.cpf,
                leadUtil.tipo,
                leadUtil.telefone,
                leadUtil.produto,
                leadUtil.stand,
                leadUtil.aceite,
                leadUtil.data_visita
            );
        Lead parseRepeated = parse(repeatedLead);

        try {
            Lead parsedLead = parse(newLead);
            System.assertEquals(leadUtil.email, parsedLead.Email_new__c);
        } catch (Exception e) {}
        Test.stopTest(); 
    }
}