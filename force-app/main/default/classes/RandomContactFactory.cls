public class RandomContactFactory {
    public Static List<Contact> generateRandomContacts(Integer numofconts, String contLastName){
        List<Contact> retContList = new List<Contact>();
        for(Integer i = 0; i < numofconts; i++){
            Contact cont = new Contact(FirstName='Contact'+i, LastName=contLastName);
            retContList.add(cont);
        }
        return retContList;
    }
}