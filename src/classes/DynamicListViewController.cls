/**
 * Created by Hyun on 2023-03-17.
 */

public with sharing class DynamicListViewController {
    private String baseQuery = 'SELECT Id, Name, Phone, RecordType.DeveloperName FROM Account ORDER BY Name ASC';
    public String AccFilterId {get; set;}
    private Integer pageSize = 25;

    public DynamicListViewController(){

    }

    public ApexPages.StandardSetController AccountStandardSetController{
        get{
            if(AccountStandardSetController == null){
                AccountStandardSetController = new ApexPages.StandardSetController(Database.getQueryLocator(baseQuery));
                AccountStandardSetController.setPageSize(pageSize);
                // We have to set FilterId after Pagesize, else it will not work
                if(AccFilterId != null) {
                    AccountStandardSetController.setFilterId(AccFilterId);
                }
            }
            return AccountStandardSetController;
        }
        set;
    }

    public DynamicListViewController(ApexPages.StandardSetController c) {

    }
    //Navigate to first Page
    public void firstPage() {
        AccountStandardSetController.first();
    }
    //Navigate to last Page
    public void lastPage() {
        AccountStandardSetController.last();
    }
    //Navigate to Next page
    public void next() {
        if(AccountStandardSetController.getHasNext()) {
            AccountStandardSetController.next();
        }
    }
    //Navigate to Prev Page
    public void prev() {
        if(AccountStandardSetController.getHasPrevious()) {
            AccountStandardSetController.previous();
        }
    }
    public List<Account> getAccounts() {
        return (List<Account>)AccountStandardSetController.getRecords();
    }
    //Get all available list view for Account
    public SelectOption[] getAccountExistingViews(){
        return AccountStandardSetController.getListViewOptions();
    }

    /**
    * Reset List View
    */
    public PageReference resetFilter() {
        AccountStandardSetController = null;
        AccountStandardSetController.setPageNumber(1);
        return null;
    }

}