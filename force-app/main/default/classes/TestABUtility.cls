@isTest()
private class TestABUtility{
    
    @isTest
	private static void getNameSpacePrefix() {
        ABUtility.getNameSpacePrefix('__');
    }
    
    @isTest
	private static void getNameSpacePrefixUsingClass() {
        ABUtility.getNameSpacePrefix(String.valueOf(nFUSE.IntegrationClassTypeProvider.class),'__');
    }
    
    @isTest
	private static void TestKeyValueParserSucceeds() {
	    
	    List<String> stringsToParse = new List<String>{ 'key|value' };
	    
	    Map<String,String> parsedMap = ABUtility.ParseKeyValuePairs(stringsToParse);
		
		System.assertEquals(true, parsedMap.containsKey('key'));

	}
	
	@isTest
	private static void TestKeyValueParserThrowsNoDelimiterValueError() {
	    
	    List<String> stringsToParse = new List<String>{ 'key' };
	    
	    try{
	    	Map<String,String> parsedMap = ABUtility.ParseKeyValuePairs(stringsToParse);
	    	System.assertEquals(true,false);
	    }catch(Exception e){
	    	System.assertEquals(String.format(System.Label.PairMissingMessage,new List<String>{'key'}),e.getMessage());	
	    }

	}
	
	@isTest
	private static void TestKeyValueParserThrowsKeyInUseError() {
	    
	    List<String> stringsToParse = new List<String>{ 'key|value', 'key|value2' };
	    
	    try{
	    	Map<String,String> parsedMap = ABUtility.ParseKeyValuePairs(stringsToParse);
	    	System.assertEquals(true,false);
	    }catch(Exception e){
	    	System.assertEquals(String.format(System.Label.KeyInUseMessage,new List<String>{'key'}),e.getMessage());	
	    }

	}
	
	@isTest
	private static void TestKeyValueParserThrowsBlankError() {
	    
	    List<String> stringsToParse = new List<String>{ '' };
	    
	    try{
	    	Map<String,String> parsedMap = ABUtility.ParseKeyValuePairs(stringsToParse);
	    	System.assertEquals(true,false);
	    }catch(Exception e){
	    	System.assertEquals(System.Label.BlankValueKeyPairMessage,e.getMessage());	
	    }

	}
	
	@isTest
	private static void TestGetGuid() {
	    
	    String guid = ABUtility.GetGuid();
		
		System.assertEquals(true, !String.isBlank(guid));

	}
	
    @isTest
	private static void TestNormalizeKey() {
	    
	    String keyToNormalize = 'This is not normal';
		String expectedKeyAfterNormalization = 'THIS_IS_NOT_NORMAL';
		
		String normalized = ABUtility.NormalizeKey(keyToNormalize);
		
		System.assertEquals(expectedKeyAfterNormalization, normalized);

	}
	
	@isTest
	private static void TestHeadersUpdatesExisting() {
	    
	    HttpRequest httpReq = new HttpRequest();
	    httpReq.setHeader('Cheese','Provolone');
	    
	    ABUtility util = new ABUtility();
	    
	    util.UpdateOrAddHeader(httpReq, 'Cheese', 'Gouda');
	    
	    System.assertEquals('Gouda', httpReq.getHeader('Cheese'));

	}
	
	@isTest
	private static void TestHeadersAddsNew() {
	    
	    HttpRequest httpReq = new HttpRequest();
	    
	    ABUtility util = new ABUtility();
	    
	    util.UpdateOrAddHeader(httpReq, 'Cheese', 'Gouda');
	    
	    System.assertEquals('Gouda', httpReq.getHeader('Cheese'));

	}
	@isTest
	private static void TestHeaderNotBlankAndExists() {
	    
	    HttpRequest httpReq = new HttpRequest();
	    httpReq.setHeader('Cheese','Provolone');
	    ABUtility util = new ABUtility();
	    
	    util.UpdateOrAddHeader(httpReq, 'Cheese', 'Provolone');
	    
	    System.assertEquals('Provolone', httpReq.getHeader('Cheese'));

	}
	
	@isTest
	private static void TestUrlEncoding() {
		Map<String, String> m = new Map<String, String>();
		
		m.put('Red', 'FF0000');
		m.put('Blue', '0000A0');
		
		String encoded = ABUtility.UrlFormEncodeMap(m);
	    
	    System.assertEquals('Red=FF0000&Blue=0000A0', encoded);

	}
	
	@isTest
	private static void TestUrlEncoding2() {
		Map<String, String> m = new Map<String, String>();
		
		m.put('Red', 'FF0000 AND IS COOL');
		m.put('Blue', '0000A0 AND IS NOT COOL');
		
		String encoded = ABUtility.UrlFormEncodeMap(m);
	    
	    System.assertEquals('Red=FF0000+AND+IS+COOL&Blue=0000A0+AND+IS+NOT+COOL', encoded);

	}
}