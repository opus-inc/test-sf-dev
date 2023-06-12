public class HttpRequestHelper {

    public static String makeHttpRequest(String url, String method, Map<String, String> headers, Map<String, String> params, String payload) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        // Configurar URL
        if (params != null && !params.isEmpty()) {
            String queryString = '';
            for (String key : params.keySet()) {
                if (queryString != '') {
                    queryString += '&';
                }
                queryString += key + '=' + params.get(key);
            }
            url += '?' + queryString;
        }
        request.setEndpoint(url);
        
        // Configurar método
        request.setMethod(method);

        // Configurar headers
        if (headers != null) {
            System.debug(headers);
            for (String key : headers.keySet()) {
                request.setHeader(key, headers.get(key));
            }
        }

        // Configurar payload
        if (payload != null) {
            request.setBody(payload);
        }

        // Enviar requisição e retornar JSON de resposta
        try {
            HttpResponse response = http.send(request);
            return response.getBody();
        } catch (Exception e) {
            System.debug('Erro ao fazer requisição HTTP: ' + e.getMessage());
            return null;
        }
    }
}