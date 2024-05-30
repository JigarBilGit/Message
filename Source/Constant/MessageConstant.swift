//
//  MessageConstant.swift
//  Billiyo Clinical
//
//  Created by Billiyo Health on 26/07/21.
//

import Foundation
import UIKit

let navigationTitleColor = UIColor.black

let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate

class MessageConstant {
    //Device Compatibility
    struct is_Device {
        static let _iPhone = (UIDevice.current.model as String).isEqual("iPhone") ? true : false
        static let _iPad = (UIDevice.current.model as String).isEqual("iPad") ? true : false
        static let _iPod = (UIDevice.current.model as String).isEqual("iPod touch") ? true : false
    }
}

struct signalR {
    static let url: String = "wss://communication-billiyo.azurewebsites.net/communication/connect?access_token="
}




