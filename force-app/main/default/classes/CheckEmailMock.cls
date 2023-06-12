@isTest
public class CheckEmailMock {
    public static void createEmailSpan(Integer numSpan) {
        String spans;
        for (Integer i=1;i<=numSpan;i++) {
            spans += 'test' + i + '@test.com;';
        }
                 
        Email_Span__c newEmailSpan = new Email_Span__c(Emails_e_dominios_bloqueados__c=spans);        
        insert newEmailSpan;
    }
}