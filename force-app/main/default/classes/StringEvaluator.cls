public class StringEvaluator {

    //Given a regex and string
    //Return if anything matches
    public static Boolean hasMatch(String regex, String str){                
        return Pattern.matches(regex,str);
    }
    
    //Given a regex and string
    //Return all the matches
    public static List<String> getMatch(String regex, String str){
        Pattern myPattern = Pattern.compile(regex);
        Matcher myMatcher = myPattern.matcher(str);
        List<String> strList = new List<String>();
        while(myMatcher.find()){
            strList.add(myMatcher.group());
        }
        return strList;
    }
    //Given a regex and string 
    //Return the string with replacing with masks
    public static String replaceMatch(String regex, String str){
        Pattern myPattern = Pattern.compile(regex);
        Matcher myMatcher = myPattern.matcher(str);
        String maskedString = str;
        String masked = null;
        System.Debug(LoggingLevel.INFO, 'In the evaluator1 = '+ str);
        while(myMatcher.find()){
            masked = maskCreditCardNumStr(myMatcher.group());
            System.Debug(LoggingLevel.INFO, 'In the evaluator2 = '+ masked);
            maskedString =  maskedString.replace(myMatcher.group(), masked);
            System.Debug(LoggingLevel.INFO, 'In the evaluator3 = '+ maskedString);
            myMatcher = myPattern.matcher(maskedString);
        }
        if( maskedString == null) {
           maskedString = ''; 
        } 
        return maskedString;
    }
    
    //https://fnni--ncino.cs69.my.salesforce.com/_ui/common/apex/debug/ApexCSIPage#Given string1 (ori), string2 (rep) and text
    //replace all string1 with string2 in text
    public static String maskMatch(String text, String ori, String rep){
        return text.replaceAll(ori, rep);
    }
    
    //Process a 16 digit credit card number 
    public static String maskCreditCardNumStr(String str){
        String noSpace = str.replaceAll('\\s','');
        noSpace = noSpace.replaceAll('-','');
        System.Debug(LoggingLevel.INFO, 'In the evaluatormask = '+ noSpace);
        String sub = noSpace.substring(6, noSpace.length()-4);
        string firstPart = noSpace.Substring(0, 6);
        string lastPart = noSpace.Substring(noSpace.length() - 4, noSpace.length());
        Integer midlen = noSpace.length() - (lastpart.length());
        System.Debug(LoggingLevel.INFO, 'In the evaluatormask substring = '+ sub);
        String newstr = firstPart.rightPad(midlen,'*') + lastpart;
        System.Debug(LoggingLevel.INFO, 'In the evaluatormask substring2 = '+ newstr);
        return newstr;
    }  


}