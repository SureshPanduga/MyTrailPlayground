public class ParkLocator {
    public Static List<String> country(String countryName){
        ParkService.ParksImplPort pkService = new ParkService.ParksImplPort();
        return pkService.byCountry(countryName);
    }
}