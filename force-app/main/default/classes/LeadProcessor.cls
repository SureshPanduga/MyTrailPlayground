global class LeadProcessor implements Database.Batchable<SObject>, Database.Stateful {
    global Database.QueryLocator Start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id, LeadSource FROM Lead ORDER BY CreatedDate DESC');
    }
    global void Execute(Database.BatchableContext bc, List<Lead> scope){
        for(Lead ld : scope){
            ld.LeadSource = 'Dreamforce';
        }
        update scope;
    }
    global void Finish(Database.BatchableContext bc){
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        System.debug('---AsyncApexJob---'+job);
    }
}