//
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2021 Billiyo Mac. All rights reserved.
//

import Foundation


class ShareMessage : NSObject{
    var strDate : String = ""
    var sectionDate : Int64 = 0
    var arrMessage : [tblMessages] = []

    internal init(strDate: String = "", sectionDate: Int64 = 0, arrMessage: [tblMessages] = []) {
        self.strDate = strDate
        self.sectionDate = sectionDate
        self.arrMessage = arrMessage
    }
}

