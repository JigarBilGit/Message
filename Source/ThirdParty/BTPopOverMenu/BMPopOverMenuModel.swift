//
//  BMPopOverMenuModel.swift
//  BMPopOverMenu_Swift
//
//  Created by Jigar Patel.
//  Copyright (c) 2023 Billiyo Mac. All rights reserved.
//

import UIKit

public class BMPopOverMenuModel: NSObject {
    
    public var title: String = ""
    public var image: Imageable?
    public var selected: Bool = false
    
    public convenience init(title: String, image: Imageable?, selected: Bool) {
        self.init()
        self.title = title
        self.image = image
        self.selected = selected
    }
    
}
