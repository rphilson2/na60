@isTest
global class TestFNNI_MockHttpRespGen implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('http://example.com/example/test', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        FNNI_B2BOAuth ba = new FNNI_B2BOAuth();

        FNNI_B2BOAuth.Developer oAuthDevResp = new FNNI_B2BOAuth.Developer();
        oAuthDevResp.email = 'test@test.com';
        FNNI_B2BOAuth.OAuthResponse oAuthResp = new FNNI_B2BOAuth.OAuthResponse();
        oAuthResp.developer = oAuthDevResp;
        oAuthResp.refresh_token_expires_in = '0';
        oAuthResp.organization_name = 'Test';
        oAuthResp.token_type = 'BearerToken';
        oAuthResp.issued_at = '1530036999086';
        oAuthResp.client_id = 'gizdfALirRhX6KeSXlFzGAw8PtkmtPD';
        oAuthResp.access_token = 'Test_Access_Token';
        oAuthResp.application_name = '350ea6df-3210-47b8-abb9-acf939a43b75';
        oAuthResp.scope = '';
        oAuthResp.expires_in = '3599';
        oAuthResp.refresh_count = '0';
        oAuthResp.status = 'approved';
        
        res.setBody(JSON.serialize(oAuthResp));
        res.setStatusCode(200);

        
        return res;
    }
}