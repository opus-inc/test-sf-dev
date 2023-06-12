import { LightningElement, api, track, wire } from 'lwc';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import TYPE_FIELD from '@salesforce/schema/Account.Type';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
// const options = [
//                     {'label':'India','value':'India'},
//                     {'label':'USA','value':'USA'},
//                     {'label':'China','value':'China'},
//                     {'label':'Rusia','value':'Rusia'}
//                 ];
 
export default class FlowMultiSelectPickList extends LightningElement {
    @api labelComponent;
    @api multiSelect;

    @track _labels;
    @track _values;

    @api 
    get labels() {
        return this._labels;
    }
    set labels(values) {
        this._labels = values.split(";");
    }

    @api
    get values() {
        return this._values;
    }
    set values(values) {
        this._values = values.split(";");
    }

    @api returnSelectedValue;
    
    @api
    get returnSelectedValues() {
        if(this.multiSelect) {
            this.selectedValueList.shift();
            return this.selectedValueList.join(';');
        } else {
            return this.selectedValue;
        }
    }

    @track _recordList = [{ 'label': 'Buscando opções...', 'value': '' }];

    @api
    get options() {
        console.log(this._recordList);
        return this._recordList;
    }
    set options(value) {
        this._recordList = value.map(this.formataItem);
    }

    resolve(path, obj=self, separator='.') {
        var properties = Array.isArray(path) ? path : path.split(separator)
        return properties.reduce((prev, curr) => prev?.[curr], obj)
    }

    formataItem(item) {
        console.log(item);
        this.labels.split(".");
        let label = this.labels.map(l => this.resolve(l, item)).join(" - ");
        let value = this.values.map(v => this.resolve(v, item)).join(" - ");
        console.log(label);
        console.log(value);
        return { label, value }
    }

    @track selectedValue = '';//selected values
    @track selectedValueList = [''];//selected values

    // @track options; //= options;
    // @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    // objectInfo;
 
    //fetch picklist options
    // @wire(getPicklistValues, {
    //     recordTypeId: "$objectInfo.data.defaultRecordTypeId",
    //     fieldApiName: TYPE_FIELD
    // })
    // wirePickList({ error, data }) {
    //     if (data) {
    //         this.options = data.values;
    //     } else if (error) {
    //         console.log(error);
    //     }
    // }
     
    //for single select picklist
    handleSelectOption(event){
        console.log(event.detail);
        this.selectedValue = event.detail;
    }
 
    //for multiselect picklist
    handleSelectOptionList(event){
        console.log(event.detail);
        this.selectedValueList = event.detail;
        console.log(this.selectedValueList);
    }
}