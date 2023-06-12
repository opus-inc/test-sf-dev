public without sharing class TokenAuthenticatorController {
    private final static String kHexChars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

    public static String generateToken(Integer size) {
        String nextCode = '';
        Integer nextByte = 0;

        for (Integer i = 0; i < size; i++) {
            nextByte = (Math.round(Crypto.getRandomInteger() * 255)) & 255;
            Integer index = Math.mod(i, 2) == 0 ? (nextByte >> 4) : (nextByte & 35);
            nextCode += kHexChars.substring(index, index + 1);
        }

        return nextCode;
    }

    @AuraEnabled
    public static Object validateCPFAndToken(String cpf,String token){
        System.debug('cpf '+ cpf);
        Corretores__c corretor = new Corretores__c();
        try {
            if(cpf != null){
                List<Corretores__c> corretores = [SELECT Id,Token__c,TokenActive__c,Token_2__c FROM Corretores__c WHERE CPF_Numeros__c =: cpf];
                
                if(!corretores.isEmpty() 
                && corretores[0].Token_2__c == token){
                    corretor = corretores[0];
                }
            }
            return corretor;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled    
    public static Boolean updateAndSendToken(String cpf){
        Boolean isValid = false;
        try {
            String generatedToken = generateToken(6);
            List<Corretores__c> corretores = [SELECT Id, Email__c FROM Corretores__c WHERE CPF_Numeros__c =: cpf];
            Corretores__c corretor = new Corretores__c();
            System.debug('corretores ' + corretores);
            if(!corretores.isEmpty()){                
                corretor = corretores[0];
                corretor.Token__c = generatedToken;
                corretor.LastTokenUpdate__c = DateTime.now();
                corretor.Envia_Token__c = true;
                update corretor;
                isValid = true;
                // sendToken(corretor);
            }
            return isValid;           
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Id autenticateWithPin(String cpf, Integer pin) {
        try {
            Corretores__c corretores = [SELECT Id, Email__c FROM Corretores__c WHERE CPF_Numeros__c =: cpf AND Pin__c =: pin];

            return corretores.Id;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Corretores__c generatePin(Id corretorId){
        try {
            Integer pin = Integer.valueof(generateRandomNumber(4));
            Corretores__c corretor = [SELECT 
                    Id,
                    Name, 
                    Pin__c,
                    CPF__c,
                    Email__c,
                    Usuario_Master__c  FROM Corretores__c WHERE Id = :corretorId];
            corretor.Pin__c = pin;
            update corretor;
            return corretor;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * @param length The number of digits to return
     * @return a random number the length of the input param length
     * @description one limitation, will never start with 0
     */
    private static String generateRandomNumber(Integer length) {
        String result = '';
        while(result.length() < length){
           //Math.abs used to cast Crypto.getRandomLong() to a positive number
           result += String.valueOf(Math.abs(Crypto.getRandomLong()));
        }
        return result.substring(0,length);
    }
}