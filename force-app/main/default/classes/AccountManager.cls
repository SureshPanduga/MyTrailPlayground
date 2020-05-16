@RestResource(urlMapping='/Accounts/*')
global class AccountManager {
    @HttpGet
    global Static Account getAccount(){
        RestRequest request = RestContext.request;
        System.debug('---URI---'+request);
        String accountId = request.requestURI.substringBetween('Accounts/','/contacts');
        System.debug('---accountId---'+accountId);
        Account acc =  [SELECT Id, Name, (SELECT Id, Name from Contacts) FROM Account WHERE Id = :accountId];
        return acc;
    }
}