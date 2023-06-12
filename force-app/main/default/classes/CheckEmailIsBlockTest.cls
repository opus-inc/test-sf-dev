@isTest
public class CheckEmailIsBlockTest {    
    @isTest static void createNewCase() {
       CheckEmailMock.createEmailSpan(1);
        
        Case cs = new Case(Origin='E-mail',
                            SuppliedEmail='test@opus.inc');
            
        insert cs;
    }    
}