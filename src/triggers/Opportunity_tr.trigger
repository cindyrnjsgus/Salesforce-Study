/**
 * Created by samsung on 2022-09-07.
 */

trigger Opportunity_tr on Opportunity (after insert, after update, after delete, before insert, before update, before delete) {
    new Opportunity_tr().run();
}