/**
 * Created by samsung on 2022-08-26.
 */

trigger OpportunityLineItem_tr on OpportunityLineItem (after insert, after update, after delete, before insert, before update, before delete){
    new OpportunityLineItem_tr().run();
}
