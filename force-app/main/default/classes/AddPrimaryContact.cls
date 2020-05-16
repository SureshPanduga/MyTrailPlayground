public class AddPrimaryContact implements Queueable {
    
    public Contact cont;
    public String stateAbbre;
    
    public AddPrimaryContact(Contact cont, String stateAbbre){
        this.cont = cont;
        this.stateAbbre = stateAbbre;
    }
    
    public void Execute(QueueableContext context){
        List<Account> accList = [SELECT Id, Name FROM Account WHERE BillingState =: stateAbbre LIMIT 200];
        List<Contact> contList = new List<Contact>();
        for(Account acc : accList){
            Contact contClone = new Contact();
            contClone = cont.clone(false);
            contClone.AccountId = acc.Id;
            contList.add(contClone);
        }
        for(Contact con : contList)
            System.debug('---con---'+con);
        if(!contList.isEmpty())
            upsert contList;
    }
}