trigger DfsleEnvelopeTrigger on dfsle__Envelope__c (before insert) {
    if( Trigger.isInsert ) {
        if(Trigger.isBefore) {
            for (dfsle__Envelope__c envelope : Trigger.New) {
                if(envelope.dfsle__SourceId__c != null) {
                    Id sourceId = Id.valueOf(envelope.dfsle__SourceId__c);
                    String objectName = sourceId.getSObjectType().getDescribe().getName();
                    envelope.SourceObjectName__c = objectName;
                }
            }
        }
    }
}