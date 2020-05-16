@isTest
public class TestVerifyDate {
    @isTest Static void checkDates(){
        Date returnedDate = VerifyDate.CheckDates(Date.newInstance(2018, 11, 25), Date.newInstance(2018, 12, 28));
        System.assertEquals(Date.newInstance(2018, 11, 30), returnedDate);
    }
    @isTest Static void DateWithin30Days(){
        Date returnedDate = VerifyDate.CheckDates(Date.newInstance(2018, 11, 25), Date.newInstance(2018, 12, 15));
        System.assertEquals(Date.newInstance(2018, 12, 15), returnedDate);
    }
}