@isTest
public class AddPrimaryContactTest {
	@testSetup
    public Static void insertAccounts(){
        List<Account> accList = new List<Account>();
        for(Integer i=0; i<50; i++)
            accList.add(new Account(Name='Test NY Account '+i,BillingState='NY'));
        for(Integer i=0; i<50; i++)
            accList.add(new Account(Name='Test CA Account '+i,BillingState='CA'));
        if(!accList.isEmpty())
            insert accList;
    }
    @isTest Static void queuableExecuteNYTest(){
        Contact con = new Contact(LastName='Suresh Test');
        insert con;
        AddPrimaryContact primCon = new AddPrimaryContact(con,'NY');
        Test.startTest();
        System.enqueueJob(primCon);
        Test.stopTest();
    }
    @isTest Static void queuableExecuteCATest(){
        Contact con = new Contact(LastName='Suresh Test');
        insert con;
        AddPrimaryContact primCon = new AddPrimaryContact(con,'CA');
        Test.startTest();
        System.enqueueJob(primCon);
        Test.stopTest();
    }
}