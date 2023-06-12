import { LightningElement, track, api } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getProponentesByProposta from '@salesforce/apex/PropostaCadastroController.getProponentesByProposta';
import upsertProponentes from '@salesforce/apex/PropostaCadastroController.upsertProponentes';
import deleteProponenteById from '@salesforce/apex/PropostaCadastroController.deleteProponenteById';
//import getPropostaById from '@salesforce/apex/PropostaCadastroController.getPropostaById';
//import updatePropostaVenda from '@salesforce/apex/PropostaCadastroController.updatePropostaVenda';

export default class PopupProponente extends LightningElement {
    @api propostaVendaId;
    @track proponente = {};
    @track proponentes = [];
    @track showModal = false;
    @track showEdit = false;
    @track showModalRecord = false;
    @track proponentInput = {};
    @track proponentePessoaFisica = true;
    @track proponentePessoaFisicaValue = 'true';
    @track proponentePessoaFisicaValueText = 'Pessoa Física'
    @track tipoProponenteOptions = [{label: 'Pessoa Física', value: 'true'},{label: 'Pessoa Jurídica', value: 'false'}];
    @track estadoCivil = [
        {
            label: 'Solteiro', 
            value: 'Solteiro'
        },
        {
            label: 'Casado', 
            value: 'Casado'
        },
        {
            label: 'Separado', 
            value: 'Separado'
        },
        {
            label: 'Divorciado', 
            value: 'Divorciado'
        },
        {
            label: 'Viúvo', 
            value: 'Viúvo'
        },
    ];
    @track tipoUniao = [
        {
            label: 'Comunhão Universal de Bens', 
            value: 'Comunhão Universal de Bens'
        },
        {
            label: 'Comunhão Parcial de Bens', 
            value: 'Comunhão Parcial de Bens'
        },
        {
            label: 'Separação de Bens', 
            value: 'Separação de Bens'
        },
        {
            label: 'Participação Final nos Aquestos', 
            value: 'Participação Final nos Aquestos'
        },
        {
            label: 'União Estável', 
            value: 'União Estável'
        },
    ];
    @track isLoading = false;

    columns = [
        {
            type: 'button-icon',
            fixedWidth: 40,
            typeAttributes: {
                iconName: 'utility:edit_form',
                name: 'edit',
                title: 'Clique para Editar',
                variant: 'bare',
                alternativeText: 'edit',
                disabled: false
            }
        },
        {
            type: 'button-icon',
            fixedWidth: 40,
            typeAttributes: {
                iconName: 'utility:ban',
                name: 'delete',
                title: 'Clique para excluir',
                variant: 'bare',
                alternativeText: 'delete',
                disabled: false
            }
        },
        {label:'CPF/CNPJ',fieldName:'CPF_CNPJ__c'},
        {label:'Nome', fieldName:'Name'},
        {label: 'E-mail', fieldName: 'Email__c'}
    ];

    connectedCallback() {
        this.isLoading = true;
        console.log('this.propostaVendaId', this.propostaVendaId);

        getProponentesByProposta({ propostaVendaId: this.propostaVendaId }).then(result => {
            this.isLoading = false;
            if (result != null && result.length > 0) {
                this.proponentes = result;
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
        this.showEdit = false;
    }

    @api viewModalRecord() {
        this.showModalRecord = !this.showModalRecord;
        this.showEdit = false;
        this.viewModal();
    }

    handleOpenEdit(event){
        this.showEdit = !this.showEdit;
    }

    handleVoltar(){
        if(this.showEdit == true){
            this.showEdit = false;
        } else {
            this.viewModal();
        }       
    }

    handleVoltarModalRecord(){
        if(this.showEdit == true){
            this.showEdit = false;
        } else {
            this.viewModalRecord();
        }  
    }

    handleTipoProponenteChange(event) {
        this.proponentePessoaFisica = event.target.value === "true";
        this.proponentePessoaFisicaValueText = event.target.value === "true" ? "Pessoa Física" : "Pessoa Jurídica";
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

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row        = event.detail.row;
        console.log(row);
        this.proponentePessoaFisica = row.RecordTypeId === "0124A000001IuzJQAS";
        this.proponentePessoaFisicaValueText = row.RecordTypeId === "0124A000001IuzJQAS" ? "Pessoa Física" : "Pessoa Jurídica";
        switch (actionName) {
            case 'delete':                
                this.deleteRow(row.Id);
                break;
            case 'edit':
                //this.editRow(row);
                this.proponente = row;
                this.showModalRecord = true;
                this.showModal = false;
                break;
            case 'show_details':
                this.proponente = row;
                break;
            case 'download':
                window.location.href = row.downloadUrl;
                break;
            default:
        }
    }

    handleNewRecord(event){
        this.proponente = {};
        this.proponentInput = {};
        this.showModal = false;
        this.showModalRecord = true;
        this.showEdit = true;
        this.proponentePessoaFisica = true;
    }

    handleSaveEdit(event) {
        this.isLoading = true;
        if(this.proponente.Id){            
            this.proponentInput.Id = this.proponente.Id;            
        }
        this.proponentInput.Proposta_de_Vendas__c = this.propostaVendaId;
        this.proponentInput.RecordTypeId = this.proponentePessoaFisica ? "0124A000001IuzJQAS" : "0124A000001IuzOQAS";
        
        console.log(' this.customerInput ', JSON.stringify(this.proponentInput));
        if (Object.keys(this.proponentInput).length >= 1) {
            upsertProponentes({ fields: JSON.stringify(this.proponentInput) }).then(result => {
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
                
                this.viewModal();
                this.showModalRecord = false;
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
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Warning',
                    message: 'Por favor preencha umas das informações',
                    variant: 'info'
                })
            );
            this.isLoading = false;
        }
    }

    deleteRow(proponenteId) {
        this.isLoading = true;
                
        deleteProponenteById({ proponenteId: proponenteId}).then(result=>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Operação realizada com sucesso!',
                    variant: 'success'
                })
            );
            this.connectedCallback();
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Erro de processamento, entre em contato com o administrador',
                    variant: 'error'
                })
            );
        });        
    }

}