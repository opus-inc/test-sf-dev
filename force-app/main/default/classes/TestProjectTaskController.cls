@isTest
public class TestProjectTaskController {
	
    static testMethod void testMethod1(){
        ldt_Project__c[] projects = new ldt_Project__c[]{
        	new ldt_Project__c(Name = 'Test Project1'),
            new ldt_Project__c(Name = 'Test Project2')
        };
        
        insert projects;
        
        
        ldt_Task__c[] tasks = new ldt_Task__c[]{
        	new ldt_Task__c(Name = 'Test Task1',Project__c = projects[0].id),
            new ldt_Task__c(Name = 'Test Task2',Project__c = projects[1].id)
        };
        
        insert tasks;

        ProjectTaskController.getProjects();
        List<ldt_Task__c> projTasks = ProjectTaskController.getTasksOfProject(projects[0].id);
        
        System.assertEquals(projTasks.size(),1);
        
        for(ldt_Task__c task : tasks){
            task.Stage__c = 'Completed';
        }
        
        ProjectTaskController.markTasksAsCompleted(tasks);
        
        ldt_Task__c task = tasks[0];
        task.Stage__c = 'Closed';
        ProjectTaskController.upsertTask(task);
        
        ProjectTaskController.deleteTask(task.id);        
    }
    
}