//
//  tblMessageReceipts.swift
//  BilliyoCommunication
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2023 Billiyo Mac. All rights reserved.
//

import Foundation

class tblMessageReceipts : SQLTable {
    var id : Int = -1
    var conversationMessageId : Int64 = 0
    var employeeId : Int64 = 0
    var isDelivered : Bool = false
    var isReceived : Bool = false
    var isRead : Bool = false
    var addedOn : Int64 = 0
    
    required init() {
        super.init()
    }
    
    func deleteAllRecord() -> Bool{
        if db.execute(sql: "DELETE from tblMessageReceipts") != 0 {
            return true
        }else{
            return false
        }
    }
    
    func getUniqueMessageReceiptsId(conversationMessageId : Int64, employeeId : Int64, completion: @escaping(_ uniqueId : Int) -> Void) {
        let arrayId = tblMessageReceipts.rowsFor(sql: "SELECT * from tblMessageReceipts where conversationMessageId = '\(conversationMessageId)' AND employeeId = '\(employeeId)'")
        var uniqueID : Int = -1
        if arrayId.count > 0 {
            uniqueID = arrayId[0].id
            completion(uniqueID)
        }
        else{
            completion(uniqueID)
        }
    }
    
    func insertORUpdateMessageReceipts(arrMessageReceiptsData : [[String : Any]], completion: @escaping( _ success: Bool) -> Void){
        for (index, eleMessageReceiptData) in arrMessageReceiptsData.enumerated() {
            self.getUniqueMessageReceiptsId(conversationMessageId: eleMessageReceiptData["conversationMessageId"] as? Int64 ?? 0, employeeId: eleMessageReceiptData["employeeId"] as? Int64 ?? 0, completion: { uniqueId in
                var objMessageReceiptData : tblMessageReceipts?
                
                if uniqueId == -1 {
                    objMessageReceiptData = tblMessageReceipts()
                }
                else{
                    objMessageReceiptData = tblMessageReceipts.rowBy(id: uniqueId)
                    objMessageReceiptData!.id = Int(uniqueId)
                }
                
                if objMessageReceiptData != nil {
                    
                    objMessageReceiptData!.conversationMessageId = eleMessageReceiptData["conversationMessageId"] as? Int64 ?? 0
                    objMessageReceiptData!.employeeId = eleMessageReceiptData["employeeId"] as? Int64 ?? 0
                    objMessageReceiptData!.isDelivered = eleMessageReceiptData["isDelivered"] as? Bool ?? false
                    objMessageReceiptData!.isReceived = eleMessageReceiptData["isReceived"] as? Bool ?? false
                    objMessageReceiptData!.isRead = eleMessageReceiptData["isRead"] as? Bool ?? false
                    objMessageReceiptData!.addedOn = eleMessageReceiptData["addedOn"] as? Int64 ?? 0
                    
                    let _ = objMessageReceiptData!.save()
                    
                    if index == arrMessageReceiptsData.count - 1{
                        completion(true)
                    }
                }
                else{
                    if index == arrMessageReceiptsData.count - 1{
                        completion(true)
                    }
                }
            })
        }
    }
}
