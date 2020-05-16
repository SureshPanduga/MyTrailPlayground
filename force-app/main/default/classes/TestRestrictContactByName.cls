@isTest
public class TestRestrictContactByName {
    @isTest Static void InvalidContactName(){
        Contact con = new Contact(FirstName='Suresh',LastName='INVALIDNAME');
        Test.startTest();
        Database.SaveResult res = Database.Insert(con,false);
        Test.stopTest();
        System.assert(!res.isSuccess());
        System.assert(res.getErrors().size() > 0);
        System.assertEquals('The Last Name "INVALIDNAME" is not allowed for DML',
                             res.getErrors()[0].getMessage());
    }
}