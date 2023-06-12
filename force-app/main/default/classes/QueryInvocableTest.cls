@isTest
public class QueryInvocableTest {
    @isTest
    static void testExecuteQuery() {
        // Crie alguns dados de teste.
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Crie um objeto QueryInput com uma consulta SOQL.
        QueryInvocable.QueryInput input = new QueryInvocable.QueryInput();
        input.soqlQuery = 'SELECT Id, Name FROM Account WHERE Id = \'' + testAccount.Id + '\'';

        // Execute a query e verifique os resultados.
        List<List<SObject>> results = QueryInvocable.executeQuery(new List<QueryInvocable.QueryInput>{input});
        System.assertEquals(1, results.size());
        System.assertEquals(1, results[0].size());
        System.assertEquals(testAccount.Id, results[0][0].Id);
    }

    @isTest
    static void testMultipleInputs() {
        // Crie dois objetos QueryInput.
        QueryInvocable.QueryInput input1 = new QueryInvocable.QueryInput();
        input1.soqlQuery = 'SELECT Id FROM Account';
        QueryInvocable.QueryInput input2 = new QueryInvocable.QueryInput();
        input2.soqlQuery = 'SELECT Id FROM Contact';

        // Tente executar a query com duas entradas e verifique se uma exceção é lançada.
        Boolean exceptionThrown = false;
        try {
            QueryInvocable.executeQuery(new List<QueryInvocable.QueryInput>{input1, input2});
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assert(exceptionThrown);
    }
}