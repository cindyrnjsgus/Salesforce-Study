/**
 * Created by Hyun on 2022-11-07.
 */

public with sharing class SearchStudentController {

    @AuraEnabled
    public static List<Contact> fetchContacts() {
        System.debug('테스트 리스트: 11');
        List<Contact> contactsList = [SELECT Id,
                                             Class__r.Grade__c,
                                             Class__r.ClassNumber__c,
                                             Name
                                      FROM Contact];
        System.debug('테스트 리스트: '+contactsList);

//        List<Map<String, String>> listReturn = new List<Map<String, String>>();
//        if(!contactsList.isEmpty()){
//            Map<String, String> mapValues = new Map<String, String>();
//            for(Contact contact : contactsList) {
//                if (!mapValues.isEmpty()) mapValues = new Map<String, String>();
//                mapValues.put('label', contact.Name);
//                mapValues.put('value', contact.Name);
//                listReturn.add(mapValues);  // 리스트의 map으로 변경해야함
//            }
//        }

        return contactsList;
    }

}