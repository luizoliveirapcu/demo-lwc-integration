public with sharing class CardSecondLifeController {
    @AuraEnabled
    public static Map<String, Object> doAction(Map<String, Object> params) {
        Map<String, Object> result = new Map<String, Object>();
        try {
            validateParameters(params);
            Case caseRecord = getCase((Id)params.get('recordId'));
            CreditCard creditCard = getCard((String) params.get('receivedMessage'));

            CardSecondLifeService.getInstance().execute(caseRecord.AccountNumber__c, caseRecord.Document__c, creditCard);
            
            result.put('success', 'Ação realizada com sucesso');
        } catch (Exception ex) {
            result.put('error', ex.getMessage());
        }
        return result;
    }

    private static void validateParameters(Map<String, Object> params) {
        Id recordId = (Id) params.get('recordId');
        if (recordId.getsobjecttype() != Schema.Case.getSObjectType()) {
            throw new AuraHandledException(
                'O Id de registro recebido não se refere a um caso'
            );
        }

        String receivedMessage = (String) params.get('receivedMessage');
        if(String.isBlank(receivedMessage)){
            throw new AuraHandledException(
                'O parâmetro receivedMessage é requerido'
            );
        }
    }

    private static CreditCard getCard(String receivedMessage) {
        System.debug(new Map<String, Object>{'receivedMessage' => receivedMessage});
        try {
            Message message = (Message)JSON.deserialize(receivedMessage, Message.class);
            return message.data;
        } catch (Exception ex) {
            System.debug(LoggingLevel.ERROR, 'ERRO ao deserializar a mensagem: ' + ex.getLineNumber() + ' - ' + ex.getTypeName() + ' - ' + ex.getMessage());
            throw new AuraHandledException('Falha ao deserializar a mensagem');
        }
    }

    private static Case getCase(Id caseId) {
        System.debug(new Map<String, Object>{'caseId' => caseId});
        try {
            List<String> fieldsCase = new List<String>{
                'AccountNumber__c',
                'Document__c'
            };

            Case caseRecord = CaseSelector.getInstance().getCaseWithId(caseId, fieldsCase);
            System.debug('Case encontrado: ' + caseRecord.Id);
            return caseRecord;
        } catch (Exception ex) {
            System.debug(LoggingLevel.ERROR, 'ERRO ao buscar caso: ' + ex.getLineNumber() + ' - ' + ex.getTypeName() + ' - ' + ex.getMessage());
            throw new AuraHandledException('Falha ao buscar o caso');
        }
    }

    public class Message {
        public String recordId;
        public String channelFilter;
        public CreditCard data;
    }
}

