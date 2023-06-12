trigger TriggerCheckEmailIsBlock on Case (before insert) {
    List<String> emailsList = CheckEmail.getBlockedEmails();
    
    for (Case currentCase : Trigger.new) {    
        String emailWeb = currentCase.SuppliedEmail;
        
        if (emailWeb != null) {            
             Boolean validation = false;        
            if (emailsList != null) {
                for (String currentEmail : emailsList) {
                    validation = currentEmail.contains(emailWeb);
                    
                    if (validation) {
                        break;
                    }
                }
            }
            
            if (currentCase.Status == 'Novo' && currentCase.Origin == 'E-mail' && validation) {
                currentCase.addError('E-mail da web informado é span!');
            }
        }
        	
       
    }
}