@isTest
private class CheckEmailTest {
    @isTest static void getBlockedEmailsTest() {
        
        Integer numSpan = 4;
        CheckEmailMock.createEmailSpan(numSpan);
        
        List<String> emailsList = CheckEmail.getBlockedEmails();
        
        System.assertEquals(numSpan, emailsList.size());
    }
}