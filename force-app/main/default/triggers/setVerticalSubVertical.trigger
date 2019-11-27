// Author: Alexander Nourbakhsh
// Date Created/Modified: 01.18.2017
// Project: Card Spend
// Purpose:
// 
// To set the Vertical and Sub Vertical fields before insert or update of a trident record. 
// The Sic code field is the indepedent variable with the Vertical and Sub Vertical fields 
// being the dependent variables.
//


trigger setVerticalSubVertical on Account (before insert, before update) {
    
    
    
    // Set of Strings to store the Medical Sic Codes
    Set<Integer> medicalSicCode = New Set<Integer> {8011, 8021, 8031, 8042, 8041, 8062};
    
    // Set of Strings to store the Nurses Sic Codes
    Set<Integer> nursesSicCode = New Set<Integer> {8049,7361};
    
    // Set of Strings to store the Business Sic Codes
    Set<Integer> businessSicCode = New Set<Integer> {8111, 8611, 8721, 8748, 8711, 2721};
    
    // Set of Strings to store the Trade Sic Codes
    Set<Integer> tradeSicCode = New Set<Integer> {8631};
    
    // Set of Strings to store the Education Sic Codes
    Set<Integer> educationSicCode = New Set<Integer> {8621,8222,8243,8299};
    
    // Set of Strings to store the General Sic Codes
    Set<Integer> generalAlumSicCode = New Set<Integer> {6311,6321,6324,6531,6541,6719,7389,
    9111,9112,9113,9114,9115,9116,9117,9118,9119,9120,9121,9122,9123,
    9124,9125,9126,9127,9128,9129,9130,9131,9132,9133,9134,9135,9136,9137,
    9138,9139,9140,9141,9142,9143,9144,9145,9146,9147,9148,9149,9150,9151,
    9152,9153,9154,9155,9156,9157,9158,9159,9160,9161,9162,9163,9164,9165,
    9166,9167,9168,9169,9170,9171,9172,9173,9174,9175,9176,9177,9178,9179,
    9180,9181,9182,9183,9184,9185,9186,9187,9188,9189,9190,9191,9192,9193,
    9194,9195,9196,9197,9198,9199,9200,9201,9202,9203,9204,9205,9206,9207,
    9208,9209,9210,9211,9212,9213,9214,9215,9216,9217,9218,9219,9220,9221,
    9222,9223,9224,9225,9226,9227,9228,9229,9230,9231,9232,9233,9234,9235,
    9236,9237,9238,9239,9240,9241,9242,9243,9244,9245,9246,9247,9248,9249,
    9250,9251,9252,9253,9254,9255,9256,9257,9258,9259,9260,9261,9262,9263,
    9264,9265,9266,9267,9268,9269,9270,9271,9272,9273,9274,9275,9276,9277,
    9278,9279,9280,9281,9282,9283,9284,9285,9286,9287,9288,9289,9290,9291,
    9292,9293,9294,9295,9296,9297,9298,9299,9300,9301,9302,9303,9304,9305,
    9306,9307,9308,9309,9310,9311,9312,9313,9314,9315,9316,9317,9318,9319,
    9320,9321,9322,9323,9324,9325,9326,9327,9328,9329,9330,9331,9332,9333,
    9334,9335,9336,9337,9338,9339,9340,9341,9342,9343,9344,9345,9346,9347,
    9348,9349,9350,9351,9352,9353,9354,9355,9356,9357,9358,9359,9360,9361,
    9362,9363,9364,9365,9366,9367,9368,9369,9370,9371,9372,9373,9374,9375,
    9376,9377,9378,9379,9380,9381,9382,9383,9384,9385,9386,9387,9388,9389,
    9390,9391,9392,9393,9394,9395,9396,9397,9398,9399,9400,9401,9402,9403,
    9404,9405,9406,9407,9408,9409,9410,9411,9412,9413,9414,9415,9416,9417,
    9418,9419,9420,9421,9422,9423,9424,9425,9426,9427,9428,9429,9430,9431,
    9432,9433,9434,9435,9436,9437,9438,9439,9440,9441,9442,9443,9444,9445,
    9446,9447,9448,9449,9450,9451};
    
    // Set of Strings to store the Four Year Sic Codes
    Set<Integer> fourYearAlumSicCode = New Set<Integer> {5812, 5912, 6282, 6411, 8221, 6722, 6732, 8231, 8399, 8412, 8661, 8669, 8741, 7999, 8211, 7261, 5541};
    
    // Set of Strings to store the Two Year Sic Codes
    Set<Integer> twoYearTradeSchoolSicCode = New Set<Integer> {8222,8244};

    // Set of Strings to Store the Military Groups Sic Codes
    Set<Integer> milGroupSicCode = New Set<Integer> {9711,9712,9713,9714,9715,9716,9717,9718,9719,9720,9721};
    
    // Set of Strings to store the Fraternal Sic Codes
    Set<Integer> fratSicCode = New Set<Integer> {8641};
    
    // Set of Strings to store the Other Special Interest Groups Sic Codes
    Set<Integer> otherSpecialInterestSicCode = New Set<Integer> {6331, 6351, 4812, 5947, 8699, 8322, 1521, 7941, 8733, 7948, 8322, 7997, 8099, 7371, 8999};


    if (Trigger.isInsert) {
                
        // Qualify records - records must be of the Trident recordTypeId
        List<Account>newVerticalAccounts = new List<Account>();
        for (Account acct : Trigger.new){
            if (acct.recordTypeId == '012a0000001ZVU7'){
                newVerticalAccounts.add(acct);
                } else {
                // do nothing
                }         
        }
                       
        // Assign vertical and sub-vertical values based on SIC code
        for(Account acct : newVerticalAccounts){

            if (acct.Sic != null) {
                // Convert Account Sic text field to Integer for comparison
                Integer acctSic = Integer.ValueOf(acct.Sic);
            
        
                if (medicalSicCode.contains(acctSic)) {
                    acct.Vertical__c = '1';
                    acct.Sub_vertical__c = 'a';
                } else if (nursesSicCode.contains(acctSic)) {
                    acct.Vertical__c = '1';
                    acct.Sub_vertical__c = 'b';
                } else if (businessSicCode.contains(acctSic)) {
                    acct.Vertical__c = '1';
                    acct.Sub_vertical__c = 'c';
                } else if (tradeSicCode.contains(acctSic)) {
                    acct.Vertical__c = '1';
                    acct.Sub_vertical__c = 'd';
                } else if (educationSicCode.contains(acctSic)) {
                    acct.Vertical__c = '1';
                    acct.Sub_vertical__c = 'e';
                } else if (generalAlumSicCode.contains(acctSic)) {      
                    acct.Vertical__c = '1';
                    acct.Sub_vertical__c = 'f';
                } else if (fourYearAlumSicCode.contains(acctSic)) {      
                    acct.Vertical__c = '2';
                    acct.Sub_vertical__c = 'a';
                } else if (twoYearTradeSchoolSicCode.contains(acctSic)) {      
                    acct.Vertical__c = '2';
                    acct.Sub_vertical__c = 'b';
                } else if (milGroupSicCode.contains(acctSic)) {      
                    acct.Vertical__c = '3';
                    acct.Sub_vertical__c = 'a';
                } else if (fratSicCode.contains(acctSic)) {      
                    acct.Vertical__c = '3';
                    acct.Sub_vertical__c = 'b';
                } else if (otherSpecialInterestSicCode.contains(acctSic)) {      
                    acct.Vertical__c = '3';
                    acct.Sub_vertical__c = 'd';
                } else {
                // do nothing
                }
            }    
        }
    }

    if(Trigger.isUpdate) {
    
        // Qualify records - compare maps to look for change on the SIC code field
        List<Account>verticalAccounts = new List<Account>();
        for (Account acct : Trigger.new){
            Account oldAcct = Trigger.oldMap.get(acct.Id);
            if (acct.recordTypeId == '012a0000001ZVU7' && acct.Sic != oldAcct.Sic){
                verticalAccounts.add(acct);
            }
        }
        
        // Assign vertical and sub-vertical values based on SIC code
        for(Account acct : verticalAccounts){
            
            if (acct.Sic != null) {
                // Convert Account Sic text field to Integer for comparison
                Integer acctSic = Integer.ValueOf(acct.Sic);    
        
                if (medicalSicCode.contains(acctSic)) {
                    acct.Vertical__c = '1';
                    acct.Sub_vertical__c = 'a';
                } else if (nursesSicCode.contains(acctSic)) {
                    acct.Vertical__c = '1';
                    acct.Sub_vertical__c = 'b';
                } else if (businessSicCode.contains(acctSic)) {
                    acct.Vertical__c = '1';
                    acct.Sub_vertical__c = 'c';
                } else if (tradeSicCode.contains(acctSic)) {
                    acct.Vertical__c = '1';
                    acct.Sub_vertical__c = 'd';
                } else if (educationSicCode.contains(acctSic)) {
                    acct.Vertical__c = '1';
                    acct.Sub_vertical__c = 'e';
                } else if (generalAlumSicCode.contains(acctSic)) {      
                    acct.Vertical__c = '1';
                    acct.Sub_vertical__c = 'f';
                } else if (fourYearAlumSicCode.contains(acctSic)) {      
                    acct.Vertical__c = '2';
                    acct.Sub_vertical__c = 'a';
                } else if (twoYearTradeSchoolSicCode.contains(acctSic)) {      
                    acct.Vertical__c = '2';
                    acct.Sub_vertical__c = 'b';
                } else if (milGroupSicCode.contains(acctSic)) {      
                    acct.Vertical__c = '3';
                    acct.Sub_vertical__c = 'a';
                } else if (fratSicCode.contains(acctSic)) {      
                    acct.Vertical__c = '3';
                    acct.Sub_vertical__c = 'b';
                } else if (otherSpecialInterestSicCode.contains(acctSic)) {      
                    acct.Vertical__c = '3';
                    acct.Sub_vertical__c = 'd';
                } else {
                    acct.Vertical__c = '';
                    acct.Sub_vertical__c = '';
                }     
            } else {
                // if null set fields to null
                acct.Vertical__c = '';
                acct.Sub_vertical__c = '';
            }
        } 
    }
}