public inherited sharing class CardSecondLifeService {
    
    private static CardSecondLifeService instance {
        get {
            if(instance == null) {
                instance = new CardSecondLifeService();
            }
            return instance;
        }
        private set;
    }

    public static CardSecondLifeService getInstance() {
        return instance;
    }

    public Success execute(String contaCorrente, String cpfCnpj, CreditCard card) {
        validateParameters(contaCorrente, cpfCnpj, card);

        Map<String, String> headers = new Map<String, String>();
        headers.put('contaCorrente', contaCorrente);
        headers.put('cpfCnpj', cpfCnpj);

        HttpResponse response = RestIntegration.getInstance().executeCallout(
            'GET',
            'https://7d3ff44a-0b94-4fbf-b70e-9d7a0d667eec.mock.pstmn.io',
            '/meios-pagamentos/v1/cartoes/segundavia',
            JSON.serialize(card),
            headers
        );

        Boolean isValidResponse = validateResponse(response);

        return parseSuccess(response);
    }

    private void validateParameters(String contaCorrente, String cpfCnpj, CreditCard card) {
        if(String.isBlank(contaCorrente)) {
            throw new CardSecondLifeServiceException(
                'ERRO DE SERVIÇO: (o parâmetro contaCorrente é requerido)'
            );
        }

        if(String.isBlank(cpfCnpj)) {
            throw new CardSecondLifeServiceException(
                'ERRO DE SERVIÇO: (o parâmetro cpfCnpj é requerido)'
            );
        }

        if(card == null) {
            throw new CardSecondLifeServiceException(
                'ERRO DE SERVIÇO: (o parâmetro card é requerido)'
            );
        }
    }

    private Boolean validateResponse(HttpResponse response) {
        System.debug(new Map<String, Object>{ 'response' => response });

        Integer statusCode = response.getStatusCode();
        Boolean isValidResponse = statusCode == 200;

        if(!isValidResponse) {
            throw new CardSecondLifeServiceException(
                String.format(
                    'ERRO DE SERVIÇO: ({0}) {1}',
                    new List<Object>{ response.getStatusCode(), response.getStatus() }
                )
            );
        }

        return isValidResponse;
    }

    private Success parseSuccess(HttpResponse response) {
        Success successResponse = (Success) JSON.deserialize(
            response.getBody(),
            Success.class
        );

        System.debug(new Map<String, Object>{ 'successResponse' => successResponse });
        return successResponse;
    }

    public class Success {
        public String mensagem;
    }

    public class CardSecondLifeServiceException extends Exception {
    }
}
