public with sharing class ProponentesTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob;
    public static boolean isFromUploadAPI = false;
    public Map<Integer, String> fieldNames = new Map<Integer, String>();

    
    public ProponentesTriggerHandler(boolean isExecuting, integer size) {
        m_isExecuting = isExecuting;
        BatchSize = size;

        // fieldNames.put(1, 'Proponente_1__c');
        // fieldNames.put(2, 'Proponente_2__c');
        // fieldNames.put(3, 'Proponente_3__c');
        // fieldNames.put(4, 'Proponente_4__c');
        // fieldNames.put(5, 'Proponente_5__c');
    }

    public void OnAfterInsert(List<Proponentes__c> newProponente) {
        for (Proponentes__c p : newProponente) {
            Account conta = this.CreateAccountToUseInDocugen(p);
            this.UpdatePropostaWithNewAccount(conta, p);
        }
    }

    public void OnAfterUpdate( List<Proponentes__c> newProponente, List<Proponentes__c> oldProponente, Map<ID, Proponentes__c> newProponenteMap , Map<ID, Proponentes__c> oldProponenteMap ) {
        for (Integer i = 0; i < newProponente.size(); i++){
            this.UpdateAccount(newProponente[i], oldProponente[i]);
        }
    }

    public void OnBeforeDelete(List<Proponentes__c> oldProponente) {
        for (Proponentes__c p : oldProponente) {
            this.DeleteAccount(p);
        }
    } 

    private Account CreateAccountToUseInDocugen(Proponentes__c proponente) {
        Account conta = new Account(
            CNPJ__c = proponente.CNPJ__c,
            CPF__c = proponente.CPF__c,
            Email__c = proponente.E_mail__c,
            Name = proponente.Name,
            Phone = proponente.Telefone__c,
            Id_Proponente__c = proponente.Id
        );
        // insert conta;
        return conta;
    }

    // private String findProponenteOnProposta(Id contaId, Proposta_de_Vendas__c propostaVenda) {
    //     String proponenteKey = null;
    //     for (Integer key : fieldNames.keySet()) {
    //         Id proponente = (Id)propostaVenda.get(this.fieldNames.get(key));
    //         if(proponente == contaId) {
    //             proponenteKey = this.fieldNames.get(key);
    //             break;
    //         }
    //     }
    //     return proponenteKey;
    // }

    private void DeleteAccount(Proponentes__c proponente) {
        Account conta = null;
        
        try{
            conta = [SELECT Id
                FROM Account 
                WHERE Id_Proponente__c =: proponente.Id
                LIMIT 1
            ];
        } catch(Exception ex){
            conta = new Account();
        }
        

        // Proposta_de_Vendas__c propostaVenda = [SELECT Id 
                                                    // Proponente_1__c, 
                                                    // Proponente_2__c, 
                                                    // Proponente_3__c, 
                                                    // Proponente_4__c, 
                                                    // Proponente_5__c
                                                // FROM Proposta_de_Vendas__c 
                                                // WHERE Id =: proponente.Proposta_de_Vendas__c
                                            // ];

        // String proponenteKey = findProponenteOnProposta(conta.Id, propostaVenda);

        // if(proponenteKey != null & proponenteKey != '') {
        //     propostaVenda.put(proponenteKey, null);
        //     update propostaVenda;
        // }

        if(conta.Id != null) {
            delete conta;
        }

    }

    private void UpdatePropostaWithNewAccount(Account conta, Proponentes__c newProponente) {
        Proposta_de_Vendas__c propostaVenda = [SELECT Id 
                                                    // Proponente_1__c, 
                                                    // Proponente_2__c, 
                                                    // Proponente_3__c, 
                                                    // Proponente_4__c, 
                                                    // Proponente_5__c
                                                FROM Proposta_de_Vendas__c 
                                                WHERE Id =: newProponente.Proposta_de_Vendas__c
                                            ];

        // String proponenteKey = findProponenteOnProposta(null, propostaVenda);

        // if(proponenteKey != null & proponenteKey != '') {
        //     propostaVenda.put(proponenteKey, conta.Id);
        //     update propostaVenda;
        // }
    }

    private void UpdateAccount(Proponentes__c newProponente, Proponentes__c oldProponente) {
        Account conta = null;
        
        try{
            conta = [SELECT Id
                FROM Account 
                WHERE Id_Proponente__c =: newProponente.Id
                LIMIT 1
            ];
        } catch(Exception ex){
            conta = new Account(
                Id_Proponente__c = newProponente.Id
            );
        }

        conta.CNPJ__c = newProponente.CNPJ__c;
        conta.CPF__c = newProponente.CPF__c;
        conta.Email__c = newProponente.E_mail__c;
        conta.Name = newProponente.Name;
        conta.Phone = newProponente.Telefone__c;

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