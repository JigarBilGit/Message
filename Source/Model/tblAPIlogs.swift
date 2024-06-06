//
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2021 Billiyo Mac. All rights reserved.
//

import Foundation

class tblAPIlogs : SQLTable {
    var id : Int = -1
    var apiURL : String = ""
    var parameter : String = ""
    var calledDate : String = ""
    var apiCalledOn : Int64 = 0
    var requestId : String = ""
    
    required init() {
        super.init()
    }
    
    func deleteAllRecord() -> Bool{
        if db.execute(sql: "DELETE from tblAPIlogs") != 0 {
            return true
        }else{
            return false
        }
    }
    
    func deleteAPILog(date : Int64) -> Bool{
        if db.execute(sql: "DELETE from tblAPIlogs where apiCalledOn < '\(date)'") != 0 {
            return true
        }else{
            return false
        }
    }
}
