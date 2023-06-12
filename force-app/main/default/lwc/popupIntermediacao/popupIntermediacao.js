import { LightningElement, track, api } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getIntermediacaoByProposta from '@salesforce/apex/PropostaCadastroController.getIntermediacaoByProposta';
import upsertIntermediacao from '@salesforce/apex/PropostaCadastroController.upsertIntermediacao';
import deleteIntermediacaoById from '@salesforce/apex/PropostaCadastroController.deleteIntermediacaoById';

export default class PopupIntermediacao extends LightningElement {

    @track type;
    @track message;
    @track showToastBar = false;
    @track autoCloseTime = 3000;


    @api propostaVendaId;
    @track intermediacoes = [];
    @track intermediacao = {};
    @track showModal = false;
    @track showEdit = false;
    @track showRecord = false;
    @track showModalRecord = false;
    @track intermediacaoInput = {};
    @track isLoading = false;
    @track error = false;
    @track intermediacaoPessoaFisica = true;
    @track intermediacaoPessoaFisicaValue = 'true';
    @track intermediacaoPessoaFisicaValueText = 'Pessoa Física'
    @track tipoIntermediacaoOptions = [{label: 'Pessoa Física', value: 'true'},{label: 'Pessoa Jurídica', value: 'false'}];
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
                alternativeText: 'dekete',
                disabled: false
            }
        },
        {label:'Nome', fieldName:'Name'},
        {label:'CPF/CNPJ',fieldName:'CPF_CNPJ__c'},
        {label:'Tipo Comissão',fieldName:'Tipo_de_Comissao__c'},
        {label:'%',fieldName:'Porcentagem__c'},
        {
            label:'Valor',
            fieldName:'Valor__c',
            type: 'currency',
            typeAttributes: { currencyCode: 'BRL', step: '0.001' },
        },
    ];

    @track tipo = [
        {
            label: 'Corretor', 
            value: 'Corretor'
        },
        {
            label: 'Gerente', 
            value: 'Gerente'
        },
        {
            label: 'Imobiliária Parceira', 
            value: 'Imobiliária Parceira'
        },
        {
            label: 'Opus Vendas', 
            value: 'Opus Vendas'
        },
    ];

    @track tipoComissao = [
        {
            label: 'Faturado', 
            value: 'Faturado'
        },
        {
            label: 'Destacado', 
            value: 'Destacado'
        },
    ];

    connectedCallback() {
        this.isLoading = true;
        console.log('this.propostaVendaId', this.propostaVendaId);

        getIntermediacaoByProposta({ propostaVendaId: this.propostaVendaId }).then(result => {
            this.isLoading = false;
            if (result != null && result.length > 0) {
                this.intermediacoes = result;                
            }

        }).catch(error => {
            console.log('error ', error);
            this.isLoading = false;
            this.showToast('Erro de processamento, entre em contato com o administrador', 'error');

            
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
    
    handleTipoIntermediacaoChange(event) {
        console.log(event.target.value); 
        this.intermediacaoPessoaFisica = event.target.value === "true";
        this.intermediacaoPessoaFisicaValueText = event.target.value === "true" ? "Pessoa Física" : "Pessoa Jurídica";
    }

    inputHandleChange(event) {
        var fieldName = event.target.dataset.field;
        var fieldType = event.target.type;

        if (fieldType == 'checkbox') {
            this.intermediacaoInput[fieldName] = event.target.checked;
        } else if(fieldName === 'Name' || fieldName === 'Razao_Social__c') {
            this.intermediacaoInput['Name'] = event.target.value;
            this.intermediacaoInput['Razao_Social__c'] = event.target.value;
        } else {
            this.intermediacaoInput[fieldName] = event.target.value;
        }
    }

    get tipoComissaoDestacada() {
        return this.intermediacao.Tipo_de_Comissao__c === "Destacado"
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row        = event.detail.row;
        this.intermediacaoPessoaFisica = row.Pessoa_Fisica__c;
        this.intermediacaoPessoaFisicaValueText = row.Pessoa_Fisica__c ? "Pessoa Física" : "Pessoa Jurídica";

        switch (actionName) {
            case 'delete':
                this.deleteRow(row.Id);
                break;
            case 'edit':
                //this.editRow(row);
                this.intermediacao = row;
                this.showModalRecord = true;
                this.showModal = false;
                break;
            case 'show_details':
                // this.showRowDetails(row);
                this.intermediacao = row;
                break;
            case 'download':
                window.location.href = row.downloadUrl;
                break;
            default:
        }
    }
    
    handleNewRecord(event){
        this.intermediacao = {};
        this.intermediacaoInput = {};
        this.showModal = false;
        this.showModalRecord = true;
        this.showEdit = true;
        this.intermediacaoPessoaFisica = true;
    }

    validateFields(intermediacao) {
        if(
            intermediacao.Pessoa_Fisica__c && 
            (
                !intermediacao.Name || 
                !intermediacao.Razao_Social__c ||
                !intermediacao.CPF_CNPJ__c ||
                !intermediacao.Tipo_de_Comissao__c ||
                !intermediacao.Porcentagem__c
            )
        ){
            return false;
        }
        
        if(
            intermediacao.Pessoa_Fisica__c && 
            (
                intermediacao.Name === '' || 
                intermediacao.Razao_Social__c === '' ||
                intermediacao.CPF_CNPJ__c === '' ||
                intermediacao.Tipo_de_Comissao__c === '' ||
                intermediacao.Porcentagem__c === ''
            )
        ){
            return false;
        }

        return true;
    }


    handleSaveEdit(event) {
        this.isLoading = true;
        if(this.intermediacao.Id){            
            this.intermediacaoInput.Id = this.intermediacao.Id;            
        }
        
        this.intermediacaoInput.Proposta_de_Vendas__c = this.propostaVendaId;
        this.intermediacaoInput.Pessoa_Fisica__c = this.intermediacaoPessoaFisica;

        if(!this.validateFields(this.intermediacaoInput)) {
            this.showToast('Por favor preencha os campos obrigatórios', 'info');

            this.isLoading = false;
            return;
        }
        
        console.log(' this.customerInput ', JSON.stringify(this.intermediacaoInput));
        if (Object.keys(this.intermediacaoInput).length >= 1) {
            upsertIntermediacao({ fields: JSON.stringify(this.intermediacaoInput) }).then(result => {
                this.connectedCallback();
                if (result != null) {
                    this.showToast('Operação realizada com sucesso!', 'success');
                }
                this.viewModal();
                this.showModalRecord = false;
            }).catch(error => {
                console.log(error);
                this.isLoading = false;
                // this.error = true;  
                this.showToast(error.body.message.split(", ")[1], 'error');

            });
        } else {
            this.showToast('Por favor preencha umas das informações', 'info');
            
            this.isLoading = false;
        }            
    }



    deleteRow(intermediacaoId) {
        this.isLoading = true;
                
        deleteIntermediacaoById({ intermediacaoId: intermediacaoId}).then(result=>{
            this.showToast('Operação realizada com sucesso!', 'success');
            
            this.connectedCallback();
        }).catch(error => {
            this.showToast('Erro de processamento, entre em contato com o administrador', 'error');

        });        
    }

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
}