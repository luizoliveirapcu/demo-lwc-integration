public with sharing class RestIntegration {
    private static final RestIntegration instance = new RestIntegration();
    public static RestIntegration getInstance() {
        return instance;
    }

    public HttpResponse executeCallout(
        String method,
        String endpoint,
        String path,
        String body,
        Map<String, String> headers
    ) {
        HttpRequest request = new HttpRequest();
        request.setMethod(method);
        request.setEndpoint(endpoint + path);
        
        if (!String.isEmpty(body)) {
            request.setBody(body);
        }

        if (headers == null) {
            headers = new Map<String, String>();
        }

        for (String headerKey : headers.keySet()) {
            request.setHeader(headerKey, headers.get(headerKey));
        }

        System.debug(new Map<String, Object>{ 'method' => method });
        System.debug(new Map<String, Object>{ 'endpoint' => endpoint });
        System.debug(new Map<String, Object>{ 'path' => path });
        System.debug(new Map<String, Object>{ 'body' => body });
        System.debug(new Map<String, Object>{ 'headers' => headers });

        return validateResponse(new Http().send(request));
    }

    public HttpResponse validateResponse(HttpResponse response) {
        if (response == null) {
            throw new RestIntegrationException('Resposta do servidor inválida.');
        }

        if (response.getBody() != null) {
            System.debug(LoggingLevel.INFO, 
                String.format(
                    'RESPONSE: {0} - {1}',
                    new List<Object>{ response.getStatusCode(), response.getBody() }
                )
            );
        }

        switch on (response.getStatusCode() / 100) {
            when 2, 3 {
                return response;
            }
            when 4, 5 {
                
                throw new RestIntegrationException(
                    String.format(
                        'ERRO DE SERVIÇO: ({0}) {1}',
                        new List<Object>{ response.getStatusCode(), response.getStatus() }
                    )
                );
            }
            when else {
                throw new RestIntegrationException(
                    'ERRO DE SERVIÇO: Resposta inesperada do servidor'
                );
            }
        }
    }

    public class RestIntegrationException extends Exception {
    }
}