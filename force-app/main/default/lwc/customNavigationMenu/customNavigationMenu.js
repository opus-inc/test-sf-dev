import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import logoMenu from '@salesforce/resourceUrl/logoMenu';

export default class CustomNavigationMenu extends NavigationMixin(LightningElement) {

    @api itens;
    @track corretorId;
    @track options = [];
    @track logoUrl = logoMenu;
    @track pageRef;
    @track enabledMenu = false;

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

        this.enabledMenu = this.corretorId ? true : false;

    }

    connectedCallback() {

        this.isLoadingProposta = true;
                
        if(this.itens && this.itens != ''){
            let itens = this.itens.split(',');
            itens.map( element => {
                let item = element.split(':');
                this.options.push({
                    value : item[0],
                    label : item[1]
                });
            });
        }
    }

    handleMenuSelect(event) {
        const selectedItemValue = event.detail.value;
        this.navigateTo(selectedItemValue);
    }

    navigateTo(pageApiName) {
        const idCorretor = localStorage.getItem('corretorId');
        console.log("pageApiName " + pageApiName);

        const state = {
            recordId: idCorretor ?? this.corretorId
        }

        if(pageApiName === "Home") {
            delete state.recordId;
        }
        
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: pageApiName
            },
            state
        });
    }

}