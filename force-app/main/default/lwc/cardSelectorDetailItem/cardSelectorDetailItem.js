import { api, LightningElement } from 'lwc'
import LANG from '@salesforce/i18n/lang'
import LOCALE from '@salesforce/i18n/locale'
import CURRENCY from '@salesforce/i18n/currency'

export default class CardSelectorDetailItem extends LightningElement {
    @api val

    get name() {
        if (this.val) {
            return this.val.name
        }
    }

    get value() {
        if (!this.val) {
            return ''
        }
        if (this.val.type === 'currency') {
            const numberFormat = new Intl.NumberFormat(LOCALE, {
                style: 'currency',
                currency: CURRENCY,
                currencyDisplay: 'symbol'
            })
            return numberFormat.format(this.val.value)
        }
        if (this.val.type === 'currency_dollar'){
            const numberFormat = new Intl.NumberFormat('en', {
                style: 'currency',
                currency: 'USD',
                currencyDisplay: 'code'
            })
            return numberFormat.format(this.val.value)
        }
        if (this.val.type === 'currency_real'){
            const numberFormat = new Intl.NumberFormat('pt', {
                style: 'currency',
                currency: 'BRL',
                currencyDisplay: 'symbol'
            })
            return numberFormat.format(this.val.value)
        }
        if (this.val.type === 'date') {
            const dateTimeFormat = new Intl.DateTimeFormat(LANG, this.val.typeAttributes)
            return dateTimeFormat.format(new Date(this.val.value));
        }
        return this.val.value
    }
}