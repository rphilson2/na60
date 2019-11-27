public without sharing class ABUtility{
    
    private static String KEYVALUE_PAIR_DELIMITER = '|';
    
    @TestVisible private class UtilityException extends Exception {}
    
    public static Map<String, String> ParseKeyValuePairs(List<String> keyValuePairs) {
        if(keyValuePairs == null) return null;
        Map<String, String> store = new Map<String, String>();
		for(String concat : keyValuePairs) {
			if(String.isBlank(concat)) throw new UtilityException(System.Label.BlankValueKeyPairMessage);
			if(concat.indexOf(KEYVALUE_PAIR_DELIMITER) < 0) throw new UtilityException(String.format(System.Label.PairMissingMessage, new List<String>{concat}));
			String key = concat.substringBefore(KEYVALUE_PAIR_DELIMITER);
			String value = concat.substringAfter(KEYVALUE_PAIR_DELIMITER);
			if(store.containsKey(key)) throw new UtilityException(String.format(System.Label.KeyInUseMessage, new List<String>{key}));
			store.put(key, value); //if we made it here it will not error
		}
		return store;
	}
	
    public static String NormalizeKey(String input){
    	return input.toUpperCase().replace(' ','_');
    }
    
    public static String GetSimpleGuid() {
		String returnVal = Math.random() + '';
		returnVal = returnVal.replace('0.', '42');
		return returnVal.substring(0, Math.min(returnVal.length(), 17));
	}
    
    public static String GetGuid(){
        Blob generatedBlob = Crypto.GenerateAESKey(128);
        String hex = EncodingUtil.ConvertTohex(generatedBlob);
        String guid = hex.substring(0, 8)
            + '-' + hex.substring(8, 12)
            + '-' + hex.substring(12, 16)
            + '-' + hex.substring(16, 20)
            + '-' + hex.substring(20);
        return guid.toUpperCase();
    }
    
    public static String UrlFormEncodeMap(Map<String,String> input){
        
        if(input == null) throw new UtilityException(System.Label.ABUtilitySerializeNullException);
        
        List<String> output = new List<String>();
        for (String key : input.keySet()) {
            output.add(EncodingUtil.urlEncode(key, 'UTF-8') + '=' + EncodingUtil.urlEncode(input.get(key), 'UTF-8'));
        }
        if(output.size()==0) return null;
        return String.join(output, '&');
    }
    
    public void UpdateOrAddHeader(HttpRequest httpReq, String headerKey, String newHeaderValue){
        String existingContentTypeHeaderValue = httpReq.getHeader(headerKey);
        if(String.isBlank(existingContentTypeHeaderValue) || existingContentTypeHeaderValue.toLowerCase() != newHeaderValue.toLowerCase()){
            httpReq.setHeader(headerKey, newHeaderValue);
            return;
        }else{
            // it already is set to what we want, so just continue
            return;
        }
    }
    
    public static String getNameSpacePrefix(String delimiter) {
        return getNameSpacePrefix(String.valueOf(ABUtility.class),delimiter);
    }
    
    public static String getNameSpacePrefix(String className, String delimiter) {
        String nameSpace = null;
        String[] classparts = className.split('\\.');
        if (classparts.size() >= 2) {
            nameSpace = classparts[0];
            return namespace+delimiter;
        }
        return '';
    }
    
}