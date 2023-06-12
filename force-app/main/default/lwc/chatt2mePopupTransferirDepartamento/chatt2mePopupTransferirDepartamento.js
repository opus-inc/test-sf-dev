import { LightningElement, wire, track } from 'lwc';

import { subscribe, MessageContext } from 'lightning/messageService';
import actionChannel from '@salesforce/messageChannel/C2Me__ActionMessageChannel__c';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getChatt2meNumbers from '@salesforce/apex/C2MeActionController.getChatt2meNumbers';
import getDepartamentName from '@salesforce/apex/C2MeActionController.getDepartamentName';
import setNewDepartament from '@salesforce/apex/C2MeActionController.setNewDepartament';

import chooseDefaultNumberLabel from '@salesforce/label/C2Me.chooseDefaultNumberLabel';
import cancelLabel from '@salesforce/label/C2Me.cancelLabel';
import transferirLabel from '@salesforce/label/c.transferirLabel';
import titleTransferirDepart from '@salesforce/label/c.titleTransferirDepart';
import successLabel from '@salesforce/label/C2Me.successLabel';
import defaultNumberSuccessLabel from '@salesforce/label/C2Me.defaultNumberSuccessLabel';

export default class Chatt2mePopupTransferirDepartamento extends LightningElement {
    label = {
        chooseDefaultNumberLabel,
        cancelLabel,
        transferirLabel,
        titleTransferirDepart,
        successLabel,
        defaultNumberSuccessLabel
    };

    @track numberId;
    @track contactId;
    @track showPopupTransferir = false;
    @track newChatt2meDepart;
    @track message;

    subscription = null;
    action;

    //event
    @wire(MessageContext) messageContext;

    //event
    subscribeMC() {
        this.subscription = subscribe(this.messageContext, actionChannel, this.handlerEvent.bind(this));
    }
    //function called when event triggered
    handlerEvent(message) {
        this.numberId = message.numberId;
        this.contactId = message.contactId;
        this.getWhatsNumberList();
        this.getMessage();

        if (message.actionName == 'Transferir_Departamento') {
            this.showPopupTransferir = true;
        }
    }

    connectedCallback() {
        //start listening
        this.subscribeMC();
    }
    //Build number list
    get options() {
        let optionArray = [];
        if (this.chatt2meNumberLst?.length) {
            for (let i = 0; i < this.chatt2meNumberLst.length; i++) {
                let item = Object.assign({}, this.chatt2meNumberLst[i]);

                optionArray.push({
                    label: item.C2Me__Display_Name__c + ' - ' + item.C2Me__Phone__c,
                    value: item.Id
                });
            }
        }

        return optionArray;
    }
    //get new chatt2me number
    handlerChangeValue(event) {
        this.newChatt2meDepart = event.detail.value;
    }
    //Build message with departament name
    getMessage() {
        if (this.contactId) {
            getDepartamentName({
                chatt2meContactId: this.contactId
            }).then((result) => {
                this.message = '' + result + ' transferiu este contato para você :)';
            }).catch(window.console.error);
        }
    }
    //Get number list
    getWhatsNumberList() {
        if (this.numberId) {
            getChatt2meNumbers({
                chatt2meNumberId: this.numberId
            }).then((result) => {
                this.chatt2meNumberLst = result;
            }).catch(window.console.error);
        }
    }
    //function to transfer departament
    transferDepartament() {
        if (this.newChatt2meDepart && this.numberId) {
            setNewDepartament({
                chatt2meNumberId: this.numberId,
                newChatt2meDepartId: this.newChatt2meDepart,
                chatt2meContactId: this.contactId,
                message: this.message
            }).then(() => {
                const event = new ShowToastEvent({
                    title: 'Sucesso',
                    message: 'Contato transferido com sucesso.',
                    variant: 'success'
                });

                this.dispatchEvent(event);

                this.closePopup();
            }).catch((error) => {
                const event = new ShowToastEvent({
                    title: 'Erro',
                    message: error.body.message,
                    variant: 'error'
                });

                this.dispatchEvent(event);

                this.closePopup();
            });
        } else {
            this.closePopup();
        }
    }
    //Get text message changes
    handlerChangeText(event) {
        this.message = event.target.value;
    }
    //Close popup
    closePopup() {
        this.showPopupTransferir = false;
    }
}