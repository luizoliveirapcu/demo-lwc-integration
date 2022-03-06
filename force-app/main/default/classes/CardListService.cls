public inherited sharing class CardListService {
    
    private static CardListService instance {
        get {
            if(instance == null) {
                instance = new CardListService();
            }
            return instance;
        }
        private set;
    }

    public static CardListService getInstance() {
        return instance;
    }

    public List<CreditCard> execute(String contaCorrente, String cpfCnpj) {
        validateParameters(contaCorrente, cpfCnpj);

        Map<String, String> headers = new Map<String, String>();
        headers.put('contaCorrente', contaCorrente);
        headers.put('cpfCnpj', cpfCnpj);

        HttpResponse response = RestIntegration.getInstance().executeCallout(
            'GET',
            'https://7d3ff44a-0b94-4fbf-b70e-9d7a0d667eec.mock.pstmn.io',
            '/meios-pagamentos/v1/cartoes',
            null,
            headers
        );

        Boolean isValidResponse = validateResponse(response);

        return parseSuccess(response);
    }

    private void validateParameters(String contaCorrente, String cpfCnpj) {
        if(String.isBlank(contaCorrente)) {
            throw new CardListServiceException(
                'ERRO DE SERVIÇO: (o parâmetro contaCorrente é requerido)'
            );
        }

        if(String.isBlank(cpfCnpj)) {
            throw new CardListServiceException(
                'ERRO DE SERVIÇO: (o parâmetro cpfCnpj é requerido)'
            );
        }
    }

    private Boolean validateResponse(HttpResponse response) {
        System.debug(new Map<String, Object>{ 'response' => response });

        Integer statusCode = response.getStatusCode();
        Boolean isValidResponse = statusCode == 200;

        if(!isValidResponse) {
            throw new CardListServiceException(
                String.format(
                    'ERRO DE SERVIÇO: ({0}) {1}',
                    new List<Object>{ response.getStatusCode(), response.getStatus() }
                )
            );
        }

        return isValidResponse;
    }

    private List<CreditCard> parseSuccess(HttpResponse response) {
        return (List<CreditCard>) JSON.deserialize(
            response.getBody(),
            List<CreditCard>.class
        );
    }

    public class CreditCard {
        public String numeroMascarado;
        public String status;
        public Boolean titular;
        public String nomeImpresso;
        public String dataCriacao;
        public String dataValidade;
        public String tipo;
        public String produto;
        public Boolean permiteSegundaVia;
    }

    public class CardListServiceException extends Exception {
    }
}
