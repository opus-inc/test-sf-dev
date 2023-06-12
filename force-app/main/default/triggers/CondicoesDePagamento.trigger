trigger CondicoesDePagamento on Condi_o_de_Pagamento__c (before insert, before update) {
    CondicoesDePagamentoTriggerHandler handler = new CondicoesDePagamentoTriggerHandler(Trigger.isExecuting, Trigger.size);
    
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