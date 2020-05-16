@isTest
public class AccountProcessorTest {
    @isTest Static void countContactsTest(){
        List<Account> accList = new List<Account>();
        for(Integer i = 0; i < 2 ; i++){
            Account acc = new Account(Name='Test Account'+i);
            accList.add(acc);
        }
        if(!accList.isEmpty())
            insert accList;
        List<Contact> contList = new List<Contact>();
        for(Account acc : accList){
            for(Integer j = 0; j < 2; j++){
                Contact cont = new Contact(LastName='Test Contact'+j);
                contList.add(cont);
            }
        }
        if(!contList.isEmpty())
            insert contList;
        List<Id> accIdsList = new List<Id>();
        for(Account acc : accList)
            accIdsList.add(acc.Id);
        Test.startTest();
        AccountProcessor.countContacts(accIdsList);
        Test.stopTest();
    }
}