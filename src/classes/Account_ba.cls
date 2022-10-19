public with sharing class Account_ba implements Database.Batchable<SObject>, Database.Stateful{

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, Name, LastModifiedDate, Email__c, (SELECT Id, Field, CreatedDate, NewValue, OldValue FROM Histories) FROM Account]);
    }

    public void execute(Database.BatchableContext bc, List<Account> ListAccount) {
        List<AccountBatch__c> listAccountBatches = new List<AccountBatch__c>();
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Account account : ListAccount){
            for(AccountHistory accountHistory : account.Histories){

                Date yesterday = Date.today().addDays(-1);
                Date modDate = Date.valueOf(account.LastModifiedDate);
                Date createDate = Date.valueOf(accountHistory.CreatedDate);

                if(yesterday.isSameDay(modDate) && yesterday.isSameDay(createDate)) {
                    String targetField = '';
                    if(accountHistory.Field == 'TextName'){
                        targetField = 'AccountName';
                    }else{
                        targetField = accountHistory.Field;
                    }
                    listAccountBatches.add(new AccountBatch__c(Name = account.Name,
                                                               Account__c = account.Id,
                                                               TargetFieldName__c = targetField,
                                                               NewValue__c = (String) accountHistory.NewValue,
                                                               OldValue__c = (String) accountHistory.OldValue
                    ));

                    if(account.Email__c != null){
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setToAddresses(new String[]{
                                account.Email__c
                        });
                        email.setSubject('Email Batch Test Subject');
                        email.setHtmlBody('Email Batch Test Body');
                        emails.add(email);
                    }
                }
            }//for
        }//for

        /** record insert */
        insert listAccountBatches;
        /** send email */
        Messaging.sendEmail(emails);
    }

    public void finish(Database.BatchableContext bc) {

    }

}