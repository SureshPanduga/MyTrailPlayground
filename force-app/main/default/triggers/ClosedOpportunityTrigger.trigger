trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    List<Task> taskInsertList = new  List<Task>();
    for(Opportunity opp : Trigger.New){
        if(opp.StageName == 'Closed Won'){
            Task tsk = new Task(subject='Follow Up Test Task',whatId = opp.Id);
            taskInsertList.add(tsk);
        }
    }
    if(!taskInsertList.isEmpty())
        insert taskInsertList;
}