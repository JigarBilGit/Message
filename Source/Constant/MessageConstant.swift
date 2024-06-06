//
//  MessageConstant.swift
//  Billiyo Clinical
//
//  Created by Billiyo Health on 26/07/21.
//

import Foundation
import UIKit

let navigationTitleColor = UIColor.black

class MessageConstant {
    //Device Compatibility
    struct is_Device {
        static let _iPhone = (UIDevice.current.model as String).isEqual("iPhone") ? true : false
        static let _iPad = (UIDevice.current.model as String).isEqual("iPad") ? true : false
        static let _iPod = (UIDevice.current.model as String).isEqual("iPod touch") ? true : false
    }
    
    struct GlobalConstants {
        static let anAppName    : NSString = "Billiyo Clinical"
        static let apiAppName   : NSString = "ClinicalPDN"
        
        static let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    }
    
    struct signalR {
        static let url: String = "wss://communication-billiyo.azurewebsites.net/communication/connect?access_token="
    }
    
    // MARK: - Version
    struct Version{
        static let v1  = "v1"
        static let v2  = "v2"
        static let v3  = "v3"
        static let v4  = "v4"
        static let current  = v1
    }

    // MARK: - API Type Constant -
    struct ServiceType{
        
        static let employees_retrieve              = Version.v1 + "/employees/retrieve"
        static let api_errors_save                 = Version.v1 + "/app-errors/save"
        static let backup_save                     = Version.v1 + "/backup/save"
        
        static let conversation_retrieve        = Version.v1 + "/conversation/retrieve"
        static let conversation_create          = Version.v1 + "/conversation/create"
        static let conversation_update          = Version.v1 + "/conversation/update"
        static let conversation_leave           = Version.v1 + "/conversation/leave"
        static let conversation_add_employee    = Version.v1 + "/conversation/add-employee"
        static let conversation_remove_employee = Version.v1 + "/conversation/remove-employee"
        static let make_admin                   = Version.v1 + "/conversation/make-admin"
        static let remove_admin                 = Version.v1 + "/conversation/remove-admin"
        
        static let message_retrieve             = Version.v1 + "/message/retrieve"
        static let message_send                 = Version.v1 + "/message/send"
        static let message_read                 = Version.v1 + "/message/read"
        static let message_delete               = Version.v1 + "/message/delete"
        
        static let content_backup               = Version.v1 + "/content/save-backup"
    }
}
