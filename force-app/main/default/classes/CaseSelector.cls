public inherited sharing class CaseSelector {
    private static CaseSelector instance {
        get {
            if(instance == null) {
                instance = new CaseSelector();
            }
            return instance;
        }
        private set;
    }

    public static CaseSelector getInstance() {
        return instance;
    }

    public Case getCaseWithId(id recordId, List<String> fields) {
        final String METHOD_NAME = 'getCaseWithId';

        if (recordId.getsobjecttype() != Schema.Case.getSObjectType()) {
            throw new CaseSelectorException('O Id de registro recebido não se refere a um caso');
        }

        Case caseRecord = null;
        try {
            String query =
                'SELECT Id, ' +
                String.join(fields, ',') +
                ' FROM Case' +
                ' WHERE Id = :recordId';

            System.assert(recordId != null, 'O ID do caso não pode ser nulo.');

            caseRecord = Database.query(query.escapeJava());
        } catch (Exception ex) {
            System.debug(LoggingLevel.ERROR, '__ [cls ' + CLASS_NAME + ' - ' + METHOD_NAME + '()] - ERROR: ' + ex.getLineNumber() + ' - ' + ex.getTypeName() + ' - ' + ex.getMessage());
            throw new CaseSelectorException('Falha ao buscar Caso');
        }

        return caseRecord;
    }
    
    public class CaseSelectorException extends Exception {
    }
}
