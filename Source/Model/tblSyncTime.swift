//
//  tblSyncTime.swift
//  Billiyo Clinical
//
//  Created by Billiyo Health on 16/08/21.
//

import Foundation

class tblSyncTime : SQLTable{
    var id : Int = -1
    var syncTime    : Int64         = 0
    var apiName     : String        = ""
    
    
    required init() {
        super.init()
    }
    
    func deleteAllRecord() -> Bool{
        if db.execute(sql: "DELETE FROM tblSyncTime") != 0 {
            return true
        }else{
            return false
        }
    }
    
    func updateSyncTimeAsZero(apiName : String, OnUpdate: @escaping (Bool) -> Void){
        if db.execute(sql: "Update tblSyncTime SET syncTime = '\(0)' WHERE apiName = '\(apiName)'") != 0 {
            OnUpdate(true)
        }else{
            OnUpdate(false)
        }
    }

}
