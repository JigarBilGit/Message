//
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2023 Billiyo Mac. All rights reserved.
//

import Foundation

class tblUserList : SQLTable {
    var id : Int = -1
    var employeeConversationId : Int64 = 0
    var employeeId : Int64 = 0
    var firstName : String = ""
    var middleName : String = ""
    var lastName : String = ""
    var profilePicture : String = ""
    var isAdmin : Bool = false
    var isDeleted : Bool = false
    var canAddEmployee : Bool = false
    
    required init() {
        super.init()
    }
    
    func deleteAllRecord() -> Bool{
        if db.execute(sql: "DELETE from tblUserList") != 0 {
            return true
        }else{
            return false
        }
    }
    
    func getUniqueEmployeeId(employeeId : Int64, employeeConversationId : Int64, completion: @escaping(_ uniqueId : Int) -> Void) {
        let arrayId = tblUserList.rowsFor(sql: "SELECT * from tblUserList where employeeId = '\(employeeId)' AND employeeConversationId = '\(employeeConversationId)'")
        var uniqueID : Int = -1
        if arrayId.count > 0 {
            uniqueID = arrayId[0].id
            completion(uniqueID)
        }
        else{
            completion(uniqueID)
        }
    }
    
    func insertORUpdateUserList(arrUserListData : [[String : Any]], completion: @escaping( _ success: Bool) -> Void){
        for (index, eleUserData) in arrUserListData.enumerated() {
            self.getUniqueEmployeeId(employeeId: eleUserData["employeeId"] as? Int64 ?? 0, employeeConversationId: eleUserData["employeeConversationId"] as? Int64 ?? 0, completion: { uniqueId in
                var objUserData : tblUserList?
                
                if uniqueId == -1 {
                    objUserData = tblUserList()
                }
                else{
                    objUserData = tblUserList.rowBy(id: uniqueId)
                    objUserData!.id = Int(uniqueId)
                }
                
                if objUserData != nil {
                    
                    objUserData!.employeeConversationId = eleUserData["employeeConversationId"] as? Int64 ?? 0
                    objUserData!.employeeId = eleUserData["employeeId"] as? Int64 ?? 0
                    objUserData!.firstName = eleUserData["firstName"] as? String ?? ""
                    objUserData!.middleName = eleUserData["middleName"] as? String ?? ""
                    objUserData!.lastName = eleUserData["lastName"] as? String ?? ""
                    objUserData!.profilePicture = eleUserData["profilePicture"] as? String ?? ""
                    objUserData!.isAdmin = eleUserData["isAdmin"] as? Bool ?? false
                    objUserData!.isDeleted = eleUserData["isDeleted"] as? Bool ?? false
                    objUserData!.canAddEmployee = eleUserData["canAddEmployee"] as? Bool ?? false
                    
                    let _ = objUserData!.save()
                    
                    if index == arrUserListData.count - 1{
                        completion(true)
                    }
                }
                else{
                    if index == arrUserListData.count - 1{
                        completion(true)
                    }
                }
            })
        }
    }
    
    func strUserListQuery() -> String {
        return "SELECT tu.employeeConversationId, tu.employeeId, tu.isAdmin, tu.canAddEmployee, te.firstName as firstName, te.middleName as middleName, te.lastName as lastName, te.photo as profilePicture"
            + " FROM tblUserList as tu"
            + " INNER JOIN tblEmployees as te on tu.employeeId = te.employeeId"
    }
    
    func setAdminState(isAdmin : Int, employeeId : Int64, employeeConversationId : Int64) -> Bool{
        if db.execute(sql: "Update tblUserList SET isAdmin = '\(isAdmin)' where employeeId = '\(employeeId)' AND employeeConversationId = '\(employeeConversationId)'") != 0 {
            return true
        }else{
            return false
        }
    }
    
    func setDeletedState(isDeleted : Int, employeeId : Int64, employeeConversationId : Int64) -> Bool{
        if db.execute(sql: "Update tblUserList SET isDeleted = '\(isDeleted)' where employeeId = '\(employeeId)' AND employeeConversationId = '\(employeeConversationId)'") != 0 {
            return true
        }else{
            return false
        }
    }
}
