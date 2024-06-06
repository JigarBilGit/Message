//
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2023 Billiyo Mac. All rights reserved.
//

import Foundation

class tblMessages : SQLTable {
    var id : Int = -1
    var conversationMessageId : Int64 = 0
    var conversationId : String = ""
    var employeeConversationId : Int64 = 0
    var messageTypeId : Int = 0
    var messageContent : String = ""
    var messageAttachment : String = ""
    var messageDateTime : Int64 = 0
    var replyMessageId : Int64 = 0
    var forwardMessageId : Int64 = 0
    var senderEmployeeId : Int64 = 0
    var mobilePrimaryKey : String = ""
    var addedBy : Int64 = 0
    var addedOn : Int64 = 0
    var isDeleted : Bool = false
    var firstName : String = ""
    var middleName : String = ""
    var lastName : String = ""
    var photo : String = ""
    var isSyncData : Bool = false
    var isUpdatedData : Bool = false
    var messageDate : Int64 = 0
    var isTimeVisible : Bool = false
    var isDownloading : Bool = false
    var uploadingStatus : Int = 0
    
    required init() {
        super.init()
    }
    
    func deleteAllRecord() -> Bool{
        if db.execute(sql: "DELETE from tblMessages") != 0 {
            return true
        }else{
            return false
        }
    }
    
    func deleteMessage(employeeConversationId : Int64) -> Bool{
        if db.execute(sql: "DELETE FROM tblMessages where employeeConversationId = '\(employeeConversationId)'") != 0 {
            return true
        }else{
            return false
        }
    }
    
    func deleteMessage(mobilePrimaryKey : String) -> Bool{
        if db.execute(sql: "DELETE FROM tblMessages where mobilePrimaryKey = '\(mobilePrimaryKey)'") != 0 {
            return true
        }else{
            return false
        }
    }
    
    func updateDownloadingFlag(isDownloading : Int, conversationMessageId : Int64) -> Bool{
        if db.execute(sql: "Update tblMessages SET isDownloading = '\(isDownloading)' where conversationMessageId = '\(conversationMessageId)'") != 0 {
            return true
        }else{
            return false
        }
    }
    
    func updateDownloadingFlagForFullConversation(isDownloading : Int, employeeConversationId : Int64) -> Bool{
        if db.execute(sql: "Update tblMessages SET isDownloading = '\(isDownloading)' where employeeConversationId = '\(employeeConversationId)'") != 0 {
            return true
        }else{
            return false
        }
    }
    
    func updateDeleteFlagForMessage(isDeleted : Int, employeeConversationId : Int64, conversationMessageId : Int64) -> Bool{
        if db.execute(sql: "Update tblMessages SET isDeleted = '\(isDeleted)' where employeeConversationId = '\(employeeConversationId)' AND conversationMessageId = '\(conversationMessageId)'") != 0 {
            return true
        }else{
            return false
        }
    }
    
    func updateUploadingStatusForMessage(uploadingStatus : Int, employeeConversationId : Int64, conversationMessageId : Int64, mobilePrimaryKey : String) -> Bool{
        if db.execute(sql: "Update tblMessages SET uploadingStatus = '\(uploadingStatus)' where employeeConversationId = '\(employeeConversationId)' AND conversationMessageId = '\(conversationMessageId)' AND mobilePrimaryKey = '\(mobilePrimaryKey)'") != 0 {
            return true
        }else{
            return false
        }
    }
    
    func getUniqueMessageId(conversationMessageId : Int64, mobilePrimaryKey : String, completion: @escaping(_ uniqueId : Int) -> Void) {
        let arrayId = tblMessages.rowsFor(sql: "SELECT * from tblMessages where conversationMessageId = '\(conversationMessageId)' OR mobilePrimaryKey = '\(mobilePrimaryKey)'")
        var uniqueID : Int = -1
        if arrayId.count > 0 {
            uniqueID = arrayId[0].id
            completion(uniqueID)
        }
        else{
            completion(uniqueID)
        }
    }
    
    func insertORUpdateMessages(arrMessagesData : [[String : Any]], completion: @escaping( _ success: Bool) -> Void){
        for (index, eleMessageData) in arrMessagesData.enumerated() {
            self.getUniqueMessageId(conversationMessageId: eleMessageData["conversationMessageId"] as? Int64 ?? 0, mobilePrimaryKey: eleMessageData["mobilePrimaryKey"] as? String ?? "", completion: { uniqueId in
                var objMessageData : tblMessages?
                
                if uniqueId == -1 {
                    objMessageData = tblMessages()
                }
                else{
                    objMessageData = tblMessages.rowBy(id: uniqueId)
                    objMessageData!.id = Int(uniqueId)
                }
                
                if objMessageData != nil {
                    
                    objMessageData!.conversationMessageId = eleMessageData["conversationMessageId"] as? Int64 ?? 0
                    objMessageData!.conversationId = eleMessageData["conversationId"] as? String ?? ""
                    objMessageData!.employeeConversationId = eleMessageData["employeeConversationId"] as? Int64 ?? 0
                    objMessageData!.messageTypeId = eleMessageData["messageTypeId"] as? Int ?? 0
                    objMessageData!.messageContent = eleMessageData["messageContent"] as? String ?? ""
                    objMessageData!.messageAttachment = eleMessageData["messageAttachment"] as? String ?? ""
                    objMessageData!.messageDateTime = eleMessageData["messageDateTime"] as? Int64 ?? 0
                    objMessageData!.replyMessageId = eleMessageData["replyMessageId"] as? Int64 ?? 0
                    objMessageData!.forwardMessageId = eleMessageData["forwardMessageId"] as? Int64 ?? 0
                    objMessageData!.senderEmployeeId = eleMessageData["senderEmployeeId"] as? Int64 ?? 0
                    objMessageData!.mobilePrimaryKey = eleMessageData["mobilePrimaryKey"] as? String ?? ""
                    objMessageData!.addedBy = eleMessageData["addedBy"] as? Int64 ?? 0
                    objMessageData!.addedOn = eleMessageData["addedOn"] as? Int64 ?? 0
                    objMessageData!.isDeleted = eleMessageData["isDeleted"] as? Bool ?? false
                    objMessageData!.firstName = ""
                    objMessageData!.middleName = ""
                    objMessageData!.lastName = ""
                    objMessageData!.photo = ""
                    objMessageData!.isSyncData = true
                    objMessageData!.isUpdatedData = false
                    objMessageData!.uploadingStatus = UploadingStatus.Uploaded.rawValue
                    objMessageData!.messageDate = MessageManager.shared.getCurrentTimeStampMMDDYYYYFrom2(strDate: MessageManager.shared.dateFormatterCurrentMMDDYYYY().string(from: MessageManager.shared.getCurrentZoneDate(timestamp:  eleMessageData["messageDateTime"] as? Int64 ?? 0)))
                    
                    let _ = objMessageData!.save()
                    
                    if index == arrMessagesData.count - 1{
                        completion(true)
                    }
                }
                else{
                    if index == arrMessagesData.count - 1{
                        completion(true)
                    }
                }
            })
        }
    }
    
    func insertORUpdateSingleMessage(messagesData : [String : Any], completion: @escaping( _ success: Bool) -> Void){
        self.getUniqueMessageId(conversationMessageId: messagesData["conversationMessageId"] as? Int64 ?? 0, mobilePrimaryKey: messagesData["mobilePrimaryKey"] as? String ?? "", completion: { uniqueId in
            var objMessageData : tblMessages?
            
            if uniqueId == -1 {
                objMessageData = tblMessages()
            }
            else{
                objMessageData = tblMessages.rowBy(id: uniqueId)
                objMessageData!.id = Int(uniqueId)
            }
            
            if objMessageData != nil {
                objMessageData!.conversationMessageId = messagesData["conversationMessageId"] as? Int64 ?? 0
                objMessageData!.conversationId = messagesData["conversationId"] as? String ?? ""
                objMessageData!.employeeConversationId = messagesData["employeeConversationId"] as? Int64 ?? 0
                objMessageData!.messageTypeId = messagesData["messageTypeId"] as? Int ?? 0
                objMessageData!.messageContent = messagesData["messageContent"] as? String ?? ""
                objMessageData!.messageAttachment = messagesData["messageAttachment"] as? String ?? ""
                objMessageData!.messageDateTime = messagesData["messageDateTime"] as? Int64 ?? 0
                objMessageData!.replyMessageId = messagesData["replyMessageId"] as? Int64 ?? 0
                objMessageData!.forwardMessageId = messagesData["forwardMessageId"] as? Int64 ?? 0
                objMessageData!.senderEmployeeId = messagesData["senderEmployeeId"] as? Int64 ?? 0
                objMessageData!.mobilePrimaryKey = messagesData["mobilePrimaryKey"] as? String ?? ""
                objMessageData!.addedBy = messagesData["addedBy"] as? Int64 ?? 0
                objMessageData!.addedOn = messagesData["addedOn"] as? Int64 ?? 0
                objMessageData!.isDeleted = messagesData["isDeleted"] as? Bool ?? false
                objMessageData!.firstName = ""
                objMessageData!.middleName = ""
                objMessageData!.lastName = ""
                objMessageData!.photo = ""
                objMessageData!.isSyncData = true
                objMessageData!.isUpdatedData = false
                objMessageData!.uploadingStatus = UploadingStatus.Uploaded.rawValue
                objMessageData!.messageDate = MessageManager.shared.getCurrentTimeStampMMDDYYYYFrom2(strDate: MessageManager.shared.dateFormatterCurrentMMDDYYYY().string(from: MessageManager.shared.getCurrentZoneDate(timestamp:  messagesData["messageDateTime"] as? Int64 ?? 0)))
                
                let _ = objMessageData!.save()
                
                completion(true)
            }
            else{
                completion(true)
            }
        })
    }
    
    func strMessageQuery() -> String {
        return "SELECT tm.conversationMessageId, tm.conversationId, tm.employeeConversationId, tm.messageTypeId, tm.messageContent, tm.messageAttachment, tm.messageDateTime, tm.senderEmployeeId, tm.mobilePrimaryKey, tm.addedBy, tm.addedOn, tm.messageDate, tm.isTimeVisible, tm.isDownloading, tm.isDeleted, tm.replyMessageId, tm.forwardMessageId, tm.uploadingStatus, te.firstName as firstName, te.middleName as middleName, te.lastName as lastName, te.photo as photo"
            + " FROM tblMessages as tm"
            + " LEFT JOIN tblEmployees as te on tm.senderEmployeeId = te.employeeId"
    }
}
