import { api, LightningElement, track, wire } from 'lwc'
import fetchData from '@salesforce/apex/CardSelectorController.fetchData'
import { publish, MessageContext } from 'lightning/messageService'
import MESSAGECHANEL from '@salesforce/messageChannel/TransacionalDataChannel__c'

const channelFilter = 'cardSelectedJson'

export default class CardSelector extends LightningElement {
    @api title
    @api iconName
    @api helpText
    @api recordId

    @track selectedData

    @wire(MessageContext)
    messageContext

    errors
    isLoadingData = false
    data = []
    channelFilter = channelFilter

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
        this.selectedData = event.detail.value
        var obj = JSON.parse(this.selectedData)
        this.sendData(obj)
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
        if (this.hasData || this.errors) {
            return
        }
        this.getData()
    }

    sendData(dataInfo) {
        const message = {
            recordId: this.recordId,
            filter: this.channelFilter,
            data: dataInfo
        }
        publish(this.messageContext, MESSAGECHANEL, message)
    }
}