@isTest
global class ParkServiceMock implements WebServiceMock {
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
            ParkService.byCountryResponse response_x = new ParkService.byCountryResponse();
            List<String> responseString = new List<String>();
            responseString.add('Yo');
            responseString.add('Man');
            response_x.return_x = responseString;
            response.put('response_x', response_x); 
        }
}