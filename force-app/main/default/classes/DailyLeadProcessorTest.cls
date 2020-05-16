@isTest
public class DailyLeadProcessorTest {
	public static String CRON_EXP = '0 0 13 * * ?';
	@testSetup
    Static void insertLeads(){
        List<Lead> leadList = new List<Lead>();
        for(Integer i = 0; i < 200; i++){
            Lead ld = new Lead(LastName='Test Lead '+i, Company='Salesforce Trailhead', LeadSource='');
            leadList.add(ld);
        }
        if(!leadList.isEmpty())
            insert leadList;
    }
    public Static TestMethod void dailyLeadProcessorTest(){
        DailyLeadProcessor dlp = new DailyLeadProcessor();
        Test.startTest();
        String jobId = System.Schedule('Test Scheduler',CRON_EXP,dlp);
        Test.stopTest();
    }
}