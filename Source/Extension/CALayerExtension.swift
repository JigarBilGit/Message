//
//  DateExtension.swift
//  Billiyo Clinical
//
//  Created by Billiyo Health on 17/08/21.
//

import Foundation
import UIKit

// MARK: - CALayer Extension

extension CALayer {
    func applySketchShadow(
        color: UIColor = UIColor(red: 167.0/255, green: 169.0/255, blue: 169.0/255, alpha: 1.0),
        alpha: Float = 0.17,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
