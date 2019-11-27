public with sharing class myOpenTasksController {
    @AuraEnabled 
    public static List<Task> getOpenTasks(String userId) {
        User currentUser = getCurrentUser(userId);
        System.debug('getOpenTasks() -- currentUser: ' + currentUser.Username);

        List<Task> openTasks = [SELECT ID, Subject, ActivityDate, WhatId, What.Name, WhoId, Who.Name FROM Task WHERE Ownerid = :currentUser.Id AND IsClosed = FALSE ORDER BY ActivityDate ASC LIMIT 5];
        System.debug('number of open tasks: ' + openTasks.size());
        
        return openTasks;
    }
    
    private static User getCurrentUser(String userId) {
        System.debug('getCurrentUser() -- userId: ' + userId);
        return [SELECT Id, Name, UserName FROM User WHERE Id = :userId LIMIT 1];
    }
}