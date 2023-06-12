public class ProjectTaskController {
    
    @AuraEnabled
    public static List<ldt_Project__c> getProjects(){
        return [SELECT Id,Name FROM ldt_Project__c];
    }
    
    @AuraEnabled
    public static List<ldt_Task__c> getTasksOfProject(String projectId){
        return [SELECT Id,Name,Start_Date__c,Due_Date__c,Stage__c,Description__c 
                FROM ldt_Task__c
                WHERE Project__c = :projectId];
    }  
    
    @AuraEnabled
    public static ldt_Task__c upsertTask(ldt_Task__c taskRec){
        upsert taskRec;
        return taskRec;
    }
    
    @AuraEnabled
    public static void markTasksAsCompleted(List<ldt_Task__c> tasks){
        update tasks;
    }
    
    @AuraEnabled
    public static void deleteTask(String taskId){
        delete new ldt_Task__c(id=taskId);
    }
    
}