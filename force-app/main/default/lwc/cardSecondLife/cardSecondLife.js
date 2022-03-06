import { LightningElement, api, wire } from 'lwc';
import { subscribe, APPLICATION_SCOPE, MessageContext } from 'lightning/messageService'
import MESSAGECHANEL from '@salesforce/messageChannel/TransacionalDataChannel__c'

const channelFilter = 'cardSelected'

export default class CardSecondLife extends LightningElement {
    @api title
    @api iconName
    @api helpText
    @api recordId

    @wire(MessageContext)
    messageContext
    subscription = null
    receivedMessage

    errors
    isLoadingData = false
    _disableButton = true
    buttonLabel = 'Executar'
    selectedCard = null
    channelFilter = channelFilter

    get getServiceError() {
        console.log(this.errors);
        return 'Falha na execução do serviço. Entre em contato com o administrador'
    }

    get disableButton() {
        if(!this.selectedCard) {
            return true
        }

        return !this.selectedCard.permiteSegundaVia
    }

    get label() {
        if(!this.selectedCard) {
            return 'Selecione um cartão para solicitar a segunda via'
        }

        if(this.selectedCard.permiteSegundaVia) {
            return 'Clique em Executar para solicitar uma segunda via para o cartão ' + this.selectedCard.numeroMascarado
        }
        else {
            return 'O cartão ' + this.selectedCard.numeroMascarado + ' não permite solicitar segunda via'
        }
    }

    get params() {
        return {
            title: this.title,
            iconName: this.iconName,
            recordId: this.recordId,
            chanelFilter: this.chanelFilter,
            receivedMessage: this.receivedMessage
        }
    }

    handleMessage(message) {
        if (
            message != null &&
            message.recordId === this.recordId &&
            message.filter === this.channelFilter
        ) {
            this.isLoadingData = true
            this.receivedMessage = JSON.stringify(message, null, '\t')
            this.params.receivedMessage = this.receivedMessage
            this.selectedCard = message.data
            console.log('menssagem recebida: ' + this.params.receivedMessage)
            this.isLoadingData = false
        }
    }

    renderedCallback() {
        if (this.subscription) {
            return
        }
        this.subscription = subscribe(
            this.messageContext,
            MESSAGECHANEL,
            (message) => {
                this.handleMessage(message)
            },
            { scope: APPLICATION_SCOPE }
        )
    }
}