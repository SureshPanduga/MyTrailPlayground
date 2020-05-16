@isTest
private class ParkLocatorTest {
    @isTest static void testCallout() {              
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        List<String> result = ParkLocator.country('India');
        System.assertEquals(2, result.size()); 
    }
}