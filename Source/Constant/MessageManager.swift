//
//  MessageManager.swift
//
//  Created by Sandip Prajapati on 25/06/19.
//  Copyright © 2019 Sandip Prajapati. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import Reachability
import CoreLocation
import Photos
import Zip
import LocalAuthentication

class Connectivity1 {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class MessageManager{

    static let shared = MessageManager()
    //=======
        
    var isNetwork : Bool = false
    let rechability = NetworkReachabilityManager()
    //=======
    
    //===== Added in version 2.0.10 =====
    //====== Notify View ================
    //===================================
    var notifyView : NotifyView = .none
    var sharedNotification : BHSharedNotification?
    //===================================
    
    let db = SQLiteDB.shared
    
    //=========
    
    //=== Login User Details =======
    var accessToken          : String = ""
    var tokenType            : String = ""
    var expiresIn            : String = "-1"
    var refreshToken         : String = ""
    var email                : String = ""
    var username             : String = ""
    var role                 : String = ""
    var employeeId           : String = "-1"
    var firstName            : String = ""
    var middleName           : String = ""
    var lastName             : String = ""
    var uniqueValue          : String = "-1"
    var issued               : String = "-1"
    var expires              : String = "-1"
    var timiroCode           : String = ""
    var payPeriodStartDate   : String = "-1"
    var payPeriodEndDate     : String = "-1"
    var hasEvvClient         : Bool   = false
    var hasNonEvvClient      : Bool   = false
    var loginUserFullName    : String = ""
    var isWorktimeRounding   : Bool   = false
    var isHomeHealthAgency   : Bool = false
    var autoDatabaseBackup   : String = "30"
    var canDeleteEmployeeSchedule : Bool = false
    var canCreateEmployeeSchedule : Bool = false
    var accessTokenWithTokenType   : String = ""
    var agencyType           : String = ""
    var arrAgencyType        : [String] = []
    var bypassSkilledVisitConflict : Bool = false
    var independentAssessmentMigrated : Bool = false
    var enableAutoSaveDocuments : Bool = false
    var caregiverEvalRequiredSupervisor : Bool = true
    var useQPInIncidentReports : Bool = true
    
    //========================================
    var umpi        : String = ""
    var initials    : String = ""
    var roleId      : String = ""
    var emailId     : String = ""
    var jobId       : String = ""
    var jobTitle    : String = ""
    var contactNo   : String = ""
    var address     : String = ""
    var city        : String = ""
    var state       : String = ""
    var zipcode     : String = ""
    var photo       : String = ""
    var addedBy     : String = ""
    var updatedBy   : String = ""
    var updatedOn   : String = ""
    var playEvvIntroVideo       : Bool = false
    var playNonEvvIntroVideo    : Bool = false
    var canEditWoundCare    : Bool = false
    var enablePayroll       : Bool = false
    var disableFieldInCareplanEdit : String = ""
    
    var canEditClosedWounds    : Bool = false
    var contractDocumentAllowEditInNumberOfDays : String = ""
    
    var isLocationEnabled = false
    
    var isAppBecomeActive : Bool = false
    
    var isNetConnected : Bool = true
}

// MARK: Calculation Formula methods
extension MessageManager{
    struct reachablity {
        var isNetwork = MessageManager.shared.isConnectivityChecked()
    }
    
    func isConnectivityChecked()-> Bool {
        if Connectivity1.isConnectedToInternet() {
            return true
        } else  {
            return false
        }
    }
}

// MARK: ProgressHUD methods

extension MessageManager{
    
    func showProgressHUD(_ isShow:Bool, _ message: String? = "") {
        
        if isShow == true {
            
            SVProgressHUD.setBackgroundColor(UIColor.white)
            SVProgressHUD.setForegroundColor(UIColor.black)
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setDefaultMaskType(.black)
            
            if(message == ""){
                SVProgressHUD.show()
            }else{
                SVProgressHUD.show(withStatus: message)
            }
        }
        else {
            SVProgressHUD.dismiss()
        }
    }
    
}

// MARK: Alert View methods
extension MessageManager{
    
    /*func showToastMessage(toastMessage:String){
        guard let currentVC = APP_DELEGATE.rootNavigationVC?.viewControllers.last else{
            return
        }
        currentVC.showToastMessage(toastMessage)
    }*/
    
    func openValidationAlertView(alertMessage:String, currentVC : UIViewController){
        let alertController = UIAlertController(title: AppConstant.GlobalConstants.anAppName as String, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        currentVC.present(alertController, animated: true, completion: nil)
    }
    
    func openValidationAlertViewWithOption(alertTitle : String? = "keyAlert".localize,
                                           alertMessage : String,
                                           rightButtonTitle:String? = "keyOKUpperCase".localize,
                                           leftButtonTitle:String? = "",
                                           currentVC : UIViewController){
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: rightButtonTitle, style: .cancel, handler: nil))
        currentVC.present(alertController, animated: true, completion: nil)
    }
    
    func openCustomValidationAlertView(alertTitle : String? = "keyAlert".localize,
                                       alertMessage : String,
                                       rightButtonTitle:String? = "keyOKUpperCase".localize,
                                       leftButtonTitle:String? = ""){
        DispatchQueue.main.async {
            _ = BHAlertVC.init(title: alertTitle ?? "keyAlert".localize, message: alertMessage, rightButtonTitle: rightButtonTitle ?? "keyOKUpperCase".localize, leftButtonTitle: leftButtonTitle) { success, actionType in }
        }
        
    }
    
    func openNotesRemarksAlertView(alertTitle : String? = "keyAlert".localize,
                                       alertMessage : String,
                                       rightButtonTitle:String? = "keyOKUpperCase".localize,
                                       leftButtonTitle:String? = ""){
        DispatchQueue.main.async {
            NotesRemarksView.instance.showAlert(title: alertTitle ?? "keyAlert".localize, message: alertMessage, rightButtonTitle: rightButtonTitle ?? "keyOKUpperCase".localize, leftButtonTitle: leftButtonTitle) { success, actionType in }
        }
        
    }
}


// MARK: 
// MARK: Patient OR Client Methods
//
extension MessageManager {
    func getFullName(firstName : String, middleName : String, lastName : String)->String{
        if lastName.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return firstName + " " + middleName
        }
        else{
            return lastName + ", " + firstName + " " + middleName
        }
    }
}


// MARK: 
// MARK: Database Methods
//
extension MessageManager {
        
    func setSyncTime(syncTime : Int64, apiName : String){
        let objSyncTime = self.db.query(sql: "SELECT * FROM tblsynctime WHERE apiName= '\(apiName)'")
        if objSyncTime.count > 0 {
            _ = self.db.query(sql: "UPDATE tblsynctime SET syncTime = '\(syncTime)' WHERE apiName= '\(apiName)'")
            
        }
        else{
            
            let objSyncTime = tblSyncTime()
            objSyncTime.syncTime = syncTime
            objSyncTime.apiName = apiName
            _ = objSyncTime.save()
        }
    }
    
    func getSyncTime(for apiName : String) -> Int64{
        let objSyncTime = self.db.query(sql: "SELECT * FROM tblsynctime WHERE apiName= '\(apiName)'")
        if objSyncTime.count > 0 {
           if let syncTime = objSyncTime[0]["syncTime"] {
                let number: Int64? = Int64(syncTime as? String ?? "0")
                return number ?? 0
            }
            else{
                return 0
            }
        }
        else{
            return 0
        }
    }
}

extension MessageManager {
    // MARK: 
    // MARK:  Image Name Generate Method
    func generateImageName(strTag : String, strExtention : String) -> String {
        return "I_\(strTag)_\(MessageManager.shared.uniqueValue)_\(Int64(Date().unixTimestamp)).\(strExtention)"
    }

    func generateSequenceImageName(index : Int, strTag : String, strExtention : String) -> String {
        return "I_\(strTag)_\(MessageManager.shared.uniqueValue)_\(Int64(Date().add(minutes: index).unixTimestamp)).\(strExtention)"
    }
    
    func generateIndexingImageName(index : Int, strTag : String, strExtention : String) -> String {
        return "I_\(index)_\(strTag)_\(MessageManager.shared.uniqueValue)_\(Int64(Date().unixTimestamp)).\(strExtention)"
    }

    func generateTempRecordName(strTag : String) -> String {
        return "I_\(strTag)_\(MessageManager.shared.uniqueValue)_\(Int64(Date().unixTimestamp))"
    }
    
    func generateMobilePrimaryKey() -> String {
        return "I_\(MessageManager.shared.uniqueValue)_\(Int64(Date().unixTimestamp))"
    }
    
    func generateSequenceMobilePrimaryKey(index : Int, strTag : String) -> String {
        return "I_\(strTag)_\(MessageManager.shared.uniqueValue)_\(Int64(Date().add(minutes: index).unixTimestamp))"
    }
    
    func generateZipName(strTag : String, timeStamp : Int64, strExtention : String) -> String {
        return "I_\(MessageManager.shared.employeeId)_\(timeStamp)_\(strTag).\(strExtention)"
    }
}

extension MessageManager{
    // MARK:  Dispatch Delay
    func delay(delay: Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}


extension MessageManager{
    // MARK: 
    // MARK:  DateFormatter Methods
    func getDateformatterWithTimeZone() -> DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.init(identifier: "CST")
        return dateFormatter
    }
    
    func getDateformatterWithCurrentTimeZone() -> DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }
}

extension MessageManager {
    
    func getDateformatter() -> DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd Z"
        return dateFormatter
    }
    
    func getDateTimeformatter() -> DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a Z"
        return dateFormatter
    }
    
    // MARK: 
    // MARK:  Timestamp to Date Convert Method
    func getDateTime(timestamp : Int64) -> Date {
        var myDate = Date()
        if timestamp.digitsCount > 10{
            myDate = Date(timeIntervalSince1970: TimeInterval(Int(timestamp/1000)))
        }
        else{
            myDate = Date(timeIntervalSince1970: TimeInterval(Int(timestamp)))
        }
        let cstDateFormatter = self.getDateTimeformatter()
        cstDateFormatter.timeZone = TimeZone.init(identifier: "CST")
        let strConvertedDate = cstDateFormatter.string(from: myDate)
        return cstDateFormatter.date(from: strConvertedDate)!
    }
    
    func getCurrentZoneDate(timestamp : Int64) -> Date {
        var myDate = Date()
        if timestamp.digitsCount > 10{
            myDate = Date(timeIntervalSince1970: TimeInterval(Int(timestamp/1000)))
        }
        else{
            myDate = Date(timeIntervalSince1970: TimeInterval(Int(timestamp)))
        }
        let cstDateFormatter = self.getDateTimeformatter()
        cstDateFormatter.timeZone = TimeZone.current
        let strConvertedDate = cstDateFormatter.string(from: myDate)
        return cstDateFormatter.date(from: strConvertedDate)!
    }
    
    func getCurrentDateWithCurrentTimeZoneWithMiliSecondsInInt() -> Int64{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a Z"
        dateFormatter.timeZone = TimeZone.current

        let strDate = dateFormatter.string(from: Date())
        let unixTime = Date().getUnixDateWithCSTTimeZoneWithMiliSeconds(strDate: strDate)
        return unixTime
    }
    
    func dateFormatterHHMMA() -> DateFormatter {
        let dateFormatter = self.getDateformatterWithTimeZone()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter
    }
    
    func viewCurrentDateFormatterHHMMA() -> DateFormatter {
        let dateFormatter = self.getDateformatterWithCurrentTimeZone()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter
    }
    
    func getCurrentCSTTimeStamp() -> Int64 {
        let dateFormatter2 = DateFormatter()
        dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter2.dateFormat = "MM/dd/yyyy hh:mm a Z"
        dateFormatter2.timeZone = TimeZone.init(identifier: "CST")
        let finalDate = dateFormatter2.date(from: dateFormatter2.string(from: Date()))

        return Int64(finalDate!.timeIntervalSince1970 * 1000)
    }
    
    func getCurrentUTCTimeStamp() -> Int64 {
        let dateFormatter2 = DateFormatter()
        dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter2.dateFormat = "MM/dd/yyyy hh:mm:ss a Z"
        dateFormatter2.timeZone = TimeZone.init(identifier: "UTC")
        let finalDate = dateFormatter2.date(from: dateFormatter2.string(from: Date()))

        return Int64(finalDate!.timeIntervalSince1970 * 1000)
    }
    
    func getTimeStampHHMM24hFrom(strDate : String) -> Int64 {
        let arrCurrentDate = strDate.components(separatedBy: " ")
        
        let cstDateFormatter = DateFormatter()
        cstDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        cstDateFormatter.dateFormat = "MM/dd/yyyy hh:mm a Z"
        cstDateFormatter.timeZone = TimeZone.init(identifier: "CST")
        let date = cstDateFormatter.date(from: strDate)
        let cstDateString = cstDateFormatter.string(from: date!)
        
        let arrCSTDate = cstDateString.components(separatedBy: " ")
        
        var arrFinalDate = arrCurrentDate
        _ = arrFinalDate.remove(at: arrFinalDate.count - 1)
        arrFinalDate.append(arrCSTDate[arrCSTDate.count - 1])
        
        let strConvetedDate = arrFinalDate.joined(separator: " ")
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter2.dateFormat = "MM/dd/yyyy hh:mm a Z"
        dateFormatter2.timeZone = .current
        let finalDate = dateFormatter2.date(from: strConvetedDate)

        return Int64(finalDate!.timeIntervalSince1970 * 1000)
    }
    
    func getCurrentTimeStampMMDDYYYYFrom2(strDate : String) -> Int64 {
        let arrCurrentDate = strDate.components(separatedBy: " ")
        
        let cstDateFormatter = DateFormatter()
        cstDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        cstDateFormatter.dateFormat = "MM/dd/yyyy"
        cstDateFormatter.timeZone = .current
        let date = cstDateFormatter.date(from: strDate)
        let cstDateString = cstDateFormatter.string(from: date!)
        
        let arrCSTDate = cstDateString.components(separatedBy: " ")
        
        var arrFinalDate = arrCurrentDate
        _ = arrFinalDate.remove(at: arrFinalDate.count - 1)
        arrFinalDate.append(arrCSTDate[arrCSTDate.count - 1])
        
        let strConvetedDate = arrFinalDate.joined(separator: " ")
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter2.dateFormat = "MM/dd/yyyy"
        dateFormatter2.timeZone = .current
        let finalDate = dateFormatter2.date(from: strConvetedDate)

        return Int64(finalDate!.timeIntervalSince1970 * 1000)
    }
    
    func dateFormatterCurrentMMDDYYYY() -> DateFormatter {
        let dateFormatter = self.getDateformatterWithCurrentTimeZone()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }
    
    func dateFormatterEEEDDMMM() -> DateFormatter {
        let dateFormatter = self.getDateformatterWithCurrentTimeZone()
        dateFormatter.dateFormat = "EEE, dd MMM"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }
}

// MARK: 
// MARK:  Document Directory Methods
extension MessageManager {
    func getDocumentDirPath() -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        return documentsPath
    }

    func createDirectory(strFolderName : String){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        let dataPath = docURL.appendingPathComponent(strFolderName)
        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveFileToDirectory(strFolderName : String, strFileName : String, fileData : Data){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(strFolderName)/\(strFileName)")
        print(paths)
        let folderPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = folderPaths[0]
        let docURL = URL(string: documentsDirectory)!
        let dataPath = docURL.appendingPathComponent(strFolderName)
        if FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            fileManager.createFile(atPath: paths, contents: fileData, attributes: nil)
        }
        else{
            self.createDirectory(strFolderName: strFolderName)
            fileManager.createFile(atPath: paths, contents: fileData, attributes: nil)
        }
    }
    
    func deleteFileFromDirectory(strFolderName : String, strFileName : String){
        if strFileName != ""{
            let fileManager = FileManager.default
            let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(strFolderName)/\(strFileName)")
            if fileManager.fileExists(atPath: paths){
                do{
                    try fileManager.removeItem(atPath: paths)
                }
                catch{
                    
                }
            }else{
                print("File not exist at DD.")
            }
        }
    }
    
    func deleteAllFilesFromDirectory(strFolderName : String){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(strFolderName)")
        if fileManager.fileExists(atPath: paths){
            do{
                try fileManager.removeItem(atPath: paths)
            }
            catch{
                
            }
        }else{
            print("File not exist at DD.")
        }
    }
    
    func getImageFromDirectory(strFolderName : String, strFileName : String)-> UIImage?{
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(strFolderName)/\(strFileName)")
        if fileManager.fileExists(atPath: paths){
            
            guard let resultImage = UIImage(contentsOfFile: paths) else{
                return nil
            }
            return resultImage
            
        }else{
            print("Image not exist in Folder at DD.")
            return nil
        }
    }

    func getFileDataFromDirectory(strFolderName : String, strFileName : String)-> Data?{
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(strFolderName)/\(strFileName)")
        if fileManager.fileExists(atPath: paths){
            let url = URL(fileURLWithPath: paths)
            let data = try? Data(contentsOf: url)
            if data != nil{
                return data
            }
            return nil
        }else{
            print("File not exist in Folder at DD.")
            return nil
        }
    }
    
    func checkFileExist(strFolderName : String, strFileName : String)-> Bool{
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(strFolderName)/\(strFileName)")
        if fileManager.fileExists(atPath: paths){
            return true
        }
        else{
            return false
        }
    }

    func saveFileToTempDirectory(strFileName : String, fileData : Data){
        let fileManager = FileManager.default
        fileManager.createFile(atPath: "\(FileManager.default.temporaryDirectory.path)/\(strFileName)", contents: fileData, attributes: nil)
    }
    
    func deleteFileFromDirectoryWithExtention(strExtension : String){
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for fileURL in fileURLs {
                if fileURL.pathExtension == strExtension {
                    try FileManager.default.removeItem(at: fileURL)
                }
            }
        } catch  { print(error) }
    }
    
    // MARK: 
    // MARK: IMAGE FOR PHASSET METHODS
    func getUIImage(objVC : UIViewController, asset: PHAsset, complition : @escaping ((_ img:UIImage?,_ error:String?) -> Void)){
        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.resizeMode = PHImageRequestOptionsResizeMode.exact
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.progressHandler = { (progress, error, stop, info) in
            if error != nil{
                MessageManager.shared.openCustomValidationAlertView(alertMessage: error!.localizedDescription)
            }
        }

        manager.requestImageData(for: asset, options: requestOptions, resultHandler: { (data, str, orientation, info) -> Void in
            if let data = data, let img = UIImage(data: data){
                complition(img,asset.originalFilename)
            }else{
                complition(nil,"Something went wrong")
            }
         })
    }
}

// MARK: 
// MARK:  Options Methods

extension MessageManager {
    func removeDuplicateOptions(mainArray : [CAOption]) -> [CAOption]{
        var resultArray = [CAOption]()
        var arrayClinicalFormFieldId = [Int]()
        for objOption in mainArray {
            if !arrayClinicalFormFieldId.contains(objOption.clinicalFormFieldOptionId) {
                resultArray.append(objOption)
                arrayClinicalFormFieldId.append(objOption.clinicalFormFieldOptionId)
            }
        }
        return resultArray
    }
}

extension MessageManager {
    // MARK: 
    // MARK: CONVERSATION LIST METHODS
    func call_EmployeeListAPI(showLoader : Bool, completion: @escaping (Bool) -> Void) {
        let paramer: [String: Any] = [:]
        Webservice.call.GET(objVC: (self.window?.rootViewController)!, filePath: APIConstant.ServiceType.employees_retrieve, params: paramer, enableInteraction: !showLoader, showLoader: showLoader, viewObj: (self.window?.rootViewController?.view)!, strAPITag: "EmployeeList", isForCommunication: true, onSuccess: { (result, success, requestId) in
            let _ = tblAPISyncStatus().setAPISyncStatus(apiSyncStatus: 1, apiName: "EmployeeList", requestId: requestId)
            if let arrEmployeeData = result as? [[String : Any]] {
                _ = tblEmployees().deleteAllRecord()
                
                if tblEmployees().saveAllRecords(arrParams: arrEmployeeData) != 0{

                }
            }
        }) {
            print("Error \(self.description)")
        }
    }
    
    func call_ConversationListAPI(showLoader : Bool, completion: @escaping (Bool) -> Void) {
        let lastSyncTime = AppManager.shared.getSyncTime(for: SyncTimeConstant.APIName.ConversationList)
        
        var paramer: [String: Any] = [:]
        paramer["syncTime"] = lastSyncTime
        
        Webservice.call.POST(objVC: (self.window?.rootViewController)!, filePath: APIConstant.ServiceType.conversation_retrieve, params: paramer, enableInteraction: !showLoader, showLoader: showLoader, viewObj: (self.window?.rootViewController?.view)!, isOffline: true, isForCommunication: true, onSuccess: { (result, success,requestId) in
            if let dictConversationData = result as? [String : Any] {
                let _ = tblAPISyncStatus().setAPISyncStatus(apiSyncStatus: 1, apiName: "ConversationList", requestId: requestId)
                if lastSyncTime == 0{
                    _ = tblConversationList().deleteAllRecord()
                    _ = tblUserList().deleteAllRecord()
                }
                
                if let arrUserListData = dictConversationData["users"] as? [[String : Any]], arrUserListData.count > 0 {
                    if lastSyncTime == 0{
                        if tblUserList().saveAllRecords(arrParams: arrUserListData) != 0{

                        }
                    }
                    else{
                        tblUserList().insertORUpdateUserList(arrUserListData: arrUserListData) { success in
                            
                        }
                    }
                }
                
                if let arrConversationListData = dictConversationData["conversations"] as? [[String : Any]], arrConversationListData.count > 0 {
                    if lastSyncTime == 0{
                        if tblConversationList().saveAllRecords(arrParams: arrConversationListData) != 0{
                            self.downloadConversationPic()
                            self.call_MessageRetrieveAPI()
                            completion(true)
                        }
                    }
                    else{
                        tblConversationList().insertORUpdateConversationList(arrConversationListData: arrConversationListData) { success in
                            self.downloadConversationPic()
                            self.call_MessageRetrieveAPI()
                            completion(true)
                        }
                    }
                }
                else{
                    self.downloadConversationPic()
                    completion(true)
                }
                
                let syncTime = dictConversationData["syncTime"] as? Int64 ?? 0
                AppManager.shared.setSyncTime(syncTime: syncTime, apiName: SyncTimeConstant.APIName.ConversationList)
            }
        }) {
            print("Error \(self.description)")
        }
    }
    
    func downloadConversationPic(){
        let arrConversationListData = tblConversationList.rowsFor(sql: "SELECT * FROM tblConversationList where isConversationImageDownloaded = '\(0)' AND conversationImage != ''")
        if arrConversationListData.count > 0{
            DispatchQueue.background(background: {
                if !AppManager.shared.checkFileExist(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: arrConversationListData[0].conversationImage){
                    BHAzure.loadDataFromAzure(clientSignature: arrConversationListData[0].conversationImage) { success, error, data in
                        if success && data != nil {
                            AppManager.shared.saveFileToDirectory(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: arrConversationListData[0].conversationImage, fileData: data!)
                            _ = tblConversationList().setConversationImageDownloadedStatus(isConversationImageDownloaded: 1, conversationId: arrConversationListData[0].conversationId)
                            
                            self.downloadConversationPic()
                        }
                        else{
                            if arrConversationListData[0].imageDownloadTryCount < 3{
                                _ = tblConversationList().setImageDownloadTryCount(imageDownloadTryCount: arrConversationListData[0].imageDownloadTryCount + 1, conversationId: arrConversationListData[0].conversationId)
                                if arrConversationListData[0].imageDownloadTryCount == 2{
                                    _ = tblConversationList().setConversationImageDownloadedStatus(isConversationImageDownloaded: 1, conversationId: arrConversationListData[0].conversationId)
                                }
                            }
                            
                            self.downloadConversationPic()
                        }
                    }
                }
            }, completion:{
                
            })
        }
        else{
//            self.reloadTabScreen()
        }
    }
    
    func call_MessageRetrieveAPI(){
        let arrConversation = tblConversationList.rowsFor(sql: "SELECT * FROM tblConversationList where isDeleted = '\(0)' ORDER By messageDateTime DESC")
        for (index, eleConversation) in arrConversation.enumerated(){
            self.call_MessageListAPI(conversationId: eleConversation.employeeConversationId, pageSize: MessagePageSize.Default.rawValue, lastMessageId: 0, nextOrPrevious: false) { (success, isMoreRecord) in
                
            }
            
            if index == arrConversation.count - 1 {
                let _ = tblAPISyncStatus().setAPISyncStatus(apiSyncStatus: 1, apiName: "Message_List", requestId: "")
            }
        }
    }
    
    func call_MessageListAPI(conversationId : Int64, pageSize : Int, lastMessageId : Int64, nextOrPrevious : Bool, completion: @escaping (Bool, Bool) -> Void) {
        var paramer: [String: Any] = [:]
        paramer["conversationId"] = conversationId
        paramer["pageSize"] = pageSize
        paramer["lastMessageId"] = lastMessageId
        paramer["nextOrPrevious"] = nextOrPrevious
        
        Webservice.call.POST(objVC: (self.window?.rootViewController)!, filePath: APIConstant.ServiceType.message_retrieve, params: paramer, enableInteraction: true, showLoader: false, viewObj: (self.window?.rootViewController?.view)!, strAPITag: "", isForCommunication: true, onSuccess: { (result, success,requestId) in
            if let dictMessageData = result as? [String : Any] {
                if let arrMessageData = dictMessageData["messages"] as? [[String : Any]], arrMessageData.count > 0 {
                    tblMessages().insertORUpdateMessages(arrMessagesData: arrMessageData) { success in
                        completion(true, arrMessageData.count < pageSize ? false : true)
                    }
                }
                else{
                    completion(true, false)
                }
                
                if let arrMessageReceiptsData = dictMessageData["receipts"] as? [[String : Any]], arrMessageReceiptsData.count > 0 {
                    tblMessageReceipts().insertORUpdateMessageReceipts(arrMessageReceiptsData: arrMessageReceiptsData) { success in

                    }
                }
            }
        }) {
            print("Error \(self.description)")
        }
    }
    
    func call_MessagesDataSubmitAPI(arrMessagesData : [tblMessages], showLoader : Bool, mobilePrimaryKey : String, completion: @escaping (Bool) -> Void){
        if arrMessagesData.count > 1{
            self.call_SendMessagesAPI(arrMessagesData: arrMessagesData, showLoader: showLoader, mobilePrimaryKey: mobilePrimaryKey) { isSuccess in
                completion(isSuccess)
            }
        }
        else{
            if arrMessagesData.count > 0{
                let finalMessageData = Message(conversationId: arrMessagesData[0].conversationId, messageTypeId: arrMessagesData[0].messageTypeId, messageContent: arrMessagesData[0].messageContent, messageAttachment: arrMessagesData[0].messageAttachment, messageDateTime: arrMessagesData[0].messageDateTime, replyMessageId: arrMessagesData[0].replyMessageId, forwardMessageId: arrMessagesData[0].forwardMessageId, mobilePrimaryKey: arrMessagesData[0].mobilePrimaryKey)
                
                self.hubConnectionConversation.invoke(method: "SendMessage", arguments: [finalMessageData]) { error in
                    if error == nil {
                        completion(true)
                    }
                    else{
                        if let error = error {
                            print("An error occurred: %@", "\(error)")
                        }
                    }
                }
            }
        }
    }
    
    
    
    func call_MessagesDataReadAPI(empConversationId : Int64, showLoader : Bool, completion: @escaping (Bool) -> Void){
        
        let finalReadMessageData = ReadMessage(employeeConversationId: empConversationId)
        
        self.hubConnectionConversation.invoke(method: "ReadMessages", arguments: [finalReadMessageData]) { error in
            if error == nil {
                completion(true)
            }
            else{
                if let error = error {
                    print("An error occurred: %@", "\(error)")
                }
                
                completion(false)
            }
        }
        
    }
    
    
    func call_SendMessagesAPI(arrMessagesData : [tblMessages], showLoader : Bool, mobilePrimaryKey : String, completion: @escaping (Bool) -> Void) {
        var arrFinalMessageData : [[String:Any]] = []
        arrMessagesData.forEach { (element) in
            var dictMessageData : [String : Any] = [:]
        
            dictMessageData["conversationId"] = element.conversationId
            dictMessageData["messageTypeId"] = element.messageTypeId
            dictMessageData["messageContent"] = element.messageContent
            dictMessageData["messageAttachment"] = element.messageAttachment
            dictMessageData["messageDateTime"] = element.messageDateTime
            dictMessageData["mobilePrimaryKey"] = element.mobilePrimaryKey
            dictMessageData["replyMessageId"] = element.replyMessageId
            dictMessageData["forwardMessageId"] = element.forwardMessageId
            
            arrFinalMessageData.append(dictMessageData)
        }
        
        Webservice.call.POSTArray(filePath: APIConstant.ServiceType.message_send, params: arrFinalMessageData, enableInteraction: !showLoader, showLoader: showLoader, viewObj: (self.window?.rootViewController?.view)!, isOffline: true, isForCommunication: true, onSuccess: { (result, success,requestId) in
            if let arrResponse = result as? [[String : Any]], arrResponse.count > 0 {
                for (index, eleResponse) in arrResponse.enumerated(){
                    if let messageData = eleResponse["message"] as? [String : Any] {
                        tblMessages().insertORUpdateSingleMessage(messagesData: messageData) { success in
                             
                        }
                    }
                    
                    if let arrMessageReceiptsData = eleResponse["receipts"] as? [[String : Any]], arrMessageReceiptsData.count > 0 {
                        tblMessageReceipts().insertORUpdateMessageReceipts(arrMessageReceiptsData: arrMessageReceiptsData) { success in

                        }
                    }
                    
                    if index == arrResponse.count - 1{
                        completion(true)
                    }
                }
            }
            else{
                completion(true)
            }
        }) {result,success, requestId in
            if result is [String : Any] {
                if !success{
                    
                }
            }
        }
    }
    
    func call_ReadMessagesAPI(employeeConversationId : Int64, showLoader : Bool, completion: @escaping (Bool) -> Void) {
        var dictMessageData : [String : Any] = [:]
        dictMessageData["employeeConversationId"] = employeeConversationId

        Webservice.call.POST(objVC: (self.window?.rootViewController)!, filePath: APIConstant.ServiceType.message_read, params: dictMessageData, enableInteraction: true, showLoader: false, viewObj: nil, isForCommunication : true, onSuccess: { (result, success, requestId) in
            if let Dict = result as? [String:Any] {
                print("d sds dsa")
            }
            
            if let arrResponse = result as? [[String : Any]], arrResponse.count > 0 {
                
                print("sdsad")
            }
            
        }) {
            print("Error \(self.description)")
        }
    }
    
    
    
    func call_DeleteMessagesAPI(employeeConversationId : Int64, conversationMessageId : Int64, showLoader : Bool, completion: @escaping (Bool) -> Void){
        var paramer: [String: Any] = [:]
        paramer["employeeConversationId"] = employeeConversationId
        paramer["conversationMessageId"] = conversationMessageId
        
        Webservice.call.DELETE(filePath: APIConstant.ServiceType.message_delete, params: paramer, enableInteraction: !showLoader, showLoader: showLoader, viewObj: (self.window?.rootViewController?.view)!, isForCommunication: true, onSuccess: { (result, success,requestId) in
            if let response = result as? [String : Any] {
                if let messageData = response["message"] as? [String : Any] {
                    tblMessages().insertORUpdateSingleMessage(messagesData: messageData) { success in
                        completion(true)
                    }
                }
                
                if let arrMessageReceiptsData = response["receipts"] as? [[String : Any]], arrMessageReceiptsData.count > 0 {
                    tblMessageReceipts().insertORUpdateMessageReceipts(arrMessageReceiptsData: arrMessageReceiptsData) { success in

                    }
                }
            }
            else{
                completion(true)
            }
        }) {
            print("Error \(self.description)")
        }
    }
    
    func call_CreateConvesationAPI(employeeIds : [Int64], groupName : String, groupImage : String, isGroup : Bool, showLoader : Bool, completion: @escaping (Bool, Int64) -> Void){
        var paramer: [String: Any] = [:]
        paramer["employeeId"] = employeeIds.compactMap({"\($0)"}).joined(separator: ",")
        paramer["groupName"] = groupName
        paramer["groupImage"] = groupImage
        paramer["isGroup"] = isGroup
        
        Webservice.call.POST(objVC: (self.window?.rootViewController)!, filePath: APIConstant.ServiceType.conversation_create, params: paramer, enableInteraction: !showLoader, showLoader: showLoader, viewObj: (self.window?.rootViewController?.view)!, strAPITag: "", isForCommunication: true, onSuccess: { (result, success,requestId) in
            if let dictMessageData = result as? [String : Any] {
                if let arrUserListData = dictMessageData["users"] as? [[String : Any]], arrUserListData.count > 0 {
                    tblUserList().insertORUpdateUserList(arrUserListData: arrUserListData) { success in
                            
                    }
                }
                
                if let arrConversationListData = dictMessageData["conversations"] as? [String : Any] {
                    tblConversationList().insertORUpdateConversationList(arrConversationListData: [arrConversationListData]) { success in
                        self.downloadConversationPic()
                        completion(true, arrConversationListData["employeeConversationId"] as? Int64 ?? 0)
                    }
                }
                else{
                    self.downloadConversationPic()
                    completion(true, 0)
                }
            }
        }) {
            print("Error \(self.description)")
        }
    }
    
    func call_UpdateConvesationAPI(employeeConversationId : Int64, groupName : String, groupImage : String, showLoader : Bool, completion: @escaping (Bool) -> Void){
        var paramer: [String: Any] = [:]
        paramer["employeeConversationId"] = employeeConversationId
        paramer["groupName"] = groupName
        paramer["groupImage"] = groupImage
        
        Webservice.call.POST(objVC: (self.window?.rootViewController)!, filePath: APIConstant.ServiceType.conversation_update, params: paramer, enableInteraction: !showLoader, showLoader: showLoader, viewObj: (self.window?.rootViewController?.view)!, strAPITag: "", isForCommunication: true, onSuccess: { (result, success,requestId) in
            if let dictMessageData = result as? [String : Any] {
                if let arrMessageData = dictMessageData["messages"] as? [[String : Any]], arrMessageData.count > 0 {
                    tblMessages().insertORUpdateMessages(arrMessagesData: arrMessageData) { success in
                         completion(true)
                    }
                }
                else{
                    completion(true)
                }
                
                if let arrMessageReceiptsData = dictMessageData["receipts"] as? [[String : Any]], arrMessageReceiptsData.count > 0 {
                    tblMessageReceipts().insertORUpdateMessageReceipts(arrMessageReceiptsData: arrMessageReceiptsData) { success in

                    }
                }
            }
        }) {
            print("Error \(self.description)")
        }
    }
    
    func call_LeaveConvesationAPI(employeeConversationId : Int64, showLoader : Bool, completion: @escaping (Bool) -> Void){
        var paramer: [String: Any] = [:]
        paramer["employeeConversationId"] = employeeConversationId
        
        Webservice.call.DELETE(filePath: APIConstant.ServiceType.conversation_leave, params: paramer, enableInteraction: !showLoader, showLoader: showLoader, viewObj: (self.window?.rootViewController?.view)!, isForCommunication: true, onSuccess: { (result, success,requestId) in
            if let _ = result as? [String : Any] {
                completion(true)
            }
            else{
                completion(false)
            }
        }) {
            print("Error \(self.description)")
        }
    }
    
    func call_MakeAdminAPI(employeeConversationId : Int64, employeeId : Int64, showLoader : Bool, completion: @escaping (Bool) -> Void){
        var paramer: [String: Any] = [:]
        paramer["employeeConversationId"] = employeeConversationId
        paramer["employeeId"] = employeeId
        
        Webservice.call.POST(objVC: (self.window?.rootViewController)!, filePath: APIConstant.ServiceType.make_admin, params: paramer, enableInteraction: !showLoader, showLoader: showLoader, viewObj: (self.window?.rootViewController?.view)!, strAPITag: "", isForCommunication: true, onSuccess: { (result, success,requestId) in
            if let dictMessageData = result as? [String : Any] {
                if let arrMessageData = dictMessageData["messages"] as? [[String : Any]], arrMessageData.count > 0 {
                    tblMessages().insertORUpdateMessages(arrMessagesData: arrMessageData) { success in
                         completion(true)
                    }
                }
                else{
                    completion(true)
                }
                
                if let arrMessageReceiptsData = dictMessageData["receipts"] as? [[String : Any]], arrMessageReceiptsData.count > 0 {
                    tblMessageReceipts().insertORUpdateMessageReceipts(arrMessageReceiptsData: arrMessageReceiptsData) { success in

                    }
                }
            }
        }) {
            print("Error \(self.description)")
        }
    }
    
    func call_RemoveAdminAPI(employeeConversationId : Int64, employeeId : Int64, showLoader : Bool, completion: @escaping (Bool) -> Void){
        var paramer: [String: Any] = [:]
        paramer["employeeConversationId"] = employeeConversationId
        paramer["employeeId"] = "\(employeeId)"
        
        Webservice.call.POST(objVC: (self.window?.rootViewController)!, filePath: APIConstant.ServiceType.remove_admin, params: paramer, enableInteraction: !showLoader, showLoader: showLoader, viewObj: (self.window?.rootViewController?.view)!, strAPITag: "", isForCommunication: true, onSuccess: { (result, success,requestId) in
            if let dictMessageData = result as? [String : Any] {
                if let arrMessageData = dictMessageData["messages"] as? [[String : Any]], arrMessageData.count > 0 {
                    tblMessages().insertORUpdateMessages(arrMessagesData: arrMessageData) { success in
                         completion(true)
                    }
                }
                else{
                    completion(true)
                }
                
                if let arrMessageReceiptsData = dictMessageData["receipts"] as? [[String : Any]], arrMessageReceiptsData.count > 0 {
                    tblMessageReceipts().insertORUpdateMessageReceipts(arrMessageReceiptsData: arrMessageReceiptsData) { success in

                    }
                }
            }
        }) {
            print("Error \(self.description)")
        }
    }
    
    func call_ConversationAddEmployeeAPI(employeeConversationId : Int64, employeeIds : [Int64], showLoader : Bool, completion: @escaping (Bool) -> Void){
        var paramer: [String: Any] = [:]
        paramer["employeeConversationId"] = employeeConversationId
        paramer["inviteEmployeeIds"] = employeeIds.compactMap({"\($0)"}).joined(separator: ",")
        
        Webservice.call.POST(objVC: (self.window?.rootViewController)!, filePath: APIConstant.ServiceType.conversation_add_employee, params: paramer, enableInteraction: !showLoader, showLoader: showLoader, viewObj: (self.window?.rootViewController?.view)!, strAPITag: "", isForCommunication: true, onSuccess: { (result, success,requestId) in
            if let dictMessageData = result as? [String : Any] {
                if let arrMessageData = dictMessageData["messages"] as? [[String : Any]], arrMessageData.count > 0 {
                    tblMessages().insertORUpdateMessages(arrMessagesData: arrMessageData) { success in
                         completion(true)
                    }
                }
                else{
                    completion(true)
                }
                
                if let arrMessageReceiptsData = dictMessageData["receipts"] as? [[String : Any]], arrMessageReceiptsData.count > 0 {
                    tblMessageReceipts().insertORUpdateMessageReceipts(arrMessageReceiptsData: arrMessageReceiptsData) { success in

                    }
                }
            }
        }) {
            print("Error \(self.description)")
        }
    }
    
    func call_ConversationRemoveEmployeeAPI(employeeConversationId : Int64, employeeIds : [Int64], showLoader : Bool, completion: @escaping (Bool) -> Void){
        var paramer: [String: Any] = [:]
        paramer["employeeConversationId"] = employeeConversationId
        paramer["RemovingEmployeeIds"] = employeeIds.compactMap({"\($0)"}).joined(separator: ",")
        
        Webservice.call.POST(objVC: (self.window?.rootViewController)!, filePath: APIConstant.ServiceType.conversation_remove_employee, params: paramer, enableInteraction: !showLoader, showLoader: showLoader, viewObj: (self.window?.rootViewController?.view)!, strAPITag: "", isForCommunication: true, onSuccess: { (result, success,requestId) in
            if let dictMessageData = result as? [String : Any] {
                if let arrMessageData = dictMessageData["messages"] as? [[String : Any]], arrMessageData.count > 0 {
                    tblMessages().insertORUpdateMessages(arrMessagesData: arrMessageData) { success in
                         completion(true)
                    }
                }
                else{
                    completion(true)
                }
                
                if let arrMessageReceiptsData = dictMessageData["receipts"] as? [[String : Any]], arrMessageReceiptsData.count > 0 {
                    tblMessageReceipts().insertORUpdateMessageReceipts(arrMessageReceiptsData: arrMessageReceiptsData) { success in

                    }
                }
            }
        }) {
            print("Error \(self.description)")
        }
    }
    
    func call_UploadContentOnAzure(resourceId : Int, strDocumentFile : String, strErrorMessage : String, strResourceType : String, strResourceName : String, completion: @escaping (Bool) -> Void) {
        var paramer: [String: Any] = [:]
        paramer["resourceId"] = resourceId
        paramer["documentFile"] = strDocumentFile
        paramer["errorMessage"] = strErrorMessage
        paramer["resourceType"] = strResourceType
        paramer["resourceName"] = strResourceName
            
        Webservice.call.POST(objVC: (self.window?.rootViewController)!, filePath: APIConstant.ServiceType.content_backup, params: paramer, enableInteraction: true, showLoader: false, viewObj: nil, isForCommunication: true, onSuccess: { (result, success,requestId) in
            if let _ = result as? [String : Any] {
                completion(true)
            }
            else{
                completion(false)
            }
        }) {
            print("Error \(self.description)")
        }
    }
}

