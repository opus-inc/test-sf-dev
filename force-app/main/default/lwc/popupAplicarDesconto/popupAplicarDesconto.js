import { LightningElement, track, api, wire } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { publish, MessageContext } from 'lightning/messageService';
import updateCondicaoDiscount from '@salesforce/apex/PropostaCadastroController.updateCondicaoDiscount';
import getCondicoesById from '@salesforce/apex/PropostaCadastroController.getCondicoesById';
import actionChannel from '@salesforce/messageChannel/ActionChannelProp__c';

export default class PopupAplicarDesconto extends LightningElement {
    @track condicaoPagamentoDesconto;
    @track percentualDesconto;
    @track paymentConditions;
    @track showModal = false;
    @track isLoadingModalDiscount = false;
    @track proposta;
    @track selectedCondicao;
    @track aplicarDescontoBotaoDisabled = true;
    @track taxaEmpreendimento;
    @track valorParcelaComDesconto = 0;
    @track condicoes = [];
    @track showValorDesconto = false;
    @track showValorDescontoPositivo = false;
    @track updateDiscount;

    @wire(MessageContext) messageContext;

    @api get propostaVendaOption() {
        return this.paymentConditions;
    }
    set propostaVendaOption(value) {
        this.paymentConditions = value;
    }

    handleChangeCondicaoDesconto(event) {
        this.condicaoPagamentoDesconto = event.detail.value;
        if(parseFloat(this.percentualDesconto) <= 10 && this.condicaoPagamentoDesconto) {
            this.aplicarDescontoBotaoDisabled = false;
        }
    }

    handleVoltarShowValor() {
        this.showValorDesconto = false;
        this.showValorDescontoPositivo = false;
        this.showValorDescontoNegativo = false;
        this.valorParcelaComDesconto = 0;
    }

    handleChangePercentualDesconto(event) {
        this.percentualDesconto = event.detail.value;
        if(parseFloat(event.detail.value) <= 10 && this.condicaoPagamentoDesconto) {
            this.aplicarDescontoBotaoDisabled = false;
        }
    }

    handleSaveDiscount(event) {
        this.isLoadingModalDiscount = true;

        updateCondicaoDiscount({
            condicao: this.condicaoPagamentoDesconto,
            desconto: this.percentualDesconto
        }).then(result => {
            if (result != null) {

                this.handleSendEvent(result);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Operação realizada com sucesso!',
                        variant: 'success'
                    })
                );
            }

            this.isLoadingModalDiscount = false;
            this.viewModal();
        }).catch(error => {
            window.console.log(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Erro de processamento, entre em contato com o administrador',
                    variant: 'success'
                })
            );
        });
    }

    @api viewModal(proposta = {}, taxaEmpreendimento = 0, updateDiscount) {
        this.showModal = !this.showModal;
        
        if (proposta.Id) {
            this.proposta = proposta;
            this.taxaEmpreendimento = taxaEmpreendimento;
            this.updateDiscount = updateDiscount;
            const idsCondicao = this.paymentConditions.map(condicao => condicao.id);
            getCondicoesById({ ids: idsCondicao }).then(result => {
                this.condicoes.push(...result);
            });
        } else {
            this.condicaoPagamentoDesconto = null;
            this.percentualDesconto = null;
            // this.paymentConditions = null;
            this.showModal = false;
            this.isLoadingModalDiscount = false;
            this.proposta = null;
            this.selectedCondicao = null;
            this.aplicarDescontoBotaoDisabled = true;
            this.taxaEmpreendimento = null;
            this.valorParcelaComDesconto = 0;
            this.condicoes = [];
            this.showValorDesconto = false;
            this.showValorDescontoPositivo = false;
        }
    }

    handleSendEvent(value) {
        publish(this.messageContext, actionChannel, { actionName: 'update values', discount: this.percentualDesconto, valueProp: value });
    }

    handleConcluir() {
        const selectedEvent = new CustomEvent("update", {
            detail: {
                valorParcelaAtualizado: this.valorParcelaComDesconto,
                condicaoPagamento: this.condicaoPagamentoDesconto,
            }  
        });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
        // this.updateDiscount(this.valorParcelaComDesconto, this.condicaoPagamentoDesconto);
        this.showModal = false;
        this.condicaoPagamentoDesconto = null;
        this.percentualDesconto = null;
        this.showModal = false;
        this.isLoadingModalDiscount = false;
        this.proposta = null;
        this.selectedCondicao = null;
        this.aplicarDescontoBotaoDisabled = true;
        this.taxaEmpreendimento = null;
        this.valorParcelaComDesconto = 0;
        this.condicoes = [];
        this.showValorDesconto = false;
        this.showValorDescontoPositivo = false;
    }

    handleLoading() {
        return new Promise((resolve, reject) => {
            this.isLoadingModalDiscount = !this.isLoadingModalDiscount;
            setTimeout(() => {
                resolve();
            }, 5000);
            resolve();
        });   
    }

    async handleAplicaDesconto() {
        this.isLoadingModalDiscount = true;

        this.valorParcelaComDesconto = await this.aplicaDesconto(
            this.percentualDesconto,
            this.condicoes,
            this.condicaoPagamentoDesconto,
            this.taxaEmpreendimento,
            this.proposta.Data_de_Entrega_do_Empreendimento__c,
            this.proposta.CreatedDate,
            this.proposta.VPL_Tabela__c
        );

        if (this.valorParcelaComDesconto) {
            this.showValorDescontoPositivo = true;
        } else {
            this.showValorDescontoNegativo = true;
        }
        this.showValorDesconto = true;
        this.isLoadingModalDiscount = false;

        // await this.handleLoading();

        // Promise.all([valorParcelaComDescontoPromise]).then(([value]) => {
        //     this.valorParcelaComDesconto = parseFloat(value);
        //     if (parseFloat(value) > 0) {
        //         this.showValorDescontoPositivo = true;
        //     } else {
        //         this.showValorDescontoNegativo = true;
        //     }
            
        //     this.showValorDesconto = true;
        //     this.isLoadingModalDiscount = false;
        // })
        
    }

    aplicaDesconto(desconto, condicoes, selectedCondicaoId, taxaEmpreendimento, dataEmpreendimento, dataProposta, vplTabela) {
        function getMonthDifference(startDate, endDate) {
            return (
                endDate.getMonth() - startDate.getMonth() + 12 * (endDate.getFullYear() - startDate.getFullYear())
            );
        }

        function addMonthsUTC (date, count) {
            if (date && count) {
                var m, d = (date = new Date(+date)).getUTCDate()

                date.setUTCMonth(date.getUTCMonth() + count, 1)
                m = date.getUTCMonth()
                date.setUTCDate(d)
                if (date.getUTCMonth() !== m) date.setUTCDate(0)
            }
            return date
        }

        function calcVpl(condicao, taxaEmpreendimento, dataEmpreendimento, tst) {
            let vpl = 0;
            const dataInicioVencimento = new Date(condicao.In_cio_do_Vencimento__c);
            for(let i=0; i < condicao.Quantidade_de_parcelas__c; i++) {
                let ordem = 0;
                if(new Date(dataProposta) < new Date(dataEmpreendimento)) {
                    if(
                        addMonthsUTC(dataInicioVencimento, i * condicao.Intervalo_das_Parcelas__c)
                        > new Date(dataEmpreendimento)
                    ) {
                        ordem = getMonthDifference(new Date(dataProposta), new Date(dataEmpreendimento));
                    } else {
                        ordem = getMonthDifference(new Date(dataProposta), addMonthsUTC(dataInicioVencimento, i * condicao.Intervalo_das_Parcelas__c));
                    }
                }
                vpl += condicao.Valor_Total_das_Parcelas__c / ((1 + taxaEmpreendimento) ** ordem);
            }
            return vpl;
        };

        function calculaVplCondicoesAnteriores(condicoes, dataEmpreendimento, taxaEmpreendimento) {
            let vpl = 0;
            for(let i=0; i < condicoes.length; i++) {
                vpl += calcVpl(condicoes[i], taxaEmpreendimento, dataEmpreendimento);
            }
            return vpl;
        }

        return new Promise((resolve, reject) => {
            const condicao = condicoes.find(condicao => condicao.Id == selectedCondicaoId);
            const filteredCondicoes = condicoes.filter(condicao => condicao.Id !== selectedCondicaoId);
            const vplAnteriores = calculaVplCondicoesAnteriores(filteredCondicoes, dataEmpreendimento, taxaEmpreendimento);
            const vplMeta = (vplTabela - (desconto / 100 * vplTabela)) - vplAnteriores;
            const salto = 1;
            let vplCondicao = 0;
            let valorParcela = (vplMeta / condicao.Quantidade_de_parcelas__c) / 2;
    
            while(vplMeta > vplCondicao) {
                valorParcela += salto;
                vplCondicao = calcVpl({ ...condicao, Valor_Total_das_Parcelas__c: valorParcela }, taxaEmpreendimento, dataEmpreendimento, true);
            }
    
            resolve(valorParcela.toFixed(2));
        });
        

    }
}