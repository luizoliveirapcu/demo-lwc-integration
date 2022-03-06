import { api, LightningElement, track } from 'lwc'

const columns = [
    { 
        label: 'Número Mascarado', 
        fieldName: 'numeroMascarado', 
        type: 'TEXT'
    },
    { 
        label: 'Status', 
        fieldName: 'status', 
        type: 'TEXT'
    },
    { 
        label: 'Titular', 
        fieldName: 'titular', 
        type: 'TEXT'
    },
    { 
        label: 'Nome Impresso', 
        fieldName: 'nomeImpresso', 
        type: 'TEXT'
    },
    { 
        label: 'Data de Criacao', 
        fieldName: 'dataCriacao', 
        type: 'TEXT',
        typeAttributes: {
            year: 'numeric',
            month: 'long',
            day: '2-digit'
        }
    },
    { 
        label: 'Data de Validade', 
        fieldName: 'dataValidade', 
        type: 'TEXT',
        typeAttributes: {
            year: 'numeric',
            month: 'long',
            day: '2-digit'
        }
    },
    { 
        label: 'Tipo', 
        fieldName: 'tipo', 
        type: 'TEXT'
    },
    { 
        label: 'Produto', 
        fieldName: 'produto', 
        type: 'TEXT'
    },
    { 
        label: 'Permite Segunda Via', 
        fieldName: 'permiteSegundaVia', 
        type: 'TEXT'
    }
]
     

export default class CardSelectorDetail extends LightningElement {
    @api
    get externalData() {
        return this._externalData;
    }
    set externalData(value) {
        this.setAttribute('externalData', value);
        this._externalData = value;
        this.getData();
    }

    @track _externalData

    columns = columns;
    title = 'Detalhes do cartão selecionado'
    iconName = 'standard:display_text'
    helpText = 'Detalhes do cartão selecionado'
    errors
    data = []
    isLoadingData = false

    get getServiceError() {
        return 'Falha inesperada. Entre em contato com o administrador'
    }

    getData() {
        this.isLoadingData = true

        try {
                this.data = []
                let info = []
                let objectData = JSON.parse(this.externalData)
                this.columns.forEach((col) => {
                    if (objectData.hasOwnProperty(col.fieldName)) {
                        info.push({
                            id: info.length,
                            name: col.label,
                            value: objectData[col.fieldName],
                            type: col.type,
                            typeAttributes: col.typeAttributes
                        })
                    }
                })

                this.data = info
        } catch (_err) {
                this.errors = Array.isArray(_err) ? _err : [_err]
        } finally{
            this.isLoadingData = false
        }
    }

    connectedCallback() {
        if (this.externalData != undefined) {
            this.getData()
        }
        else {
            this.errors = [this.getServiceError]
        }
    }
}
