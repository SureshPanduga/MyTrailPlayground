public class SentimentAnalysis_Ctrl {
    @AuraEnabled
    public Static List<String> getSentimentAnalysisForText(String textToAnalyse){
        Map<Decimal, String> finalResponse = new Map<Decimal, String>();
        List<Decimal> probList = new List<Decimal>();
        EinsteinService einstein = new EinsteinService();
        SentimentAnalysisResponse response = einstein.findSentiment(textToAnalyse);
        System.debug('Response = '+ response);
        for(SentimentAnalysisResponse.Probabilities prob : response.Probabilities){
            finalResponse.put(prob.probability,prob.label);
            probList.add(prob.probability);
        }
        System.debug('-probList-'+probList);
        List<String> resultList = new List<String>();
        //String result = '';
        //String result = 'FEEDBACK : '+ finalResponse.get(probList[0]) + ' --- PROBABILITY : ' + probList[0];
        for(Integer i = 0; i < probList.size(); i++){
            String result = 'FEEDBACK : '+ finalResponse.get(probList[i]) + ' --- PROBABILITY : ' + probList[i];
            //result = result + 'FEEDBACK : '+ finalResponse.get(probList[i]) + ' --- PROBABILITY : ' + probList[i] + '\n';
            resultList.add(result);
        }
        return resultList;
    }
}