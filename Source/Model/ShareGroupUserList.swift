//
//  ShareGroupUserList.swift
//  BilliyoCommunication
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2023 Billiyo Mac. All rights reserved.
//

import Foundation


class ShareGroupUserList : NSObject {
    
    var userId : Int64!
    var userName : String!
    var userPhoto : String!
    var isGroupAdmin : Bool!
    var userTag : Int!
    var name : String!
    
    internal init(userId: Int64? = nil, userName: String? = nil, userPhoto: String? = nil, isGroupAdmin: Bool? = nil, userTag: Int? = nil, name: String? = nil) {
        self.userId = userId
        self.userName = userName
        self.userPhoto = userPhoto
        self.isGroupAdmin = isGroupAdmin
        self.userTag = userTag
        self.name = name
    }
}
