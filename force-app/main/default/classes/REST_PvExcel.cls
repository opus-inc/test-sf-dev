@RestResource(urlMapping='/PvExcel/*')
global class REST_PvExcel {

    global class Pv {
        global String Numero_pasta_Facilita;
        global String Garagem;
        global Double Valor_Tabela;
        global Double VPL_Tabela;
        global Double Valor_da_Proposta;
        global Double VPL_Proposta;
        global String Nome_do_Cliente;
        global String Telefone_do_Cliente;
        global String CPF_do_Cliente;
        global String E_mail_do_Cliente;
        global Double Perc_Comissao_Destacada;
        global Double Perc_Comissao_Faturada;
        global Double Valor_da_Premiacao;
        global String Observacao_do_Cliente;
    }

    global class Condicoes_PvExcel {
        global String Periodicidade_Condicao;
        global Integer Intervalo_das_Parcelas;
        global Integer Quantidade_de_parcelas;
        global Date Inicio_do_Vencimento;
        global Double Valor_Total_das_Parcelas;
        global String Tipo_Tabela;
    }

    global class PF {
        global String Nacionalidade;
        global String Name;
        global String E_mail;
        global Date Data_de_Nascimento;
        global String Telefone_Residencial;
        global String CPF;
        global String Telefone_Celular;
        global String RG;
        global String Profissao;
        global String Orgao_Expedidor;
        global String Estado_Civil;
        global String Endereco_Residencial;
        global String Tipo_de_Uniao;
        global String Nome_Completo_CJ;
        global String E_mail_CJ;
        global Date Data_de_Nascimento_CJ;
        global String Telefone;
        global String CPF_CJ;
        global String Celular_CJ;
        global String RG_CJ;
        global String Profissao_CJ;
        global String Orgao_Expedidor_CJ;
        global String Estado_Civil_CJ;
        global String Endereco_Residencial_CJ;
        global String Tipo_de_Uniao_CJ;
    }

    global class PJ {
        global String Raz_o_Social;
        global String Telefone_Comercial;
        global String CNPJ;
        global String Endereco_Comercial;
        global String Name;
        global String Estado_Civil;
        global String CPF;
        global String Tipo_de_Uniao;
        global String Nacionalidade;
        global String Profissao;
        global String RG;
        global String E_mail;
        global Date Data_de_Nascimento;
        global String Telefone_Residencial;
        global String Orgao_Expedidor;
        global String Telefone_Celular;
        global String Endereco_Residencial;
    }

    global class Intermediacao {
        global String Tipo;
        global String Name;
        global String Telefone_para_Contato;
        global String CPF_CNPJ;
        global String Email;
        global String CRECI;
        global String Tipo_de_Comissao;
        global String Razao_Social;
        global Double Porcentagem;
    }

	@HttpPost
    global static String createNewPv (
        Pv pv,
        List<Condicoes_PvExcel> condicoes,
        List<Intermediacao> intermediacao,
        String Empreendimento_Nome,
        String Unidade_Nome,
        String CPF_Corretor,
        String RecordTypeId,
        PJ pessoa_juridica,
        PF pessoa_fisica
    ) {
        List<Corretores__c> corretor = [SELECT Id, Email__c, E_mail_do_Gerente__c FROM Corretores__c WHERE CPF__c =: CPF_Corretor];
        if(corretor.isEmpty()) {
            //RestContext.response.responseBody = Blob.valueOf('Erro: ' + 'Corretor não encontrado');
            return 'Erro: ' + 'Corretor não encontrado';
        }
        
        List<Empreendimento__c> empreendimento = [SELECT Id FROM Empreendimento__c WHERE Name =: Empreendimento_Nome];
        if(empreendimento.isEmpty()) {
            //RestContext.response.responseBody = Blob.valueOf('Erro: ' + 'Empreendimento não encontrado');
            return 'Erro: ' + 'Empreendimento não encontrado';
        }
        
        List<Unidade__c> unidade = [SELECT Id, Status_da_unidade__c FROM Unidade__c WHERE Name =: Unidade_Nome AND Empreendimento__c =: empreendimento[0].Id];
        if(unidade.isEmpty()) {
            //RestContext.response.responseBody = Blob.valueOf('Erro: ' + 'Unidade não encontrada');
            return 'Erro: ' + 'Unidade não encontrada';
        }
        
        List<Tabela_de_Vendas__c> tabela_venda_ativa = [SELECT Id,Data_da_Tabela__c FROM Tabela_de_Vendas__c WHERE Tipo__c = 'Tabela' AND Status__c = 'Ativa' AND Empreendimento__c =: empreendimento[0].Id];

        if(RecordTypeId != '0124A000001IuzJQAS' && RecordTypeId != '0124A000001IuzOQAS') {
            //RestContext.response.responseBody = Blob.valueOf('Erro: ' + 'Tipo de Proponente não informado');
            return 'Erro: ' + 'Tipo de Proponente não informado';   
        }
        
        if(unidade[0].Status_da_unidade__c != 'Disponível') {
            //RestContext.response.responseBody = Blob.valueOf('Erro: ' + 'Unidade não disponível');
            return 'Erro: ' + 'Unidade não disponível';
        }

        try {
            /*
                Proposta de Vendas
            */
            Proposta_de_Vendas__c newPv = new Proposta_de_Vendas__c();
            newPv.Fase_da_Proposta__c = 'Simulação';
            newPv.Numero_pasta_Facilita__c = pv.Numero_pasta_Facilita;
            newPv.Criado_no_Excel__c = False;
            newPv.Garagem__c = pv.Garagem;
            newPv.Valor_Tabela__c = pv.Valor_Tabela;
            newPv.VPL_Tabela__c = pv.VPL_Tabela;
            newPv.Valor_da_Proposta__c = pv.Valor_da_Proposta;
            newPv.VPL_Proposta__c = pv.VPL_Proposta;
            newPv.Nome_do_Cliente__c = pv.Nome_do_Cliente;
            newPv.Telefone_do_Cliente__c = pv.Telefone_do_Cliente;
            newPv.CPF_do_Cliente__c = pv.CPF_do_Cliente;
            newPv.E_mail_do_Cliente__c = pv.E_mail_do_Cliente;
            newPv.Valor_da_Premiacao__c = pv.Valor_da_Premiacao;
            newPv.Observacao_do_Cliente__c = pv.Observacao_do_Cliente;
            newPv.Empreendimento__c = empreendimento[0].Id;
            newPv.Corretor__c = corretor[0].Id;
            newPv.Email__c = corretor[0].Email__c;
            newPv.E_mail_do_Gerente__c = corretor[0].E_mail_do_Gerente__c;
            newPv.Unidade__c = unidade[0].Id;
            newPv.Criado_no_Excel__c = True;

            //insert newPv;

            /*
                Tabelas
            */
            Tabela_de_Vendas__c tabela_venda = new Tabela_de_Vendas__c();
            tabela_venda.Tipo__c = 'Tabela';
            tabela_venda.Unidade__c = unidade[0].Id;
            tabela_venda.Data_da_Tabela__c = tabela_venda_ativa[0].Data_da_Tabela__c;
            tabela_venda.Proposta_de_Vendas__c = newPv.Id;
            insert tabela_venda;
			newPv.Tabela_de_Vendas_Proposta__c = tabela_venda.Id;
            //update newPv;
            
            Tabela_de_Vendas__c tabelaProposta = new Tabela_de_Vendas__c();
            tabelaProposta.Tipo__c = 'Proposta';
            tabelaProposta.Unidade__c = unidade[0].Id;
            tabelaProposta.Data_da_Tabela__c = date.today();
            tabelaProposta.Proposta_de_Vendas__c = newPv.Id;
            insert tabelaProposta;
            
			newPv.Tabela_da_Proposta__c = tabelaProposta.Id;
            //update newPv;
            
            insert newPv;
            /*
                Condições
            */
            List<Condi_o_de_Pagamento__c> condicoes_list = new List<Condi_o_de_Pagamento__c>();
            for(Condicoes_PvExcel condic : condicoes) {
                Condi_o_de_Pagamento__c new_condicao = new Condi_o_de_Pagamento__c();
                
                if(condic.Tipo_Tabela == 'Vendas') {
                    new_condicao.Tabela_de_Vendas__c = tabela_venda.Id;
                } else {
                    new_condicao.Tabela_de_Vendas__c = tabelaProposta.Id;
                }

                new_condicao.Proposta_de_Vendas__c = newPv.Id;
                new_condicao.Periodicidade_Condicao__c = condic.Periodicidade_Condicao;
                new_condicao.Intervalo_das_Parcelas__c = condic.Intervalo_das_Parcelas;
                new_condicao.Quantidade_de_parcelas__c = condic.Quantidade_de_parcelas;
                new_condicao.In_cio_do_Vencimento__c = condic.Inicio_do_Vencimento;
                new_condicao.Valor_Total_das_Parcelas__c = condic.Valor_Total_das_Parcelas;

                condicoes_list.add(new_condicao);
            }
            insert condicoes_list;

            
            newPv.Perc_Comissao_Destacada__c = pv.Perc_Comissao_Destacada;
            newPv.Perc_Comissao_Faturada__c = pv.Perc_Comissao_Faturada;
            update newPv;
            
            Approval.ProcessSubmitRequest reqApproval = new Approval.ProcessSubmitRequest();
            reqApproval.setComments('Requisição de aprovação feita pelo Integrador do Pv Excel.');
			reqApproval.setProcessDefinitionNameOrId('Aprovacao_da_Proposta');
            reqApproval.setSkipEntryCriteria(true);
			reqApproval.setObjectId(newPv.Id);

			Approval.ProcessResult reqApprovalRequest = Approval.process(reqApproval);
            
            Approval.ProcessWorkitemRequest approveRequest = new Approval.ProcessWorkitemRequest();
            approveRequest.setComments('Aprovação feita pelo Integrador do Pv Excel.');
            approveRequest.setAction('Approve');
            approveRequest.setWorkitemId(reqApprovalRequest.getNewWorkitemIds().get(0));
			
			Approval.ProcessResult approvalResult = Approval.process(approveRequest);
            
            Approval.ProcessWorkitemRequest appReq = new Approval.ProcessWorkitemRequest();
            appReq.setComments('Aprovação feita pelo Integrador do Pv Excel.');
            appReq.setAction('Approve');
            appReq.setWorkitemId(approvalResult.getInstanceId());
            System.assert(approvalResult.isSuccess(), 'Result Status:'+approvalResult.isSuccess());
            
            /*
                Proponentes
            */
            Proponentes__c new_proponentes = new Proponentes__c();
            new_proponentes.Proposta_de_Vendas__c = newPv.Id;
            
            if(RecordTypeId == '0124A000001IuzJQAS') {
                new_proponentes.Nacionalidade__c = pessoa_fisica.Nacionalidade;
                new_proponentes.Name = pessoa_fisica.Name;
                new_proponentes.E_mail__c = pessoa_fisica.E_mail;
                new_proponentes.Data_de_Nascimento__c = pessoa_fisica.Data_de_Nascimento;
                new_proponentes.Telefone_Residencial__c = pessoa_fisica.Telefone_Residencial;
                new_proponentes.CPF__c = pessoa_fisica.CPF;
                new_proponentes.Telefone_Celular__c = pessoa_fisica.Telefone_Celular;
                new_proponentes.RG__c = pessoa_fisica.RG;
                new_proponentes.Profissao__c = pessoa_fisica.Profissao;
                new_proponentes.Orgao_Expedidor__c = pessoa_fisica.Orgao_Expedidor;
                new_proponentes.Estado_Civil__c = pessoa_fisica.Estado_Civil;
                new_proponentes.Endereco_Residencial__c = pessoa_fisica.Endereco_Residencial;
                new_proponentes.Tipo_de_Uniao__c = pessoa_fisica.Tipo_de_Uniao;
                new_proponentes.Nome_Completo_CJ__c = pessoa_fisica.Nome_Completo_CJ;
                new_proponentes.E_mail_CJ__c = pessoa_fisica.E_mail_CJ;
                new_proponentes.Data_de_Nascimento_CJ__c = pessoa_fisica.Data_de_Nascimento_CJ;
                new_proponentes.Telefone__c = pessoa_fisica.Telefone;
                new_proponentes.CPF_CJ__c = pessoa_fisica.CPF_CJ;
                new_proponentes.Celular_CJ__c = pessoa_fisica.Celular_CJ;
                new_proponentes.RG_CJ__c = pessoa_fisica.RG_CJ;
                new_proponentes.Profissao_CJ__c = pessoa_fisica.Profissao_CJ;
                new_proponentes.Orgao_Expedidor_CJ__c = pessoa_fisica.Orgao_Expedidor_CJ;
                new_proponentes.Estado_Civil_CJ__c = pessoa_fisica.Estado_Civil_CJ;
                new_proponentes.Endereco_Residencial_CJ__c = pessoa_fisica.Endereco_Residencial_CJ;
                new_proponentes.Tipo_de_Uniao_CJ__c = pessoa_fisica.Tipo_de_Uniao_CJ;
            }

           if(RecordTypeId == '0124A000001IuzOQAS') {
                new_proponentes.Raz_o_Social__c = pessoa_juridica.Raz_o_Social;
                new_proponentes.Telefone_Comercial__c = pessoa_juridica.Telefone_Comercial;
                new_proponentes.CNPJ__c = pessoa_juridica.CNPJ;
                new_proponentes.Endereco_Comercial__c = pessoa_juridica.Endereco_Comercial;
                new_proponentes.Name = pessoa_juridica.Name;
                new_proponentes.Estado_Civil__c = pessoa_juridica.Estado_Civil;
                new_proponentes.CPF__c = pessoa_juridica.CPF;
                new_proponentes.Tipo_de_Uniao__c = pessoa_juridica.Tipo_de_Uniao;
                new_proponentes.Nacionalidade__c = pessoa_juridica.Nacionalidade;
                new_proponentes.Profissao__c = pessoa_juridica.Profissao;
                new_proponentes.RG__c = pessoa_juridica.RG;
                new_proponentes.E_mail__c = pessoa_juridica.E_mail;
                new_proponentes.Data_de_Nascimento__c = pessoa_juridica.Data_de_Nascimento;
                new_proponentes.Telefone_Residencial__c = pessoa_juridica.Telefone_Residencial;
                new_proponentes.Orgao_Expedidor__c = pessoa_juridica.Orgao_Expedidor;
                new_proponentes.Telefone_Celular__c = pessoa_juridica.Telefone_Celular;
                new_proponentes.Endereco_Residencial__c = pessoa_juridica.Endereco_Residencial;
            }
            insert new_proponentes;

            /*
                Intermediacao
            */
            List<Intermediacao__c> intermediacao_list = new List<Intermediacao__c>();
            for(Intermediacao inter : intermediacao) {
                Intermediacao__c new_intermediacao = new Intermediacao__c();
                new_intermediacao.Proposta_de_Vendas__c = newPv.Id;
                new_intermediacao.Tipo__c = inter.Tipo;
                new_intermediacao.Name = inter.Name;
                new_intermediacao.Telefone_para_Contato__c = inter.Telefone_para_Contato;
                new_intermediacao.CPF_CNPJ__c = inter.CPF_CNPJ;
                new_intermediacao.Email__c = inter.Email;
                new_intermediacao.CRECI__c = inter.CRECI;
                new_intermediacao.Tipo_de_Comissao__c = inter.Tipo_de_Comissao;
                new_intermediacao.Razao_Social__c = inter.Razao_Social;
                new_intermediacao.Porcentagem__c = inter.Porcentagem;

                intermediacao_list.add(new_intermediacao);
            }
            insert intermediacao_list;
            
            newPv.Fase_da_Proposta__c = 'Confecção do Contrato';
            update newPv;
            
            //RestContext.response.responseBody = Blob.valueOf('Proposta de Vendas criada com sucesso. ID: ' + newPv.Id);
            return 'Proposta de Vendas criada com sucesso. Nome: ' + newPv.Name;
        } catch (Exception e) {
            //RestContext.response.responseBody = Blob.valueOf('Erro: ' + e.getMessage());
            return 'Erro: ' + e.getMessage();
        }
    }
}