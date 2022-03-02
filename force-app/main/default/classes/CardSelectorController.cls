public with sharing class CardSelectorController {

    @AuraEnabled
    public static List<Map<String, Object>> fetchData(Map<String, Object> params) {

        validateParameters(params);
        CaseSelector caseRecord = CaseSelector.getInstance().getCaseWithId((Id)params.get('recordId'));

        List<CardListService.CreditCard> creditCardList = CardListService.getInstance().execute('123456', '09967782684');
        List<Map<String, Object>> optionData = new List<Map<String, Object>>();
        
        for (CardListService.CreditCard creditCard : creditCardList) {
            optionData.add(new Map<String, Object>{ 'label' => creditCard.numeroMascarado, 'value' => JSON.serialize(creditCard) });
        }

        System.debug(new Map<String, Object>{ 'optionData' => optionData });

        return optionData;
    }

    public void validateParameters(Map<String, Object> params) {
        Id recordId = (Id) params.get('recordId');
        if (recordId.getsobjecttype() != Schema.Case.getSObjectType()) {
            throw new BoletoControllerException(
                'O Id de registro recebido não se refere a um caso'
            );
        }

        return recordId;
    }
}
