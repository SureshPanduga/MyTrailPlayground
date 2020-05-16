@isTest
public class AccountManagerTest {
    @isTest static void testGetAccount() {
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestUri = 'https://ap4.salesforce.com/services/apexrest/Accounts/'+ recordId+'/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        Account thisAccount = AccountManager.getAccount();
        System.assert(thisAccount != null);
        System.assertEquals('REST TEST ACCOUNT', thisAccount.Name);
    }
    static Id createTestRecord() {
        Account accountTest = new Account(Name='REST TEST ACCOUNT');
        insert accountTest;
        List<Contact> contList = new List<Contact>();
        for(Integer i=0;i<5;i++){
            Contact cont = new Contact(LastName='Test Contact'+i,AccountId=accountTest.Id);
            contList.add(cont);
        }
        if(!contList.isEmpty())
            insert contList;
        return accountTest.Id;
    }     
}