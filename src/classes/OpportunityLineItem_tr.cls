/**
 * Created by samsung on 2022-09-07.
 */

public with sharing class OpportunityLineItem_tr extends TriggerHandler {

    public OpportunityLineItem_tr(){
        listNew = (List<OpportunityLineItem>) Trigger.new;
        listOld = (List<OpportunityLineItem>) Trigger.old;
        mapNew = (Map<Id, OpportunityLineItem>) Trigger.newMap;
        mapOld = (Map<Id, OpportunityLineItem>) Trigger.oldMap;
    }

    /** TriggerHandler */
    private List<OpportunityLineItem> listNew { get; set; }
    private List<OpportunityLineItem> listOld { get; set; }
    private Map<Id, OpportunityLineItem> mapNew { get; set; }
    private Map<Id, OpportunityLineItem> mapOld { get; set; }

    /** OpportunityLineItem 생성 시 */
    public override void afterInsert(){
        insertQuoteLineItem();
    }

    /** OpportunityLineItem 업데이트 시 */
    public override void afterUpdate(){
        updateQuoteLineItem();
    }

    /** OpportunityLineItem 삭제 시 */
    public override void beforeDelete(){
        deleteQuoteLineItem();
    }


    /** Insert QuoteLineItem */
    public void insertQuoteLineItem(){
        Set<Id> setOptyIds = new Set<Id>();
        Set<Id> setOptyLineItemIds = new Set<Id>();
        Map<Id,String> mapProductIdToId = new Map<Id,String>();

        if (listNew.size() > 0) {
            for (OpportunityLineItem opportunityLineItem : listNew) {
                if (opportunityLineItem.OpportunityId != null) {
                    setOptyIds.add(opportunityLineItem.OpportunityId);
                    setOptyLineItemIds.add(opportunityLineItem.Id);
                    mapProductIdToId.put(opportunityLineItem.Product2Id,opportunityLineItem.Id);
                }
            }
        }

        if (setOptyIds.size() > 0) {
            List<Quote> listQuotes = new List<Quote>();
            listQuotes = [
                    SELECT Id, Status, OpportunityId, Name
                    FROM Quote
                    WHERE OpportunityId = :setOptyIds
                    ORDER BY OpportunityId, CreatedDate DESC
            ];

            String str;
            List<QuoteLineItem> listQuoteLineItems = new List<QuoteLineItem>();

            if (listQuotes.size() > 0) {
                for (Quote quote : listQuotes) {
                    if(str != quote.OpportunityId){
                        str = quote.OpportunityId;
                        for (OpportunityLineItem opportunityLineItem : listNew) {
                            if (quote.Status == 'Draft' && quote.OpportunityId == opportunityLineItem.OpportunityId) {
                                listQuoteLineItems.add(new QuoteLineItem(
                                        OpportunityLineItemId = opportunityLineItem.Id,
                                        Product2Id = opportunityLineItem.Product2Id,
                                        PricebookEntryId = opportunityLineItem.PricebookEntryId,
                                        Quantity = opportunityLineItem.Quantity,
                                        Discount = opportunityLineItem.Discount,
                                        UnitPrice = opportunityLineItem.UnitPrice,
                                        ServiceDate = opportunityLineItem.ServiceDate,
                                        Description = opportunityLineItem.Description,
                                        QuoteId = quote.Id
                                ));
                            }//if
                        }//for(optyLineItem)
                    }//if
                }//for(quote)
                insert listQuoteLineItems;
            }
        }
    }//insertQuoteLineItem


    /** Update QuoteLineItem */
    public void updateQuoteLineItem() {

        Set<Id> setOptyIds = new Set<Id>();
        Set<Id> setOptyLineItemIds = new Set<Id>();
        Map<Id,String> mapProductIdToId = new Map<Id,String>();
        Map<Id,Decimal> mapProductIdToQuantity = new Map<Id,Decimal>();
        Map<Id,Decimal> mapProductIdToDiscount = new Map<Id,Decimal>();
        Map<Id,Decimal> mapProductIdToSalesPrice = new Map<Id,Decimal>();
        Map<Id,Date> mapProductIdToDate = new Map<Id,Date>();
        Map<Id,String> mapProductIdToLineDescription = new Map<Id,String>();

        if (listNew.size() > 0) {
            for (OpportunityLineItem opportunityLineItem : listNew) {
                if (opportunityLineItem.OpportunityId != null) {
                    setOptyIds.add(opportunityLineItem.OpportunityId);
                    setOptyLineItemIds.add(opportunityLineItem.Id);
                    mapProductIdToId.put(opportunityLineItem.Product2Id,opportunityLineItem.Id);
                    mapProductIdToQuantity.put(opportunityLineItem.Product2Id,opportunityLineItem.Quantity);
                    mapProductIdToDiscount.put(opportunityLineItem.Product2Id,opportunityLineItem.Discount);
                    mapProductIdToSalesPrice.put(opportunityLineItem.Product2Id,opportunityLineItem.UnitPrice);
                    mapProductIdToDate.put(opportunityLineItem.Product2Id,opportunityLineItem.ServiceDate);
                    mapProductIdToLineDescription.put(opportunityLineItem.Product2Id,opportunityLineItem.Description);
                }
            }
        }

        if (setOptyIds.size() > 0){

            List<QuoteLineItem> listQuoteLineItems = new List<QuoteLineItem>();
            listQuoteLineItems = [
                    SELECT Id, Product2Id, Quote.Status
                    FROM QuoteLineItem
                    WHERE Quote.OpportunityId =: setOptyIds
                    AND OpportunityLineItemId =: setOptyLineItemIds
                    ORDER BY CreatedDate DESC
            ];

            String str;
            if(listQuoteLineItems.size() > 0){
                for(OpportunityLineItem optyLineItem : listNew){
                    for(QuoteLineItem quoteLineItem : listQuoteLineItems){
                        str = mapProductIdToId.get(quoteLineItem.Product2Id);
                        if(str != mapProductIdToId.get(quoteLineItem.Product2Id) && quoteLineItem.Quote.Status == 'Draft'){
                            quoteLineItem.Quantity = mapProductIdToQuantity.get(quoteLineItem.Product2Id);
                            quoteLineItem.Discount = mapProductIdToDiscount.get(quoteLineItem.Product2Id);
                            quoteLineItem.UnitPrice = mapProductIdToSalesPrice.get(quoteLineItem.Product2Id);
                            quoteLineItem.ServiceDate = mapProductIdToDate.get(quoteLineItem.Product2Id);
                            quoteLineItem.Description = mapProductIdToLineDescription.get(quoteLineItem.Product2Id);
                        }
                    }
                }
                update listQuoteLineItems;
            }
        }
    }//afterInsertOpptyLineItem


    /** Delete QuoteLineItem */
    public void deleteQuoteLineItem(){

        Set<Id> setOptyIds = new Set<Id>();
        Set<Id> setOptyLineItemIds = new Set<Id>();

        if (listOld.size() > 0) {
            for (OpportunityLineItem opportunityLineItem : listOld) {
                if (opportunityLineItem.OpportunityId != null) {
                    setOptyIds.add(opportunityLineItem.OpportunityId);
                    setOptyLineItemIds.add(opportunityLineItem.Id);
                }
            }
        }
        if (setOptyIds.size() > 0) {

            List<QuoteLineItem> listQuoteLineItems = new List<QuoteLineItem>();
            listQuoteLineItems = [
                    SELECT Id, Product2Id, Quote.Status, OpportunityLineItemId
                    FROM QuoteLineItem
                    WHERE Quote.OpportunityId =: setOptyIds
                    AND OpportunityLineItemId =: setOptyLineItemIds
            ];

            List<Quote> listQuotes = new List<Quote>();
            listQuotes = [
                    SELECT Id, OpportunityId
                    FROM Quote
                    WHERE OpportunityId =: setOptyIds
                    ORDER BY OpportunityId, CreatedDate DESC
            ];

            List<QuoteLineItem> listQuoteLineItemsToDelete = new List<QuoteLineItem>();
            String str;
            for(Quote quote : listQuotes){
                if(str != quote.OpportunityId){
                    str = quote.OpportunityId;
                    for (QuoteLineItem quoteLineItem : listQuoteLineItems) {
                        if (quoteLineItem.Quote.Status == 'Draft' && quoteLineItem.QuoteId == quote.Id) {
                            listQuoteLineItemsToDelete.add(quoteLineItem);
                        }
                    }
                }
            }
            if(listQuoteLineItemsToDelete.size() > 0){
                delete listQuoteLineItemsToDelete;
            }
        }
    }//deleteQuoteLineItem

}//class