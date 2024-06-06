//
//  BMPopOverUsable.swift
//  BMPopOver
//
//  Created by Sandip Prajapati on 21/11/19.
//  Copyright © 2019 Sandip Prajapati. All rights reserved.
//

import Foundation
import UIKit

public protocol BMPopOverUsable {
    
    var contentSize: CGSize { get }
    var contentView: UIView { get }
    var popOverBackgroundColor: UIColor? { get }
    var arrowDirection: UIPopoverArrowDirection { get }
}

extension BMPopOverUsable {
    
    public var popOverBackgroundColor: UIColor? {
        return nil
    }
    
    public var arrowDirection: UIPopoverArrowDirection {
        return .any
    }
}

public extension UIPopoverArrowDirection {
    static var none: UIPopoverArrowDirection {
        return UIPopoverArrowDirection(rawValue: 0)
    }
}
