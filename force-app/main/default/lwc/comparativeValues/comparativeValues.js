import { LightningElement, wire, track } from 'lwc';

import { subscribe, MessageContext } from 'lightning/messageService';
import actionChannel from '@salesforce/messageChannel/ActionChannelProp__c';

import { CurrentPageReference } from 'lightning/navigation';
import getPropostaById from '@salesforce/apex/PropostaCadastroController.getPropostaById';
import updatePropostaVenda from '@salesforce/apex/PropostaCadastroController.updatePropostaVenda';
export default class ComparativeValues extends LightningElement {
    @track propostaVendaId;
    @track propostaVenda;
    @track faseProposta;
    @track isLoadingProposta = false;
    @track type;
    @track message;
    @track showToastBar = false;
    @track autoCloseTime = 6000;
    
    @track dataTabela;
    @track dataProposta;

    @track isLoadingModal = false;
    @track isOpenModal = false;

    subscription = null;
    action;

    //event
    @wire(MessageContext) messageContext;

    //event
    subscribeMC() {
        this.subscription = subscribe(this.messageContext, actionChannel, this.handlerEvent.bind(this));
    }

    showToast(message, type) {
        this.type = type;
        this.message = message;
        this.showToastBar = true;
        setTimeout(() => {
            this.closeModalToast();
        }, this.autoCloseTime);
    }

    get getIconName() {
        return 'utility:' + this.type;
    }

    get innerClass() {
        return 'slds-icon_container slds-icon-utility-' + this.type + ' slds-icon-utility-success slds-m-right_small slds-no-flex slds-align-top';
    }

    get outerClass() {
        return 'slds-notify slds-notify_toast slds-theme_' + this.type;
    }

    closeModalToast() {
        this.showToastBar = false;
        this.type = '';
        this.message = '';
    }

    openCommentaryModal(event) {
        this.isOpenModal = true;
    }

    closeCommentaryModal(event) {
        this.isLoadingModal = false;
        this.isOpenModal = false;
    }

    @wire(CurrentPageReference) wiredPageRef(pageRef) {
        this.pageRef = pageRef;
        if (!this.pageRef) {
            this.pageRef = {};
            this.pageRef.attributes = {};
            this.pageRef.attributes.LightningApp = "LightningApp";
        }
        this.propostaVendaId = this.pageRef.state.recordId;
    }

    connectedCallback() {
        this.subscribeMC();
        this.isLoadingProposta = true;
        this.getPropById(this.propostaVendaId);
    }

    getPropById(propId) {
        console.log(propId);
        getPropostaById({ propostaVendaId: propId }).then(result => {
            this.isLoadingProposta = false;
            
            const options = {
                year: 'numeric', month: 'numeric', day: 'numeric',
                hour12: false
            };
 
            if (result != null) {

                this.propostaVenda = result;

                this.faseProposta = this.propostaVenda.Fase_da_Proposta__c;

                this.propostaVenda.Valor_Tabela__c = this.propostaVenda.Valor_Tabela__c ? parseFloat(this.propostaVenda.Valor_Tabela__c.toFixed(2)) : 0;
                this.propostaVenda.VPL_Tabela__c = this.propostaVenda.VPL_Tabela__c ? parseFloat(this.propostaVenda.VPL_Tabela__c.toFixed(2)) : 0;
                this.propostaVenda.VPL_Proposta__c = this.propostaVenda.VPL_Proposta__c ? parseFloat(this.propostaVenda.VPL_Proposta__c.toFixed(2)) : 0;
                this.propostaVenda.Variacao_VPL__c = this.propostaVenda.Variacao_VPL__c ? parseFloat(this.propostaVenda.Variacao_VPL__c.toFixed(2)) : 0;
                this.propostaVenda.Valor_M2__c = this.propostaVenda.Valor_M2__c ? parseFloat(this.propostaVenda.Valor_M2__c.toFixed(2)) : 0;
                this.propostaVenda.Valor_M2_Tabela__c = this.propostaVenda.Valor_M2_Tabela__c ? parseFloat(this.propostaVenda.Valor_M2_Tabela__c.toFixed(2)) : 0;
                this.propostaVenda.Variacao_Nominal__c = this.propostaVenda.Variacao_Nominal__c ? parseFloat(this.propostaVenda.Variacao_Nominal__c.toFixed(2)) : 0;
                this.propostaVenda.Valor_da_Proposta__c = this.propostaVenda.Valor_da_Proposta__c ? parseFloat(this.propostaVenda.Valor_da_Proposta__c.toFixed(2)) : 0;
                this.dataTabela = this.formatDate(this.propostaVenda.CreatedDate);
                this.dataProposta = this.formatDate(this.propostaVenda.CreatedDate, true);
           }
        }).catch(error => {
            this.isLoadingProposta = false;
            this.showToast('Erro de processamento, entre em contato com o administrador', 'error');
        });
    }

    get disableFaseProp() {
        return (this.faseProposta != 'Simulação' && this.faseProposta != 'Aprovação da Proposta' && this.faseProposta != 'Proposta Rejeitada');
    }

    get disableAprovFase() {
        return !(this.faseProposta == 'Aprovação da Proposta');
    }

    get disableNotAprovFase() {
        return (this.faseProposta != 'Simulação' && this.faseProposta != 'Proposta Rejeitada');
    }

    handleSaveEdit(event) {
        this.isLoadingModal = true;
        let propostaVendaToUpdate = { Id: this.propostaVendaId, Comentarios_e_Clausulas__c: this.propostaVenda.Comentarios_e_Clausulas__c };


        updatePropostaVenda({ fields: JSON.stringify(propostaVendaToUpdate) }).then(result => {
            this.isLoadingModal = false;

            if (result != null) {
                this.showToast('Operação realizada com sucesso!', 'success');
            }
            this.closeCommentaryModal();
            this.connectedCallback();

        }).catch(error => {
            this.isLoadingModal = false;
            this.showToast('Erro de processamento, entre em contato com o administrador', 'error');
        });
    }

    inputHandleChange(event) {
        this.propostaVenda.Comentarios_e_Clausulas__c = event.target.value;
    }

    handleOpenEnviarProposta(event) {
        this.template.querySelector('c-popup-enviar-proposta')?.viewModal();
    }
    handleOpenAprovarProposta(event) {
        this.template.querySelector('c-popup-aprovar-proposta')?.viewModal();
    }

    handlerEvent(message) {
        this.getPropById(this.propostaVendaId);
    }

    formatDate(date, showDay = false) {
        var d = new Date(date)
        var month = d.getMonth() + 1
        
        if(month < 10) {
            month = '0' + month;
        };

        var year = d.getFullYear();

        if(showDay) {
            var day = d.getDate();
            if(day < 10) {
                day = '0' + day;
            };
            return day + '/' + month + '/' + year;
        }
        
        return month + '/' + year;
    }
}