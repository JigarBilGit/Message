//
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2023 Billiyo Mac. All rights reserved.
//

import Foundation

class tblEmployees : SQLTable {
    var id : Int = -1
    var employeeId : Int64 = 0
    var firstName : String = ""
    var middleName : String = ""
    var lastName : String = ""
    var telephone : String = ""
    var photo : String = ""
    var genderId : Int = 0
    var gender : String = ""
    var employeeStatusId : Int = 0
    var employeeStatus : String = ""
    
    
    required init() {
        super.init()
    }
    
    func deleteAllRecord() -> Bool{
        if db.execute(sql: "DELETE from tblEmployees") != 0 {
            return true
        }else{
            return false
        }
    }
}
