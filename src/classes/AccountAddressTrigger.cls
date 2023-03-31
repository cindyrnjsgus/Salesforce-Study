/**
 * Created by Hyun on 2023-01-31.
 */

public with sharing class AccountAddressTrigger extends TriggerHandler{
    public AccountAddressTrigger() {
        listNew = (List<Account>) Trigger.new;  // new - before insert, before update 및 before undelete 트리거에서만 사용할 수 있습니다.
        listOld = (List<Account>) Trigger.old;  // old - update 및 delete
        mapNew = (Map<Id, Account>) Trigger.newMap; // newMap - before update,after insert,after update 및 after undelete
        mapOld = (Map<Id, Account>) Trigger.oldMap;
    }

    /** TriggerHandler */
    private List<Account> listNew { get; set; }
    private List<Account> listOld { get; set; }
    private Map<Id, Account> mapNew { get; set; }
    private Map<Id, Account> mapOld { get; set; }


    public override void beforeUpdate() {
        updateShippingAddress();
    }
    public override void beforeInsert() {
        updateShippingAddress();
    }

    public void updateShippingAddress(){
        for(Account account : listNew){
            if(account.Match_Billing_Address__c = true && account.BillingPostalCode != null){
                account.ShippingPostalCode = account.BillingPostalCode;
            }
        }
    }//updateShippingAddress
}