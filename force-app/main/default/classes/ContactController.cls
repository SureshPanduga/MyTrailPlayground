/**
 * @File Name          : ContactController.cls
 * @Description        : 
 * @Author             : supanduga@deloitte.com.acdhsdev1
 * @Group              : 
 * @Last Modified By   : supanduga@deloitte.com.acdhsdev1
 * @Last Modified On   : 7/17/2019, 11:28:00 AM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    7/17/2019, 11:27:06 AM   supanduga@deloitte.com.acdhsdev1     Initial Version
**/
public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList() {
        return [SELECT Id, Name, Title, Phone, Email FROM Contact];
    }
}