trigger HelpdeskArticle on HelpDesk_Nota__c (after insert, after update) {
    for( Id articleId : Trigger.newMap.keySet() ) {
        if(Trigger.newMap.get( articleId ).Status_Sincronizacao__c == 'Pendente') {
            HelpDesk_Nota__c nota = RestCreateArticle.getNotaById(articleId);
            
            RestCreateArticle.createArticleInOtrs(JSON.serialize(nota));
        }
    }
}