/************************************************************************************
 * Description :
 *
 * Ver      Date           Author          Modification
 * ===================================================================================
   1.0      2022-09-07     yr.lee         Create
*************************************************************************************/

public with sharing class StudentInfoController {

    @AuraEnabled
    public static Map<String, String> getInitData(String recordId){

        List<Awards__c> listAwards = new List<Awards__c>();
        listAwards = [
                SELECT Id, Student__r.LastName, Student__r.Class__r.Name
                FROM Awards__c
                WHERE Id = :recordId
        ];

        /** 여기에서는 하나의 record만 조회하기 때문에 Bulk API 신경쓰지 않아도됨 */
//        Map<String, String> mapReturn = new Map<String, String>();
//        if(!listContact.isEmpty()){
//            mapReturn.put('LastName', listContact[0].Student__r.LastName);
//            mapReturn.put('ClassName', listContact[0].Student__r.Class__r.Name);
//        }
//        return mapReturn;

        Map<String, String> mapStringToAward = new Map<String, String>();
        for(Awards__c awards : listAwards){
            if(awards != null){
                mapStringToAward.put('LastName', awards.Student__r.LastName);
                mapStringToAward.put('ClassName', awards.Student__r.Class__r.Name);
            }
        }
        return mapStringToAward;

    }
}