({
	analyseText : function(component, event, helper) {
		var action = component.get("c.getSentimentAnalysisForText");
        action.setParams({textToAnalyse : component.get("v.strAnalyse")});
        action.setCallback(this,function(a){
            if(a.getState() === "SUCCESS"){
                component.set("v.analysisResponse", a.getReturnValue());
            }
            else{
                alert('ERROR');
            }
        });
        $A.enqueueAction(action);
	}
})