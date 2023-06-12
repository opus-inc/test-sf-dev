import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import getPaymentConditionsByProposta from '@salesforce/apex/PropostaCadastroController.getPaymentConditionsByProposta';
import getTabelaDeVendas from '@salesforce/apex/PropostaCadastroController.getTabelaDeVendas';
import getValorTotal from '@salesforce/apex/PropostaCadastroController.getValorTotal';
import saveCondicoes from '@salesforce/apex/PropostaCadastroController.saveCondicoes';
import getClimatValueTabelaVenda from '@salesforce/apex/PropostaCadastroController.getClimatValueTabelaVenda';
import getClimatValueTabelaProposta from '@salesforce/apex/PropostaCadastroController.getClimatValueTabelaProposta';

import getEmpreendimentoById from '@salesforce/apex/PropostaCadastroController.getEmpreendimentoById';

import actionChannel from '@salesforce/messageChannel/ActionChannelProp__c';
import { publish, subscribe, MessageContext } from 'lightning/messageService';

import getPropostaById from '@salesforce/apex/PropostaCadastroController.getPropostaById';
import updatePropostaVenda from '@salesforce/apex/PropostaCadastroController.updatePropostaVenda';
import Id from '@salesforce/schema/A_o_teste__ChangeEvent.Id';
import Item_est_em_garantia__c from '@salesforce/schema/Case.Item_est_em_garantia__c';
import lang from '@salesforce/i18n/lang'

Date.prototype.toDateInputValue = (function() {
    var local = new Date(this);
    local.setMinutes(this.getMinutes() - this.getTimezoneOffset());
    return local.toJSON().slice(0,10);
});

const columnsTabCondicoes = [
    { 
        label: 'Periodicidade', 
        fieldName: 'Periodicidade_Condicao__c',
        initialWidth: 167, 
    },
    { 
        label: 'Nº de parcelas', 
        fieldName: 'Quantidade_de_parcelas__c',
        initialWidth: 147, 
    },
    { 
        label: 'Início do vencimento', 
        fieldName: 'In_cio_do_Vencimento__c', 
        type: 'date',  
        typeAttributes: {
            year: "numeric",
            month: "2-digit",
            day: "2-digit",
            timeZone: 'UTC'
        },
        initialWidth: 171,   
    },
    { 
        label: 'Valor das parcelas', 
        fieldName: 'Valor_Total_das_Parcelas__c', 
        type: 'currency',
        initialWidth: 153, 
    
    },
    { 
        label: 'Valor total', 
        fieldName: 'Valor_Total_Parcela__c', 
        type: 'currency',
        initialWidth: 114, 
    },
    { 
        label: 'Correção', 
        fieldName: 'Correcao__c',
        // initialWidth: 159, 
    },
];

/**
 *
 *
 * @export
 * @class ConditionsComparative
 * @extends {LightningElement}
 */
export default class ConditionsComparative extends LightningElement {
    /**
     * functions that handle the event of the paymentTable component
     */
    // handleChangePeriodicidade
    // handleChangeParcelas
    // inputHandleChange
    // inputHandleChange
    // handleDeleteRow
    // handleAddRow
    // handleSave

    @track isEditing = false;

    /**
     * variables of paymentTable component
     */
    columns = columnsTabCondicoes;

    tabSimulacaoColunas = [
        { 
        label: 'Periodicidade', 
        fieldName: 'Periodicidade_Condicao__c',
        initialWidth: 188, 
    },
    { 
        label: 'Nº de parcelas', 
        fieldName: 'Quantidade_de_parcelas__c',
        initialWidth: 170, 
    },
    { 
        label: 'Início do vencimento', 
        fieldName: 'In_cio_do_Vencimento__c', 
        initialWidth: 170,   
    },
    { 
        label: 'Valor das parcelas', 
        fieldName: 'Valor_Total_das_Parcelas__c', 
        type: 'currency',
        initialWidth: 159, 
    
    },
    { 
        label: 'Valor total', 
        fieldName: 'Valor_Total_Parcela__c', 
        type: 'currency',
        initialWidth: 165, 
    },
    { 
        label: 'Correção', 
        fieldName: 'Correcao__c',
        initialWidth: 145, 
    },
    ];

    // @track propostaVendaId;
    @track tabCondicoes;
    // @track faseProposta;
    @track valorTotalProp;
    @track valorIntegralProp;
    @track paymentConditions = [];
    @track isLoadingPaymentCondition;
    @track isLoading = false;
    @track taxaEmpreendimento = 0;

    @track dateToday;
    @track messageWhenRangeUnderflow = false;

    @wire(MessageContext) messageContext;

    /**
     * variables of comparativeValues component
     */

    @track cannotSendToValidation = false;
    @track propostaVendaId;
    @track propostaVenda;
    @track faseProposta;
    @track isLoadingProposta = false;
    @track type;
    @track message;
    @track showToastBar = false;
    @track autoCloseTime = 10000;
    
    @track dataTabela;
    @track dataProposta;

    @track isLoadingModal = false;
    @track isOpenModal = false;

    subscription = null;
    action;

    /**
     * functions of paymentTable component
     */
    openModalDiscount() {
        this.template.querySelector('c-popup-aplicar-desconto')?.viewModal(this.propostaVenda, this.taxaEmpreendimento, this.updateDiscount);
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

    connectedCallback() {

        console.log(lang)

        var date = new Date();

        this.dateToday = this.toJSONLocal( date );

        console.log( this.dateToday );

        this.isLoadingPaymentCondition = true;

        if (this.propostaVendaId) {
            this.getPropById(this.propostaVendaId);
            this.getValorProp(this.propostaVendaId);
            this.getCondicoesProposta(this.propostaVendaId, true, true);
            this.getCondicoesTabela(this.propostaVendaId);
            this.subscribeMC();
            //getClimatValueTabelaVenda({ propostaVendaId: this.propostaVendaId }).then(result => {
            //    this.haveClimatValue = result && result > 0;
            //    if(this.haveClimatValue) {
            //        this.valorMtQuadradoClimat = result;
            //        this.valorClimat = this.propostaVenda.Area_Privativa__c * this.valorMtQuadradoClimat;
            //        this.valorUnid = this.propostaVenda.Valor_Tabela__c - this.valorClimat;
            //        this.valorMtQuadradoUnid = this.propostaVenda.Valor_M2_Tabela__c - this.valorMtQuadradoClimat;
            //        
            //        getClimatValueTabelaProposta({ propostaVendaId: this.propostaVendaId }).then(result => {
            //            this.propostaValorUnid = this.propostaVenda.Valor_da_Proposta__c * this.valorUnid / this.propostaVenda.Valor_Tabela__c;
            //            this.propostaValorClimat = this.propostaVenda.Valor_da_Proposta__c * this.valorClimat / this.propostaVenda.Valor_Tabela__c;
            //            this.propostaValorMtQuadradoUnid = this.propostaVenda.Valor_M2__c * this.valorMtQuadradoUnid / this.propostaVenda.Valor_M2_Tabela__c;
            //            this.propostaValorMtQuadradoClimat = this.propostaVenda.Valor_M2__c * this.valorMtQuadradoClimat / this.propostaVenda.Valor_M2_Tabela__c;
            //
            //        }).catch(error => {
            //            window.console.log(error);
            //        });
            //    }
            //
            //}).catch(error => {
            //    window.console.log(error);
            //});
            
            this.isLoadingProposta = true;
        }

    }

    checkCanSendToValidation() {
        if(this.propostaVenda.Perc_Comissao_Destacada__c === 0) {
            this.cannotSendToValidation = false;
            return false;
        }

        const valorTotalSinal = this.rows.filter(item => item.Periodicidade_Condicao__c === "Sinal").reduce((a, b) => a + parseFloat(b.Valor_Total_das_Parcelas__c), 0);
        console.log(valorTotalSinal)
        const umVirgulaCincoPorCentoValorTotal = this.valorIntegralProp * 1.5 / 100;
        const comissaoDestacadaValor = this.propostaVenda.Perc_Comissao_Destacada__c * this.valorIntegralProp / 100;

        if(valorTotalSinal < comissaoDestacadaValor + umVirgulaCincoPorCentoValorTotal) {
            this.showToast('Sinais da proposta não são suficientes para destacar a comissão', 'error');
            this.cannotSendToValidation = true;
            return true;
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

                    row.Id = element.Id;
                    row.Periodicidade_Condicao__c = element.Periodicidade_Condicao__c;
                    row.Quantidade_de_parcelas__c = element.Quantidade_de_parcelas__c;
                    row.In_cio_do_Vencimento__c = element.In_cio_do_Vencimento__c;
                    row.Valor_Total_das_Parcelas__c = element.Valor_Total_das_Parcelas__c ? parseFloat(element.Valor_Total_das_Parcelas__c.toFixed(2)) : 0;
                    row.valorTotal = (row.Quantidade_de_parcelas__c * row.Valor_Total_das_Parcelas__c);
                    row.correcao = element.Correcao__c;
                    row.Atualiza_Fluxo__c = 'Não';
                    row.maxQuantidade_de_parcelas__c = 99;
                    row.messageWhenRangeOverflow = false;

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
        this.isEditing = true;

        var item = this.rows[event.target.dataset.index];

        item.Periodicidade_Condicao__c = event.detail.value;

        if(
            item.Periodicidade_Condicao__c == 'Sinal' || 
            item.Periodicidade_Condicao__c == 'Financiamento' ||
            item.Periodicidade_Condicao__c == 'Única'
        ) {
            item.Quantidade_de_parcelas__c = 1;
            item.maxQuantidade_de_parcelas__c = 1;
        } else {
            item.maxQuantidade_de_parcelas__c = 99;
        }

        if(item.Periodicidade_Condicao__c == "Sinal") {
            var currentDateMonth = new Date().getMonth() + 1;
            var chooseDateMonth = new Date(event.target.value).getMonth() + 1;

            var currentDateYear = new Date().getFullYear();
            var chooseDateYear = new Date(event.target.value).getFullYear();
            item.correcao = ( chooseDateMonth > currentDateMonth || chooseDateYear > currentDateYear ) ? 'Reajustáveis' : 'Fixas';
        } else {
            item.correcao = 'Reajustáveis';
            if(!([5, 10, 15].find(d => d === new Date(item.In_cio_do_Vencimento__c).getUTCDate()))) {
                item.error = true;
                item.errorMessage = 'Dia deve ser 05, 10 ou 15.';
                item.In_cio_do_Vencimento__c = null;
            }
        }
    }

    handleChangeParcelas(event) {
        this.isEditing = true;
        
        var item = this.rows[event.target.dataset.index];

        if(
            item.Periodicidade_Condicao__c == 'Sinal' || 
            item.Periodicidade_Condicao__c == 'Financiamento' ||
            item.Periodicidade_Condicao__c == 'Única'
        ) {
            item.Quantidade_de_parcelas__c = 1;
            item.maxQuantidade_de_parcelas__c = 1;
            item.valorTotal = item.Valor_Total_das_Parcelas__c ? (item.Quantidade_de_parcelas__c * item.Valor_Total_das_Parcelas__c) : item.valorTotal;
            return;
        } else {
            item.maxQuantidade_de_parcelas__c = 99;
        }

        event.target.value = event.target.value.length <= 0 ? 0 : event.target.value;

        item.Quantidade_de_parcelas__c = event.target.value;

        item.valorTotal = item.Valor_Total_das_Parcelas__c ? (item.Quantidade_de_parcelas__c * item.Valor_Total_das_Parcelas__c) : item.valorTotal;

        if(
            new Date(item.In_cio_do_Vencimento__c) < new Date(this.propostaVenda.Data_de_Entrega_do_Empreendimento__c) && 
            this.addMonthsUTC(new Date(item.In_cio_do_Vencimento__c), item.Quantidade_de_parcelas__c - 1) > new Date(this.propostaVenda.Data_de_Entrega_do_Empreendimento__c)
        ) {
            /**
             * Error - Início do vencimento menor que fim do empreendimento E fim do vencimento maior que o fim do empreendimento
             */
            item.In_cio_do_Vencimento__c = null;
        }


    }

    handleDeleteRow(event) {
        this.isEditing = true;
        
        if (this.rows.length > 1) this.rows.splice( event.target.dataset.index, 1 );        

        this.calcValorIntegral();
    }

    handleAddRow() {
        this.isEditing = true;
        
        if (this.rows.length < 9) this.rows.push({ Atualiza_Fluxo__c: 'Não' });

    }

    addMonthsUTC (date, count) {
        if (date && count) {
            var m, d = (date = new Date(+date)).getUTCDate()

            date.setUTCMonth(date.getUTCMonth() + count, 1)
            m = date.getUTCMonth()
            date.setUTCDate(d)
            if (date.getUTCMonth() !== m) date.setUTCDate(0)
        }
        return date
    }

    inputHandleChange(event) {
        this.isEditing = true;
        
        var fieldName = event.target.dataset.field;
        
        event.target.value = fieldName == 'Valor_Total_das_Parcelas__c' && event.target.value.length <= 0 ? 0 : event.target.value;
        
        var item = this.rows[event.target.dataset.index];
        item.error = false;

        item.messageWhenRangeOverflow = false;

        item[fieldName] = event.target.value;

        if (fieldName == 'Valor_Total_das_Parcelas__c' && item.Quantidade_de_parcelas__c) {
            item.valorTotal = (item.Quantidade_de_parcelas__c * item[fieldName]);
        }
        
        if (fieldName == 'In_cio_do_Vencimento__c' && item.In_cio_do_Vencimento__c) {
            if(
                new Date(event.target.value) < new Date(this.propostaVenda.Data_de_Entrega_do_Empreendimento__c) && 
                this.addMonthsUTC(new Date(event.target.value), item.Quantidade_de_parcelas__c - 1) > new Date(this.propostaVenda.Data_de_Entrega_do_Empreendimento__c)
            ) {
                /**
                 * Error - Início do vencimento menor que fim do empreendimento E fim do vencimento maior que o fim do empreendimento
                 */
                item.maxIn_cio_do_Vencimento__c = this.addMonthsUTC(new Date(event.target.value), -1);
                item.error = true;
                item.errorMessage = 'Data fim > entrega';
                item[fieldName] = event.target.value;
            }
          
            if(item.Periodicidade_Condicao__c != "Sinal" && !([5, 10, 15].find(d => d === new Date(event.target.value).getUTCDate()))) {
                item.error = true;
                item.errorMessage = 'Dia deve ser 05, 10 ou 15.';
                item.In_cio_do_Vencimento__c = null;

            }
            
        }

        if(fieldName != 'Valor_Total_das_Parcelas__c' && fieldName != 'Quantidade_de_parcelas__c') {
            if(item.Periodicidade_Condicao__c === "Sinal") {
                var currentDateMonth = new Date().getMonth() + 1;
                var chooseDateMonth = new Date(event.target.value).getMonth() + 1;
    
                var currentDateYear = new Date().getFullYear();
                var chooseDateYear = new Date(event.target.value).getFullYear();
                item.correcao = ( chooseDateMonth > currentDateMonth || chooseDateYear > currentDateYear ) ? 'Reajustáveis' : 'Fixas';
            } else {
                item.correcao = 'Reajustáveis';
            }
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

        this.checkCanSendToValidation();

    }

    pagarConformeTabela() {
        this.isEditing = true;
        
        if (this.tabCondicoes) {
            let rows = [];
            let i = 0;

            this.tabCondicoes.forEach(element => {
                const row = {};

                row.Periodicidade_Condicao__c = element.Periodicidade_Condicao__c;
                row.Quantidade_de_parcelas__c = element.Quantidade_de_parcelas__c;

                if(new Date(element.In_cio_do_Vencimento__c) < new Date()) {
                    row.In_cio_do_Vencimento__c = new Date().toDateInputValue();
                } else {
                    row.In_cio_do_Vencimento__c = element.In_cio_do_Vencimento__c;
                }

                row.Valor_Total_das_Parcelas__c = element.Valor_Total_das_Parcelas__c ? parseFloat(element.Valor_Total_das_Parcelas__c.toFixed(2)) : 0;
                row.valorTotal = element.Valor_Total_Parcela__c;
                
                var currentDateMonth = new Date().getMonth() + 1;   
                var chooseDateMonth = new Date(element.In_cio_do_Vencimento__c).getMonth() + 1;

                var currentDateYear = new Date().getFullYear();
                var chooseDateYear = new Date(element.In_cio_do_Vencimento__c).getFullYear();

                if(element.Periodicidade_Condicao__c === "Sinal") {
                    row.correcao = ( chooseDateMonth > currentDateMonth || chooseDateYear > currentDateYear ) ? 'Reajustáveis' : 'Fixas';
                } else {
                    row.correcao = element.Correcao__c;
                }

                row.Atualiza_Fluxo__c = 'Não';

                rows.push(row);
            });

            this.rows = rows;
        }

        this.calcValorIntegral();
    }

    pagarAVista() {
        this.isEditing = true;
        let currentDateYear = new Date().getFullYear();
        let currentDateMonth = new Date().getMonth() + 1;
        let lastDayOfMonth = new Date(currentDateYear, currentDateMonth, 0).getDate();

        
        let rows = [];
        const row = {};
        
        row.Periodicidade_Condicao__c = 'Sinal';
        row.Quantidade_de_parcelas__c = 1;
        row.In_cio_do_Vencimento__c = currentDateYear + '-' + (currentDateMonth < 10 ? '0' + currentDateMonth : currentDateMonth) + '-' + lastDayOfMonth;
        row.Valor_Total_das_Parcelas__c = parseInt(this.propostaVenda.VPL_Tabela__c);
        row.valorTotal = (this.propostaVenda.VPL_Tabela__c);
        row.Atualiza_Fluxo__c = 'Não';
        
        let chooseDateMonth = new Date(row.In_cio_do_Vencimento__c).getMonth() + 1;
        let chooseDateYear = new Date(row.In_cio_do_Vencimento__c).getFullYear();
        
        row.correcao = ( chooseDateMonth > currentDateMonth || chooseDateYear > currentDateYear ) ? 'Reajustáveis' : 'Fixas';
        
        rows.push(row);
        this.rows = rows;

        this.calcValorIntegral();
    }

    handleSave() {

        let rowsToInsert = [];

        this.rows.map(row => {

            let newRow = row;
            delete newRow.Id;
            newRow.Proposta_de_Vendas__c = this.propostaVendaId;

            rowsToInsert.push(newRow);
            
        });

        if(!this.isInputValid()) return;
        if(this.checkCanSendToValidation()) return;    


        this.isLoading = true;

        saveCondicoes({ condicoes: JSON.stringify(rowsToInsert) }).then(result => {

            if (result != null) {
                this.handleSendEvent();
                this.showToast('Operação realizada com sucesso!', 'success');
            }
            this.isLoading = false;
            this.isEditing = false;
            this.showGridInput = true;
            this.connectedCallback();

        }).catch(error => {
            window.console.log('error ', error);
            this.isLoading = false;
            // this.showToast('Erro de processamento, entre em contato com o administrador', 'error');
            this.showToast(error.body.message, 'error');
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

    
    /**
     * Functions of comparativeValues component
     */

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

    updateDiscount(event) {
        const rows = this.rows;
        const index = rows.findIndex(row => row.Id === event.detail.condicaoPagamento);
        rows[index] = { 
            ...rows[index], 
            Valor_Total_das_Parcelas__c: parseFloat(event.detail.valorParcelaAtualizado), 
            valorTotal: rows[index].Quantidade_de_parcelas__c * parseFloat(event.detail.valorParcelaAtualizado)
        };

        this.rows = rows;
        this.calcValorIntegral();
        this.isEditing = true;
    }

    getPropById(propId) {
        getPropostaById({ propostaVendaId: propId }).then(result => {
            this.isLoadingProposta = false;

            console.log(result);
            
            const options = {
                year: 'numeric', month: 'numeric', day: 'numeric',
                hour12: false
            };
 
            if (result != null) {

                this.propostaVenda = result;

                this.faseProposta = this.propostaVenda.Fase_da_Proposta__c;

                this.propostaVenda.Valor_Tabela__c = this.propostaVenda.Valor_Tabela__c ? parseFloat(parseFloat(this.propostaVenda.Valor_Tabela__c).toFixed(2)) : 0;
                this.propostaVenda.VPL_Tabela__c = this.propostaVenda.VPL_Tabela__c ? parseFloat(parseFloat(this.propostaVenda.VPL_Tabela__c).toFixed(2)) : 0;
                this.propostaVenda.VPL_Proposta__c = this.propostaVenda.VPL_Proposta__c ? parseFloat(parseFloat(this.propostaVenda.VPL_Proposta__c).toFixed(2)) : 0;
                this.propostaVenda.Variacao_VPL__c = this.propostaVenda.Variacao_VPL__c ? parseFloat(parseFloat(this.propostaVenda.Variacao_VPL__c).toFixed(2)) : 0;
                this.propostaVenda.Valor_M2__c = this.propostaVenda.Valor_M2__c ? parseFloat(parseFloat(this.propostaVenda.Valor_M2__c).toFixed(2)) : 0;
                this.propostaVenda.Valor_M2_Tabela__c = this.propostaVenda.Valor_M2_Tabela__c ? parseFloat(parseFloat(this.propostaVenda.Valor_M2_Tabela__c).toFixed(2)) : 0;
                this.propostaVenda.Variacao_Nominal__c = this.propostaVenda.Variacao_Nominal__c ? parseFloat(parseFloat(this.propostaVenda.Variacao_Nominal__c).toFixed(2)) : 0;
                this.propostaVenda.Valor_da_Proposta__c = this.propostaVenda.Valor_da_Proposta__c ? parseFloat(parseFloat(this.propostaVenda.Valor_da_Proposta__c).toFixed(2)) : 0;
                this.dataTabela = this.formatDate(this.propostaVenda.CreatedDate);
                this.dataProposta = this.formatDate(this.propostaVenda.CreatedDate, true);
                this.taxaEmpreendimento = this.propostaVenda.Bloco__r.PV_Taxa_c__c
                // getEmpreendimentoById({ empreendimentoId: this.propostaVenda.Empreendimento__c })
                //     .then(result => {
                //         this.taxaEmpreendimento = result.PV_Taxa__c
                //     });

                this.haveClimatValue = this.propostaVenda.Possui_Valor_Climat__c;
                if(this.haveClimatValue) {
                    this.valorMtQuadradoClimat = this.propostaVenda.Tabela_de_Vendas_Proposta__r.Valor_Climatiza_o__c;
                    this.valorClimat = this.propostaVenda.Area_Privativa__c * this.valorMtQuadradoClimat;
                    this.valorUnid = this.propostaVenda.Valor_Tabela__c - this.valorClimat;
                    this.valorMtQuadradoUnid = this.propostaVenda.Valor_M2_Tabela__c - this.valorMtQuadradoClimat;
                    
                    this.propostaValorUnid = this.propostaVenda.Valor_da_Proposta__c * this.valorUnid / this.propostaVenda.Valor_Tabela__c;
                    this.propostaValorClimat = this.propostaVenda.Valor_da_Proposta__c * this.valorClimat / this.propostaVenda.Valor_Tabela__c;
                    this.propostaValorMtQuadradoUnid = this.propostaVenda.Valor_M2__c * this.valorMtQuadradoUnid / this.propostaVenda.Valor_M2_Tabela__c;
                    this.propostaValorMtQuadradoClimat = this.propostaVenda.Valor_M2__c * this.valorMtQuadradoClimat / this.propostaVenda.Valor_M2_Tabela__c;
                }
            }
        }).catch(error => {
            this.isLoadingProposta = false;
            console.error(error);
            this.showToast('Erro de processamento, entre em contato com o administrador', 'error');
        });
    }

    get disableFaseProp() {
        if(this.isEditing) return true;
        return !(this.faseProposta == 'Simulação' || this.faseProposta == 'Proposta de Vendas'|| this.faseProposta == 'Proposta Rejeitada');
    }

    get disableFasePropSaveButton() {
        return !(this.faseProposta == 'Simulação' || this.faseProposta == 'Proposta de Vendas'|| this.faseProposta == 'Proposta Rejeitada');
    }

    get disableSaveButton() {
        if(!this.isEditing) return true;
        return !(this.faseProposta == 'Simulação' || this.faseProposta == 'Proposta de Vendas'|| this.faseProposta == 'Proposta Rejeitada');
    }

    get disableAprovFase() {
        return !(this.faseProposta == 'Proposta de Vendas'|| this.faseProposta == 'Proposta Rejeitada');
    }

    get disableValidarProposta() {
        return !(this.faseProposta == 'Simulação' || this.faseProposta == 'Proposta de Vendas'|| this.faseProposta == 'Proposta Rejeitada');
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
            console.error(error);
            this.showToast('Erro de processamento, entre em contato com o administrador', 'error');
        });
    }

    comparativeValuesInputHandleChange(event) {
        this.propostaVenda.Comentarios_e_Clausulas__c = event.target.value;
    }

    handleOpenEnviarProposta(event) {
        this.template.querySelector('c-popup-enviar-proposta')?.viewModal(this.cannotSendToValidation);
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