public class IntermediacaoUtils {

    public static Intermediacao__c createIntermediacao(Id propostaVendasId){
        Intermediacao__c intermediacao = IntermediacaoServiceImpl.buildIntermediacao(
            '772.557.450-67', '03588-GO', 'Teste', 2, '62 99999-8888', 'Name Test', propostaVendasId, 'Faturado', 'Teste Observações',
            'Corretor', 'email@email.com'
        );         
        return IntermediacaoServiceImpl.insertIntermediacao(intermediacao);
    }
}