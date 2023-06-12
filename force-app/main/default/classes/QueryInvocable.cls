public class QueryInvocable {
    public class QueryInput {
        @InvocableVariable(required=true)
        public String soqlQuery;
    }

    @InvocableMethod(label='Execute SOQL Query' description='Retorna os resultados de uma única query SOQL como uma lista de SObjects do tipo especificado.')
    public static List<List<SObject>> executeQuery(List<QueryInput> inputs) {
        if (inputs == null || inputs.size() != 1) {
            throw new IllegalArgumentException('Apenas uma entrada é permitida por chamada.');
        }

        QueryInput input = inputs[0];
        String soqlQuery = input.soqlQuery;

        // Faz a query.
        List<SObject> sObjects = Database.query(soqlQuery);

        // Retorne a lista de SObjects. Os SObjects serão do tipo especificado na query.
        return new List<List<SObject>>{sObjects};
    }
}