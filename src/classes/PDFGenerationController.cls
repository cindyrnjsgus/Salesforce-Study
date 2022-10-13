./**
 * Created by samsung on 2022-09-27.
 */

public with sharing class PDFGenerationController {

    @AuraEnabled
    public static void GenerateCustomPDFAndEmail(Id recordId) {
        //first we need to get the page
        PageReference defaultPage = new PageReference('/apex/PrintStudentList2?recordId='+recordId);

        Blob pageData = defaultPage.getContentAsPDF();

        //create attachment
        Attachment att = new Attachment(
                ParentId = recordId,
                Body = pageData,
                Name = '학생정보 ' + Datetime.now().formatLong() + '.pdf'
        );
        insert att;
    }

}