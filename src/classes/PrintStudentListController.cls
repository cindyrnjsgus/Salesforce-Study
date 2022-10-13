
public with sharing class PrintStudentListController {
    public String recordId { get; set; }
    public List<List<Contact>> doubleListContact { get; set; }

    public PrintStudentListController() {
        //url속 파라미터를 가져오는 코드
        String recordId;
        recordId = ApexPages.currentPage().getParameters().get('recordId');

        //Contact 조회쿼리
        List<Contact> listContact = [
                SELECT Birthdate, LastName
                FROM Contact
                WHERE Class__c =: recordId
        ];

        doubleListContact = new List<List<Contact>>();
        List<Contact> listTempContact = new List<Contact>();
        Integer i = 1;

        for(Contact contact : listContact) {
            listTempContact.add(contact);
            if(Math.mod(i, 30) == 0) {
                doubleListContact.add(listTempContact);
                listTempContact = new List<Contact>();
            }
            i++;
        }
        if(listTempContact.size()>0) {
            doubleListContact.add(listTempContact);
        }
    }

}