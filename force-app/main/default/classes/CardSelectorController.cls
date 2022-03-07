public with sharing class CardSelectorController {

    @AuraEnabled
    public static List<Map<String, Object>> fetchData(Map<String, Object> params) {

        validateParameters(params);
        Case caseRecord = getCase((Id)params.get('recordId'));

        List<CreditCard> creditCardList = CardListService.getInstance().execute(caseRecord.AccountNumber__c, caseRecord.Document__c);
        List<Map<String, Object>> optionData = new List<Map<String, Object>>();
        
        for (CreditCard creditCard : creditCardList) {
            optionData.add(new Map<String, Object>{ 'label' => creditCard.numeroMascarado, 'value' => JSON.serialize(creditCard) });
        }

        System.debug(new Map<String, Object>{ 'optionData' => optionData });

        return optionData;
    }

    private static void validateParameters(Map<String, Object> params) {
        Id recordId = (Id) params.get('recordId');
        if (recordId.getsobjecttype() != Schema.Case.getSObjectType()) {
            throw new AuraHandledException(
                'O Id de registro recebido não se refere a um caso'
            );
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
}
