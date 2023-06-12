import { LightningElement,wire, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPropostaByCorretor from '@salesforce/apex/PropostaCadastroController.getPropostaByCorretor';
import pdflib from "@salesforce/resourceUrl/pdflib";
import { loadScript } from "lightning/platformResourceLoader";


export default class PopupComparacaoPropostas extends LightningElement {
    @api corretorId;
    @track isLoading = false;
    @track propostas = [];
    @track showModal = false;
    @track showComparacao = false;
    @track propostasSelected = [];
    @track alertMessage = false;

    @api viewModal(propostas=[], selected=[]) {
        if(selected.length > 0) {
            this.propostasSelected = this.propostas.filter(element => selected.includes(element.Id));
            
            if(selected.length > 3) {
                this.handleMoreThanThreeProposalsError();
                this.showModal = !this.showModal;
                return;
            }

            this.showComparacao = true;
        } else {
            this.propostasSelected = [];
            this.showComparacao = false;
        }

        this.showModal = !this.showModal;
    }

    handleMoreThanThreeProposalsError() {
        this.showComparacao = false;
        this.alertMessage = true;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Info',
                message: 'Por favor selecione no máximo 3 propostas para comparar',
                variant: 'info'
            })
        );
    }
    
    handleVoltar(){
        this.viewModal();
    }
    
    renderedCallback() {
        loadScript(this, pdflib).then(() => {});
    }

    //imprimir
    async generatePDF() {
        const pdfDoc = await PDFLib.PDFDocument.create();
        const timesRomanFont = await pdfDoc.embedFont(
          PDFLib.StandardFonts.TimesRoman
        );
    
        const page = pdfDoc.addPage();
        const { width, height } = page.getSize();
        const fontSize = 30;
        page.drawText("Learning with Salesforce Bolt !"+window.print(), {
          x: 50,
          y: height - 4 * fontSize,
          size: fontSize,
          font: timesRomanFont,
          color: PDFLib.rgb(0, 0.53, 0.71)
        });
    
        const pdfBytes = await pdfDoc.save();
        this.saveByteArray("Simulação", pdfBytes);
    }
    
    saveByteArray(pdfName, byte) {
        var blob = new Blob([byte], { type: "application/pdf" });
        var link = document.createElement("a");
        link.href = window.URL.createObjectURL(blob);
        var fileName = pdfName;
        link.download = fileName;
        link.click();
    }

    connectedCallback() {
        this.isLoading = !this.isLoading;
        console.log('this.propostaVendaId', this.propostaVendaId);
        
        getPropostaByCorretor({ corretorId: this.corretorId }).then(result => {
            
            if (result != null) {
                result.map( element => {
                    let proposta = element;
                    proposta.value = element.Id;
                    proposta.label = element.Name;
                    
                    if(proposta.Valor_Tabela__c){
                        proposta.Valor_Tabela__c = proposta.Valor_Tabela__c.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
                    }

                    if(proposta.Valor_da_Proposta__c){
                        proposta.Valor_da_Proposta__c = proposta.Valor_da_Proposta__c.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
                    }

                    if(proposta.Variacao_VPL__c){
                        proposta.Variacao_VPL__c = proposta.Variacao_VPL__c.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
                    }                   
                    
                    this.propostas.push(proposta);
                });
            }
            this.isLoading = !this.isLoading;          
        }).catch(error => {
            console.log('error ', error);
            this.isLoading = !this.isLoading;   
            //this.showToast('Erro de processamento, entre em contato com o administrador', 'error');
        });
    }

    handleChange(event) {
        this.propostasSelected = event.detail.value;
        
        if(event.detail.value.length > 3){
            this.alertMessage = true;
        } else {
            this.alertMessage = false;
        }
    }

    handleClickComparar(){
        if(this.propostasSelected.length <= 3){
            this.propostasSelected = this.propostasSelected.map(element => {
                return this.propostas.find(proposta => proposta.value === element);
            });
           console.log('if(this.propostasSelected.length == 3){');
           this.showComparacao = !this.showComparacao;
        } else {
            this.handleMoreThanThreeProposalsError();
        }
    }

    

}