import { LightningElement, track, api } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPropostaById from '@salesforce/apex/PropostaCadastroController.getPropostaById';
import updatePropostaVenda from '@salesforce/apex/PropostaCadastroController.updatePropostaVenda';

export default class PopupAprovarProposta extends LightningElement {
    @api propostaVendaId;
    @track propostaVenda;
    @track showModal = false;
    @track isLoading = false;
    @track showEdit = false;
    @track dataLimiteAprovacao = "";
    @track codigoGerente;

    connectedCallback() {
        this.isLoading = true;
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

     
    @api viewModal() {
        this.showModal = !this.showModal;
    }

    inputHandleChange(event) {
        this.codigoGerente = event.target.value;
    }

    handleUpdateApprove(event) {
        this.isLoading = true;
        if(this.codigoGerente && this.codigoGerente == this.propostaVenda.Codigo_Gerente__c){

            let propostaVendaToUpdate = { 
                Id: this.propostaVendaId, 
                Enviar_para_Aprovacao__c: true
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

                
                this.showModal = false;
                this.connectedCallback();

            }).catch(error => {
                this.isLoading = false;
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
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Senha informada é inválida',
                    variant: 'success'
                })
            );
        }
    }

    get errorDate() {

        console.log(this.propostaVenda.Data_Limite_Aprovacao__c);

        let dataLimiteAprovacaoProposta = new Date(this.propostaVenda.Data_Limite_Aprovacao__c + "T00:00");
        let dataAtual = new Date();


        if(dataAtual.getMonth() + 1 === dataLimiteAprovacaoProposta.getMonth() + 1) {
            return dataAtual.getUTCDate() > dataLimiteAprovacaoProposta.getUTCDate();
        } else if(dataAtual.getMonth() + 1 < dataLimiteAprovacaoProposta.getMonth() + 1) {
            return false;
        } else {
            return true;
        }

    }

    get errorDate() {

        console.log(this.propostaVenda.Data_Limite_Aprovacao__c);

        let dataLimiteAprovacaoProposta = new Date(this.propostaVenda.Data_Limite_Aprovacao__c + "T00:00");
        let dataAtual = new Date();

        if(dataAtual.getYear() < dataLimiteAprovacaoProposta.getYear()) {
            return false;
        } else if(dataAtual.getMonth() + 1 === dataLimiteAprovacaoProposta.getMonth() + 1) {
            return dataAtual.getUTCDate() > dataLimiteAprovacaoProposta.getUTCDate();
        } else if(dataAtual.getMonth() + 1 < dataLimiteAprovacaoProposta.getMonth() + 1) {
            return false;
        } else {
            return true;
        }
    }

}