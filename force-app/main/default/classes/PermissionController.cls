public without sharing class PermissionController {

    Map<Id, Id> permSetProfileMap = new Map<Id, Id>() ;
    Map<Id, String> profileMap = new Map<Id, String>();
     
    List<ObjectPermissions> profileObjectPermList = new  List<ObjectPermissions>();
    
    public List<Permission__c> permissions = new List<Permission__c>();
    
    public List<Permission__c> getPermissions() {
        return permissions;
    }

    public PermissionController() {
        populatePermissionList();
    }

    public void populatePermissionList() {

        For(PermissionSet ps : [SELECT Id, ProfileId 
                                FROM PermissionSet 
                                WHERE IsOwnedbyProfile = TRUE]) {              
            permSetProfileMap.put(ps.id, ps.ProfileId);
        }  
            
        For(ObjectPermissions op : [SELECT id, ParentId, PermissionsCreate, PermissionsRead, PermissionsEdit,
                                    PermissionsDelete, PermissionsViewAllRecords, PermissionsModifyAllRecords, SobjectType 
                                    FROM ObjectPermissions 
                                    WHERE ParentId
                                    IN: permSetProfileMap.keySet()]) {                
            profileObjectPermList.add(op);
        }
            
        For(Profile p : [SELECT Id, Name FROM Profile]) {              
            profileMap.put(p.id, p.Name);
        }           

        For (ObjectPermissions op: profileObjectPermList) {
            Permission__c permission = new Permission__c();
                      
            if (profileMap.containsKey(permSetProfileMap.get(op.parentId))) {
                permission.id__c = permSetProfileMap.get(op.parentId); 
                permission.profile__c = profileMap.get(permission.id__c);         
                permission.obj__c = op.sObjectType;
                permission.create__c = op.PermissionsCreate;
                permission.read__c = op.PermissionsRead;
                permission.edit__c = op.PermissionsEdit;
                permission.delete__c = op.PermissionsDelete;
                permission.viewAll__c = op.PermissionsViewAllRecords;
                permission.modifyAll__c = op.PermissionsModifyAllRecords;
                
                permissions.add(permission); 
             }
        }
    }
}