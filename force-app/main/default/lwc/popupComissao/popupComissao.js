import { LightningElement, track, api } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateCondicaoDiscount from '@salesforce/apex/PropostaCadastroController.updateCondicaoDiscount';
import getPropostaById from '@salesforce/apex/PropostaCadastroController.getPropostaById';
import getPaymentConditionsByProposta from '@salesforce/apex/PropostaCadastroController.getPaymentConditionsByProposta';
import updatePropostaVenda from '@salesforce/apex/PropostaCadastroController.updatePropostaVenda';

export default class PopupComissao extends LightningElement {
    // parseFloat(string.replaceAll(",", "."))
    @api propostaVendaId;
    @track propostaVenda;
    @track faseProposta;
    @track condicoesSinalProposta = [];
    @track showModal = false;
    @track isLoading = false;
    @track showEdit = false;
    @track cannotSendToValidation = false;
    @track valores = {
        faturada: 0,
        destacada: 0,
        premiacao: 0
    };

    @track type;
    @track message;
    @track showToastBar = false;
    @track autoCloseTime = 6000;


    showToast(message, type) {
        this.type = type;
        this.message = message;
        this.showToastBar = true;
        setTimeout(() => {
            this.closeModalToast();
        }, this.autoCloseTime);
    }

    closeModalToast() {
        this.showToastBar = false;
        this.type = '';
        this.message = '';
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

    connectedCallback() {
        this.isLoading = true;
        console.log('this.propostaVendaId', this.propostaVendaId);

        getPropostaById({ propostaVendaId: this.propostaVendaId })
            .then(result => {
                this.isLoading = false;
                if (result != null) {
                    this.propostaVenda = result;
                    this.faseProposta = result.Fase_da_Proposta__c;
                    this.valores = {
                        faturada: ((result.Perc_Comissao_Faturada__c / 100) * result.Valor_da_Proposta__c)
                            .toLocaleString('pt-br',{style: 'currency', currency: 'BRL'}),
                        destacada: ((result.Perc_Comissao_Destacada__c / 100) * result.Valor_da_Proposta__c)
                            .toLocaleString('pt-br',{style: 'currency', currency: 'BRL'}),   
                        premiacao: result.Valor_da_Premiacao__c.toLocaleString('pt-br',{style: 'currency', currency: 'BRL'}) 
                    }
                    getPaymentConditionsByProposta({ propostaVendaId: this.propostaVendaId }).then(result => {
                        this.condicoesSinalProposta = [];
                        for(var i = 0; i < result.length; i++) {
                            if(result[i].Periodicidade_Condicao__c === "Sinal") {
                                let row = result[i];
                                row.In_cio_do_Vencimento__c = new Intl.DateTimeFormat('pt-BR').format(new Date(`${row.In_cio_do_Vencimento__c} `))
                                row.Valor_Total_das_Parcelas__c = (row.Valor_Total_das_Parcelas__c).toLocaleString('pt-BR', {
                                    style: 'currency',
                                    currency: 'BRL',
                                });
                                
                                if(row.Valor_Opus__c) {
                                    row.Valor_Opus__c = (row.Valor_Opus__c).toLocaleString('pt-BR', {
                                        style: 'currency',
                                        currency: 'BRL',
                                    });
                                }

                                if(row.Valor_Comissao__c) {
                                    row.Valor_Comissao__c = (row.Valor_Comissao__c).toLocaleString('pt-BR', {
                                        style: 'currency',
                                        currency: 'BRL',
                                    });
                                }
                                    
                                this.condicoesSinalProposta.push(row);
                            }
                        }
                    });
                }
            })
            .catch(error => {
                console.log('error ', error);
                this.isLoading = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Erro de processamento, entre em contato com o administrador',
                        variant: 'success'
                    })
                );
            });
    }

     
    @api viewModal() {
        this.showModal = !this.showModal;
        this.connectedCallback();
    }

    get canEdit() {
        return !(this.faseProposta == 'Simulação' || this.faseProposta == 'Proposta de Vendas'|| this.faseProposta == 'Proposta Rejeitada');
    }

    inputHandleChange(event) {
        var fieldName = event.target.dataset.field;
        if(fieldName === "Perc_Comissao_Destacada__c") {
            this.canSendToValidation(event.target.value);
        }
        this.propostaVenda[fieldName] = event.target.value;
    }

    canSendToValidation(Perc_Comissao_Destacada__c) {
        if(this.propostaVenda) {
            const valorTotalSinal = this.condicoesSinalProposta.reduce((a, b) => a + b.Valor_Total_Parcela__c, 0);
            const umVirgulaCincoPorCentoValorTotal = this.propostaVenda.Valor_da_Proposta__c * 1.5 / 100;
            const comissaoDestacadaValor = Perc_Comissao_Destacada__c * this.propostaVenda.Valor_da_Proposta__c / 100;

            this.cannotSendToValidation = valorTotalSinal < comissaoDestacadaValor + umVirgulaCincoPorCentoValorTotal;

            if(this.propostaVenda.Perc_Comissao_Destacada__c === 0) {
                this.cannotSendToValidation = false;
            }
        }
    }

    handleSaveEdit(event) {
        this.isLoading = true;


        let propostaVendaToUpdate = { 
            Id: this.propostaVendaId, 
            Perc_Comissao_Faturada__c: this.propostaVenda.Perc_Comissao_Faturada__c,
            Perc_Comissao_Destacada__c: this.propostaVenda.Perc_Comissao_Destacada__c,
            Valor_da_Premiacao__c: this.propostaVenda.Valor_da_Premiacao__c,
            Atualizar_Distribuicao_Comissao__c: true
        };


        updatePropostaVenda({ fields: JSON.stringify(propostaVendaToUpdate) }).then(result => {
            this.isLoading = false;

            if (result != null) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Operação realizada com sucesso!',
                        variant: 'success'
                    })
                );
            }

            //this.viewModal();
            this.showEdit = false;
            //this.closeCommentaryModal();
            this.connectedCallback();

        }).catch(error => {
            this.isLoading = false;
            console.log(error)
            this.showToast(error.body.message.split(", ")[1], 'error');

            // this.dispatchEvent(
            //     new ShowToastEvent({
            //         title: 'Success',
            //         message: 'Erro de processamento, entre em contato com o administrador',
            //         variant: 'success'
            //     })
            // );
        });
    }

    handleOpenEdit(event){
        this.showEdit = !this.showEdit;
    }
}