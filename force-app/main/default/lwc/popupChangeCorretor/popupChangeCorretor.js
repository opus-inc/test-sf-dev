import { LightningElement, track, api, wire } from 'lwc';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getCorretoresMaster from '@salesforce/apex/PropostaCadastroController.getCorretoresMaster';
import changeCorretorProposta from '@salesforce/apex/PropostaCadastroController.changeCorretorProposta';

export default class PopupProponente extends NavigationMixin(LightningElement) {
    @api propostaVendaId;
    @track corretores = [];
    @track showModal = false;
    @track isLoading = false;
    @track corretorSelectedId = null;
    @track corretorId;

    @wire(CurrentPageReference) wiredPageRef(pageRef) {
        this.pageRef = pageRef;
        
        if (!this.pageRef) {
            this.pageRef = {};
            this.pageRef.attributes = {};
            this.pageRef.attributes.LightningApp = "LightningApp";
        }

        if(this.pageRef.state.corretorId){
            this.corretorId = this.pageRef.state.corretorId;
        } else {
            this.corretorId = this.pageRef.state.recordId;
        } 

    }

    connectedCallback() {
        this.isLoading = true;

        getCorretoresMaster({ corretorId: this.corretorId }).then(result => {
            this.isLoading = false;
            if (result != null && result.length > 0) {
                this.corretores = result.map(corretor => ({
                    label: corretor.CPF__c + " | " + corretor.Name.toUpperCase(),
                    value: corretor.Id
                }));
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

    handleChangeCorretor(event) {
        this.corretorSelectedId = event.detail.value;
    }

    handleCancelar(){
        this.viewModal();
    }

    inputHandleChange(event) {
        var fieldName = event.target.dataset.field;
        var fieldType = event.target.type;

        if (fieldType == 'checkbox') {
            this.proponentInput[fieldName] = event.target.checked;
        } else {
            this.proponentInput[fieldName] = event.target.value;
        }
    }

    navigateToPropostas() {
        window.open(`${window.location.href.split("/pv/")[0]}/pv/propostas?recordId=${this.corretorId}`, "_self");
        
        // this[NavigationMixin.Navigate]({
        //     type: 'standard__webPage',
        //     attributes: {
        //         url
        //     }
        // });
    }

    handleSave(event) {
        this.isLoading = true;
        
        changeCorretorProposta({ 
            corretorId: this.corretorId, 
            corretorSelectedId: this.corretorSelectedId, 
            propostaId: this.propostaVendaId 
        }).then(result => {
            this.connectedCallback();
            if (result != null) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Operação realizada com sucesso!',
                        variant: 'success'
                    })
                );
            }
            
            this.navigateToPropostas();

        }).catch(error => {
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


    get disabledSaveButton() {
        return !(this.corretorSelectedId);
    }

}