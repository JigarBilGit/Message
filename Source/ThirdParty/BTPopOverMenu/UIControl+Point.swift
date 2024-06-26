//
//  UIControl+Point.swift
//  BMPopOverMenu_Swift
//
//  Created by Jigar Patel.
//  Copyright (c) 2023 Billiyo Mac. All rights reserved.
//

import UIKit

extension UIControl {

    internal func setAnchorPoint(anchorPoint: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * anchorPoint.x, y: bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = anchorPoint
    }

}
