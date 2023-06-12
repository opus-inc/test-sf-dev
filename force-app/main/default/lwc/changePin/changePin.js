import { LightningElement, track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getLoggedCorretor from '@salesforce/apex/PropostaCadastroController.getLoggedCorretor';
import generatePin from '@salesforce/apex/TokenAuthenticatorController.generatePin';

export default class ChangePin extends LightningElement {

    @track corretor = {};

    @track isLoading = false;

    // Toast Variables
    @track type;
    @track message;
    @track showToastBar = false;
    @track autoCloseTime = 6000;
    
    @wire(CurrentPageReference) async wiredPageRef(pageRef) {
        if(pageRef.state.recordId) {
            const idCorretor = localStorage.getItem('corretorId');
            console.log("pageRef.state.recordId", pageRef.state.recordId);
            console.log("idCorretor", idCorretor);
            
            if(!idCorretor || idCorretor !== pageRef.state.recordId){
                window.open(`${window.location.href.split("/pv/")[0]}/pv/`, "_self");
                return;
            }

        }

        this.pageRef = pageRef;
        if (!this.pageRef) {
            this.pageRef = {};
            this.pageRef.attributes = {};
            this.pageRef.attributes.LightningApp = "LightningApp";
        }
        this.corretorId = this.pageRef.state.recordId;
    }

    connectedCallback() {
        this.isLoading = true;

        getLoggedCorretor({ corretorId: this.corretorId })
            .then(result => {
                console.log("result");
                console.dir(result);

                this.corretor = result;
            })
            .catch(error => {
                console.error(error);
                this.showToast('Erro de processamento, entre em contato com o administrador', 'error');
            })

        this.isLoading = false;
    }

    // @wire(getLoggedCorretor, { corretorId: "$corretorId" })
    // getLoggedCorretorData({ error, data }) {
    //     console.log("data");
    //     console.dir(data);
    //     if(data) {
    //         this.corretor = data;
    //     }

    //     if(error) {
    //         this.showToast('Erro de processamento, entre em contato com o administrador', 'error');
    //     }
    // }

    handleGenerateNewPin() {
        this.isLoading = true;
        generatePin({ corretorId: this.corretorId })
            .then(result => {
                console.log(result);
                this.corretor = result;
                this.showToast('PIN gerado com sucesso!', 'success');
            })
            .catch(error => {
                console.error(error);
                this.showToast('Erro de processamento, entre em contato com o administrador', 'error');
            });
        this.isLoading = false;
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
}