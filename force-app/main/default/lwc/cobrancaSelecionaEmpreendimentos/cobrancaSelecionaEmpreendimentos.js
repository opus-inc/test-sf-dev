import { LightningElement, api, track } from 'lwc';
import getEmpreendimentosByConta from '@salesforce/apex/PagamentoAvulsoController.getEmpreendimentosByConta';

export default class CobrancaSelecionaEmpreendimentos extends LightningElement {
    _contaId;
    
    @api 
    get contaId() {
        return this._contaId;
    }
    set contaId(value) {
        console.log(value);
        this._contaId = value;
        this.getEmpreendimentosByConta(value);
    };

    @api
    get selectedValue() {
        return this.value;
    }

    @track empreendimentos = [];
    @track value = '';

    getEmpreendimentosByConta(contaId) {
        getEmpreendimentosByConta({ contaId })
            .then(result => {
                console.log(result);
                if (result != null) {
                    this.empreendimentos = result.map(({Id, Name}) => ({ label: Name, value: Id }));
                }
            });
    }

    get hasEmpreendimentos() {
        return this.empreendimentos.length > 0; 
    }

    handleChange(event) {
        this.value = event.detail.value;
    }
}