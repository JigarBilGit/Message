//
//  ViewExtension.swift
//  Billiyo Clinical
//
//  Created by Billiyo Health on 26/07/21.
//

import Foundation
import UIKit

extension UIView {
    
    func borderColor(width : CGFloat, color : UIColor){
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    func roundCorners(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func roundSpecificCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        layer.masksToBounds = true
    }
    
    func setShadow(){
        self.layer.shadowColor = MessageTheme.Color.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 20, height: 20)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 20
    }
    
    func setSketchShadow(){
        self.layer.applySketchShadow(color: MessageTheme.Color.lightGray,
                                     alpha: 1.0,
                                           x: 0,
                                           y: 2,
                                           blur: 10,
                                           spread: 0)
    }
    
    func getPixelColorAt(point:CGPoint) -> UIColor{
            
            let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
            let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
            
            context!.translateBy(x: -point.x, y: -point.y)
            layer.render(in: context!)
            let color:UIColor = UIColor(red: CGFloat(pixel[0])/255.0,
                                        green: CGFloat(pixel[1])/255.0,
                                        blue: CGFloat(pixel[2])/255.0,
                                        alpha: CGFloat(pixel[3])/255.0)
            
            pixel.deallocate()
            return color
        }
    
}


// MARK: Navigation View Property

extension UIView {
    
    func setNavigationViewCorner(){
        
        // layerMaxXMaxYCorner – lower right corner
       // layerMaxXMinYCorner – top right corner
       // layerMinXMaxYCorner – lower left corner
       // layerMinXMinYCorner – top left corner
        
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
    
    func setLowerCorner(){
        
        // layerMaxXMaxYCorner – lower right corner
       // layerMinXMaxYCorner – lower left corner
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
    }
    
    func setUpperCorner(){
        
       // layerMaxXMinYCorner – top right corner
       // layerMinXMinYCorner – top left corner
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    }
    
    func setButtonCorner(){
        
        // layerMaxXMaxYCorner – lower right corner
       // layerMaxXMinYCorner – top right corner
       // layerMinXMaxYCorner – lower left corner
       // layerMinXMinYCorner – top left corner
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner]
    }
    
}


