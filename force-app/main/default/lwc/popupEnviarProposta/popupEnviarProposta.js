import { LightningElement, track, api } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPropostaById from '@salesforce/apex/PropostaCadastroController.getPropostaById';
import getPaymentConditionsByProposta from '@salesforce/apex/PropostaCadastroController.getPaymentConditionsByProposta';
import updatePropostaVenda from '@salesforce/apex/PropostaCadastroController.updatePropostaVenda';

export default class PopupEnviarProposta extends LightningElement {
    @api propostaVendaId;
    @track propostaVenda;
    @track condicaoPagamentoDesconto;
    @track showModal = false;
    @track isLoading = false;
    @track error = false;
    @track cannotSendToValidation = false;
    @track dataLimiteAprovacao = "";

    connectedCallback() {
        this.isLoading = true;
        this.cannotSendToValidation = false;
        console.log('this.propostaVendaId', this.propostaVendaId);

        getPropostaById({ propostaVendaId: this.propostaVendaId }).then(result => {
            this.isLoading = false;
            if (result != null) {
                this.propostaVenda = result;
                let mes = new Date(result.CreatedDate).getMonth() + 1;
                let ano = new Date(result.CreatedDate).getUTCFullYear();
                this.dataLimiteAprovacao = (mes > 9 ? mes : "0" + mes) + "/" + ano;
            }

        }).catch(error => {
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
   
    @api viewModal(cannotSendToValidation) {
        this.cannotSendToValidation = cannotSendToValidation;
        this.showModal = !this.showModal;
    }

    inputHandleChange(event) {
        var fieldName = event.target.dataset.field;
        this.propostaVenda[fieldName] = event.target.value;
    }

    handleSubmitToApprove(event){
        this.error = false;
        this.isLoading = true;
        if(this.propostaVenda.Gerente_Empreendimento__c && this.propostaVenda.Gerente_Empreendimento_Email__c){
            updatePropostaVenda({ fields: JSON.stringify({Id: this.propostaVendaId, EmailEnviado__c: true })}).then(result => {
                this.isLoading = false;
                console.log('sendEmailToApprove()');
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Operação realizada com sucesso!',
                            variant: 'success'
                        })
                    );

                this.viewModal();
            }).catch(error => {
                this.isLoading = false;
                this.error = true;
                console.log(error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Erro de processamento, entre em contato com o administrador',
                        variant: 'success'
                    })
                );
            });
           
        } else {
            this.isLoading = false;
        }        
    }
}