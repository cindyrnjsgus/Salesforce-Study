
public with sharing class AssetSignatureFormController {

    @AuraEnabled
    public static DataWrapper saveSignature(String signatureBody, String recordId, String sObjectName){

        String strStatus = 'SUCCESS';
        String strMessage = '';

        DataWrapper objDataWrapper = new DataWrapper();
        try {
            Date d = Date.today();
            ContentVersion objContentVersion = new ContentVersion();

            /** count files number ************************************************************************************/
            List<ContentVersion> listContentVersions = [
                    SELECT Id, Title, FirstPublishLocationId
                    FROM ContentVersion
                    ORDER BY CreatedDate
            ];

            String[] test;
            Integer newVersion;
            for(ContentVersion contentVersion : listContentVersions){
                if(contentVersion.FirstPublishLocationId.equals(recordId)){
                    test = contentVersion.Title.split('_',3);
                    if(test.size()==3){
                        newVersion = Integer.valueOf(test[2])+1;
                    }
                }
            }
            if(newVersion == null){
                newVersion = 1;
            }
            /**********************************************************************************************************/
            System.debug('signatureBody : '+signatureBody);
            if (sObjectName == 'Asset') {

                objContentVersion.Title = UserInfo.getName() + '_' + d.year() + d.month() + d.day() + '_' + newVersion;
                objContentVersion.PathOnClient = UserInfo.getName() + '_' + d.year() + d.month() + d.day() + '_' + newVersion + '.jpg';
                objContentVersion.VersionData = EncodingUtil.base64Decode(signatureBody);
                objContentVersion.FirstPublishLocationId = recordId;
                objContentVersion.OwnerId = UserInfo.getUserId();
                objContentVersion.ContentLocation = 'S';
                insert objContentVersion;
            }

            Set<String> setFileId = new Set<String>();
            setFileId.add(objContentVersion.Id);

            List<ContentVersion> TempAttachList = [
                    SELECT Id, Title, ContentDocumentId
                    FROM ContentVersion
                    WHERE Id IN: setFileId
            ];

            List<ContentDistribution> insertList = new List<ContentDistribution>();
            for (ContentVersion tempobj : TempAttachList) {
                ContentDistribution publiclink = new ContentDistribution();
                publiclink.ContentVersionId = tempobj.Id;
                publiclink.Name = tempobj.Title;
                publiclink.PreferencesAllowViewInBrowser = true;
                publiclink.PreferencesLinkLatestVersion = true;
                publiclink.PreferencesNotifyOnVisit = false;
                publiclink.PreferencesPasswordRequired = false;
                publiclink.PreferencesAllowOriginalDownload = true;
                insertList.add(publiclink);
            }

            if (!insertList.isEmpty()) {
                insert insertList;
            }

        } catch (Exception e) {
            strStatus = 'ERROR';
            strMessage = e.getMessage() + ' Line : '+e.getLineNumber();
        }

        objDataWrapper.strStatus = strStatus;
        objDataWrapper.strMessage = strMessage;

        return objDataWrapper;
    }

    public class DataWrapper {
        @AuraEnabled
        public String strStatus {get;set;}
        @AuraEnabled
        public String strMessage {get;set;}
    }
}