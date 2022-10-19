/**
 * Created by Hyun on 2022-10-17.
 */

public with sharing class Asset_ba implements Database.Batchable<SObject>, Database.Stateful{
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, Name, LastModifiedDate, WarrantyDate__c, AccountId, IsWarrantyCaseExist__c FROM Asset]);
    }

    public void execute(Database.BatchableContext bc, List<Asset> listAssets) {
        List<Case> listCases = new List<Case>();

        for (Asset asset : listAssets){
            Date today = Date.today();
            Date oneMonthBefore = Date.valueOf(asset.WarrantyDate__c).addMonths(-1);
            if(today.isSameDay(oneMonthBefore)){
                listCases.add(new Case( Status = 'New',
                                        Origin = 'Web',
                                        AccountId = asset.AccountId,
                                        Subject = 'Warranty Case',
                                        AssetId = asset.Id,
                                        Type = 'Warranty Case'
                ));
                asset.IsWarrantyCaseExist__c = true;
            }
        }

        insert listCases;
        update listAssets;
    }

    public void finish(Database.BatchableContext bc) {

    }
}