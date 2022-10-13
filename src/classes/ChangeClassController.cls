/**
 * Created by samsung on 2022-10-04.
 */

public with sharing class ChangeClassController {

    @AuraEnabled
    public static List<Map<String, String>> getInitData(){

        List<Class__c> listClass = [
                SELECT Name
                FROM Class__c
                ORDER BY Grade__c, ClassNumber__c
        ];

        List<Map<String, String>> listReturn = new List<Map<String, String>>();
        if(!listClass.isEmpty()){
            Map<String, String> mapValues = new Map<String, String>();
            for(Class__c obj : listClass) {
                if (!mapValues.isEmpty()) mapValues = new Map<String, String>();
                    mapValues.put('label', obj.Name);
                    mapValues.put('value', obj.Name);
                    listReturn.add(mapValues);  // 리스트의 map으로 변경해야함
            }
        }
        return listReturn;

    }//getInitData


    @AuraEnabled
    public static Boolean changeClass(String className, String recordId){

        Contact contact = [
                SELECT Class__r.Grade__c
                FROM Contact
                WHERE Id =: recordId
        ];

        Class__c classes = [
                SELECT Id, Grade__c
                FROM Class__c
                WHERE Name =: className
        ];

        if(classes.Grade__c != contact.Class__r.Grade__c) {
            return false;
        }
        else {
            contact.Class__c = classes.Id;
            update contact;
            return true;
        }

    }//changeClass


}