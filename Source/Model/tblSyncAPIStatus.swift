//
//  Schedule.swift
//  Billiyo Clinical
//
//  Created by Billiyo Health on 16/08/21.
//

import Foundation

class tblAPISyncStatus : SQLTable{

    var apiName : String = ""
    var apiEndpoint : String = ""
    var apiTagName : String = ""
    var apiTag : Int = 0
    var apiSyncStatus : Bool = false
    var apiFailStatus : Bool = false
    var maxAttempt : Int = 0
    var requestId : String = ""
    var errorMessage : String = ""
    var errorCode : String = ""
    
    required init() {
        super.init()
    }
    
    func deleteAllRecord() -> Bool{
        if db.execute(sql: "DELETE FROM tblAPISyncStatus") != 0 {
            return true
        }else{
            return false
        }
    }
    
    //====== Added By Sandip  =====
    //====== From Version 2.3 =====
    //=============================
    func getAPISyncStatus(apiName : String, OnGettingStatus: @escaping (Bool) -> Void){
        
        let querySyncStatus = "SELECT * tblAPISyncStatus WHERE apiName = '\(apiName)'"
        
        print("====== Get Query For API Sync Status ========")
        print(querySyncStatus)
        print("==============")
        
        let arrayApiStatus = tblAPISyncStatus.rowsFor(sql: querySyncStatus)
        
        if arrayApiStatus.count > 0 {
            OnGettingStatus(arrayApiStatus[0].apiSyncStatus)
        }else{
            OnGettingStatus(false)
        }
    }
    //=============================
    

    func setAPISyncStatus(apiSyncStatus : Int, apiName : String, requestId : String) -> Bool{
        if db.execute(sql: "Update tblAPISyncStatus SET apiSyncStatus = '\(apiSyncStatus)', requestId = '\(requestId)', apiFailStatus = '\(0)' where apiName = '\(apiName)'") != 0 {
            return true
        }else{
            return false
        }
    }
    
    func setAPIFailStatus(apiFailStatus : Int, apiName : String, requestId : String, errorMessage : String, errorCode : String) -> Bool{
        if db.execute(sql: "Update tblAPISyncStatus SET apiFailStatus = '\(apiFailStatus)', apiSyncStatus = '\(0)', requestId = '\(requestId)', errorMessage = '\(errorMessage)', errorCode = '\(errorCode)' where apiName = '\(apiName)'") != 0 {
            return true
        }else{
            return false
        }
    }
    
    func resetSyncStatus(apiSyncStatus : Int, apiFailStatus : Int, maxAttempt : Int, apiName : String) -> Bool{
        if db.execute(sql: "Update tblAPISyncStatus SET apiSyncStatus = '\(apiSyncStatus)', apiFailStatus = '\(apiFailStatus)', maxAttempt = '\(maxAttempt)' where apiName = '\(apiName)'") != 0 {
            return true
        }else{
            return false
        }
    }
}
