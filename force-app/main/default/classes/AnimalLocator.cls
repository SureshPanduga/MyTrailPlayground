public class AnimalLocator {
    public Static String getAnimalNameById(Integer animalId){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+animalId);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        Map<String, Object> animalObj = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        Map<String, Object> animalAttrMap = (Map<String, Object>)animalObj.get('animal');
        System.debug('----animalName----'+animalAttrMap.get('name'));
        return (String)animalAttrMap.get('name');
    }
}