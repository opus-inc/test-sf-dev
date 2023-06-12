import { LightningElement, track, wire } from 'lwc';
import getEmpreendimentos from '@salesforce/apex/SelectPropertyController.getEmpreendimentos';
import getUnidadesByEmpreendimento from '@salesforce/apex/SelectPropertyController.getUnidadesByEmpreendimento';
import getGaragensByEmpreendimento from '@salesforce/apex/SelectPropertyController.getGaragensByEmpreendimento';
import getGaragensByEmpreendimentoAndTipologia from '@salesforce/apex/SelectPropertyController.getGaragensByEmpreendimentoAndTipologia';
import getAditionalItensByEmpreendimento from '@salesforce/apex/SelectPropertyController.getAditionalItensByEmpreendimento';
import getTipologiaByEmpreendimento from '@salesforce/apex/SelectPropertyController.getTipologiaByEmpreendimento';
import getContentVersion from '@salesforce/apex/SelectPropertyController.getContentVersion';
import saveProposal from '@salesforce/apex/SelectPropertyController.saveProposal';

import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SelectPropertyInformation extends NavigationMixin(LightningElement) {
    @track empreendimentos = [];
    @track tipologias = [];
    @track unidades = [];
    @track garagens = [];
    @track garagensCombo = [];
    @track itensAdicionais = [];
    @track hasGaragensCombo = false;
    @track limitarPorTipologia = false;

    @track empreendimentoSelected = {};
    @track empreendimentoSelectedId = {};
    @track tipologiaSelected = {};
    @track tipologiaSelectedId = {};
    @track unidadesSelected = [];
    @track lastUnidadeSelected;
    @track unidadesSelectedResumo;
    @track unidadesSelectedId = [];
    @track garagensSelected = [];
    @track garagensSelectedResumo;
    @track garagensComboSelected = [];
    @track garagensComboSelectedResumo = [];
    @track filteredItensAdicionais = [];
    @track itensAdicionaisSelected = [];
    
    @track lastGaragemSelected;
    @track lastGaragemComboSelected;
    @track garagensSelectedId = [];

    @track standardGaragens = [];
    @track standardGaragensResumo;

    @track isLoading = false;

    @track corretorId;
    @track propostaDeVenda;
    @track totalValorUnidades = 0;
    @track totalAreaUnidades = 0;
    @track totalValorGaragensCombo = 0;
    @track totalValorGaragensExtras = 0;
    @track totalValorGaragens = 0;
    @track totalItensAdicionais = 0;
    @track totalProposta = 0;
    @track totalArea = 0;

    @track empreendimentoImages = [];
    @track unidadeImages = [];
    @track empreendimentoImage = '';
    @track disableSaveButton = true;

    @track infoSelectedResumo;

    closeModel() {
        this.type = '';
        this.message = '';
    }

    @wire(CurrentPageReference) wiredPageRef(pageRef) {
        this.pageRef = pageRef;
        if (!this.pageRef) {
            this.pageRef = {};
            this.pageRef.attributes = {};
            this.pageRef.attributes.LightningApp = "LightningApp";
        }
        this.corretorId = this.pageRef.state.corretorId ?? this.pageRef.state.recordId;
    }

    connectedCallback() {
        this.isLoading = true;
        getEmpreendimentos({ corretorId: this.corretorId }).then(result => {
            if (result.length > 0) {
                this.empreendimentos = result.filter(i => i.Tabelas_de_Vendas__r).sort((a,b) => {
                    if ( a.Empreendimento__r.Name < b.Empreendimento__r.Name ){
                        return -1;
                    }
                    if ( a.Empreendimento__r.Name > b.Empreendimento__r.Name ){
                        return 1;
                    }
                    return 0;
                }).map(element => {
                    return {
                        value: element.Id,
                        ...(!element.Empreendimento__r.Numero_Blocos__c && { label: `${element.Empreendimento__r.Name}` }),
                        ...(element.Empreendimento__r.Numero_Blocos__c === 1 && { label: `${element.Empreendimento__r.Name}` }),
                        ...(element.Empreendimento__r.Numero_Blocos__c > 1 && { label: `${element.Empreendimento__r.Name} | ${element.Name}` }),
                        img: element.Empreendimento__r.Imagem_Empreendimento__c ? element.Empreendimento__r.Imagem_Empreendimento__c : '',
                        info: element.Info_Card__c,
                        garagemCombo: element.Utiliza_Garagem_Combo__c,
                        empreendimento: element.Empreendimento__r.Id,
                        limitarPorTipologia: element.Limitar_por_Tipologia__c === "Sim" ? true : false
                    };

                });
            }
            this.isLoading = false;
        }).catch(error => {
            window.console.log('error ', error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Erro de processamento, entre em contato com o administrador',
                    variant: 'error'
                })
            );
            this.isLoading = false;
        });

        getUnidadesByEmpreendimento({blocoId: "a2j4w000001YxOSAA0", corretorId: "a0E4w00002gMROMEA4"}).then(result => console.log(result));
    }

    async getTipologiaByEmpreendimento() {
        this.isLoading = true;
        await getTipologiaByEmpreendimento({ blocoId: this.empreendimentoSelected.Id }).then(result => {
            if(result.length > 0) {
                this.tipologias = result.map(element => ({
                    label: element.Name,
                    value: element.Id,
                    Valor_Descontado_na_Garagem__c: element.Valor_Descontado_na_Garagem__c
                }))
            }
        });
        this.isLoading = false;
    }

    async getUnidadesByEmpreendimento() {
        this.isLoading = true;
        await getUnidadesByEmpreendimento({ 
            blocoId: this.empreendimentoSelected.Id,
            corretorId: this.corretorId,
            ...(this.limitarPorTipologia && { tipologiaId: this.tipologiaSelected.Id })
        }).then(result => {
            var returnValue = result;
            if (result.returnValue) {
                returnValue = result.returnValue;
            }
            if (returnValue.length > 0) {
                this.unidades = returnValue.map(element => {
                    let label = element.Name + ' | ' + element.Area_privada__c + ' m² | ';
                    
                    if (element.Valor_de_tabela__c) {
                        label += element.Valor_de_tabela__c.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' }) + " ";
                    }

                    if(element.Status_Secund_rio__c === 'Reserva Técnica' || element.Status_Secund_rio__c === 'Reserva Negociação') {
                        label += "| " + element.Status_Secund_rio__c.toUpperCase();
                    }

                    return {
                        value: element.Id,
                        label: label,
                        valor: element.Valor_de_tabela__c,
                        area: element.Area_privada__c,
                        name: element.Name,
                        img: element.ImagemUnidade__c,
                        standardGarage: element.N_mero_de_vagas_de_garagem__c === "Sem Garagem" ? "" : element.N_mero_de_vagas_de_garagem__c,
                    }
                });
                this.unidades.sort((a, b) => {
                    let numberA = parseInt(a.name.match(/\d/g).join(""));
                    let numberB = parseInt(b.name.match(/\d/g).join(""));

                    if (numberA < numberB) {
                        return -1;
                    }
                    if (numberA < numberB) {
                        return 1;
                    }
                    return 0;
                });
                this.unidades.unshift({ value: 'Selecione unidade', label: 'Selecione unidade' });
            }
            this.getGaragensByEmpreendimento();
            this.getAditionalItensByEmpreendimento();
        }).catch(error => {
            window.console.log('error ', error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Erro de processamento, entre em contato com o administrador',
                    variant: 'error'
                })
            );
            this.isLoading = false;
        });
    }

    async getAditionalItensByEmpreendimento() {
        getAditionalItensByEmpreendimento({ empreendimentoId: this.empreendimentoSelected.Id }).then(result => {
            this.itensAdicionais = [];
            result.forEach(element => {
                const obj = {
                    label: element.Name + " | " + element.Valor__c.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' }),
                    value: element.Id,
                    Final_da_Unidade__c: element.Final_da_Unidade__c,
                    Id: element.Id,
                };
                this.itensAdicionais.push(obj);
            });
        });
    }

    async getGaragensByEmpreendimento() {
        this.isLoading = true;
        console.log(this.empreendimentoSelected.Id)
        const empreendimentoId = this.empreendimentos.find(i => i.value === this.empreendimentoSelected.Id).empreendimento;
        const garagensResponse = [];

        if(this.limitarPorTipologia) {
            const res = await getGaragensByEmpreendimentoAndTipologia({ empreendimentoId: empreendimentoId, tipologiaId: this.tipologiaSelected.Id })
            if(res.returnValue && res.returnValue.length > 0) {
                res.returnValue.forEach(element => garagensResponse.push(element.Unidade_Garagem__r));
            } else {
                res.forEach(element => garagensResponse.push(element.Unidade_Garagem__r));
            }
        } else {
            const res = await getGaragensByEmpreendimento({ empreendimentoId: empreendimentoId });
            if(res.returnValue && res.returnValue.length > 0) {
            // if(returnValue && returnValue.length > 0) {
                res.returnValue.forEach(element => garagensResponse.push(element));
            } else {
                res.forEach(element => garagensResponse.push(element));
            }
        }
        console.log(garagensResponse);
        if (garagensResponse.length > 0) {
            const _garagensCombo = [];
            const _garagensExtras = [];
            console.log(this.tipologias);
            console.log(this.tipologiaSelected.Id);

            garagensResponse.forEach(element => {
                console.log(element);
                let label = '';
                if(element.Garagem_Tipo__c === "COMBO" && this.tipologias.find(el => el.value === this.tipologiaSelected.Id)?.Valor_Descontado_na_Garagem__c) {
                    element.Valor_de_tabela__c = element.Valor_de_tabela__c - this.tipologias.find(el => el.value === this.tipologiaSelected.Id).Valor_Descontado_na_Garagem__c;
                }

                if (element.Valor_de_tabela__c) {
                    label = element.Name + ' | ' + element.Valor_de_tabela__c.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
                } else {
                    label = element.Name;
                }

                const obj = {
                    value: element.Id,
                    label: label,
                    valor: element.Valor_de_tabela__c,
                    area: element.Area__c,
                    name: element.Name,
                    img: element.ImagemUnidade__c
                };

                if(element.Garagem_Tipo__c === "COMBO") {
                    _garagensCombo.push(obj);
                } else {
                    _garagensExtras.push(obj);
                };
            });
            this.garagensCombo = _garagensCombo;
            this.garagens = _garagensExtras;
            
            // this.garagens.unshift({ value: 'Selecione a garagem extra', label: 'Selecione a garagem extra' });
            // this.garagensCombo.unshift({ value: 'Selecione a garagem combo', label: 'Selecione a garagem combo' });
        }
        this.isLoading = false;
    }


    getContentVersionEmpreendimento(recordId) {
        this.empreendimentoImages = []
        getContentVersion({ recordId: recordId }).then(result => {
            if (result.length > 0) {
                result.map(element => {
                    this.empreendimentoImages.push({
                        Id: this.empreendimentoSelectedId,
                        url: 'data:image/png;base64,' + element
                    });
                });
            }
        }).catch(error => {
            window.console.log(error);
        });
    }

    getContentVersionUnidade(recordId, unidadeLabel, unidadeId) {
        getContentVersion({ recordId: recordId }).then(result => {
            if (result.length > 0) {
                result.map(element => {
                    this.unidadeImages.push({
                        Id: unidadeId,
                        label: unidadeLabel.split('|')[0],
                        unidadeId: unidadeId,
                        url: 'data:image/png;base64,' + element
                    });
                });
            }
        }).catch(error => {
            window.console.log(error);
        });
    }


    handleChangeEmpreendimento(event) {
        this.isLoading = true;
        var label = event.target.options.find(opt => opt.value === event.detail.value).label;
        this.empreendimentoSelected = { Id: event.detail.value, name: label };
        this.empreendimentoSelectedId = event.detail.value;
        this.limitarPorTipologia = event.target.options.find(opt => opt.value === event.detail.value).limitarPorTipologia;
        this.unidadesSelected = [];
        this.garagensSelected = [];
        this.empreendimentoImages = [];
        this.unidadeImages = [];
        this.totalProposta = 0;
        this.totalArea = 0;
        this.totalValorGaragens = 0;
        this.totalValorGaragensCombo = 0;
        this.totalValorGaragensExtras = 0;
        this.totalValorUnidades = 0;
        this.totalAreaUnidades = 0;
        this.disableSaveButton = true;
        this.unidades = [];
        this.garagens = [];
        this.garagensCombo = [];
        this.lastGaragemComboSelected = '';
        this.lastGaragemSelected = '';
        this.standardGaragensResumo = ''; 
        this.standardGaragens = [];
        this.unidadesSelectedResumo = '';
        this.garagensSelectedResumo = '';
        this.garagensComboSelectedResumo = '';
        this.garagensComboSelected = [];
        this.itensAdicionais = [];
        this.filteredItensAdicionais = [];
        this.itensAdicionaisSelected = [];
        this.hasGaragensCombo = this.empreendimentos.find(opt => opt.value === event.detail.value).garagemCombo === "Sim" ? true : false;
        this.infoSelectedResumo = this.empreendimentos.find(opt => opt.value === event.detail.value).info;

        this.getContentVersionEmpreendimento(event.detail.value);
        
        if(this.limitarPorTipologia) {
            this.getTipologiaByEmpreendimento();
        } else {
            this.getUnidadesByEmpreendimento();

        }
    }

    handleChangeTipologia(event) {
        this.isLoading = true;
        var label = event.target.options.find(opt => opt.value === event.detail.value).label;
        this.tipologiaSelected = { Id: event.detail.value, name: label };
        this.tipologiaSelectedId = event.detail.value;

        this.unidadesSelected = [];
        this.garagensSelected = [];
        this.totalProposta = 0;
        this.totalArea = 0;
        this.totalValorGaragens = 0;
        this.totalValorGaragensCombo = 0;
        this.totalValorGaragensExtras = 0;
        this.totalValorUnidades = 0;
        this.totalAreaUnidades = 0;
        this.disableSaveButton = true;
        this.unidades = [];
        this.garagens = [];
        this.garagensCombo = [];
        this.lastGaragemComboSelected = '';
        this.lastGaragemSelected = '';
        this.standardGaragensResumo = ''; 
        this.standardGaragens = [];
        this.unidadesSelectedResumo = '';
        this.garagensSelectedResumo = '';
        this.garagensComboSelectedResumo = '';
        this.garagensComboSelected = [];
        this.itensAdicionais = [];
        this.filteredItensAdicionais = [];
        this.itensAdicionaisSelected = [];
        // this.hasGaragensCombo = this.empreendimentos.find(opt => opt.value === event.detail.value).garagemCombo === "Sim" ? true : false;
        // this.infoSelectedResumo = this.empreendimentos.find(opt => opt.value === event.detail.value).info;
        
        this.getUnidadesByEmpreendimento();
    }

    handleChangeUnidade(event) {
        
        if (event.detail.value !== 'Selecione unidade' && this.unidadesSelected.filter(unidade => unidade.Id == event.detail.value).length === 0) {
            
            var unidadeSelected = event.target.options.find(opt => opt.value === event.detail.value);

            this.unidadesSelected.push({ Id: event.detail.value, label: unidadeSelected.label });
            this.unidadesSelectedResumo = this.unidadesSelected.map(element => element.label.split('|')[0]).join(",");

            if(unidadeSelected.standardGarage) {
                this.standardGaragens.push( { Id: event.detail.value, standardGarage: unidadeSelected.standardGarage } );
                this.standardGaragensResumo = this.standardGaragens.map(element => element.standardGarage.split('|')[0]).join(", ");
            }

            this.lastUnidadeSelected = event.detail.value;
            this.calculateUnidades(event.detail.value);
            this.getContentVersionUnidade(event.detail.value, unidadeSelected.label, event.detail.value);
            
            const filtered = this.itensAdicionais.find(element => element.Final_da_Unidade__c == unidadeSelected.label.split(" | ")[0].slice(-1));
            if(filtered) {
                this.filteredItensAdicionais.push(filtered);
            }
        }

        this.disableSaveButton = this.handleDisableSaveButton();

    }

    handleDisableSaveButton() {
        if(this.hasGaragensCombo) {

            if(this.unidadesSelected.length > 0 && this.unidadesSelected.length === this.garagensComboSelected.length) {
                return false;
            } 
            
            if(this.unidadesSelected.length === 0 && this.garagensSelected.length > 0) {
                return false;
            }

            return true;
        } 
        
        if(this.unidadesSelected.length > 0 || this.garagensSelected.length > 0) {
            return false;
        }
        
        return true;

    }

    calculateUnidades(unidade) {
        this.unidades.forEach(element => {
            if (element.value == unidade) {
                this.totalValorUnidades += element.valor;
                this.totalAreaUnidades += element.area;
            }
        });

        this.calculateProposal();

    }

    handleRemoveUnidade(event) {
        this.lastUnidadeSelected = '';
        this.unidadesSelected = this.unidadesSelected.filter(unidade => {
            if (unidade.Id != event.target.dataset.id) {
                return unidade;
            } else {
                this.filteredItensAdicionais = this.filteredItensAdicionais.filter(element => element.Final_da_Unidade__c != unidade.label.split(" | ")[0].slice(-1));
                this.itensAdicionaisSelected = this.itensAdicionaisSelected.filter(element => element.Final_da_Unidade__c != unidade.label.split(" | ")[0].slice(-1));
            }
        });

        this.standardGaragens = this.standardGaragens.filter(standardGarage => {
            if (standardGarage.Id != event.target.dataset.id) {
                return standardGarage;
            }
        });

        this.unidadesSelectedResumo = this.unidadesSelected.map(element => element.label.split('|')[0]).join(",");

        this.standardGaragensResumo = this.standardGaragens.map(element => element.standardGarage.split('|')[0]).join(",");

        this.unidades.forEach(element => {

            if (element.value == event.target.dataset.id) {
                this.totalValorUnidades -= element.valor;
                this.totalAreaUnidades -= element.area;
            }
        });

        this.unidadeImages = this.unidadeImages.filter(element => {
            if (element.unidadeId != event.target.dataset.id) {
                return element;
            }
        });

        this.disableSaveButton = this.handleDisableSaveButton();

        this.calculateProposal();

    }

    handleChangeGaragem(event) {

        debugger;

        if (event.detail.value !== 'Selecione garagem'
            && this.garagensSelected.filter(garagem => garagem.Id == event.detail.value).length === 0) {
            var label = event.target.options.find(opt => opt.value === event.detail.value).label;
            this.garagensSelected.push({ Id: event.detail.value, label });
            // this.garagensSelectedResumo = this.garagensSelected.map(element => element.label.split('|')[0]).join(",");
            this.garagensSelectedResumo = [...this.garagensComboSelected, ...this.garagensSelected].map(element => element.label.split('|')[0]).join(",");
            this.lastGaragemSelected = event.detail.value;
            this.garagens.forEach(element => {
                if (element.value == event.detail.value && element.valor > 0) {
                    this.totalValorGaragensExtras += element.valor;
                }
            });
            this.calculateGaragens(event.detail.value);
        }

        this.disableSaveButton = this.handleDisableSaveButton();

    }

    handleChangeGaragemCombo(event) {
        if (event.detail.value !== 'Selecione garagem'
            && this.garagensComboSelected.filter(garagem => garagem.Id == event.detail.value).length === 0
        ) {
            var label = event.target.options.find(opt => opt.value === event.detail.value).label;
            this.garagensComboSelected.push({ Id: event.detail.value, label });
            this.garagensSelectedResumo = [...this.garagensComboSelected, ...this.garagensSelected].map(element => element.label.split('|')[0]).join(",");
            
            this.garagensCombo.forEach(element => {
                if (element.value == event.detail.value && element.valor > 0) {
                    this.totalValorGaragensCombo += element.valor;
                }
            });

            //this.totalValorGaragensCombo = this.garagensCombo.find(element => element.value == event.detail.value).valor ? this.garagensCombo.find(element => element.value == event.detail.value).valor : 0;
            this.lastGaragemComboSelected = event.detail.value;
            this.disableSaveButton = this.handleDisableSaveButton();
            this.calculateGaragens(event.detail.value);
        }
    }

    handleChangeItemAdicional(event) {
        if (event.detail.value !== 'Selecione os itens adicionais:'
            && this.itensAdicionaisSelected.filter(itemAdicional => itemAdicional.Id == event.detail.value).length === 0) {
            var label = event.target.options.find(opt => opt.value === event.detail.value).label;
            var Final_da_Unidade__c = event.target.options.find(opt => opt.value === event.detail.value).Final_da_Unidade__c;
            this.itensAdicionaisSelected = [{ Id: event.detail.value, label, Final_da_Unidade__c }];
            this.lastItemAdicionalSelected = event.detail.value;
            this.totalItensAdicionais = parseFloat(label.split(" | ")[1].replace(/\./g, '').replace(/,/g, '.').replace(/\R/g, '').replace(/\$/g, ''));
            this.calculateProposal();

        }
    }

    calculateGaragens(garagem) {

        this.totalValorGaragens = this.totalValorGaragensExtras + this.totalValorGaragensCombo;

        this.calculateProposal();

    }

    handleRemoveGaragemCombo(event) {
        debugger;

        this.lastGaragemComboSelected = '';
        this.garagensComboSelected = this.garagensComboSelected.filter(garagem => {
            if (garagem.Id != event.target.dataset.id) {
                return garagem;
            }
        });

        this.garagensSelectedResumo = this.garagensSelectedResumo.replaceAll(this.garagensCombo.find(i => i.value === event.target.dataset.id).name + " ,", '');
        this.garagensSelectedResumo = this.garagensSelectedResumo.replaceAll(" ," + this.garagensCombo.find(i => i.value === event.target.dataset.id).name, '');
        this.garagensSelectedResumo = this.garagensSelectedResumo.replaceAll(this.garagensCombo.find(i => i.value === event.target.dataset.id).name, '');

        // this.garagensCombo.forEach(element => {
        //     if (element.value == event.target.dataset.id && element.valor > 0) {
        //         this.totalValorGaragens -= element.valor;
        //     }
        // });

        this.totalValorGaragensCombo = 0;
        this.disableSaveButton = this.handleDisableSaveButton();

        this.calculateGaragens();

    }

    handleRemoveGaragem(event) {
        debugger;

        this.lastGaragemSelected = '';
        this.garagensSelected = this.garagensSelected.filter(garagem => {
            if (garagem.Id != event.target.dataset.id) {
                return garagem;
            }
        });
        this.garagensSelectedResumo = this.garagensSelectedResumo.replaceAll(this.garagens.find(i => i.value === event.target.dataset.id).name + " ,", '');
        this.garagensSelectedResumo = this.garagensSelectedResumo.replaceAll(" ," + this.garagens.find(i => i.value === event.target.dataset.id).name, '');
        this.garagensSelectedResumo = this.garagensSelectedResumo.replaceAll(this.garagens.find(i => i.value === event.target.dataset.id).name, '');
        
        this.garagens.forEach(element => {
            if (element.value == event.target.dataset.id && element.valor > 0) {
                this.totalValorGaragensExtras -= element.valor;
            }
        });

        this.disableSaveButton = this.handleDisableSaveButton();

        this.calculateGaragens();

    }

    handleRemoveItemAdicional(event) {
        this.lastItemAdicionalSelected = "";
        this.itensAdicionaisSelected = this.itensAdicionaisSelected.filter(element => {
            if (element.Id != event.target.dataset.id) {
                return element;
            }
        });

        this.filteredItensAdicionais.forEach(element => {
            if (element.value == event.target.dataset.id) {
                console.log(parseFloat(element.label.split(" | ")[1].replace(/\./g, '').replace(/,/g, '.').replace(/\R/g, '').replace(/\$/g, '')))
                this.totalItensAdicionais -= parseFloat(element.label.split(" | ")[1].replace(/\./g, '').replace(/,/g, '.').replace(/\R/g, '').replace(/\$/g, ''));
            }
        });
        
        this.calculateProposal();

    }

    handleClickSimular(event) {
        this.isLoading = true;
        let totalValor = (this.totalValorGaragens + this.totalValorUnidades + this.totalItensAdicionais);
        this.unidadesSelected = this.unidadesSelected.map(element => ({ Id: element.Id, label: element.label.split('|')[0] }));
        const _garagens = [...this.garagensSelected, ...this.garagensComboSelected];
        const empreendimentoId = this.empreendimentos.find(i => i.value === this.empreendimentoSelected.Id).empreendimento;

        const body = {
            corretorId: this.corretorId,
            empreendimentoId: empreendimentoId,
            blocoId: this.empreendimentoSelected.Id,
            unidades: JSON.stringify(this.unidadesSelected),
            garagens: JSON.stringify(_garagens),
            ...(this.itensAdicionaisSelected.length > 0 && {
                itensAdicionais: JSON.stringify(this.itensAdicionaisSelected.map(i => ({
                    Id: i.Id,
                    Valor: parseFloat(i.label.split(" | ")[1].replace(/\./g, '').replace(/,/g, '.').replace(/\R/g, '').replace(/\$/g, ''))
                })))
            }),
            ...(this.itensAdicionaisSelected.length === 0 && {
                itensAdicionais: ""
            }),
            valorTotal: totalValor.toString(),
            areaTotal: this.totalAreaUnidades.toString(),
        }
        saveProposal(body).then(result => {
            this.propostaDeVenda = result;
            this.isLoading = false;
            this.navigateToCadastroProposta();
        }).catch(error => {
            console.log('error ', error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Erro de processamento, entre em contato com o administrador',
                    variant: 'error'
                })
            );
            this.isLoading = false;
        });
    }

    navigateToCadastroProposta() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Cadastro_Proposta__c'
            },
            state: {
                recordId:  this.propostaDeVenda.Id,
                corretorId: this.corretorId
            }
        });
    }

    calculateProposal() {

        this.totalValorGaragens = parseFloat( this.totalValorGaragens.toFixed(2) );

        this.totalValorUnidades = parseFloat( this.totalValorUnidades.toFixed(2) );

        this.totalAreaUnidades = parseFloat ( this.totalAreaUnidades.toFixed(2) );

        this.totalItensAdicionais = parseFloat ( this.totalItensAdicionais.toFixed(2) );

        this.totalProposta = ( parseFloat( (this.totalValorGaragens + this.totalValorUnidades + this.totalItensAdicionais).toFixed(2) ));

        this.totalArea = this.totalAreaUnidades;

    }

    navigateToPropostas() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Propostas__c'
            },
            state: {
                recordId: this.corretorId
            }
        });
    }

    get hasAditionalItens() {
        return this.filteredItensAdicionais && this.filteredItensAdicionais.length > 0;
    }

}