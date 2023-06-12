import { LightningElement, wire, track, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPropostaById from '@salesforce/apex/PropostaCadastroController.getPropostaById';
import updatePropostaVenda from '@salesforce/apex/PropostaCadastroController.updatePropostaVenda';
import getPickListOptions from '@salesforce/apex/PropostaCadastroController.getPickListOptions';
import getContentVersion from '@salesforce/apex/PropostaCadastroController.getContentVersion';
import isCorretorMaster from '@salesforce/apex/PropostaCadastroController.isCorretorMaster';

export default class PropostaCadastro extends LightningElement {

    @track propostaVendaId;
    @track corretorId;
    @track currentCorretorId;
    @track corretorMaster;
    @track propostaVenda;
    @track faseProposta;
    @track isCustomerModalOpen = false;
    @track isOpenCommentsModal = false;
    @track isLoadingModal = false;
    @track customer = {};
    @track customerInput = {};
    @track fasesPicklist = [];
    @track indexCurrentStatus;
    @track isLoading = false;
    @track isLoadingProposta = false;
    @track selectedStage;
    @track type;
    @track message;
    @track autoCloseTime = 6000;

    @track empreendimentoImages = [];
    @track unidadeImages = [];
    @track disableStatusButton = true;
    @track empreendimentoImage = '';
    @track unidadesProposta = [];
    @track garagensProposta = [];
    @track itensAdicionaisProposta = [];

    @track linkPastaFacilita = '';

    @wire(CurrentPageReference) async wiredPageRef(pageRef) {
        // const idCorretor = localStorage.getItem('corretorId');
        // console.log("this.pageRef.state", this.pageRef.state);
        // console.log("idCorretor", idCorretor);
        
        // if(!idCorretor){
        //     window.open(`${window.location.href.split("/pv/")[0]}/pv/`, "_self");
        //     return;
        // }
        
        // if(idCorretor !== pageRef.state.corretorId){
        //     try {
        //         isCorretorMaster({ corretorId: idCorretor }).then(result => {
        //             console.log(result);
        //             if(!result) {
        //                 throw new Error("Não é um usuário master!")
        //             }
        //         });
        //     } catch (error) {
        //         window.open(`${window.location.tem 

        // }

        this.pageRef = pageRef;
        if (!this.pageRef) {
            this.pageRef = {};
            this.pageRef.attributes = {};
            this.pageRef.attributes.LightningApp = "LightningApp";
        }
        
        if(this.pageRef.state.recordId && !this.pageRef.state.corretorId) {
            window.open(`${window.location.href.split("/pv/")[0]}/pv/`, "_self");
        }

        this.propostaVendaId = this.pageRef.state.recordId;
        this.corretorId = this.pageRef.state.corretorId;
        this.currentCorretorId = localStorage.getItem('corretorId');
    }

    @wire(isCorretorMaster, { corretorId: "$currentCorretorId" })
    checkIfCorretorIsMaster({ error, data }) {
        if(this.corretorId) {
            console.log("this.corretorId", this.corretorId);
            // console.log("idCorretor", idCorretor);
            if(data) {
                this.corretorMaster = true;
            }
            
            if(!this.currentCorretorId){
                window.open(`${window.location.href.split("/pv/")[0]}/pv/`, "_self");
                return;
            }
            
            if(!this.corretorMaster && this.currentCorretorId !== this.corretorId) {
                window.open(`${window.location.href.split("/pv/")[0]}/pv/`, "_self");
            }
        }
    }

    openCommentaryModal(event) {
        this.isOpenCommentsModal = true;
    }

    closeCommentaryModal(event) {
        this.isLoadingModal = false;
        this.isOpenCommentsModal = false;
    }

    handleSaveEditCommentary(event) {
        this.isLoadingModal = true;
        let propostaVendaToUpdate = { Id: this.propostaVendaId, Comentarios_e_Clausulas__c: this.propostaVenda.Comentarios_e_Clausulas__c };


        updatePropostaVenda({ fields: JSON.stringify(propostaVendaToUpdate) }).then(result => {
            this.isLoadingModal = false;

            this.closeCommentaryModal();
            this.connectedCallback();

        }).catch(error => {
            this.isLoadingModal = false;
            this.showToast('Erro de processamento, entre em contato com o administrador', 'error');
        });
    }

    comparativeValuesInputHandleChange(event) {
        this.propostaVenda.Comentarios_e_Clausulas__c = event.target.value;
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
        this.type = '';
        this.message = '';
    }

    monthDiff(d1, d2) {
        let months;
        months = (d2.getFullYear() - d1.getFullYear()) * 12;
        months -= d1.getMonth();
        months += d2.getMonth();
        return months <= 0 ? 0 : months;
    }

    connectedCallback() {
        this.isLoadingProposta = true;

        // isCorretorMaster({ corretorId: this.corretorId }).then(result => {
        //     console.log(result);
        //     this.corretorMaster = result;
        // })

        getPropostaById({ propostaVendaId: this.propostaVendaId }).then(result => {
            this.isLoadingProposta = false;

            if (result != null) {
                this.propostaVenda = result;
            }

            if(result.Status_Transferencia__c) {
                this.propostaVenda.Name = result.Name + "T";
            }

            if(!result.Empreendimento__r.Numero_Blocos__c || result.Empreendimento__r.Numero_Blocos__c === 1) {
                this.propostaVenda.Nome_do_Empreendimento__c = this.propostaVenda.Nome_do_Empreendimento__c;
            } else {
                this.propostaVenda.Nome_do_Empreendimento__c = this.propostaVenda.Nome_do_Empreendimento__c + " | " + this.propostaVenda.Bloco__r.Name;
            }

            this.propostaVenda.Data_de_Entrega_do_Empreendimento__c = new Date(this.propostaVenda.Data_de_Entrega_do_Empreendimento__c);
            this.propostaVenda.mesesEntrega = this.monthDiff(new Date(), new Date(this.propostaVenda.Data_de_Entrega_do_Empreendimento__c));

            // if ( this.propostaVenda.Empreendimento__c && this.propostaVenda.Empreendimento__r.Data_Previs_o_de_Entrega__c) {

            //     this.propostaVenda.Empreendimento__r.Data_Previs_o_de_Entrega__c = this.propostaVenda.Empreendimento__r.Data_do_Habite_se__c ? this.propostaVenda.Empreendimento__r.Data_do_Habite_se__c :
            //                                                                             this.propostaVenda.Empreendimento__r.Data_Previs_o_de_Entrega__c;

            //     this.propostaVenda.mesesEntrega = this.monthDiff(new Date(),new Date(this.propostaVenda.Empreendimento__r.Data_Previs_o_de_Entrega__c));
            //     this.propostaVenda.Empreendimento__r.Data_Previs_o_de_Entrega__c = new Date(this.propostaVenda.Empreendimento__r.Data_Previs_o_de_Entrega__c);
            // }

            this.propostaVenda.Area_Privativa__c = this.propostaVenda.Area_Privativa__c ? this.propostaVenda.Area_Privativa__c + ' m² ' : '';

            this.getPickListOptions();
            this.getContentVersionEmpreendimento();


            if (result.Unidades_da_Proposta__r != null && result.Unidades_da_Proposta__r.length > 0) {
                if(this.unidadesProposta.length > 0) {
                    this.unidadesProposta = [];
                }
                if(this.garagensProposta.length > 0) {
                    this.garagensProposta = [];
                }
                result.Unidades_da_Proposta__r.forEach(element => {
                    console.log(element);
                    if (element.Unidade__r.Tipo_da_unidade__c == 'Unidade') {

                        // this.unidadesProposta.pop();
                        this.unidadesProposta.push({ 
                            ...element, 
                            ...((element.Unidade__r.Status_Secund_rio__c === 'Reserva Técnica' || element.Unidade__r.Status_Secund_rio__c === 'Reserva Negociação') && { 
                                Unidade__r: { ...element.Unidade__r, Name: element.Unidade__r.Name +  " | " + element.Unidade__r.Status_Secund_rio__c.toUpperCase() }
                            })});
                        if(element.Unidade__r.N_mero_de_vagas_de_garagem__c) {
                            this.garagensProposta.push({
                                "Id": element.Id,
                                "Proposta_de_Vendas__c": element.Proposta_de_Vendas__c,
                                "Unidade__c": element.Unidade__c,
                                "Unidade__r": {
                                    "Tipo_da_unidade__c": "Garagem",
                                    "Id": element.Unidade__r.Id,
                                    "Name": element.Unidade__r.N_mero_de_vagas_de_garagem__c,
                                    ...(element.Unidade__r.N_mero_de_vagas_de_garagem__c === "Sem Garagem" && { "Name": "Vaga Indeterminada"})
                                }
                            });
                        }
                    } else if (element.Unidade__r.Tipo_da_unidade__c == 'Garagem') {
                        // this.garagensProposta.pop();
                        this.garagensProposta.push(element);
                    }
                });
            }

            if (result.Itens_Adicionais_da_Proposta__r != null && result.Itens_Adicionais_da_Proposta__r.length > 0) {
                if(this.itensAdicionaisProposta.length > 0) {
                    this.itensAdicionaisProposta = [];
                }

                result.Itens_Adicionais_da_Proposta__r.forEach(element => {
                    this.itensAdicionaisProposta.push(element);
                })

            }

            this.faseProposta = result.Fase_da_Proposta__c;
            this.linkPastaFacilita = "https://opus.facilitavendas.com/vendas/negocios/" + this.propostaVenda.Numero_pasta_Facilita__c;

            
        }).catch(error => {
            console.log('error ', error);

            this.isLoadingProposta = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Erro de processamento, entre em contato com o administrador',
                    variant: 'error'
                })
            );
        });
    }

    imprimir() {
       window.print();
    }

    get disableChangeCorretor() {
        return (this.faseProposta == 'Confecção do Contrato ' || this.faseProposta == 'Contrato Elaborado');
    }

    get disableChangeUnidade() {
        return this.faseProposta != 'Simulação';

    }

    get disableFaseProp() {
        return !(this.faseProposta == 'Simulação' || this.faseProposta == 'Proposta de Vendas' || this.faseProposta == 'Proposta Rejeitada');
    }

    get disablePropInterFase() {
        return false;
        // return !(this.faseProposta == 'Proponentes e Intermediação');
    }

    getPickListOptions() {
        getPickListOptions({ fieldName: 'Fase_da_Proposta__c' }).then(optionsResult => {
            var isBeforeCurrentStatus = true;
            this.fasesPicklist = [];
            optionsResult.map(element => {
                var newElement = {};
                if (isBeforeCurrentStatus && element.value !== this.propostaVenda.Fase_da_Proposta__c) {
                    newElement = { pathClass: "slds-path__item slds-is-complete", value: element.value, label: element.label };
                } else if (isBeforeCurrentStatus && element.value === this.propostaVenda.Fase_da_Proposta__c) {
                    isBeforeCurrentStatus = false;
                    newElement = { pathClass: "slds-path__item slds-is-current slds-is-active", value: element.value, label: element.label };
                } else if (!isBeforeCurrentStatus && element.value !== this.propostaVenda.Fase_da_Proposta__c) {
                    newElement = { pathClass: "slds-path__item slds-is-incomplete", value: element.value, label: element.label };
                }
                this.fasesPicklist.push(newElement);
            });
        }).catch(error => {

        });
    }

    openEditCustomerModal(event) {
        this.isCustomerModalOpen = true;
    }

    closeEditCustomerModal(event) {
        this.isCustomerModalOpen = false;
        this.isLoading = false;
        this.customerInput = {};
    }

    inputHandleChange(event) {
        var fieldName = event.target.dataset.field;
        var fieldType = event.target.type;

        if (fieldType == 'checkbox') {
            this.customerInput[fieldName] = event.target.checked;
        } else {
            this.customerInput[fieldName] = event.target.value;
        }
    }

    handleSaveEdit(event) {
        this.isLoading = true;
        this.customerInput.Id = this.propostaVendaId;
        console.log(' this.customerInput ', JSON.stringify(this.customerInput));
        if (Object.keys(this.customerInput).length >= 1) {
            updatePropostaVenda({ fields: JSON.stringify(this.customerInput) }).then(result => {
                this.connectedCallback();
                if (result != null) {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Operação realizada com sucesso!',
                            variant: 'success'
                        })
                    );
                this.linkPastaFacilita = "https://opus.facilitavendas.com/vendas/negocios/" + this.propostaVenda.Numero_pasta_Facilita__c;
                }
                this.closeEditCustomerModal();
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

    getContentVersionEmpreendimento() {
        this.empreendimentoImages = []
        var recordList = [this.propostaVenda.Empreendimento__c];

        getContentVersion({ recordIds: JSON.stringify(recordList) }).then(result => {

            if (result.length > 0) {
                result.map(element => {
                    this.empreendimentoImages.push({
                        //Id: this.propostaVenda.Empreendimento__c,
                        Id: this.propostaVenda.Empreendimento__c,
                        url: 'data:image/png;base64,' + element
                    });
                });
            }
        }).catch(error => {

        });
    }

    getContentVersionUnidade() {
        if (this.propostaVenda.Unidades_da_Proposta__r && this.propostaVenda.Unidades_da_Proposta__r.length > 0) {
            var recordList = this.propostaVenda.Unidades_da_Proposta__r.map(element => {
                return element.Unidade__r.Id;
            });
            getContentVersion({ recordIds: JSON.stringify(recordList) }).then(result => {
                if (result.length > 0) {
                    result.map(element => {
                        this.unidadeImages.push({
                            Id: element.Id,
                            label: element.FirstPublishLocation.Name,
                            url: 'https://opus--pvv2--c.documentforce.com/sfc/servlet.shepherd/version/download/' + element.Id
                        });
                    });
                }
            }).catch(error => {

            });
        }
    }

    keyCheckOnlyNumber(event) {
        if (event.keyCode < 48 || event.keyCode > 57) {
            event.preventDefault();
        }
    }

    pathHandler2(event) {
        let targetId = event.currentTarget.id;
        targetId = targetId.replaceAll('-', '').replaceAll(/[0-9]/g, "");
        //var isBeforeCurrentStatus = true;
        this.fasesPicklist = this.fasesPicklist.map(element => {
            var newElement = {};
            console.log('targetId ' + targetId);
            console.log('element.value ' + element.value);
            if (element.value === targetId) {
                newElement = { pathClass: "slds-path__item slds-is-active", value: element.value, label: element.label };
            } else if (element.value !== targetId && element.value !== this.propostaVenda.Fase_da_Proposta__c) {
                newElement = { pathClass: "slds-path__item slds-is-incomplete", value: element.value, label: element.label };
            } else if (element.value === this.propostaVenda.Fase_da_Proposta__c) {
                newElement = { pathClass: "slds-path__item slds-is-current slds-is-active", value: element.value, label: element.label };
            }
            return newElement;
        });
        this.selectedStage = targetId;
        this.disableStatusButton = false;
    }

    handleSave(event) {
        this.isLoadingProposta = true;
        let stageInput = { Id: this.propostaVendaId, Fase_da_Proposta__c: this.selectedStage };
        this.disableStatusButton = true;
        console.log('salvar status');

        updatePropostaVenda({ fields: JSON.stringify(stageInput) }).then(result => {
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
        }).catch(error => {
            this.isLoadingProposta = false;

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Erro de processamento, entre em contato com o administrador',
                    variant: 'error'
                })
            );
        });
    }

    handleOpenChangeCorretor(event) {
        this.template.querySelector('c-popup-change-corretor')?.viewModal(this.propostaVendaId);
    }

    handleOpenChangeUnidade(event) {
        this.template.querySelector('c-popup-change-property')?.viewModal(this.propostaVenda.Empreendimento__r.Id, this.propostaVendaId);
    }

    handleOpenProponente(event) {
        this.template.querySelector('c-popup-proponente')?.viewModal();
    }
    handleOpenIntermediacao(event) {
        this.template.querySelector('c-popup-intermediacao')?.viewModal();
    }

    get hasItemAdicional() {
        return this.itensAdicionaisProposta.length > 0;
    }

}