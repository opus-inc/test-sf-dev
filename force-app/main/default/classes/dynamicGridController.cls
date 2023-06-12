public without sharing class dynamicGridController {
    
    @AuraEnabled(cacheable =true)
    public static List<SObject> getData(String sObjectName, String fieldsNames, String whereCondition, String adicionalConditions, String searchValue, Integer pageSize, Integer pagenumber) {
        
        Set<Id> searchIds;
        if(String.isNotBlank(searchValue) && searchValue != null){
            String searchQuery =  'FIND \'' + searchValue + '\' RETURNING ' + sObjectName;
            List<List<sObject>> lstIds = search.query(searchQuery);

            searchIds = new Set<Id>();
            for(sObject obj : lstIds[0]) {
                searchIds.add(obj.Id);
            }
        }
        
        String query = 'SELECT ' + String.escapeSingleQuotes(fieldsNames);
        query += ' FROM ' + String.escapeSingleQuotes(sObjectName);

        if (String.isNotBlank(whereCondition) && whereCondition != null){
            query += ' WHERE ' + whereCondition;
        }

        if (searchIds != null) {
            if (query.indexOf('WHERE')>=0) {
                query += ' AND ';
            } else {
                query += ' WHERE ';
            }
            query += ' Id IN :searchIds';   
        }
        if (String.isNotBlank(adicionalConditions) && adicionalConditions != null){
            query += ' ' + String.escapeSingleQuotes(adicionalConditions);
        }
        if(pageSize != null){
            query += ' LIMIT ' + pageSize + ' offset ' + (pageSize * (pagenumber - 1));
        }

        return Database.query(query);
    }
    
    @AuraEnabled(cacheable = true)  
    public static Integer getRecordListCount(String sObjectName, String whereCondition, String searchValue, Integer pagenumber) {  
        Set<Id> searchIds;
        if(String.isNotBlank(searchValue) && searchValue != null){
            String searchQuery =  'FIND \'' + searchValue + '\' RETURNING ' + sObjectName;
            List<List<sObject>> lstIds = search.query(searchQuery);

            searchIds = new Set<Id>();

            for(sObject obj : lstIds[0]) {
                searchIds.add(obj.Id);
            }
            
        }
        String query = 'SELECT count() ' ;
        query += ' FROM ' + String.escapeSingleQuotes(sObjectName);

        if (String.isNotBlank(whereCondition) && whereCondition != null){
            query += ' WHERE ' + whereCondition;
        }

        if (searchIds != null) {
            if (query.indexOf('WHERE')>=0) {
                query += ' AND ';
            } else {
                query += ' WHERE ';
            }
            query += ' Id IN :searchIds';
        }
        
        return Database.countQuery(query);  
    }
    
    @AuraEnabled(cacheable =true)
    public static List<DynamicGridColumn> getColumns(String sObjectName, String fieldsNames) {
        Schema.DescribeSObjectResult d = Schema.describeSObjects(new String[]{sObjectName})[0];
        Map<String, Schema.SObjectField> mapFields = d.fields.getMap();

        List<DynamicGridColumn> result = new List<DynamicGridColumn>();
        List<String> fnames = fieldsNames.split(',');

        for(String s : fnames) {
            if (mapFields.containsKey(s.trim())) {
                String label = mapFields.get(s.trim()).getDescribe().getLabel();
                String type = String.Valueof(mapFields.get(s.trim()).getDescribe().getType());

                system.debug(type);
                result.add(new DynamicGridColumn(label, s.trim(), type));
            }
            else {
                result.add(new DynamicGridColumn(s.trim(), s.trim(), 'text'));
            }
        }

        return result;
    }

    @AuraEnabled
    public static List<Proposta_de_Vendas__c> deleteData(List<String> ids) {
        List<Proposta_de_Vendas__c> propostas = [SELECT Id, Versao_PV__c FROM Proposta_de_Vendas__c WHERE Id IN :ids];
        for(Proposta_de_Vendas__c proposta : propostas) {
            proposta.Versao_PV__c = '0';
        }
        update propostas;
        return propostas;
    }
    
    @AuraEnabled
    public static Proposta_de_Vendas__c deleteOne(String id) {
        Proposta_de_Vendas__c proposta = [SELECT Id, Versao_PV__c FROM Proposta_de_Vendas__c WHERE Id =:id];
        proposta.Versao_PV__c = '0';
        update proposta;
        return proposta;
    } 
            
    public class DynamicGridColumn{
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public String fieldName {get;set;}
        @AuraEnabled
        public String type {get;set;}
    
        public DynamicGridColumn(String label, String fieldName, String type){
            this.label = label;
            this.fieldName = fieldName;
            this.type = convertType(type);
        }

        private String convertType(String currentTyype) {
            currentTyype = currentTyype.toUppercase();
            switch on currentTyype {
                when 'BOOLEAN' {
                    return 'boolean';
                }
                when 'CURRENCY' {
                    return 'currency';
                }
                when 'URL' {
                    return 'url';
                }
                when 'PHONE' {
                    return 'phone';
                }
                when 'STRING' {
                    return 'text';
                }
                when 'PERCENT' {
                    return 'percent';
                }
                when 'INTEGER'{
                    return 'number';
                }
                when 'LONG' {
                    return 'number';
                }
                when 'DOUBLE' {
                    return 'number';
                }
                when 'EMAIL' {
                    return 'email';
                }
                when 'DATE' {
                    return 'date';
                }
                when 'DATETIME' {
                    return 'date';
                }
                when else {
                    return 'text';
                }
            }
        }
    }
}