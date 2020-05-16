({
    doInit : function(component, event, helper) {
        if(component.get("v.pageReference").state.code){
            var action = component.get("c.");
            action.setCallback(this,function(a){
                if(a.getState() === "SUCCESS"){
                    
                }
                else{
                    alert('ERROR');
                }
            });
        }
    }
})