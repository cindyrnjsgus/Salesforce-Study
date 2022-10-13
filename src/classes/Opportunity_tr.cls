/**
 * Created by samsung on 2022-09-07.
 */

public with sharing class Opportunity_tr extends TriggerHandler {

    public Opportunity_tr() {
        listNew = (List<Opportunity>) Trigger.new;  // new - before insert, before update 및 before undelete 트리거에서만 사용할 수 있습니다.
        listOld = (List<Opportunity>) Trigger.old;  // old - update 및 delete
        mapNew = (Map<Id, Opportunity>) Trigger.newMap; // newMap - before update,after insert,after update 및 after undelete
        mapOld = (Map<Id, Opportunity>) Trigger.oldMap;
    }

    /** TriggerHandler */
    private List<Opportunity> listNew { get; set; }
    private List<Opportunity> listOld { get; set; }
    private Map<Id, Opportunity> mapNew { get; set; }
    private Map<Id, Opportunity> mapOld { get; set; }

    /** Opportunity [Stage] 업데이트 시 */
    public override void afterUpdate() {
        insertQuoteLineItem();
    }

    /** Create QuoteLineItem */
    public void insertQuoteLineItem(){
        Set<Id> setOpportunityIds = new Set<Id>();
        for(Opportunity opportunity : listNew){
            if(opportunity.StageName == 'Negotiation/Review' && mapOld.get(opportunity.Id).StageName != 'Negotiation/Review' && opportunity.HasOpportunityLineItem){
                setOpportunityIds.add(opportunity.Id);
            }
        }

        if(setOpportunityIds.size()>0){
            List<OpportunityLineItem> listOpportunityLineItems = new List<OpportunityLineItem>([
                    SELECT  Id, PricebookEntryId, Product2Id, Quantity, UnitPrice, OpportunityId, Description
                    FROM    OpportunityLineItem
                    WHERE   OpportunityId =: setOpportunityIds
            ]);

            List<Quote> listQuotes = new List<Quote>([
                    SELECT      Id, Name, OpportunityId, Status, CreatedDate
                    FROM        Quote
                    WHERE       OpportunityId = :setOpportunityIds
                    ORDER BY    CreatedDate DESC
            ]);

            // optyId 와 Quote 맵핑
            Map<Id,Quote> mapOptyIdToQuote = new Map<Id,Quote>();
            if(listQuotes.size()>0){
                for(Quote quote : listQuotes){
                    if(mapOptyIdToQuote.get(quote.OpportunityId) == null){
                        mapOptyIdToQuote.put(quote.OpportunityId, quote);
                    }
                }
            }

            // Quote가 없는 경우 -> Quote 생성
            List<Quote> listInsertQuotes = new List<Quote>();
            for(Opportunity opportunity : listNew){
                if(mapOptyIdToQuote.get(opportunity.Id) == null){
                    Quote objQuote = new Quote();
                    objQuote.Name = String.valueOf(Datetime.now());
                    objQuote.Status ='Draft';
                    objQuote.OpportunityId = opportunity.Id;
                    listInsertQuotes.add(objQuote);
                }
            }

            if(listInsertQuotes.size()>0){
                insert listInsertQuotes;

                //Quote 생성 후 -> QuoteLineItem 생성
                List<QuoteLineItem> listQuoteLineItems = new List<QuoteLineItem>();
                for(Quote quote : listInsertQuotes){
                    for(OpportunityLineItem optyLineItem : listOpportunityLineItems){
                        if(quote.OpportunityId == optyLineItem.OpportunityId){
                            QuoteLineItem quoteLineItem = new QuoteLineItem();
                            quoteLineItem.OpportunityLineItemId = optyLineItem.Id;
                            quoteLineItem.Product2Id = optyLineItem.Product2Id;
                            quoteLineItem.PricebookEntryId = optyLineItem.PricebookEntryId;
                            quoteLineItem.Quantity = optyLineItem.Quantity;
                            quoteLineItem.UnitPrice = optyLineItem.UnitPrice;
                            quoteLineItem.Description = optyLineItem.Description;
                            quoteLineItem.QuoteId = quote.Id;

                            listQuoteLineItems.add(quoteLineItem);
                        }
                    }
                }
                if(listQuoteLineItems.size()>0){
                    insert listQuoteLineItems;
                }

            }// if(quote 존재여부)
        }// if(opty 존재여부)
    }// insertQuoteLineItem
}
