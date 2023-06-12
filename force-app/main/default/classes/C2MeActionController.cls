public without sharing class C2MeActionController {
    @AuraEnabled
    public static void finishConversation(String chatt2meNumberId, String chatt2meContactId, String finishMessage, String conversationStep, Boolean archived) {
        C2Me__Chatt2me_Contact__c c2meContact = [SELECT Id,
                                                        C2Me__Chatt2me_Number__c,
                                                        C2Me__Chatt2me_Number__r.C2Me__Phone__c
                                                FROM C2Me__Chatt2me_Contact__c
                                                WHERE Id =: chatt2meContactId];
        
        //Get Bot Chatt2me_Number
        C2Me__Chatt2meNumber__c bot = [SELECT Id 
                                        FROM C2Me__Chatt2meNumber__c 
                                        WHERE C2Me__Phone__c = :c2meContact.C2Me__Chatt2me_Number__r.C2Me__Phone__c AND 
                                        C2Me__Status__c = 'Active' AND 
                                        C2Me__Default__c = TRUE];

        c2meContact.Step__c = conversationStep;
        c2meContact.Session_Id__c = null;
        c2meContact.C2Me__Chatt2me_Number__c = bot.Id;
        update c2meContact;

        C2Me__Conversation__c messageFeedBack = new C2Me__Conversation__c();
        messageFeedBack.C2Me__Message__c = finishMessage; 

        messageFeedBack.C2Me__Chatt2me_Number__c = chatt2meNumberId; 
        messageFeedBack.C2Me__Chatt2me_Contact__c = chatt2meContactId; 
        messageFeedBack.C2Me__Direction__c = 'OUT'; 
        messageFeedBack.C2Me__Type__c = 'Text'; 
        messageFeedBack.C2Me__Status__c = 'Pending Submission';
        insert messageFeedBack;
        
        C2Me__Chatt2me_Contact_Share__c contactShare =  [SELECT Id, C2Me__Archived__c
                                                        FROM C2Me__Chatt2me_Contact_Share__c
                                                        WHERE C2Me__Chatt2me_Contact__c =: chatt2meContactId
                                                        AND C2Me__Chatt2me_Number__c =: chatt2meNumberId
                                                        LIMIT 1];

        contactShare.C2Me__Archived__c = archived;
        update contactShare;
    }

    @AuraEnabled
    public static List<C2Me__Chatt2meNumber__c> getChatt2meNumbers(String chatt2meNumberId) {
        C2Me__Chatt2meNumber__c currentNumber = [ SELECT C2Me__Phone__c
                                                FROM C2Me__Chatt2meNumber__c
                                                WHERE Id =: chatt2meNumberId];

        return [SELECT Id, C2Me__Display_Name__c, C2Me__Phone__c
                FROM C2Me__Chatt2meNumber__c
                WHERE C2Me__Status__c = 'Active'
                AND C2Me__Phone__c =: currentNumber.C2Me__Phone__c
                AND Id !=: chatt2meNumberId];
    }

    @AuraEnabled
    public static String getDepartamentName(String chatt2meContactId) {
        C2Me__Chatt2me_Contact__c c2meContact = [SELECT Id,
                                                        C2Me__Chatt2me_Number__c,
                                                        C2Me__Chatt2me_Number__r.C2Me__Default__c,
                                                        C2Me__Chatt2me_Number__r.C2Me__Display_Name__c
                                                FROM C2Me__Chatt2me_Contact__c
                                                WHERE Id =: chatt2meContactId];

        return c2meContact.C2Me__Chatt2me_Number__r.C2Me__Display_Name__c;
    }

    @AuraEnabled
    public static void setNewDepartament(String chatt2meNumberId, String newChatt2meDepartId, String chatt2meContactId, String message){
        List<C2Me__Conversation__c> c2meConversationList = [SELECT Id,
                                                                    C2Me__Chatt2me_Number__c,
                                                                    C2Me__Chatt2me_Contact__c
                                                            FROM C2Me__Conversation__c
                                                            WHERE C2Me__Chatt2me_Number__c =: chatt2meNumberId
                                                            AND C2Me__Chatt2me_Contact__c =: chatt2meContactId];
        
        if(chatt2meNumberId != newChatt2meDepartId){
            
            if(c2meConversationList.size() > 0){
                for(C2Me__Conversation__c conversation : c2meConversationList){
                    conversation.C2Me__Chatt2me_Number__c = newChatt2meDepartId;
                }

                update c2meConversationList;
            }

            C2Me__Conversation__c newMessage = new C2Me__Conversation__c();
            newMessage.C2Me__Message__c = message; 
            newMessage.C2Me__Chatt2me_Number__c = newChatt2meDepartId; 
            newMessage.C2Me__Chatt2me_Contact__c = chatt2meContactId; 
            newMessage.C2Me__Direction__c = 'IN'; 
            newMessage.C2Me__Type__c = 'Text'; 
            newMessage.C2Me__Status__c = 'Sent';

            C2Me__Chatt2me_Contact__c c2meContact = [SELECT Id,
                                                            C2Me__Chatt2me_Number__c,
                                                            Step__c
                                                    FROM C2Me__Chatt2me_Contact__c
                                                    WHERE Id =: chatt2meContactId];

            c2meContact.C2Me__Chatt2me_Number__c = newChatt2meDepartId;
            c2meContact.Step__c = 'step-atendimento';
            update c2meContact;
            
            createContactShare(newChatt2meDepartId, chatt2meContactId);

            insert newMessage;

            C2Me__Chatt2me_Contact_Share__c oldContactShare = [SELECT C2Me__Archived__c
                                                            FROM C2Me__Chatt2me_Contact_Share__c
                                                            WHERE C2Me__Chatt2me_Number__c =: chatt2meNumberId
                                                            AND C2Me__Chatt2me_Contact__c =: chatt2meContactId];

            oldContactShare.C2Me__Archived__c = true;
            update oldContactShare;     
        } else {
            throw new C2MeConversationException('Este contato já está falando com o departamento escolhido');
        }
    }

    private static void createContactShare(String newChatt2meDepartId, String chatt2meContactId) {
        C2Me__Chatt2me_Contact_Share__c contactShare = new C2Me__Chatt2me_Contact_Share__c();
        contactShare.C2Me__Chatt2me_Number__c = newChatt2meDepartId;
        contactShare.C2Me__Chatt2me_Contact__c = chatt2meContactId;
        contactShare.C2Me__Token__c = getMd5((String) contactShare.C2Me__Chatt2me_Number__c + (String) contactShare.C2Me__Chatt2me_Contact__c);
        contactShare.C2Me__Archived__c = false;

        upsert contactShare C2Me__Token__c;
    }

    public static String getMd5(String stringData) {
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(stringData));
        return EncodingUtil.convertToHex(hash);
    }

    private class C2MeConversationException extends Exception {}
}