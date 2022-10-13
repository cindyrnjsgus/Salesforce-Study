/**
 * Created by samsung on 2022-10-11.
 */

public with sharing class Account_ba_scheduler implements Schedulable{
    public void execute(SchedulableContext SC) {
        Account_ba accountBa = new Account_ba();
        Database.executeBatch(accountBa);
    }
}