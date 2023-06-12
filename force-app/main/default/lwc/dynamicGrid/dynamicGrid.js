/* eslint-disable no-console */
import { LightningElement, api, wire, track } from 'lwc';

import { ShowToastEvent } from "lightning/platformShowToastEvent";

import getData from '@salesforce/apex/dynamicGridController.getData';
import getColumns from '@salesforce/apex/dynamicGridController.getColumns';
import getCountData from '@salesforce/apex/dynamicGridController.getRecordListCount';
import deleteData from '@salesforce/apex/dynamicGridController.deleteData';

//disparar usando pubsub
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import { fireEvent } from 'c/pubsub';

//para escutar usando pubsub
import { registerListener, unregisterAllListeners } from 'c/pubsub';

export default class DynamicGrid extends NavigationMixin(LightningElement) {
    @api gridTitleParm;
    @api gridIconParam;
    @api hideCheckboxParam = false;
    @api sObjectNameParam;
    @api fieldsNamesParam;
    @api whereParam;
    @api adicionalConditionsParam;
    @api identification;
    @api actions;

    //Paginations API
    @api pagesize;
    @track currentpage = 1;
    @track totalpages;
    @track totalrecords;

    @track recordsCount;
    @track recordId;
    @track corretorId;
    @track columns;
    @track configData;
    @track originalWhere;
    @track searchKey = '';
    @track showDetail;
    @track showSimulationButtons = false;
    @track showPaymentButtons = false;
    @track isDiscountModalOpen = false;

    @track sortBy;
    @track sortDirection;

    selectedRecords = [];

    openPropostaButton = {
        type: 'button-icon',
        fixedWidth: 40,
        typeAttributes: {
            iconName: 'utility:open',
            name: 'open-proposta',
            title: 'Abrir Proposta',
            variant: 'bare',
            alternativeText: 'open-proposta',
            disabled: false,
            name: 'open-proposta'
        }
    };

    @wire(CurrentPageReference) wiredPageRef(pageRef) {
        this.pageRef = pageRef;
        

        if (!this.pageRef) {
            this.pageRef = {};
            this.pageRef.attributes = {};
            this.pageRef.attributes.LightningApp = "LightningApp";
        }

        this.corretorId=this.recordId;
        this.recordId = this.pageRef.state.recordId;

        registerListener('updateTripList', this.handleUpdateTripList, this);
    }

    @wire(getColumns, {
        sObjectName: '$sObjectNameParam',
        fieldsNames: '$fieldsNamesParam'
    }) headerData({ error, data }) {
        if (error) {
            window.console.log(error);
        }
        this.columns = [];

        if (data) {
            console.log(data)
            for (let i = 0; i < data.length; i++) {
                this.columns.push({
                    ...data[i], 
                    sortable: true,
                    ...(data[i].fieldName === "Status_Transferencia__c" && { label: "Transferido para você?" }) 
                });
            }

            if (this.sObjectNameParam == "Proposta_de_Vendas__c") {
                this.columns.unshift(this.openPropostaButton);
            }

            window.console.log(this.actions);
            if (this.actions) {
                this.columns.push({
                    type: 'action',
                    typeAttributes: { rowActions: JSON.parse(this.actions) },
                });
            }
        }
    }

    @wire(getCountData, {
        sObjectName: '$sObjectNameParam',
        whereCondition: '$whereParam',
        searchValue: '$searchKey',
        pagenumber: '$currentpage'
    }) countObj({ error, data }) {
        window.console.log(data);
        if (data || data >= 0) {
            this.totalrecords = data;
            window.console.log(this.totalrecords);
            if (this.totalrecords !== 0 && !isNaN(this.totalrecords)) {
                this.totalpages = Math.ceil(this.totalrecords / this.pagesize);
                getData({
                    sObjectName: this.sObjectNameParam,
                    fieldsNames: this.fieldsNamesParam,
                    whereCondition: this.whereParam,
                    adicionalConditions: this.adicionalConditionsParam,
                    searchValue: this.searchKey,
                    pageSize: this.pagesize,
                    pagenumber: this.currentpage
                })
                    .then(objList => {
                        this.configData = objList;
                        window.console.log(this.configData);
                        this.error = undefined;
                    })
                    .catch(errorData => {
                        this.error = errorData;
                    });
            } else {
                this.configData = [];
                this.totalpages = 1;
                this.totalrecords = 0;
            }
        } else {
            if (this.recordId) {
                const event = new ShowToastEvent({
                    title: "Error",
                    message: "There is no record child",
                    variant: "error"
                });
                this.dispatchEvent(event);
            }
        }
        if (error) {
            this.error = error;
        }
    }

    // Getting selected rows 
    getSelectedRecords(event) {
        // getting selected rows
        const selectedRows = event.detail.selectedRows;
        this.recordsCount = event.detail.selectedRows.length;

        // this set elements the duplicates if any
        let conIds = new Set();

        // getting selected record id
        for (let i = 0; i < selectedRows.length; i++) {
            conIds.add(selectedRows[i].Id);
        }
        // coverting to array
        this.selectedRecords = Array.from(conIds);
        window.console.log(this.selectedRecords);

        fireEvent(this.pageRef, 'dynamicGridSelectedId', this.selectedRecords);
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        if (this.sObjectNameParam == "Proposta_de_Vendas__c"
            && actionName == "open-proposta") {
                console.log(this.corretorId);
                this.handleClickOpenProposta(event.detail.row.Id);
        } else {
            const rowEvent = { detail: event.detail.row, action: actionName };
            fireEvent(this.pageRef, 'sendId', rowEvent);
        }
    }

    handleKeyChange(event) {
        if (event.target.value.length === 0 || event.target.value.length > 1) {
            if (this.searchKey !== event.target.value) {
                this.isSearchChangeExecuted = false;
                this.searchKey = event.target.value;
                this.currentpage = 1;
            }
        }
    }

    sendId(event) {
        if (this.identification === event.action) {
            if (!this.recordId) {
                this.recordId = event.detail.Id;
            }

            this.showDetail = true;

            window.console.log(this.recordId);
            //Show popup
            //Set record id on whereField
            if (this.whereParam) {
                if (!this.originalWhere) {
                    this.originalWhere = this.whereParam;
                }
                if (this.originalWhere.indexOf('{recordId}') >= 0) {
                    this.whereParam = this.originalWhere.replace('{recordId}', '\'' + this.recordId + '\''); //ParentId = {recordId}
                }
                if (!this.recordId) {
                    this.whereParam = '';
                }
            }
        }
    }

    connectedCallback() {
        const idCorretor = localStorage.getItem('corretorId');
        
        if(!idCorretor){
            window.open(`${window.location.href.split("/pv/")[0]}/pv/`, "_self");
            return;
        }

        if(idCorretor !== this.recordId){
            window.open(`${window.location.href.split("/pv/")[0]}/pv/`, "_self");
        }

        this.whereParam = this.whereParam.replace('{recordId}', '\'' + this.recordId + '\'');
        this.corretorId = this.recordId;
        console.log('this.whereParam ' + this.whereParam);
        // console.log('connectedCallback() { ' + this.corretorId);

        console.log('this.sObjectNameParam  ' + this.sObjectNameParam);

        getCountData({
            sObjectName: this.sObjectNameParam,
            whereCondition: this.whereParam,
            searchValue: this.searchKey,
            pagenumber: this.currentpage
        }).then((data) => {
            window.console.log(data);
            if (data || data >= 0) {
                this.totalrecords = data;
                window.console.log(this.totalrecords);
                if (this.totalrecords !== 0 && !isNaN(this.totalrecords)) {
                    this.totalpages = Math.ceil(this.totalrecords / this.pagesize);
                    getData({
                        sObjectName: this.sObjectNameParam,
                        fieldsNames: this.fieldsNamesParam,
                        whereCondition: this.whereParam,
                        adicionalConditions: this.adicionalConditionsParam,
                        searchValue: this.searchKey,
                        pageSize: this.pagesize,
                        pagenumber: this.currentpage
                    })
                        .then(objList => {
                            this.configData = objList;
                            window.console.log(this.configData);
                            this.error = undefined;
                        })
                        .catch(errorData => {
                            this.error = errorData;
                        });
                } else {
                    this.configData = [];
                    this.totalpages = 1;
                    this.totalrecords = 0;
                }
            } else {
                if (this.recordId) {
                    const event = new ShowToastEvent({
                        title: "Error",
                        message: "There is no record child",
                        variant: "error"
                    });
                    this.dispatchEvent(event);
                }
            }
            if (error) {
                this.error = error;
            }
        });


        if (this.sObjectNameParam == "Condi_o_de_Pagamento__c") {
            this.showPaymentButtons = true;
        } else if (this.sObjectNameParam == "Proposta_de_Vendas__c") {
            this.showSimulationButtons = true;
        }
        registerListener('sendId', this.sendId, this);
    }
    disconnectedCallback() {
        unregisterAllListeners(this);
    }
    closePopup() {
        this.showDetail = false;
    }

    handlerNextClick() {
        this.currentpage++;
    }
    handlerPreviousClick() {
        this.currentpage--;
    }

    handleClickSimular() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'custom_seleo_movel__c'
            },
            state: {
                recordId: this.recordId
            }
        });
    }

    handleClickDelete() {
        deleteData({ ids: this.selectedRecords })
            .then((result) => {
                result.forEach(item => console.log(item));
                this.configData = this.configData.filter(item => !result.find(i => i.Id === item.Id));
                this.selectedRecords = [];
                this.totalrecords = this.configData.length;
                this.totalpages = Math.ceil(this.totalrecords / this.pagesize);
                const event = new ShowToastEvent({
                    title: "Sucesso",
                    message: "Propostas deletadas com sucesso.",
                    variant: "sucess"
                });
                this.dispatchEvent(event);
            })
            .catch(errorData => {
                this.error = errorData;
                console.error(errorData);
            });

    }

    handleClickOpenProposta(recordId) {
        console.log(this.corretorId);
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Cadastro_Proposta__c'
            },
            state: {
                recordId: recordId,
                corretorId: this.corretorId
            }
        });
    }

    handleClickOpenComparacao() {
        this.template.querySelector('c-popup-comparacao-propostas')?.viewModal(this.configData, this.selectedRecords);
    }

    // The method onsort event handler
    updateColumnSorting(event) {
        var fieldName = event.detail.fieldName;
        var sortDirection = event.detail.sortDirection;
        // assign the latest attribute with the sorted column fieldName and sorted direction
        this.sortedBy = fieldName;
        this.sortedDirection = sortDirection;
        this.data = this.sortData(fieldName, sortDirection);
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.configData));
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1: -1;
        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.configData = parseData;
    }    

}