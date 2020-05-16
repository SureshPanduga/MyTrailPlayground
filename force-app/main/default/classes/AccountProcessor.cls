public class AccountProcessor {
	@future
    public Static void countContacts(List<Id> accountIds){
        List<Account> accountList = [SELECT Id, Name, Number_of_Contacts__c, (SELECT Id, Name from Contacts) FROM Account WHERE Id IN: accountIds];
        for(Account acc : accountList){
            acc.Number_of_Contacts__c = acc.Contacts.size();
        }
        if(!accountList.isEmpty())
            update accountList;
    }
}