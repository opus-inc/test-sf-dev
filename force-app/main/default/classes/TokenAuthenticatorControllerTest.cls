@IsTest
public class TokenAuthenticatorControllerTest {
    @TestSetup
    private static void testSetup(){
        Corretores__c corretor = new Corretores__c(
            Name = 'Teste1',
            Origem__c = 'Salesforce',
            CPF__c = '12345678900',
            Token__c = 'FAF123',
            Email__c = 'test@test.com',
            Pin__c = 2222
        );
        insert corretor;
    }
 
    @IsTest
    private static void shouldUpdateAndSendToken(){
        Test.startTest();
        Boolean isValid =  TokenAuthenticatorController.updateAndSendToken('12345678900');
        Corretores__c corretor = [SELECT Id,Token__c FROM Corretores__c WHERE CPF__C = '12345678900'];
        System.assert(corretor.Token__c!='FAF123');
        Test.stopTest();
    }

    @IsTest
    private static void shouldValidateCPFAndToken(){
        Test.startTest();
        Corretores__c corretor = (Corretores__c) TokenAuthenticatorController.validateCPFAndToken('12345678900', 'FAF123');
        System.assert(corretor!=null);
        Test.stopTest();
    }

    @IsTest
    private static void shouldGeneratePin() {
        Test.startTest();
        Corretores__c corretor = [SELECT Id,Token__c FROM Corretores__c WHERE CPF__C = '12345678900'];
        Corretores__c updatedCorretor = TokenAuthenticatorController.generatePin(corretor.Id);
        System.assert(updatedCorretor.Pin__c != null);
        Test.stopTest();
    }

    @IsTest
    private static void shouldAutenticateWithPin() {
        Test.startTest();
        Corretores__c corretor = [SELECT Id,CPF__C,Pin__c FROM Corretores__c WHERE CPF__C = '12345678900'];
        Id corretorId = TokenAuthenticatorController.autenticateWithPin(corretor.CPF__c, 2222);
        System.assert(corretorId == corretor.Id);
        Test.stopTest();
    }


}