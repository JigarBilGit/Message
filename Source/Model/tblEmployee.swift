//
//  Employee.swift
//  Billiyo Clinical 
//  Created on August 18, 2021

import Foundation

class tblEmployee : SQLTable{
    var id : Int = -1
    var address : String = ""
    var caretakerId : Int = 0
    var city : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var middleName : String = ""
    var state : String = ""
    var telephone : String = ""
    var zipcode : String = ""
    var isCaregiver : Bool = false

    required init() {
        super.init()
    }
    
    func deleteAllRecord() -> Bool{
        if db.execute(sql: "DELETE FROM tblEmployee") != 0 {
            return true
        }else{
            return false
        }
    }
}
