/**
 * EinsteinAPI class.
 * 
 * @author      Last Khajiit
 * @since       10/13/2017
 **/
public class EinsteinAPI {
    public String tokenEndpoint {
        get {
            EinsteinAPISettings__c settings =
            		EinsteinAPISettings__c.getInstance(UserInfo.getUserId());
            return settings.TokenEndpoint__c;
        }
    }
    
    public Decimal tokenExpirationSeconds {
        get {
            EinsteinAPISettings__c settings =
            		EinsteinAPISettings__c.getInstance(UserInfo.getUserId());
            return settings.TokenExpirationSeconds__c;
        }
    }
    
    public String registeredEmail {
        get {
            EinsteinAPISettings__c settings =
            		EinsteinAPISettings__c.getInstance(UserInfo.getUserId());
            return settings.RegisteredEmail__c;
        }
    }
    
    public String sentimentEndpoint {
        get {
            EinsteinAPISettings__c settings =
            		EinsteinAPISettings__c.getInstance(UserInfo.getUserId());
            return settings.SentimentEndpoint__c;
        }
    }
    
    public String sentimentModelId {
        get {
            EinsteinAPISettings__c settings =
            		EinsteinAPISettings__c.getInstance(UserInfo.getUserId());
            return settings.SentimentModelId__c;
        }
    }

    public Einstein_API_Settings__c settings        {
        get {
            return Einstein_API_Settings__c.getInstance( UserInfo.getOrganizationId() );
        }
    }
    
    ////////////////////////////////
    // Einstein Intent API Config //
    ////////////////////////////////
    public String intentUploadDatasetEP             {
        get {
            return settings.Intent_Upload_Dataset_Endpoint__c;
        }
    }
    public String intentDatasetDetailsEP            {
        get {
            return settings.Intent_Dataset_Details_Endpoint__c;
        }
    }
    public String intentTrainDatasetEP              {
        get {
            return settings.Intent_Train_Dataset_Endpoint__c;
        }
    }
    public String intentDatasetTrainingStatusEP     {
        get {
            return settings.Intent_Dataset_Training_Status_Endpoint__c;
        }
    }
    public String predictIntentEP                   {
        get {
            return settings.Predict_Intent_Endpoint__c;
        }
    }
    public String intentDatasetCSV                  {
        get {
            return settings.Intent_Dataset_CSV__c;
        }
    }

    public String getAccessToken() {
        ContentVersion base64Content = [
            SELECT  Title, VersionData
            FROM    ContentVersion
            WHERE   Title = 'einstein_platform'
            OR      Title = 'predictive_services'
            ORDER BY Title
            LIMIT 1
        ];
        
        String keyContents = base64Content.VersionData.tostring();
        keyContents = keyContents.replace('-----BEGIN RSA PRIVATE KEY-----', '');
        keyContents = keyContents.replace('-----END RSA PRIVATE KEY-----', '');
        keyContents = keyContents.replace('\n', '');
        JWT jwt = new JWT('RS256');
        jwt.pkcs8 = keyContents; 
        jwt.iss = 'developer.force.com';
        jwt.sub = registeredEmail;
        jwt.aud = tokenEndpoint;
        jwt.exp = String.valueOf(tokenExpirationSeconds);
        String access_token = JWTBearerFlow.getAccessToken(tokenEndpoint, jwt);
        return access_token;
    }

    public SentimentAnalysisResponse findSentiment(String text) {
        String key = getAccessToken();
        Http http = new Http();        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(sentimentEndpoint);
        req.setHeader('Authorization', 'Bearer ' + key);
        req.setHeader('Content-type', 'application/json');        
        String body = '{\"modelId\":\"'+ sentimentModelId + '\",\"document\":\"' + text + '\"}';
        req.setBody(body);        
        HTTPResponse res = http.send(req);        
        SentimentAnalysisResponse resp =
        		(SentimentAnalysisResponse) JSON.deserialize(res.getBody(), SentimentAnalysisResponse.class);
        return resp;
    }

    ////////////////////////////////
    //Einstein Intent API Methods //
    ////////////////////////////////
    /**
     * This method is created to build
     * Http Requests.
     * 
     * @param   method          The method of the Http Call
     * @param   endpoint        The endpoint to which the Http Call has to be made
     * 
     * @return  HttpRequest     Instance of the HttpRequest class
     **/
    private HttpRequest buildRequest( String method, String endpoint ) {
        HttpRequest httpReq = new HttpRequest();
        
        httpReq.setMethod( method );
        httpReq.setEndpoint( endpoint );
        
        httpReq.setHeader( 'Authorization', 'Bearer ' + getAccessToken() );
        httpReq.setHeader( 'Cache-Control', 'no-cache' );
        httpReq.setHeader( 'Content-Type', HttpFormBuilder.GetContentType() );
        
        httpReq.setTimeout( 120000 );
        
        return httpReq;
    }
    
    /**
     * This method is created to make a Http
     * POST Call to the Einstein Intent APIs to
     * upload the file into their server.
     * 
     * @return      DatasetDetailsResponse      Status of the upload process
     **/
    public DatasetUploadResponse uploadDataset() {
        String endpoint = intentUploadDatasetEP;
        
        HttpRequest httpReq = buildRequest( 'POST', endpoint );
        
        String mutipartFormData = '';
        mutipartFormData += HttpFormBuilder.WriteBoundary();
        mutipartFormData += HttpFormBuilder.WriteBodyParameter( 'path', intentDatasetCSV );
        mutipartFormData += HttpFormBuilder.WriteBoundary();
        mutipartFormData += HttpFormBuilder.WriteBodyParameter( 'type', 'text-intent' );
        mutipartFormData += HttpFormBuilder.WriteBoundary( NULL );
        
        Blob formBlob = EncodingUtil.base64Decode( mutipartFormData );
        
        httpReq.setBodyAsBlob( formBlob );

        Http http = new Http();
        
        HTTPResponse httpRes = http.send( httpReq );
        
        DatasetUploadResponse resp = new DatasetUploadResponse();
        
        resp = ( DatasetUploadResponse ) JSON.deserialize( httpRes.getBody(), DatasetUploadResponse.class );
        
        return resp;
    }
    
    /**
     * This method is created to make a 
     * GET call and get the status
     * of the dataset upload process.
     * 
     * @param       datasetId                   The Id of the Dataset that was created
     * 
     * @return      DatasetDetailsResponse      Status of the upload process
     */
    public DatasetDetailsResponse getDatasetDetails( String datasetId ) {
        String endpoint = intentDatasetDetailsEP.replace( '#DSID#', datasetId );
        
        HttpRequest httpReq = buildRequest( 'GET', endpoint );
        
        Http http = new Http();
        
        HTTPResponse httpRes = http.send( httpReq );
        
        DatasetDetailsResponse resp = new DatasetDetailsResponse();
        
        resp = ( DatasetDetailsResponse ) JSON.deserialize( httpRes.getBody(), DatasetDetailsResponse.class );
        
        return resp;
    }
    
    /**
     * This method is created to make a POST
     * Http call to create a model and start
     * training the AI.
     * 
     * @param       datasetId               The Id of te Dataset that was created.
     * 
     * @return      TrainDatasetResponse    Status of the training process
     **/
    public TrainDatasetResponse trainDataset( String datasetId ) {
        String endpoint = intentTrainDatasetEP;
        
        HttpRequest httpReq = buildRequest( 'POST', endpoint );
        
        String mutipartFormData = '';
        mutipartFormData += HttpFormBuilder.WriteBoundary();
        mutipartFormData += HttpFormBuilder.WriteBodyParameter( 'name', 'Case Routing Model - ' + DateTime.now().getTime() );
        mutipartFormData += HttpFormBuilder.WriteBoundary();
        mutipartFormData += HttpFormBuilder.WriteBodyParameter( 'datasetId', String.valueOf( datasetId ) );
        mutipartFormData += HttpFormBuilder.WriteBoundary( NULL );
        
        Blob formBlob = EncodingUtil.base64Decode( mutipartFormData );
        
        httpReq.setBodyAsBlob( formBlob );

        Http http = new Http();
        
        HTTPResponse httpRes = http.send( httpReq );
        
        TrainDatasetResponse resp = new TrainDatasetResponse();
        
        resp = ( TrainDatasetResponse ) JSON.deserialize( httpRes.getBody(), TrainDatasetResponse.class );
        
        return resp;
    }
    
    /**
     * This method is created to make a GET
     * call to get the training status of 
     * the Dataset.
     * 
     * @param       modelId     Id of the model that was created
     * 
     * @return      Object      Status of the training process
     **/
    public Object getDatasetTrainingStatus( String modelId ) {
        String endpoint = intentDatasetTrainingStatusEP.replace( '#MODELID#', modelId );
        
        HttpRequest httpReq = buildRequest( 'GET', endpoint );
        
        Http http = new Http();
        
        HTTPResponse httpRes = http.send( httpReq );
        
        TrainingStatusResponse respTrainingStatus   = new TrainingStatusResponse();
        TrainDatasetResponse respTrainDataset       = new TrainDatasetResponse();
        
        try {
            respTrainingStatus = ( TrainingStatusResponse ) JSON.deserialize( httpRes.getBody(), TrainingStatusResponse.class );
            
            return respTrainingStatus;
        }
        catch( Exception ex ) {
            respTrainDataset = ( TrainDatasetResponse ) JSON.deserialize( httpRes.getBody(), TrainDatasetResponse.class );
            
            return respTrainDataset;
        }
    }
    
    /**
     * This method is created to make a 
     * POST call to predict the Intent in 
     * the text and identify the Label.
     * 
     * @param       modelId             The Id of the model that was created
     * @param       textToPredict       The text that has to be analysed
     * 
     * @return      PredictionResponse  Intent analysed from the given block of text
     **/
    public PredictionResponse predictIntent( String modelId, String textToPredict ) {
        String endpoint = predictIntentEP;
        
        HttpRequest httpReq = buildRequest( 'POST', endpoint );
        
        String mutipartFormData = '';
        mutipartFormData += HttpFormBuilder.WriteBoundary();
        mutipartFormData += HttpFormBuilder.WriteBodyParameter( 'modelId', modelId );
        mutipartFormData += HttpFormBuilder.WriteBoundary();
        mutipartFormData += HttpFormBuilder.WriteBodyParameter( 'document', textToPredict );
        mutipartFormData += HttpFormBuilder.WriteBoundary( NULL );
        
        Blob formBlob = EncodingUtil.base64Decode( mutipartFormData );
        
        httpReq.setBodyAsBlob( formBlob );

        Http http = new Http();
        
        HTTPResponse httpRes = http.send( httpReq );
        
        PredictionResponse resp = new PredictionResponse();
        
        resp = ( PredictionResponse ) JSON.deserialize( httpRes.getBody(), PredictionResponse.class );
        
        return resp;
    }
}