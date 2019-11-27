// Author: Alexander Nourbakhsh
// Date: 01.27.2017
// Project: First in the Community Survey Applications
// Purpose: Create Community Investment records from Force.com site FIC survey applications
//  

public without sharing class processFicSurveyApps {

    private final Map<Id, FIC_Survey_Application__c> oldMap;
    private final List<FIC_Survey_Application__c> newFICSurveyApps;
    
    public static void qualifyFicSurveyApps(Map<Id, FIC_Survey_Application__c> oldMap, 
                                            List<FIC_Survey_Application__c> newFICSurveyApps) {
                                                
        List<FIC_Survey_Application__c> qualifiedFICSurveyApps = new List<FIC_Survey_Application__c>();                                        
                                                
        //qualify records
        for(FIC_Survey_Application__c newApp: newFICSurveyApps) {
            FIC_Survey_Application__c oldApp = oldMap.get(newApp.id);
            
            if(oldApp.Conversion__c == False && newApp.Conversion__c == True){  
            
                // Throw error if Non Profit Organization or Conversion Type fields are null
                if(newApp.Non_Profit_Organization__c == null || newApp.Conversion_Type__c == null) {
                    newApp.addError(' Please complete the "Non Profit Organization" and "Conversion Type" fields before attemping to process this record.');
                }
  
                //Add qualified records to list
                qualifiedFICSurveyApps.add(newApp);
                
            } else if (oldApp.Conversion__c == True) {
              //DAG_2019_04_02 New code and new field here.  If Update code is 37, allow the update, then reset the update code so it stay at 37 and keep allowing updates. 
               if (newApp.Update_Code__c == '37') {
                  newApp.Update_Code__c = '00';
               } else {
              // Throw error if already converted
                 newApp.addError(' This FIC Survey Application has already been converted.');
               }
            }
        }
                                                                                         
        // Prevent null pointers                                        
        if(qualifiedFICSurveyApps.size() > 0) {                                     
            // Call method to create Community Investment records from qualified records  
            createCommunityInvestment(qualifiedFICSurveyApps);
            // Call method reparent attachments to Community Investment records                                        
            createAttachments(qualifiedFICSurveyApps); 
        }
    }
    
    public static void createCommunityInvestment (List<FIC_Survey_Application__c> qualifiedFICSurveyApps) {
        
        System.debug(qualifiedFICSurveyApps.size());
        // Record types 
        Id donationRecordTypeId = [SELECT Id
                                       FROM RecordType
                                       WHERE sObjectType = 'Community_Giving__c'
                                       AND Name = 'Donation'
                                       LIMIT 1].id;
        
        Id sponsorshipRecordTypeId = [SELECT Id
                                       FROM RecordType
                                       WHERE sObjectType = 'Community_Giving__c'
                                       AND Name = 'Sponsorship'
                                       LIMIT 1].id;
        
        Id grantRecordTypeId = [SELECT Id
                                FROM RecordType
                                WHERE sObjectType = 'Community_Giving__c'
                                AND Name = 'Community Development Grant'
                                LIMIT 1].id;

        Id floodRecordTypeId = [SELECT Id
                                FROM RecordType
                                WHERE sObjectType = 'Community_Giving__c'
                                AND Name = 'Flood Relief'
                                LIMIT 1].id;
        
        //List for Community Investment record insertion
        List<Community_Giving__c> newCommInvest = New List<Community_Giving__c>();
        for (FIC_Survey_Application__c qualApp : qualifiedFICSurveyApps) {
            
            
            // try catch if data quality if poor 
            try{
                
                if(qualApp.Conversion_Type__c == 'Donation') {
                    // Donation
                  Community_Giving__c commGiving = new Community_Giving__c(
                        Market__c = qualApp.Market__c,
                        Date_Requested__c = qualApp.createdDate.date(),
                        Non_Profit_Organization__c = qualApp.Non_Profit_Organization__c,
                        Request_Title__c = qualApp.Program_Event_Name__c,
                        Description__c = qualApp.Program_Event_Description__c,
                        Total_Request_Amount__c = qualApp.Amount_Requested__c,
                        Requesting_Org_s_Board_of_Directors__c = qualApp.Please_Provide_Board_of_Directors__c,
                        FNB_Employee_Board_Members__c = qualApp.Provide_Name_and_Service_Description__c,
                        Business_Relationship__c = qualApp.Please_Describe_Relationship__c,
                        Requestor_Name__c = qualApp.Person_Completing_This_Form__c,
                        Requestor_Email__c = qualApp.Person_Completing_This_Form_Email__c,
                        Purpose__c = qualApp.Organization_Community_Focus_Area__c,
                        Impacts__c = 'Estimated Attendance: ' + qualApp.Estimated_Attendance__c + 
                                                ' / ' + 'Media Opportunities: ' + qualApp.Media_Opportunities_del__c,
                        OwnerId = qualApp.Ownerid,
                        RecordTypeId = donationRecordTypeId,
                        FIC_Survey_Application__c = qualApp.Id,
                        Program_Event_Date__c = qualApp.Program_Event_Date__c);
                    
                    newCommInvest.add(commGiving); 
                }
              //DAG 03/28/2019 New section for Flood Relief type. 
                if(qualApp.Conversion_Type__c == 'Flood Relief') {
                    // Flood Relief
                  Community_Giving__c commGiving = new Community_Giving__c(
                        Market__c = qualApp.Market__c,
                        Date_Requested__c = qualApp.createdDate.date(),
                        Non_Profit_Organization__c = qualApp.Non_Profit_Organization__c,
                        Request_Title__c = qualApp.Program_Event_Name__c,
                        Description__c = qualApp.Program_Event_Description__c,
                        Total_Request_Amount__c = qualApp.Amount_Requested__c,
                        Requesting_Org_s_Board_of_Directors__c = qualApp.Please_Provide_Board_of_Directors__c,
                        FNB_Employee_Board_Members__c = qualApp.Provide_Name_and_Service_Description__c,
                        Requestor_Name__c = qualApp.Person_Completing_This_Form__c,
                        Requestor_Email__c = qualApp.Person_Completing_This_Form_Email__c,
                        Purpose__c = qualApp.Flood_Community_Focus_Area__c,
                        OwnerId = qualApp.Ownerid,
                        Annual_Independent_Audit__c = qualApp.Annual_Independent_Audit__c,
                        Flood_Anticipated_End_Date__c = qualApp.Flood_Anticipated_End_Date__c,
                        Flood_Collaborations__c = qualApp.Flood_Collaborations__c,
                        Flood_Community_Focus_Area__c = qualApp.Flood_Community_Focus_Area__c,
                        Flood_Counties_Served__c = qualApp.Flood_Counties_Served__c,
                        Flood_Describe_Impact__c = qualApp.Flood_Describe_Impact__c,
                        Flood_Describe_Track_Record__c = qualApp.Flood_Describe_Track_Record__c,
                        Flood_Describe_Outcomes__c = qualApp.Flood_Describe_Outcomes__c,
                        Flood_Funding_Use__c = qualApp.Flood_Funding_Use__c,
                        Flood_Volunteer_Opportunities__c = qualApp.Flood_Volunteer_Opportunities__c,
                        Flood_Long_Term_Recovery_Group__c = qualApp.Flood_Long_Term_Recovery_Group__c,
                        RecordTypeId = floodRecordTypeId,
                        FIC_Survey_Application__c = qualApp.Id,
                        Program_Event_Date__c = qualApp.Program_Event_Date__c);
                    
                    newCommInvest.add(commGiving); 
                }
                
                if(qualApp.Conversion_Type__c == 'Sponsorship') {
                    // Sponsorship 
                   Community_Giving__c commGiving = new Community_Giving__c(
                        Market__c = qualApp.Market__c,
                        Date_Requested__c = qualApp.createdDate.date(),
                        Non_Profit_Organization__c = qualApp.Non_Profit_Organization__c,
                        Request_Title__c = qualApp.Program_Event_Name__c,
                        Partnership_Description__c = qualApp.Program_Event_Description__c,
                        Total_Request_Amount__c = qualApp.Amount_Requested__c,
                        Employee_Sponsor__c = qualApp.Provide_Name_and_Service_Description__c,
                        Purpose__c = qualApp.Organization_Community_Focus_Area__c,
                        Organization_Program__c = 'Briefly describe the community issue your organization is working to address: ' +
                                                   qualApp.Briefly_Describe_Community_Issue__c + ' / ' +
                                                  'Briefly describe the success of your organization in addressing the stated community issue, citing specific organizational outcomes and community outcomes (what results did your organization realize, and what difference did it make in the community): '
                                                   + qualApp.Briefly_Describe_Community_Success__c,
                        Impacts__c = qualApp.Briefly_Describe_Funds__c,
                        Other_Notes__c = 'Estimated Attendance: ' + qualApp.Estimated_Attendance__c + 
                                                ' / ' + 'Media Opportunities: ' + qualApp.Media_Opportunities_del__c,
                        OwnerId = qualApp.Ownerid,
                        RecordTypeId = sponsorshipRecordTypeId,
                        FIC_Survey_Application__c = qualApp.Id,
                        Program_Event_Date__c = qualApp.Program_Event_Date__c);
                    
                    newCommInvest.add(commGiving);
                }
                
                if(qualApp.Conversion_Type__c == 'Grant') {
                    // Grant
                   
                    List<String> purposeList = new List<String>();
                    
                    if(qualApp.G_Educated_Workforce__c == True) {
                       purposeList.add('Educated Workforce'); 
                    }
                    if(qualApp.G_Stable_Housing__c == True) {
                       purposeList.add('Stable Housing');
                    }
                    if(qualApp.G_Strong_Local_Economies__c == True) {
                       purposeList.add('Strong Local Economies');
                    }
                    if(qualApp.G_Neighborhood_Revitalization__c == True) {
                       purposeList.add('Neighborhood Revitalization');
                    }
                    
                    string purposeString = String.join(purposeList,',');
                    
                    // Question 15 table
                    string primaryBeneficiary = 'null';
                    string fundingYesNoTable = 'A. Does the program for which you are requesting funding primarily serve youth?: ' + qualApp.G_Funding_Primarily_Serve_Youth__c + '\n' +
                                               'B. Do you track Medicaid eligibility for program participants?: ' + qualApp.G_Medicaid_Eligibility_for_Program__c + '\n' +
                                               'C. Does your program have income thresholds to be eligible for program participation?: ' + qualApp.G_Income_Thresholds_to_be_Eligible__c + '\n' +
                                               'D. Is your program or organization targeted to individuals or families within a close geographical radius of the organization’s location?: '
                                                + qualApp.G_Geographical_Radius_of_Organization__c + '\n' + 
                                               'E. Are you requesting funds to support technical assistance, training, development, or financing of small businesses or small farms?: ' 
                                                + qualApp.G_Small_Businesses_or_Small_Farms__c + '\n' + 
                                               'F. Are you requesting funds to support the revitalization and stabilization of a low or moderate income neighborhood?: '
                                                + qualApp.G_Low_or_Moderate_Income_Neighborhood__c + '\n' + 
                                               'G. Do you track income information of clients served?: ' + qualApp.G_Track_Income_Information__c + '\n' + '\n' + '\n';
                   
                    string lowPrimaryBen = '\n';
                    
                    if(qualApp.G_Eligible_for_Free_and_Reduced_Lunch__c != null) {
                        lowPrimaryBen = 'A. What percentage of youth served are eligible for Free and Reduced lunch?: ' + '\n' + qualApp.G_Eligible_for_Free_and_Reduced_Lunch__c + '\n' + '\n';
                    }
                    if(qualApp.G_Schools_Free_and_Reduced_Lunch__c != null) {
                        lowPrimaryBen = lowPrimaryBen + 'A. List the school(s) that youth participating in your programming attend, and include Free and Reduced Lunch percentages for each: ' + '\n' + qualApp.G_Schools_Free_and_Reduced_Lunch__c +'\n' + '\n';
                    }
                    if(qualApp.G_Eligible_for_Medicaid__c != null) {
                        lowPrimaryBen = lowPrimaryBen + 'B. What percentage of program beneficiaries are eligible for Medicaid?: ' + '\n' + qualApp.G_Eligible_for_Medicaid__c + '\n' + '\n';
                    }
                    if(qualApp.G_Provide_Income_Thresholds_and_Relate__c != null) {
                        lowPrimaryBen = lowPrimaryBen + 'C. Provide income thresholds and relate them to the figure in Box B. Your response should follow this example: To be eligible for [Insert Program Name], incomes cannot exceed [Insert Income Threshold], which is [XX% - Divide threshold by Box B] of the median family income for the [Insert MSA from Box A] area: ' + '\n' + qualApp.G_Provide_Income_Thresholds_and_Relate__c +'\n' + '\n';
                    }
                    if(qualApp.G_Address_of_Services_or_Activities__c != null) {
                        lowPrimaryBen = lowPrimaryBen + 'D. Provide the address where the services or activities will occur: ' + '\n' + qualApp.G_Address_of_Services_or_Activities__c + '\n' + '\n';
                    }
                    if(qualApp.G_Family_Income_of_the_areas_where_servi__c != null) {
                        lowPrimaryBen = lowPrimaryBen + 'D. The Median Family Income of the areas where services will occur, reported as BOTH a dollar value and as a percentage of Median Family Income. If you are targeting multiple areas, provide all locations. Your response should follow this example: This program/service is located in the following area(s): [List all addresses]. Median Family Income for this area is: [list Median Family Income for each area], which is [XX%] of the Median Family Income for [MSA found in box A or Appendix A that corresponds with the address you provided above]: ' + '\n' + qualApp.G_Family_Income_of_the_areas_where_servi__c +' \n'+ '\n';
                    }
                    if(qualApp.G_Annual_revenues_under_one_million__c != null) {
                        lowPrimaryBen = lowPrimaryBen + 'E. What percentage of businesses served have annual revenues under one million?: ' + '\n' + qualApp.G_Annual_revenues_under_one_million__c +' \n' + '\n';
                    }
                    if(qualApp.G_Demographic_information_on_the_bus__c != null) {
                        lowPrimaryBen = lowPrimaryBen + 'E. Provide demographic information on the businesses you serve: ' + '\n' + qualApp.G_Demographic_information_on_the_bus__c +' \n' + '\n';
                    }
                    if(qualApp.G_Average_wage_of_jobs_created__c != null) {
                        lowPrimaryBen = lowPrimaryBen + 'E. What is the average wage of jobs created by your program?: ' + '\n' + qualApp.G_Average_wage_of_jobs_created__c +' \n'+ '\n';
                    }
                    if(qualApp.G_Average_wage_relate_Median_Family_Inc__c != null) {
                        lowPrimaryBen = lowPrimaryBen + 'E. How does the average wage of jobs created by your program relate to the Median Family Income? Divide average wage by the figure in box B. Your response should follow this example: The average wage of jobs created by [program/organization] is $[Average Wage], which is [XX]% of the median family income for the [box A area]: ' + '\n' + qualApp.G_Average_wage_relate_Median_Family_Inc__c +' \n' + '\n';
                    }
                    if(qualApp.G_Address_of_the_project_center__c != null) {
                        lowPrimaryBen = lowPrimaryBen + 'F. Provide an address of the project or activity center and how the activity will attract or retain businesses and/or residents to the area. If the project or activity is consistent with a federal, state, local government or other community development plan, reference the plan and provide a description of how the proposed activity is aligned with the plan. If a map is available, attach it as a supplemental document: ' + '\n' + qualApp.G_Address_of_the_project_center__c +' \n' + '\n';
                    }
                    if(qualApp.G_Program_ben_incomes_at_or_below__c != null) {
                        lowPrimaryBen = lowPrimaryBen + 'G. Indicate what percentage of program beneficiaries earn incomes at or below the income listed in question 14 Box C. Your response should follow this format: [XX]% of individuals served by [Program] earn at or below 80% of the median family income for the [Box A] area, which is [Box C]: ' + '\n' + qualApp.G_Program_ben_incomes_at_or_below__c +' \n' + '\n';
                    }
                    if(qualApp.Q_Collect_and_Verify_Beneficiary_Income__c != null) {
                        lowPrimaryBen = lowPrimaryBen + 'How do you collect and verify beneficiary income data?: ' + '\n' + qualApp.Q_Collect_and_Verify_Beneficiary_Income__c +' \n' + '\n';
                    }
                    
                    primaryBeneficiary = fundingYesNoTable + lowPrimaryBen;
                        
                   Community_Giving__c commGiving = new Community_Giving__c(
                       
                       Non_Profit_Organization__c = qualApp.Non_Profit_Organization__c,
                       OwnerId = qualApp.Ownerid,
                       RecordTypeId = grantRecordTypeId,
                       FIC_Survey_Application__c = qualApp.Id,
                       Application_Received__c = qualApp.createdDate.date(),
                       Executive_Director_Name__c = qualApp.Executive_Director__c,
                       Executive_Director_Email__c = qualApp.Executive_Director_Email_Address__c,
                       Grant_Contact_Name__c = qualApp.Grant_Contact_Name__c,
                       Grant_Contact_Email__c = qualApp.Grant_Contact_Email__c,
                       Social_Media_Info__c = 'Organization Facebook Page URL: ' + qualApp.G_Organization_Facebook__c + '\n' +
                                              'Organization Twitter Handle: ' + qualApp.G_Organization_Twitter_Handle__c + '\n' +
                                              'Organization Instagram Handle: ' + qualApp.G_Organization_Instagram_Handle__c + '\n' +
                                              'Other Organization Social Media Accounts: ' + qualApp.G_Other_Social_Media_Accounts__c,
                       FNB_Service__c = qualApp.Provide_Name_and_Service_Description__c,
                       FNB_Business_Relationship__c= qualApp.Please_Describe_Relationship__c,
                       Request_Title__c = qualApp.Program_Event_Name__c,
                       Brief_Program_Description__c = qualApp.Program_Event_Description__c,
                       Total_Request_Amount__c = qualApp.Amount_Requested__c,
                       Primary_County_Served__c = qualApp.G_Primary_County_Served__c,
                       Secondary_County_Served__c = qualApp.G_Secondary_County_Served__c,
                       Purpose__c = purposeString,
                       Program_Objectives__c = qualApp.G_Program_Implementation_History__c,
                       Housing_Units_Created_Built__c = qualApp.G_Program_Housing_Units_Created__c,
                       Number_of_Housing_Units_Rehab_Renov__c = qualApp.G_Program_Housing_Units_Rehab_Renov__c,
                       Homeownership_Educ_Sessions__c = qualApp.G_Program_Homeownership_Education_Ses__c,
                       Housing_Units_Financed__c = qualApp.G_Program_Housing_Units_Financed__c,
                       Individuals_Rec_Homeownership_Educ__c = qualApp.G_Program_Ind_Rec_Homeownership_Educ__c,
                       Individuals_Served_in_Prop_Program__c = qualApp.G_Program_Individuals_Served__c,
                       Adults_Provided_Education__c = qualApp.G_Program_Adults_Provided_Education__c,
                       Adults_Provided_Vocational_Training__c = qualApp.G_Program_Adults_Provided_Vocational__c,
                       Youth_Provided_Work_Career_Educ__c = qualApp.G_Program_Youth_Provided_Workforce_Caree__c,
                       Youth_Provided_Voc_Train_Work_Dev__c = qualApp.G_Program_Youth_Provided_Vocational__c,
                       Small_Businesses_Assisted__c = qualApp.G_Program_Small_Businesses_Assisted__c,
                       New_Businesses_Served__c = qualApp.G_Program_New_Businesses_Served__c,
                       Workshops_Training_Events_Provided__c = qualApp.G_Program_Workshops_and_Training_events__c,
                       Indiv_Coaching_Sessions_w_Small_Bus__c = qualApp.G_Program_Individual_Coaching_Sessions__c,
                       Jobs_Created_Full_Time__c = qualApp.G_Program_Jobs_Created_Full_Time__c,
                       Jobs_Created_Part_Time__c = qualApp.G_Program_Jobs_Created_Part_Time__c,
                       Jobs_Retained__c = qualApp.G_Program_Jobs_Retained__c,
                       Strategy_Description__c = qualApp.G_Describe_Grant_Funding_Use__c,
                       Community_Need_and_Strategy_to_Address__c = 'Describe the community need you are seeking to address, citing data and statistics if applicable: ' 
                                                                    + qualApp.G_Community_Need__c + '\n' + 'Describe how your program and strategy will address the community need articulated: ' + qualApp.G_Strategy_Address_Community_Need__c,
                       
                       Sustainability_Plan__c = qualApp.G_Plans_to_Sustain_This_Program__c,
                       Impact_Measurement__c = qualApp.G_Measure_Long_Term_Imp_Out__c,
                       EBP_and_Collaboration__c = 'Detail collaborations with other organizations that directly relate to the program for which you are requesting funding. How do those collaborations enhance your program?: ' + qualApp.G_Collab_Enhance_Your_Program__c + '\n' +
                                                  'Identify evidence-based practices utilized in the implementation of the program/service/initiative for which you are requesting funding: ' + qualApp.G_Evidence_Based_Practices_Utilized__c,
                       Program_Government_Contracts_Grants__c = qualApp.G_Program_Government_Contracts_Grants__c,
                       Program_Individual_Contributions_Grants__c = qualApp.G_Program_Individual_Contributions_Grant__c,
                       Program_Corporate_Cont_Grants_Fees__c = qualApp.G_Program_Corporate_Cont_Grants_Fees__c,
                       Program_Foundation_Cont_Grants_Fees__c = qualApp.G_Program_Foundation_Cont_Grants_Fees__c,
                       Program_Membership_Dues_Fees__c = qualApp.G_Program_Membership_dues_fees__c,
                       Program_Investment_Interest_Tax_Rev__c = qualApp.G_Program_Investment_Interest_Tax_Rev__c,
                       Program_Earned_Revenue__c = qualApp.G_Program_Earned_Revenue__c,
                       Program_United_Way__c = qualApp.G_Program_United_Way__c,
                       Program_Other__c = qualApp.G_Program_Other__c,
                       Org_Government_Contracts_Grants__c = qualApp.G_Org_Government_Contracts_Grants__c,
                       Org_Individual_Contributions_Grants__c = qualApp.G_Org_Individual_contributions_grants__c,
                       Org_Corporate_Cont_Grants_Fees__c = qualApp.G_Org_Corporate_Cont_Grants_Fees__c,
                       Org_Foundation_Cont_Grants_Fees__c = qualApp.G_Org_Foundation_Cont_Grants_Fees__c,
                       Org_Membership_Dues_Fees__c = qualApp.G_Org_Membership_Dues_Fees__c,
                       Org_Investment_Interest_Tax_Rev__c = qualApp.G_Org_Investment_Interest_Tax_Rev__c,
                       Org_Earned_Revenue__c = qualApp.G_Org_Earned_Revenue__c,
                       Org_United_Way__c = qualApp.G_Org_United_Way__c,
                       Org_Other__c = qualApp.G_Org_Other__c,
                       Volunteer_Opportunities__c = qualApp.G_Vol_Opportunities_for_Bank_Employees__c,
                       MSA_Name__c = qualApp.G_Box_A__c,
                       X100_MFI__c = qualApp.G_Box_B__c,
                       X80_MFI__c = qualApp.G_Box_C__c,
                       Primary_Beneficiary__c = primaryBeneficiary);
                    
                    newCommInvest.add(commGiving);
                }

            } catch (Exception e) {
                qualApp.addError (' Conversion processing failure. Please contact salesforcesupport@fnni.com for assistance.');          
            }
        } 
        //Insert list
        System.Debug(newCommInvest.size());
        insert newCommInvest;

    }
    
    public static void createAttachments (List<FIC_Survey_Application__c> qualifiedFICSurveyApps) {
        
        // Child attachments, limit at 9600 for DML sake (200 buffer)
        List<Attachment> attachmentsList = [SELECT Id, ParentId, body, contentType, description, isPrivate, name, ownerId
                                            FROM Attachment
                                            WHERE ParentId =: qualifiedFICSurveyApps
                                            LIMIT 9600];
        // New Attachments to be inserted
        List<Attachment> newAttachmentsList = new List<Attachment>();
        
        Map<Id, Id> parentCommInvest = New Map<Id, Id>();

        for(Community_Giving__c commGiving : [SELECT Id, FIC_Survey_Application__c
                                              FROM Community_Giving__c
                                              WHERE FIC_Survey_Application__c =: qualifiedFICSurveyApps
                                              LIMIT 10000]) {
            parentCommInvest.put(CommGiving.FIC_Survey_Application__c, commGiving.Id);

            }
        
        
        for(Attachment attach : attachmentsList) {

            Attachment newAttach = new Attachment(ParentId = parentCommInvest.get(attach.ParentId),
                                                  body = attach.body,
                                                  contentType = attach.contentType,
                                                  description = attach.description, 
                                                  // For Shield if ever neededed
                                                  //isEncrypted = attach.IsEncrypted,       
                                                  isPrivate = attach.isPrivate,                                         
                                                  name = attach.name,
                                                  ownerId = attach.ownerId);
            newAttachmentsList.add(newattach);
        }
        
        insert newAttachmentsList;
        
        // Finalize qualified apps to prevent double processing by user
        for(FIC_Survey_Application__c qualApp : qualifiedFICSurveyApps) {
            qualApp.Conversion__c = True;
            qualApp.Conversion_Date__c = date.today();
            qualApp.Community_Investment__c = parentCommInvest.get(qualApp.Id);
        }
          
    }
}