//
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2023 Billiyo Mac. All rights reserved.
//

import Foundation

class tblConversationList : SQLTable {
    var id : Int = -1
    var employeeConversationId : Int64 = 0
    var conversationId : String = ""
    var conversationName : String = ""
    var conversationImage : String = ""
    var lastMessageContent : String = ""
    var lastMessageTypeId : Int = 0
    var lastSenderEmployeeId : Int64 = 0
    var lastSenderFirstName : String = ""
    var messageDateTime : Int64 = 0
    var isAdmin : Bool = false
    var canAddEmployee : Bool = false
    var isGroup : Bool = false
    var isConnected : Bool = false
    var lastSeen : Int64 = 0
    var unreadCount : Int = 0
    var isConversationImageDownloaded : Bool = false
    var isDeleted : Bool = false
    var imageDownloadTryCount : Int = 0
    
    required init() {
        super.init()
    }
    
    func deleteAllRecord() -> Bool{
        if db.execute(sql: "DELETE from tblConversationList") != 0 {
            return true
        }else{
            return false
        }
    }
    
    func deleteConversation(employeeConversationId : Int64) -> Bool{
        if db.execute(sql: "DELETE FROM tblConversationList where employeeConversationId = '\(employeeConversationId)'") != 0 {
            return true
        }else{
            return false
        }
    }
    
    func getUniqueConversationId(conversationId : String, completion: @escaping(_ uniqueId : Int) -> Void) {
        let arrayId = tblConversationList.rowsFor(sql: "SELECT * from tblConversationList where conversationId = '\(conversationId)'")
        var uniqueID : Int = -1
        if arrayId.count > 0 {
            uniqueID = arrayId[0].id
            completion(uniqueID)
        }
        else{
            completion(uniqueID)
        }
    }
    
    func insertORUpdateConversationList(arrConversationListData : [[String : Any]], completion: @escaping( _ success: Bool) -> Void){
        for (index, eleConversationData) in arrConversationListData.enumerated() {
            self.getUniqueConversationId(conversationId: eleConversationData["conversationId"] as? String ?? "", completion: { uniqueId in
                var objConversationData : tblConversationList?
                
                if uniqueId == -1 {
                    objConversationData = tblConversationList()
                }
                else{
                    objConversationData = tblConversationList.rowBy(id: uniqueId)
                    objConversationData!.id = Int(uniqueId)
                }
                
                if objConversationData != nil {
                    if eleConversationData["conversationImage"] as? String ?? "" != ""{
                        if MessageManager.shared.checkFileExist(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: eleConversationData["conversationImage"] as? String ?? ""){
                            objConversationData!.isConversationImageDownloaded = true
                        }
                        else{
                            objConversationData!.isConversationImageDownloaded = false
                        }
                    }
                    else{
                        objConversationData!.isConversationImageDownloaded = false
                    }
                    
                    objConversationData!.employeeConversationId = eleConversationData["employeeConversationId"] as? Int64 ?? 0
                    objConversationData!.conversationId = eleConversationData["conversationId"] as? String ?? ""
                    objConversationData!.conversationName = eleConversationData["conversationName"] as? String ?? ""
                    objConversationData!.conversationImage = eleConversationData["conversationImage"] as? String ?? ""
                    objConversationData!.lastMessageContent = eleConversationData["lastMessageContent"] as? String ?? ""
                    objConversationData!.lastMessageTypeId = eleConversationData["lastMessageTypeId"] as? Int ?? 0
                    objConversationData!.lastSenderEmployeeId = eleConversationData["lastSenderEmployeeId"] as? Int64 ?? 0
                    objConversationData!.lastSenderFirstName = eleConversationData["lastSenderFirstName"] as? String ?? ""
                    objConversationData!.messageDateTime = eleConversationData["messageDateTime"] as? Int64 ?? 0
                    objConversationData!.isAdmin = eleConversationData["isAdmin"] as? Bool ?? false
                    objConversationData!.canAddEmployee = eleConversationData["canAddEmployee"] as? Bool ?? false
                    objConversationData!.isGroup = eleConversationData["isGroup"] as? Bool ?? false
                    objConversationData!.isConnected = eleConversationData["isConnected"] as? Bool ?? false
                    objConversationData!.lastSeen = eleConversationData["lastSeen"] as? Int64 ?? 0
                    objConversationData!.unreadCount = Int(eleConversationData["unreadCount"] as? Int ?? 0)
                    objConversationData!.isDeleted = eleConversationData["isDeleted"] as? Bool ?? false
                    
                    let _ = objConversationData!.save()
                    
                    if index == arrConversationListData.count - 1{
                        completion(true)
                    }
                }
                else{
                    if index == arrConversationListData.count - 1{
                        completion(true)
                    }
                }
            })
        }
    }
    
    func setConversationImageDownloadedStatus(isConversationImageDownloaded : Int, conversationId : String) -> Bool{
        if db.execute(sql: "Update tblConversationList SET isConversationImageDownloaded = '\(isConversationImageDownloaded)' where conversationId = '\(conversationId)'") != 0 {
            return true
        }else{
            return false
        }
    }
    
    func setImageDownloadTryCount(imageDownloadTryCount : Int, conversationId : String) -> Bool{
        if db.execute(sql: "Update tblConversationList SET imageDownloadTryCount = '\(imageDownloadTryCount)' where conversationId = '\(conversationId)'") != 0 {
            return true
        }else{
            return false
        }
    }
    
    func setUnreadCount(unreadCount : Int, conversationId : String) -> Bool{
        if db.execute(sql: "Update tblConversationList SET unreadCount = '\(unreadCount)' where conversationId = '\(conversationId)'") != 0 {
            return true
        }else{
            return false
        }
    }
    
    func setGroupInfoUpdate(conversationName : String, conversationImageName : String, employeeConversationId : Int64) -> Bool{
        if db.execute(sql: "Update tblConversationList SET conversationName = '\(conversationName)', conversationImage = '\(conversationImageName)' where employeeConversationId = '\(employeeConversationId)'") != 0 {
            return true
        }else{
            return false
        }
    }
    
    
    func getUnreadMessageConversationCount(completion: @escaping( _ unReadConversationCount: Int) -> Void){
        
        let unReadCountQuery = "SELECT COUNT(*) as unReadConversationCount FROM tblConversationList WHERE unreadCount != '\(0)'"
        
        let resultArray = MessageManager.shared.db.query(sql:unReadCountQuery)
        var unReadConversationCount : Int = 0
        if resultArray.count > 0 {
            unReadConversationCount = resultArray[0]["unReadConversationCount"] as? Int ?? 0
            completion(unReadConversationCount)
        }
        else{
            completion(unReadConversationCount)
        }

    }
    
    
}
