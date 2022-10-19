/**
 * Created by Hyun on 2022-10-17.
 */

public with sharing class Asset_ba_scheduler implements Schedulable{
    public void execute(SchedulableContext SC) {
        Asset_ba assetBa = new Asset_ba();
        Database.executeBatch(assetBa);
    }
}