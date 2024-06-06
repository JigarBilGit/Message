//
//  BMExtension.swift
//  BMPopOverMenuDemo
//
//  Created by Jigar Patel.
//  Copyright (c) 2023 Billiyo Mac. All rights reserved.
//

import UIKit

public protocol Imageable {
    func getImage() -> UIImage?
}

extension String: Imageable {
    public func getImage() -> UIImage? {
        return UIImage(named: self)
    }
}

extension UIImage: Imageable {
    public func getImage() -> UIImage? {
        return self
    }
}

public protocol BMMenuObject {
    
}

extension String: BMMenuObject {
    
}

extension BMPopOverMenuModel: BMMenuObject {
    
}
