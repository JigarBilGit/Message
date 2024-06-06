//
//  BMSharedNotification.swift
//
//  Billiyo Clinical
//  Created on Sept 07, 2021

import Foundation
import UIKit

class BMSharedNotification : NSObject{
    
    
    var clientId        : Int64 = -1
    var resourceId      : Int64 = -1
    var notifyPurpose   : String = ""
    var notifyMessage   : String = ""
    var enumNotifyPurpose : NotifyPurpose = .none
    
    internal init(clientId: Int64 = -1, resourceId: Int64 = -1, notifyPurpose: String = "", notifyMessage: String = "", enumNotifyPurpose: NotifyPurpose = .none) {
        self.clientId = clientId
        self.resourceId = resourceId
        self.notifyPurpose = notifyPurpose
        self.notifyMessage = notifyMessage
        self.enumNotifyPurpose = enumNotifyPurpose
    }
    

}

