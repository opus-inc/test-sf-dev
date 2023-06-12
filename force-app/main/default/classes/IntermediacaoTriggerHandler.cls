public with sharing class IntermediacaoTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob;
    public static boolean isFromUploadAPI = false;
    public Map<Integer, String> fieldNames = new Map<Integer, String>();

    
    public IntermediacaoTriggerHandler(boolean isExecuting, integer size) {
        m_isExecuting = isExecuting;
        BatchSize = size;

        // fieldNames.put(1, 'Intermediacao_1__c');
        // fieldNames.put(2, 'Intermediacao_2__c');
        // fieldNames.put(3, 'Intermediacao_3__c');
        // fieldNames.put(4, 'Intermediacao_4__c');
        // fieldNames.put(5, 'Intermediacao_5__c');
    }

    public void OnAfterInsert(List<Intermediacao__c> newIntermediacao) {
        for (Intermediacao__c p : newIntermediacao) {
            Account conta = this.CreateAccountToUseInDocugen(p);
            this.UpdatePropostaWithNewAccount(conta, p);
        }
    }

    public void OnAfterUpdate( List<Intermediacao__c> newIntermediacao, List<Intermediacao__c> oldIntermediacao, Map<ID, Intermediacao__c> newIntermediacaoMap , Map<ID, Intermediacao__c> oldIntermediacaoMap ) {
        for (Integer i = 0; i < newIntermediacao.size(); i++){
            this.UpdateAccount(newIntermediacao[i], oldIntermediacao[i]);
        }
    }

    public void OnBeforeDelete(List<Intermediacao__c> oldIntermediacao) {
        for (Intermediacao__c p : oldIntermediacao) {
            this.DeleteAccount(p);
        }
    } 

    private Account CreateAccountToUseInDocugen(Intermediacao__c intermediacao) {
        Account conta = new Account(
            Email__c = intermediacao.Email__c,
            Name = intermediacao.Name,
            Phone = intermediacao.Telefone_para_Contato__c,
            Id_Intermediacao__c = intermediacao.Name
        );
        insert conta;
        return conta;
    }

    // private String findIntermediacaoOnProposta(Id contaId, Proposta_de_Vendas__c propostaVenda) {
    //     String intermediacaoKey = null;
    //     for (Integer key : fieldNames.keySet()) {
    //         Id intermediacao = (Id)propostaVenda.get(this.fieldNames.get(key));
    //         if(intermediacao == contaId) {
    //             intermediacaoKey = this.fieldNames.get(key);
    //             break;
    //         }
    //     }
    //     return intermediacaoKey;
    // }

    private void DeleteAccount(Intermediacao__c intermediacao) {
        Account conta = null;
        
        try{
            conta = [SELECT Id
                FROM Account 
                WHERE Id_Intermediacao__c =: intermediacao.Id
                LIMIT 1
            ];
        } catch(Exception ex){
            conta = new Account();
        }

        // Proposta_de_Vendas__c propostaVenda = [SELECT Id
        //                                             // Intermediacao_1__c, 
        //                                             // Intermediacao_2__c, 
        //                                             // Intermediacao_3__c, 
        //                                             // Intermediacao_4__c, 
        //                                             // Intermediacao_5__c
        //                                         FROM Proposta_de_Vendas__c 
        //                                         WHERE Id =: intermediacao.Proposta_de_Vendas__c
        //                                     ];

        // String intermediacaoKey = findIntermediacaoOnProposta(conta.Id, propostaVenda);

        // if(intermediacaoKey != null & intermediacaoKey != '') {
        //     propostaVenda.put(intermediacaoKey, null);
        //     update propostaVenda;
        // }

        if(conta.Id != null) {
            delete conta;
        }
    }

    private void UpdatePropostaWithNewAccount(Account conta, Intermediacao__c newIntermediacao) {
        Proposta_de_Vendas__c propostaVenda = [SELECT Id
                                                    // Intermediacao_1__c, 
                                                    // Intermediacao_2__c, 
                                                    // Intermediacao_3__c, 
                                                    // Intermediacao_4__c, 
                                                    // Intermediacao_5__c
                                                FROM Proposta_de_Vendas__c 
                                                WHERE Id =: newIntermediacao.Proposta_de_Vendas__c
                                            ];

        // String intermediacaoKey = findIntermediacaoOnProposta(null, propostaVenda);

        // if(intermediacaoKey != null & intermediacaoKey != '') {
        //     propostaVenda.put(intermediacaoKey, conta.Id);
        //     update propostaVenda;
        // }
    }

    private void UpdateAccount(Intermediacao__c newIntermediacao, Intermediacao__c oldIntermediacao) {
        Account conta = null;
        
        try{
            conta = [SELECT Id
                FROM Account 
                WHERE Id_Intermediacao__c =: newIntermediacao.Id
                LIMIT 1
            ];
        } catch(Exception ex){
            conta = new Account(
                Id_Intermediacao__c = newIntermediacao.Id
            );
        }

        conta.Email__c = newIntermediacao.Email__c;
        conta.Name = newIntermediacao.Name;
        conta.Phone = newIntermediacao.Telefone_para_Contato__c;

        upsert conta;
    }

    public boolean IsTriggerContext {
        get{ return m_isExecuting;}
    }
    
    public boolean IsVisualforcePageContext {
        get{ return !IsTriggerContext;}
    }
    
    public boolean IsWebServiceContext {
        get{ return !IsTriggerContext;}
    }
    
    public boolean IsExecuteAnonymousContext {
        get{ return !IsTriggerContext;}
    }

}