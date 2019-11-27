@isTest
public class myOpenTasksController_Tests {
	@TestSetup
    static void SetupTestData() {
   		//a. get the System Admin profile
        Profile adminProfile = [Select Id from Profile WHERE Name=:'System Administrator'];

        //b. create a new UserRole
        UserRole customRole = new UserRole(Name = 'New Role');
        insert customRole;
        
        //c. create a new User
        User testUser = new User(
            LastName = 'TestSysAdmin', 
            Alias = 'alias', 
            Email = 'test.SysAdmin000@fnbo.com', 
            Username = 'test.SysAdmin000@fnbo.com', 
			CommunityNickname = 'test.SysAdmin000@fnbo.com',

            UserRoleId = customRole.Id,
            // User License
            ProfileId = adminProfile.Id,

            User_s_Market__c = 'Omaha', 
            Title = 'title', 
            
            EmailEncodingKey = 'ISO-8859-1', 
            TimeZoneSidKey = 'America/Chicago', 
            LanguageLocaleKey = 'en_US', 
            LocaleSidKey = 'en_US',
            
            IsActive = true
        ); 
        insert testUser;
    }

    @isTest
    static void getCurrentUser_TestOneOpenOneClosedTasks() {
        //public static List<Task> getOpenTasks(String userId) 
        // Assign...
        User testUser = [SELECT Id FROM User WHERE Username = 'test.SysAdmin000@fnbo.com'];
		// Add some tasks 
        System.runAs(testUser) {
        	List<Task> taskList = new List<Task>();       
			taskList.add(new Task(Priority = 'Normal', Subject = 'OpenTask01', Status = 'Scheduled', OwnerId = testUser.Id)); 
			taskList.add(new Task(Priority = 'Normal', Subject = 'ClosedTask01', Status = 'Completed', OwnerId = testUser.Id)); 
        	insert taskList; 
        }      
        Integer expectedNumberOfTasks = 1;
        
        // Act..
        List<Task> actual = myOpenTasksController.getOpenTasks(testUser.Id);
        
        // Assert..
		//while we added two tasks in the setup, only one is not closed
        System.assertEquals(expectedNumberOfTasks, actual.size());		
	}
    
    @isTest
    static void getCurrentUser_MoreThanFiveEligibleTasks() {
        //public static List<Task> getOpenTasks(String userId) 
        // Assign...
        User testUser = [SELECT Id FROM User WHERE Username = 'test.SysAdmin000@fnbo.com'];
		// Add some tasks 
        System.runAs(testUser) {
        	List<Task> taskList = new List<Task>();       
			taskList.add(new Task(Priority = 'Normal', Subject = 'OpenTask01', Status = 'Scheduled', OwnerId = testUser.Id)); 
			taskList.add(new Task(Priority = 'Normal', Subject = 'OpenTask02', Status = 'Scheduled', OwnerId = testUser.Id)); 
			taskList.add(new Task(Priority = 'Normal', Subject = 'OpenTask03', Status = 'Scheduled', OwnerId = testUser.Id)); 
			taskList.add(new Task(Priority = 'Normal', Subject = 'OpenTask04', Status = 'Scheduled', OwnerId = testUser.Id)); 
			taskList.add(new Task(Priority = 'Normal', Subject = 'OpenTask05', Status = 'Scheduled', OwnerId = testUser.Id)); 
			taskList.add(new Task(Priority = 'Normal', Subject = 'OpenTask06', Status = 'Scheduled', OwnerId = testUser.Id)); 
			taskList.add(new Task(Priority = 'Normal', Subject = 'OpenTask07', Status = 'Scheduled', OwnerId = testUser.Id)); 
			taskList.add(new Task(Priority = 'Normal', Subject = 'OpenTask08', Status = 'Scheduled', OwnerId = testUser.Id)); 
			taskList.add(new Task(Priority = 'Normal', Subject = 'OpenTask09', Status = 'Scheduled', OwnerId = testUser.Id)); 
			taskList.add(new Task(Priority = 'Normal', Subject = 'OpenTask10', Status = 'Scheduled', OwnerId = testUser.Id)); 
			taskList.add(new Task(Priority = 'Normal', Subject = 'ClosedTask01', Status = 'Completed', OwnerId = testUser.Id)); 
        	insert taskList; 
        }      
        Integer expectedNumberOfTasks = 5;
        
        // Act..
        List<Task> actual = myOpenTasksController.getOpenTasks(testUser.Id);
        
        // Assert..
		//while we added eleven tasks, only ten of them are not closed and the SOQL query should only return 5
        System.assertEquals(expectedNumberOfTasks, actual.size());		
	}
}