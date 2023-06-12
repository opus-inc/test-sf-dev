import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import validateCPFAndToken from '@salesforce/apex/TokenAuthenticatorController.validateCPFAndToken';
import updateAndSendToken from '@salesforce/apex/TokenAuthenticatorController.updateAndSendToken';
import autenticateWithPin from '@salesforce/apex/TokenAuthenticatorController.autenticateWithPin';
import { NavigationMixin,CurrentPageReference } from 'lightning/navigation';

export default class TokenAuthenticator extends NavigationMixin(LightningElement) {
    @track cpf;
    @track pin;
    @track token;
    @track isLoaded = false;
    @track corretorId;
    @track type;
    @track message;
    @track showToastBar = false;
    @track autoCloseTime = 6000;
    @track tokenEnviado = false;

    showToast(message, type) {
        this.type = type;
        this.message = message;
        this.showToastBar = true;
        setTimeout(() => {
            this.closeModel();
        }, this.autoCloseTime);
    }

    closeModel() {
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

    handleClickNext(){
        this.isLoaded = true;
        if(this.validateField(this.cpf) && this.validateField(this.token)){
            validateCPFAndToken({ cpf: this.cpf, token: this.token}).then(result=>{
                if(result.Id){
                    if(result.TokenActive__c == true){
                        this.corretorId = result.Id;
                        this.showToast('Tudo ok, voce sera redirecionado', 'success');
                        

                        this.navigateToHomePage();
                    } else {
                        this.showToast("Token expirado, favor solicitar um novo token para acessar a nossa plataforma");
                    }                
                } else {
                    this.showToast('Seu CPF não consta em nosso sistema, favor entre em contato com seu administrador', 'info');
                }
                this.isLoaded = false;
            }).catch(error => {
                console.log('error ', error);
                this.showToast('Erro de processamento, entre em contato com o administrador', 'error');
                this.isLoaded = false;
            });

        } else {
            this.isLoaded = false;
            this.showToast('Todos os campos são obrigatórios');
        }        
    }

    validateField(field){        
        if(field == ''
        || field == undefined
        || field == null){
            return false;
        }
        return true;
    }

    handleClickPinButton() {
        this.isLoaded = true;
        if(this.validateField(this.pin)) {
            autenticateWithPin({ cpf: this.cpf, pin: this.pin })
                .then(result => {
                    if(result){
                        console.log("result");
                        console.log(result);
                        this.corretorId = result;
                        this.showToast('Tudo ok, você sera redirecionado!', 'success');
                        

                        this.navigateToHomePage();
                    } else {
                        this.showToast('CPF ou PIN incorreto!', 'info');
                    }
                    this.isLoaded = false;
                })
                .catch(error => {
                    this.showToast('CPF ou PIN incorreto!', 'error');
                    this.isLoaded = false;
                })
        }
    }

    handleClickToken(){
        this.isLoaded = true;
        if(this.validateField(this.cpf)){
            updateAndSendToken({ cpf: this.cpf}).then(result=>{
                if(result == true){
                    this.showToast('Um novo token foi enviado', 'success');
                    this.tokenEnviado = true;
                    
                } else {
                    this.showToast('Seu CPF não consta em nosso sistema, favor entre em contato com seu administrador', 'info');
                }
                this.isLoaded = false;
            }).catch(error => {
                this.showToast('Erro de processamento, entre em contato com o administrador', 'error');
                this.isLoaded = false;
            });
        } else {
            this.isLoaded = false;
            this.showToast('O CPF é obrigatório');
        }
        
    }

    handleInputCpf(event){
        this.cpf = event.target.value;
    }
    
    handleInputToken(event){
        this.token = event.target.value;
    }

    handleInputPin(event) {
        this.pin = event.target.value;
    }

    keyCheckOnlyNumber(event){
        if(event.keyCode < 48 || event.keyCode > 57){
            event.preventDefault();
        }
    }

    navigateToHomePage() {
        localStorage.setItem('corretorId', this.corretorId);

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
}