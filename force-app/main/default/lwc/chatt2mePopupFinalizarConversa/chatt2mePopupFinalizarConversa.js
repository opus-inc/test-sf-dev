import { LightningElement, api, wire, track } from 'lwc';

import { subscribe, MessageContext } from 'lightning/messageService';
import actionChannel from '@salesforce/messageChannel/C2Me__ActionMessageChannel__c';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import finishConversation from '@salesforce/apex/C2MeActionController.finishConversation';
import warningLabel from '@salesforce/label/C2Me.warningLabel';
import cancelLabel from '@salesforce/label/C2Me.cancelLabel';
import conversationEndedLabel from '@salesforce/label/c.conversationEndedLabel';
import titleFinalizarConversa from '@salesforce/label/c.titleFinalizarConversa';
import encerrarChat from '@salesforce/label/c.encerrarChat';

export default class Chatt2mePopupFinalizarConversa extends LightningElement {
    label = {
        warningLabel,
        cancelLabel,
        conversationEndedLabel,
        titleFinalizarConversa,
        encerrarChat
    };

    subscription = null;
    action;

    @api isArchived;
    @api message;
    @api step;

    @track numberId;
    @track contactId;
    @track showPopupFinalizar = false;

    @wire(MessageContext) messageContext;

    subscribeMC() {
        this.subscription = subscribe(this.messageContext, actionChannel, this.handleEvent.bind(this));
    }

    connectedCallback() {
        this.subscribeMC();
    }

    handleEvent(message) {
        this.numberId = message.numberId;
        this.contactId = message.contactId;

        if (message.actionName == 'Finalizar_Conversa') {
            this.showPopupFinalizar = true;
        }
    }

    sendFinishConversation() {
        if (this.message) {
            finishConversation({
                chatt2meNumberId: this.numberId,
                chatt2meContactId: this.contactId,
                finishMessage: this.message,
                conversationStep: this.step,
                archived: this.isArchived
            }).then(() => {
                const eventSuccess = new ShowToastEvent({
                    title: 'Sucesso',
                    message: this.label.conversationEndedLabel,
                    variant: 'success'
                });

                this.dispatchEvent(eventSuccess);

                this.closePopup();
            }).catch((error) => {
                const eventError = new ShowToastEvent({
                    title: this.label.warningLabel,
                    message: error,
                    variant: 'warning'
                });

                this.dispatchEvent(eventError);
            });
        }
    }

    handlerChangeText(event) {
        this.message = event.target.value;
    }

    closePopup() {
        this.showPopupFinalizar = false;
    }
}