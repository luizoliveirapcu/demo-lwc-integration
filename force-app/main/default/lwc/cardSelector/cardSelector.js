import { api, wire, LightningElement } from 'lwc'
import fetchData from '@salesforce/apex/CardSelectorController.fetchData'

export default class CardSelector extends LightningElement {
    @api title
    @api iconName
    @api recordId

    errors
    isLoadingData = false
    data = []

    get hasData() {
        return this.data.length > 0
    }

    get getServiceError() {
        console.log(this.errors);
        return 'Falha na execução do serviço. Entre em contato com o administrador'
    }

    get options() {
        return this.data
    }

    get params() {
        return {
            title: this.title,
            iconName: this.iconName,
            recordId: this.recordId
        }
    }

    handleChange(event) {
        this.fiteredData = event.detail.value
    }

    getData() {
        this.isLoadingData = true
        fetchData({
            params: this.params
        })
            .then((res) => {
                this.data = res
            })
            .catch((_err) => {
                this.errors = Array.isArray(_err.body) ? _err.body : [_err.body]
            })
            .finally(() => {
                this.isLoadingData = false
            })
    }

    renderedCallback() {
        if (this.hasData) {
            return
        }
        this.getData()
    }
}