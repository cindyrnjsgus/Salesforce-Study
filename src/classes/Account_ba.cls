public with sharing class Account_ba implements Database.Batchable<SObject>, Database.Stateful{

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, Name, CreatedDate, Email__c FROM Account]);
    }

    public void execute(Database.BatchableContext bc, List<Account> accounts) {
        List<AccountBatch__c> listAccountHistories = new List<AccountBatch__c>();
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Account account : accounts){
            if(account.CreatedDate.day() == Date.today().addDays(-6).day()) {
                listAccountHistories.add(new AccountBatch__c(Name = account.Name,
                                                             Account__c = account.Id));

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
        }

        /** record insert */
        insert listAccountHistories;
        /** send email */
        Messaging.sendEmail(emails);
    }

    public void finish(Database.BatchableContext bc) {

    }

}