import { LightningElement, track, api } from 'lwc';
    //  Example statuses
    //statuses = [
    //    {
    //        id: '1',
    //        name: 'Clientes',
    //        classNames: 'slds-path__item',
    //        subscribers: [
    //            {
    //                id: '1',
    //                name: 'Assinante 1',
    //                status: 'Concluído',
    //                subscriptionDate: '2023-01-01'
    //            },
    //            {
    //                id: '2',
    //                name: 'Assinante 2',
    //                status: 'Concluído',
    //                subscriptionDate: '2023-01-01'
    //            }
    //        ]
    //    },
    //];
export default class AcompanhamentoPathBar extends LightningElement {
    @api statuses = [];

        
    @api currentStep = {};
    @track currentShowingStep = null;
    @track showDetails = true;

    handlePathClick(event) {
        let statusId = event.currentTarget.dataset.id;
        let selectedStep = this.statuses.find(status => status.id === statusId);
        
        if (this.currentShowingStep === selectedStep) {
            this.showDetails = !this.showDetails;
        } else {
            this.currentShowingStep = selectedStep;
            this.showDetails = true;
            this.updateClassNames();
        }
    }

    updateClassNames() {
        const lastIndex = this.statuses.length - 1;
        const currentStepIndex = this.statuses.findIndex(status => status.id === this.currentStep.id);
        this.statuses = this.statuses.map((status, index) => {
            if (index === currentStepIndex) {
                status.classNames = "slds-is-current slds-is-active slds-path__item";
            } else if (index < currentStepIndex) {
                status.classNames = "slds-is-complete slds-path__item";
            } else {
                status.classNames = "slds-is-incomplete slds-path__item";
            }
            if (index === lastIndex) {
                status.classNames += " slds-path__item_last";
            }
            return status;
        });        
    }

    connectedCallback() {
        this.currentShowingStep = this.currentStep;
        this.updateClassNames();
    }
}
