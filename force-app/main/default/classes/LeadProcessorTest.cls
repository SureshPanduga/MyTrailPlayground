@isTest
public class LeadProcessorTest {
	@testSetup
    Static void insertLeads(){
        List<Lead> leadList = new List<Lead>();
        for(Integer i = 0; i < 200; i++){
            Lead ld = new Lead(LastName='Test Lead '+i, Company='Salesforce Trailhead');
            leadList.add(ld);
        }
        if(!leadList.isEmpty())
            insert leadList;
    }
    Static testMethod void leadUpdateTest(){
        Test.startTest();
        LeadProcessor ldpro = new LeadProcessor();
        Database.executeBatch(ldpro,200);
        Test.stopTest();
        System.assertEquals(200, [SELECT Count() FROM Lead WHERE LeadSource = 'Dreamforce']);
    }
}