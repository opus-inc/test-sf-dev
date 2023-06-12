import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import getPaymentConditionsByProposta from '@salesforce/apex/PropostaCadastroController.getPaymentConditionsByProposta';
import getTabelaDeVendas from '@salesforce/apex/PropostaCadastroController.getTabelaDeVendas';
import getValorTotal from '@salesforce/apex/PropostaCadastroController.getValorTotal';
import saveCondicoes from '@salesforce/apex/PropostaCadastroController.saveCondicoes';

import actionChannel from '@salesforce/messageChannel/ActionChannelProp__c';
import { publish, MessageContext } from 'lightning/messageService';

const columnsTabCondicoes = [
    { label: 'Periodicidade', fieldName: 'Periodicidade_Condicao__c' },
    { label: 'Nº de parcelas', fieldName: 'Quantidade_de_parcelas__c' },
    { label: 'Início do vencimento', fieldName: 'In_cio_do_Vencimento__c', type: 'date',  typeAttributes:{
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
        timeZone: 'UTC'
    }},
    { label: 'Valor das parcelas', fieldName: 'Valor_Total_das_Parcelas__c', type: 'currency' },
    { label: 'Valor total', fieldName: 'Valor_Total_Parcela__c', type: 'currency' },
    { label: 'Correção', fieldName: 'Correcao__c' },
];

export default class PaymentTable extends LightningElement {

    columns = columnsTabCondicoes;

    @track propostaVendaId;
    @track tabCondicoes;
    @track faseProposta;
    @track valorTotalProp;
    @track valorIntegralProp;
    @track paymentConditions = [];
    @track isLoadingPaymentCondition;
    @track isLoading = false;
    @track isLoading = false;

    @track dateToday;

    @wire(MessageContext) messageContext;

    openModalDiscount() {
        this.template.querySelector('c-popup-aplicar-desconto')?.viewModal();
    }

    openModalComissao() {
        this.template.querySelector('c-popup-comissao')?.viewModal();
    }

    periodicidadeOptions = [
        { value: 'Sinal', label: 'Sinal' },
        { value: 'Única', label: 'Única' },
        { value: 'Mensal', label: 'Mensal' },
        { value: 'Semestral', label: 'Semestral' },
        { value: 'Anual', label: 'Anual' },
        { value: 'Financiamento', label: 'Financiamento' }
    ];

    @track rows = [{
        Atualiza_Fluxo__c: 'Não'
    }];

    @wire(CurrentPageReference) wiredPageRef(pageRef) {
        this.pageRef = pageRef;
        if (!this.pageRef) {
            this.pageRef = {};
            this.pageRef.attributes = {};
            this.pageRef.attributes.LightningApp = "LightningApp";
        }
        this.propostaVendaId = this.pageRef.state.recordId;
    }

    get hasRow() {
        return (this.rows && this.rows.length > 0);
    }

    get disableFaseProp() {
        return (this.faseProposta != 'Simulação' && this.faseProposta != 'Aprovação da Proposta' && this.faseProposta != 'Proposta Rejeitada');
    }

    connectedCallback() {

        var date = new Date();

        this.dateToday = this.toJSONLocal( date );

        console.log( this.dateToday );

        this.isLoadingPaymentCondition = true;

        if (this.propostaVendaId) {
            this.getValorProp(this.propostaVendaId);
            this.getCondicoesProposta(this.propostaVendaId, true, true);
            this.getCondicoesTabela(this.propostaVendaId);
        }
    }

    getCondicoesProposta(propostaId, ispicklist, istable) {
        getPaymentConditionsByProposta({ propostaVendaId: propostaId }).then(result => {
            this.isLoadingPaymentCondition = false;

            if (!this.faseProposta) {
                this.faseProposta = result[0].Proposta_de_Vendas__r.Fase_da_Proposta__c;
            }
            //Populate picklist Desconto
            if (ispicklist) {
                this.paymentConditions = [];
                result.map(element => {
                    this.paymentConditions.push({
                        id: element.Id,
                        value: element.Id,
                        label: element.Periodicidade_Condicao__c + ' - ' + element.In_cio_do_Vencimento__c + ' - ' + element.Quantidade_de_parcelas__c + ' x ' + element.Valor_Total_das_Parcelas__c
                    });
                });
            }

            if (istable) {
                //Popuplate payment table
                let rows = [];
                let i = 0;

                result.forEach(element => {
                    const row = {};

                    row.Periodicidade_Condicao__c = element.Periodicidade_Condicao__c;
                    row.Quantidade_de_parcelas__c = element.Quantidade_de_parcelas__c;
                    row.In_cio_do_Vencimento__c = element.In_cio_do_Vencimento__c;
                    row.Valor_Total_das_Parcelas__c = element.Valor_Total_das_Parcelas__c ? parseFloat(element.Valor_Total_das_Parcelas__c.toFixed(2)) : 0;
                    row.valorTotal = (row.Quantidade_de_parcelas__c * row.Valor_Total_das_Parcelas__c);
                    row.correcao = element.Correcao__c;
                    row.Atualiza_Fluxo__c = 'Não';

                    rows.push(row);
                });

                this.rows = rows;

                this.calcValorIntegral();
            }
        }).catch(error => {
            window.console.log(error);
            this.isLoadingPaymentCondition = false;
        });
    }

    getCondicoesTabela(propostaId) {
        getTabelaDeVendas({ propostaVendaId: propostaId }).then(result => {

            this.tabCondicoes = result;
        }).catch(error => {
            window.console.log(error);
        });
    }

    getValorProp(propostaId) {
        getValorTotal({ propostaVendaId: propostaId }).then(result => {

            this.valorTotalProp = result.Valor_da_Proposta__c;
            this.faseProposta = result.Fase_da_Proposta__c;
        }).catch(error => {
            window.console.log(error);
        });
    }

    handleChangePeriodicidade(event) {

        var item = this.rows[event.target.dataset.index];

        item.Periodicidade_Condicao__c = event.detail.value;

    }

    handleChangeParcelas(event) {

        var item = this.rows[event.target.dataset.index];

        event.target.value = event.target.value.length <= 0 ? 0 : event.target.value;

        item.Quantidade_de_parcelas__c = event.target.value;

        item.valorTotal = item.Valor_Total_das_Parcelas__c ? (item.Quantidade_de_parcelas__c * item.Valor_Total_das_Parcelas__c) : item.valorTotal;

    }

    handleDeleteRow(event) {

        if (this.rows.length > 1) this.rows.splice( event.target.dataset.index, 1 );        

        this.calcValorIntegral();
    }

    handleAddRow() {

        if (this.rows.length < 9) this.rows.push({ Atualiza_Fluxo__c: 'Não' });

    }

    inputHandleChange(event) {
        
        var fieldName = event.target.dataset.field;

        event.target.value = fieldName == 'Valor_Total_das_Parcelas__c' && event.target.value.length <= 0 ? 0 : event.target.value;

        var item = this.rows[event.target.dataset.index];

        item[fieldName] = event.target.value;

        if (fieldName == 'Valor_Total_das_Parcelas__c' && item.Quantidade_de_parcelas__c) {
            item.valorTotal = (item.Quantidade_de_parcelas__c * item[fieldName]);
        }

        if (item == 'In_cio_do_Vencimento__c' && item.In_cio_do_Vencimento__c) {
            
            var currentDateMonth = new Date().getMonth() + 1;
            var chooseDateMonth = new Date(event.target.value).getMonth() + 1;

            var currentDateYear = new Date().getFullYear();
            var chooseDateYear = new Date(event.target.value).getFullYear();

            item.correcao = ( chooseDateMonth > currentDateMonth || chooseDateYear > currentDateYear ) ? 'Reajustáveis' : 'Fixas';

        }

        this.calcValorIntegral();
    }

    calcValorIntegral() {
        let valueRow = 0;
        this.rows.forEach(element => {
            if (element.Quantidade_de_parcelas__c && element.Valor_Total_das_Parcelas__c) {
                valueRow += (element.Quantidade_de_parcelas__c * element.Valor_Total_das_Parcelas__c);
            }
        });

        if (valueRow != undefined) {
            this.valorIntegralProp = parseFloat(valueRow.toFixed(2));
        } else {
            this.valorIntegralProp = '0';
        }
    }

    pagarConformeTabela() {
        if (this.tabCondicoes) {
            let rows = [];
            let i = 0;

            this.tabCondicoes.forEach(element => {
                const row = {};

                row.Periodicidade_Condicao__c = element.Periodicidade_Condicao__c;
                row.Quantidade_de_parcelas__c = element.Quantidade_de_parcelas__c;
                row.In_cio_do_Vencimento__c = element.In_cio_do_Vencimento__c;
                row.Valor_Total_das_Parcelas__c = element.Valor_Total_das_Parcelas__c ? parseFloat(element.Valor_Total_das_Parcelas__c.toFixed(2)) : 0;
                row.valorTotal = element.Valor_Total_Parcela__c;
                row.correcao = element.Correcao__c;
                row.Atualiza_Fluxo__c = 'Não';

                rows.push(row);
            });

            this.rows = rows;
        }

        this.calcValorIntegral();
    }

    pagarAVista() {
        let currentDateYear = new Date().getFullYear();
        let currentDateMonth = new Date().getMonth() + 1;
        let lastDayOfMonth = new Date(currentDateYear, currentDateMonth, 0).getDate();

        let rows = [];
        const row = {};

        row.Periodicidade_Condicao__c = 'Sinal';
        row.Quantidade_de_parcelas__c = 1;
        row.In_cio_do_Vencimento__c = currentDateYear + '-' + (currentDateMonth < 10 ? '0' + currentDateMonth : currentDateMonth) + '-' + lastDayOfMonth;
        row.Valor_Total_das_Parcelas__c = parseInt(this.valorTotalProp);
        row.valorTotal = (this.valorTotalProp);
        row.Atualiza_Fluxo__c = 'Não';

        rows.push(row);
        this.rows = rows;

        this.calcValorIntegral();
    }

    handleSave() {

        let rowsToInsert = [];

        this.rows.map(row => {

            let newRow = row;

            newRow.Proposta_de_Vendas__c = this.propostaVendaId;

            rowsToInsert.push(newRow);
            
        });

        if(!this.isInputValid()) return;

        this.isLoading = true;

        saveCondicoes({ condicoes: JSON.stringify(rowsToInsert) }).then(result => {

            if (result != null) {
                this.handleSendEvent();
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Operação realizada com sucesso!',
                        variant: 'success'
                    })
                );
            }
            this.isLoading = false;
            this.showGridInput = true;
            this.connectedCallback();
        }).catch(error => {
            window.console.log('error ', error);
            this.isLoading = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Erro de processamento, entre em contato com o administrador',
                    variant: 'error'
                })
            );
        });
    }

    handleSendEvent() {
        publish(this.messageContext, actionChannel, { actionName: 'update values'});
    }

    isInputValid() {
        let isValid = true;
        let inputFields = this.template.querySelectorAll('.validate');
        inputFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
            this.rows[inputField.name] = inputField.value;
        });
        return isValid;
    }

    toJSONLocal(date) {
        var local = new Date(date);
        local.setMinutes(date.getMinutes() - date.getTimezoneOffset());
        return local.toJSON().slice(0, 10);
    }

}