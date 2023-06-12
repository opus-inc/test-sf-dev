public class CheckEmail {   
    public static List<String> getBlockedEmails() {
        Email_Span__c emails = [SELECT Emails_e_dominios_bloqueados__c FROM Email_Span__c LIMIT 1];
 
        if (emails.Emails_e_dominios_bloqueados__c != null) {
            List<String> emailList = emails.Emails_e_dominios_bloqueados__c.split(';');
            return emailList;
        }
        
        return null;        

    }
}