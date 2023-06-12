public class TransferMessagingSessionController {
    
    @AuraEnabled
    public static String fetchMEU( String messagingSessionId ) {
        
        return [ 
            SELECT MessagingEndUserId
            FROM MessagingSession 
            WHERE Id =: messagingSessionId
        ][ 0 ].MessagingEndUserId;
        
    }
 
}