import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import UserName_FIELD from '@salesforce/schema/User.Name'
import OpptyOwnerName_FIELD from '@salesforce/schema/Opportunity.Owner.Name'
import OpptyOwnerId_FIELD from '@salesforce/schema/Opportunity.OwnerId'
import OpptyName_FIELD from '@salesforce/schema/Opportunity.Name'

const fields = [UserName_FIELD, OpptyName_FIELD, OpptyOwnerId_FIELD, OpptyOwnerName_FIELD];

export default class opptyLWC extends LightningElement {

    @api
    recordId;

    @wire(getRecord,{recordId : "$recordId", fields})
    opportunity;

    get User(){
        return getFieldValue(this.opportunity.data, UserName_FIELD);
    }

    get OwnerName(){
        return getFieldValue(this.opportunity.data, OpptyOwnerName_FIELD);
    }

    get OwnerId(){
        return getFieldValue(this.opportunity.data, OpptyOwnerId_FIELD);
    }

    get OpptyName(){
        return getFieldValue(this.opportunity.data, OpptyName_FIELD);
    }
    changeValue(event) {
        return this.changeValue = 'Hyun Kwon';
    }

}