import { LightningElement, api, track } from 'lwc';
import getParcelaByContrato from '@salesforce/apex/PagamentoAvulsoController.getParcelaByContrato';

export default class CobrancaSelecionaParcelas extends LightningElement {
    _contratoMegaIds;
    
    @api 
    get contratoMegaIds() {
        return this._contratoMegaIds;
    }
    set contratoMegaIds(value) {
        console.log(value);
        console.log(value.split(";").filter(String));
        this._contratoMegaIds = value.split(";").filter(String);
        this.getParcByContrato(value.split(";").filter(String));
    };

    @track parcelas = [];

    getParcByContrato(contMegaIds) {
        getParcelaByContrato({ contratosId: contMegaIds })
            .then(result => {
                if (result != null) {
                    this.parcelas = result;
                }
            });
    }

    get hasParcelas() {
        return this.parcelas.length > 0; 
    }
}