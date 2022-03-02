public with sharing class CardSelectorController {

    @AuraEnabled
    public static List<Map<String, Object>> fetchData(Map<String, Object> params) {

        validateParameters(params);
        CaseSelector caseRecord = getCase((Id)params.get('recordId'));

        List<CardListService.CreditCard> creditCardList = CardListService.getInstance().execute(caseRecord.AccountNumber__c, caseRecord.Document__c);
        List<Map<String, Object>> optionData = new List<Map<String, Object>>();
        
        for (CardListService.CreditCard creditCard : creditCardList) {
            optionData.add(new Map<String, Object>{ 'label' => creditCard.numeroMascarado, 'value' => JSON.serialize(creditCard) });
        }

        System.debug(new Map<String, Object>{ 'optionData' => optionData });

        return optionData;
    }

    private void validateParameters(Map<String, Object> params) {
        Id recordId = (Id) params.get('recordId');
        if (recordId.getsobjecttype() != Schema.Case.getSObjectType()) {
            throw new BoletoControllerException(
                'O Id de registro recebido não se refere a um caso'
            );
        }

        return recordId;
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
            debug.errorLog(ex, true);
            throw new AuraHandledException('Falha ao buscar o caso');
        }
    }
}
