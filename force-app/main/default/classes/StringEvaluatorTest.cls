@isTest
public class StringEvaluatorTest {
    public static String regex = '[.\\s]?\\d{4}[-\\s]?\\d{4}[-\\s]?\\d{4}[-\\s]?\\d{4}\\b';
    public static String descmatch = 'Hi Kristin - card# 1058 3443 5689 5673, written for $50,000.00, was deposited for $5,000.00 on 8/21.Requesting a credit in the amount of $45,000.00.Thank you.';
	public static String descrmatch = 'Hi Kristin - card# 1058 3443 5689, written for $50,000.00, was deposited for $5,000.00 on 8/21.Requesting a credit in the amount of $45,000.00.Thank you.';

    @isTest
    static void hasMatchPosTest() {
        String descrmatch = '1058 3443 5689 5673';
        boolean converted = StringEvaluator.hasMatch(regex, descrmatch);
        System.Debug(LoggingLevel.INFO, 'Testing case ifMatchPosTest is converted to = ' + converted);
        System.assertEquals(true, converted);
    }
    @isTest
    static void hasMatchNegTest() {
        String descrmatch = 'Hi Kristin - card# 1058 3443 5689, written for $50,000.00, was deposited for $5,000.00 on 8/21.Requesting a credit in the amount of $45,000.00.Thank you.';
        boolean converted = StringEvaluator.hasMatch(regex, descrmatch);
        System.Debug(LoggingLevel.INFO, 'Testing case ifMatchNegTest is converted to = ' + converted);
        System.assertEquals(false, converted);
    }
    @isTest
    static void getMatchPosTest() {
        String expected = ' 1058 3443 5689 5673';
        List<String> converted = StringEvaluator.getMatch(regex, descmatch);
        System.Debug(LoggingLevel.INFO, 'Testing case getMatchPosTest is converted to = ' + converted.get(0));
        System.assertEquals(expected, converted.get(0));
    }
    @isTest
    static void getMatchNegTest() {
        String descrmatch = 'Hi Kristin - card# 1058 3443 5689, written for $50,000.00, was deposited for $5,000.00 on 8/21.Requesting a credit in the amount of $45,000.00.Thank you.';
        List<String> converted = StringEvaluator.getMatch(regex, descrmatch);
        System.Debug(LoggingLevel.INFO, 'Testing case getMatchNegTest is converted to = ' + converted);
        System.assertEquals(0, converted.size());
    }
    @isTest
    static void replaceMatchPosTest() {
        String expected = 'Hi Kristin - card#105834******5673, written for $50,000.00, was deposited for $5,000.00 on 8/21.Requesting a credit in the amount of $45,000.00.Thank you.';
        String converted = StringEvaluator.replaceMatch(regex, descmatch);
        System.Debug(LoggingLevel.INFO, 'Testing case replaceMatchPosTest is = '+ converted);
        System.assertEquals(expected, converted);
    }
    @isTest
    static void replaceMatchNegTest() {
        String descrmatch = 'Hi Kristin - card# 1058 3443 3667 written for $50,000.00, was deposited for $5,000.00 on 8/21.Requesting a credit in the amount of $45,000.00.Thank you.';
        String expected = 'Hi Kristin - card# 1058 3443 3667 written for $50,000.00, was deposited for $5,000.00 on 8/21.Requesting a credit in the amount of $45,000.00.Thank you.';
        String converted = StringEvaluator.replaceMatch(regex, descrmatch);
        System.Debug(LoggingLevel.INFO, 'Testing case replaceMatchNegTest  = ' + converted);
        System.assertEquals(expected, converted);
    }
    @isTest
    static void replaceMatchMultiMatchTest() {
        String desmatch = 'Hi Kristin - card# 1058 3443 5689 3667, card# 1058-3443-5689-5673 written for $50,000.00, was deposited for $5,000.00 on 8/21.Requesting a credit in the amount of $45,000.00.Thank you.';
        String expected = 'Hi Kristin - card#105834******3667, card#105834******5673 written for $50,000.00, was deposited for $5,000.00 on 8/21.Requesting a credit in the amount of $45,000.00.Thank you.';
        String converted = StringEvaluator.replaceMatch(regex, desmatch);
        System.Debug(LoggingLevel.INFO, 'Testing case replaceMatchMultiMatchTest  = ' + converted);
        System.assertEquals(expected, converted);
    }
    @isTest
    static void maskMatchPosTest() {
        String matchedStr = '105834******5673';
        String originalStr = '1058 3443 5689 5673';
        String expected = 'Hi Kristin - card# 105834******5673, written for $50,000.00, was deposited for $5,000.00 on 8/21.Requesting a credit in the amount of $45,000.00.Thank you.';
        String converted = StringEvaluator.maskMatch(descmatch, originalStr, matchedStr);
        System.Debug(LoggingLevel.INFO, 'Testing case maskMatchPosTest is converted to = ' + converted);
        System.assertEquals(expected, converted);
    }
    @isTest
    static void maskMatchNegTest() {
        String matchedStr = '1058 3*** **** 5673';
        String originalStr = '1058 3443 5689 5673';
        String expected = descrMatch;
        String converted = StringEvaluator.maskMatch(descrmatch, originalStr, matchedStr);
        System.Debug(LoggingLevel.INFO, 'Testing case maskMatchNegTest is converted to = ' + converted);
        System.assertEquals(expected, converted);
    }    
    @isTest
    static void maskCreditCardNumStrTest() {
        String expected = '105834******5673';
        String matchedStr = '1058 3443 5689 5673';
        String converted = StringEvaluator.maskCreditCardNumStr(matchedStr);
        System.Debug(LoggingLevel.INFO, 'Testing maskCreditCardNumStrTest converted to = ' + converted);
        System.assertEquals(expected, converted);
    }
    
    @isTest
    static void allpatternTest() {
    List<String> testString = new List<String>();
    List<String> testString2 = new List<String>();
    String testStr_n1  = '1234123412341234'; //true
    String converted = StringEvaluator.replaceMatch(regex, testStr_n1);
    System.assertNotEquals('12341*******1234', converted);
    testString.add(testStr_n1);
    String testStr_n2  = 'abcd1234123412341234abcd';        //false
    testString2.add(testStr_n2);
    String testStr_n3  = 'abcd 1234123412341234 abcd';  //true
    converted = StringEvaluator.replaceMatch(regex, testStr_n3);
    System.assertNotEquals('abcd 12341*******1234 abcd', converted);
    testString.add(testStr_n3);
    String testStr_s1 = '1234 1234 1234 1234';              //true
    converted = StringEvaluator.replaceMatch(regex, testStr_s1);
    System.assertNotEquals('12341*******1234', converted);
    testString.add(testStr_s1);
    String testStr_s2 = 'abcd1234 1234 1234 1234abcd';      //
    testString2.add(testStr_s2);
    String testStr_s3 = 'abcd 1234 1234 1234 1234 abcd';    //true
    converted = StringEvaluator.replaceMatch(regex, testStr_s3);
    System.assertNotEquals('abcd 12341*******1234 abcd', converted);
    testString.add(testStr_s3);
    String testStr_d1  = '1234-1234-1234-1234';             //true
    converted = StringEvaluator.replaceMatch(regex, testStr_d1);
    System.assertNotEquals('12341*******1234', converted);
    testString.add(testStr_d1);
    String testStr_d2  = 'abcd1234-1234-1234-1234abcd';     //
    testString2.add(testStr_d2);
    String testStr_d3  = 'abcd 1234-1234-1234-1234 abcd';   //
    testString.add(testStr_d3);
    String testStr_d4  = 'abcd1234-1234-1234-1234 abcd';   //
    testString.add(testStr_d4);
        for (String test : testString) {
             converted = StringEvaluator.replaceMatch(regex, test);
             System.Debug(LoggingLevel.INFO, 'Testing4 = '+ test +'converted to'+converted);
             System.assertNotEquals(test, converted);
            
        }
        for (String test : testString2) {
             converted = StringEvaluator.replaceMatch(regex, test);
             System.Debug(LoggingLevel.INFO, 'Testing5 = '+ test +'converted to'+converted);
             System.assertEquals(test, converted);
            
        }
    }
}