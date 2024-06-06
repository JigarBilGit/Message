//
//  UIScreen+Frame.swift
//  BMPopOverMenu_Swift
//
//  Created by Jigar Patel.
//  Copyright (c) 2023 Billiyo Mac. All rights reserved.
//

import UIKit

extension UIScreen {
    
    public static func bi_width() -> CGFloat {
        return self.main.bounds.size.width
    }
    
    public static func bi_height() -> CGFloat {
        return self.main.bounds.size.height
    }
    
}
