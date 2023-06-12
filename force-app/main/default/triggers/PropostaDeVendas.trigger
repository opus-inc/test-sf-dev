trigger PropostaDeVendas on Proposta_de_Vendas__c (before insert, before update) {
    PropostaDeVendasTriggerHandler handler = new PropostaDeVendasTriggerHandler(Trigger.isExecuting, Trigger.size);
    
    if( Trigger.isInsert ) {
        if(Trigger.isBefore) {
            handler.OnBeforeInsert(Trigger.New);
        }
    } else if ( Trigger.isUpdate ) {
        if(Trigger.isBefore) {
            handler.OnBeforeUpdate(Trigger.New, Trigger.Old, Trigger.NewMap, Trigger.OldMap);
        }
    }
}