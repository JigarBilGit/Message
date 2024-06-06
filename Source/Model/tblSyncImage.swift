//
//  tblSyncTime.swift
//  Billiyo Clinical
//
//  Created by Billiyo Health on 16/08/21.
//

import Foundation


class tblSyncImage : SQLTable{
    
   // Zero is used to represent false, and
    //One is used to represent true.

    var id          : Int           = -1
    var imageName   : String        = ""
    var imageType   : Int           = -1
    var primaryId   : String        = ""
    var secondaryId : String        = ""
    var isSync      : Int           = 0
    var recordDate  : Int64         = 0
    
    
    
    // primaryId    ==  documentId OR ClinicalAssessmentId
    // secondaryId  ==  shortCodeId OR employeeScheduleId 
    
    func deleteAllRecord() -> Bool{
        if db.execute(sql: "DELETE from tblSyncImage") != 0 {
            return true
        }else{
            return false
        }
    }
    
    func deleteImage(strImageName : String, primaryId : String, secondaryId : String) -> Bool{
        if db.execute(sql: "DELETE from tblSyncImage where imageName = '\(strImageName)' AND primaryId = '\(primaryId)' AND secondaryId = '\(secondaryId)'") != 0 {
            return true
        }else{
            return false
        }
    }
    
    func deleteImageUsingName(strImageName : String, OnDeletingSyncImage: @escaping( _ deleteSyncImage: Bool) -> Void){
        if db.execute(sql: "DELETE from tblSyncImage where imageName = '\(strImageName)'") != 0 {
            OnDeletingSyncImage(true)
        }else{
            OnDeletingSyncImage(false)
        }
    }
    
    func updateImageSyncStatus(isSync : Int, strImageName : String) -> Bool{
        if db.execute(sql: "Update tblSyncImage SET isSync = '\(isSync)' where imageName = '\(strImageName)'") != 0 {
            return true
        }else{
            return false
        }
    }
    
    func deleteSyncedImage(imageType : Int) -> Bool{
        
        if db.execute(sql: "DELETE FROM tblSyncImage WHERE isSync = '\(1)' AND imageType = '\(imageType)'") != 0 {
            return true
        }else{
            return false
        }
        
    }
    
    
    func deleteImageByPrimaryId(primaryId : String) -> Bool{
        if db.execute(sql: "DELETE FROM tblSyncImage WHERE primaryId = '\(primaryId)'") != 0 {
            return true
        }else{
            return false
        }
        
    }
    
    func setSyncImageStatus(imageName : String,
                            imageType : Int,
                            primaryId : String,
                            secondaryId : String,
                            isSync : Bool,
                            recordDate : Int64? = Date().getUnixTimeForCurrentDate()){
        
        let syncImageId = tblSyncImage().getUniqueIDForSyncImage(strImageName: imageName,
                                                                 primaryId: primaryId,
                                                                 secondaryId: secondaryId)
        
        let isSyncInt = MessageManager.shared.convertBoolToInt(value: isSync)
        if syncImageId == -1 {
            let syncImage = tblSyncImage()
            syncImage.imageName     = imageName
            syncImage.imageType     = imageType
            syncImage.primaryId     = primaryId
            syncImage.secondaryId   = secondaryId
            syncImage.isSync        = isSyncInt
            syncImage.recordDate    = recordDate ?? 0
            
            _ = syncImage.save()
            
        }
        else{
            _ = tblSyncImage().updateImageStatusUsingUniqueID(isSync: isSync, uniqueId: syncImageId)
        }
    }
    
    func getUniqueIDForSyncImage(strImageName : String, primaryId : String, secondaryId : String) -> Int {
        let arraySyncImage = tblSyncImage.rowsFor(sql: "SELECT * FROM tblSyncImage WHERE imageName = '\(strImageName)' AND primaryId = '\(primaryId)' AND secondaryId = '\(secondaryId)'")
        var syncImageUniqueID = -1
        if arraySyncImage.count > 0 {
            syncImageUniqueID = arraySyncImage[0].id
            return syncImageUniqueID
        }
        else{
            return syncImageUniqueID
        }
    }
    
    func updateImageStatusUsingUniqueID(isSync : Bool, uniqueId : Int) -> Bool{
        let isSyncInt = MessageManager.shared.convertBoolToInt(value: isSync)
        if db.execute(sql: "Update tblSyncImage SET isSync = '\(isSyncInt)' where id = '\(uniqueId)'") != 0 {
            return true
        }
        else{
            return false
        }
    }
    
    func updateImageStatus(isSync : Int) -> Bool{
        if db.execute(sql: "Update tblSyncImage SET isSync = '\(isSync)' WHERE imageType = '\(SyncImageType.clinicalAssessmentClientSign.rawValue)' OR imageType = '\(SyncImageType.clinicalAssessmentEmployeeSign.rawValue)'") != 0 {
            return true
        }
        else{
            return false
        }
    }
}
