@isTest
public class TransferMessafingSessionControllerTest {
    @isTest static List<String> createMessagingUserAndMessagingSession() {        
        MessagingEndUser newMessagingEndUser = new MessagingEndUser(
        	MessageType='Whatsapp',
            MessagingConsentStatus='ImplicitlyOptedIn',
            MessagingPlatformKey='whatsapp:+556296690887',
            Name='whatsapp:+556296690887',
            MessagingChannelId='0Mj4w000000blKHCAY'
        );
        insert newMessagingEndUser;
        ID idMessagingEndUser = newMessagingEndUser.id;
        
        MessagingSession newMessagingSession = new MessagingSession(
        	MessagingEndUserId=idMessagingEndUser,
            Status='New',
            MessagingChannelId='0Mj4w000000blKHCAY'
        );
        insert newMessagingSession;
        ID idMessagingSession = newMessagingSession.id;
        
        List<String> data = new List<String>();
        data.add(idMessagingEndUser);
        data.add(idMessagingSession);
        
        
        return data;
    }
    
    @isTest static void getMessagingSessionUser() {
        List<String> getData = createMessagingUserAndMessagingSession();
        String messagingUserId = getData[0];
        String messagingSessionId = getData[1];
        
        String returnUserId = TransferMessagingSessionController.fetchMEU(messagingSessionId);
        
        System.assertEquals(messagingUserId, returnUserId);
        
    }
}