global class DailyLeadProcessor implements Schedulable {
    global void Execute(SchedulableContext sc){
        List<Lead> leadList = [SELECT Id, LeadSource FROM Lead WHERE LeadSource =: '' LIMIT 200];
        for(Lead ld : leadList)
            ld.LeadSource = 'Dreamforce';
        if(!leadList.isEmpty())
            update leadList;
    }
}