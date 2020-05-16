({
createItem : function(component,strcamp) {

       
        var action = component.get("c.saveItem");
       
        action.setParams({
           
            "strcamp" : strcamp
           
        });
       
        action.setCallback(this,function(response){
           
            var state = response.getState();
           
            console.log('Status of the response is : ' + state);
           
            if(state === "SUCCESS"){
           
                var ilist = component.get("v.items");
               
                ilist.push(strcamp);
               
                component.set("v.items",ilist);
                                      
                component.set("v.newItem",{'sObjectType':'Camping_Item__c','Name':' ','Quantity__c':0,'Price__c':0});
                   
            }
            else{
               
                console.log('Errored Out');
               
            }
           
        });
       
        $A.enqueueAction(action);
       
       
}

})