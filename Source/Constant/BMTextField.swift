//
//
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2021 Billiyo Mac. All rights reserved.
//

import Foundation
import UIKit

class BMTextField: UITextField {
    var intRow : Int = 0
    var intSection : Int = 0
    
    let viewline = UIView()
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 20)
    let padding2 = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    let padding3 = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    let padding4 = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageTheme.Size.Size_22)
        self.tintColor = MessageTheme.Color.primaryTheme
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
        //        self.autoscalingSizeOflable()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setUpView() {
        self.font = UIFont(name: MessageTheme.Font.avenirBook, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_20 : MessageTheme.Size.Size_23)
        if self.tag == 301{
            self.backgroundColor = MessageTheme.Color.white
            self.tintColor = MessageTheme.Color.black
            self.textColor = MessageTheme.Color.black
            // self.placeHolderColor = MessageTheme.Color.lightGray
            self.layer.cornerRadius = 8.0
            
        }else if self.tag == 302{
            self.font = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_20 : MessageTheme.Size.Size_23)
            
            self.backgroundColor = MessageTheme.Color.clear
            self.tintColor = MessageTheme.Color.black
            self.textColor = MessageTheme.Color.black
            self.layer.borderWidth = 1.0
            self.layer.borderColor = MessageTheme.Color.black.cgColor
            self.textAlignment = .center
            self.layer.cornerRadius = 8.0
            // self.placeHolderColor = MessageTheme.Color.lightGray
        }else if self.tag == 303{
            
            self.font = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_20 : MessageTheme.Size.Size_23)
            self.backgroundColor = MessageTheme.Color.white
            self.tintColor = MessageTheme.Color.darkGray
            self.textColor = MessageTheme.Color.darkGray
            self.layer.borderWidth = 0
            self.textAlignment = .left
            self.layer.cornerRadius = 8.0
            
            let attributes = [
                NSAttributedString.Key.foregroundColor: MessageTheme.Color.lightGray,
                NSAttributedString.Key.font :  UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_18 : MessageTheme.Size.Size_23) // Note the !
            ]
            
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes:attributes as [NSAttributedString.Key : Any])
            self.setLeftPaddingPoints(10)
            self.setRightPaddingPoints(10)
            
        }else if self.tag == 304{
            self.textAlignment = .left
            self.textColor = MessageTheme.Color.black
            self.font = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_14 : MessageTheme.Size.Size_18)
            
        }
        else if self.tag == 307{
            self.textAlignment = .left
            self.textColor = MessageTheme.Color.black
            self.font = UIFont(name: MessageTheme.Font.avenirNextMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_15 : MessageTheme.Size.Size_20)
        }
        else if self.tag == 308{
            self.font = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_18 : MessageTheme.Size.Size_22)
            
            self.backgroundColor = MessageTheme.Color.clear
            self.tintColor = MessageTheme.Color.black
            self.textColor = MessageTheme.Color.black
            self.layer.borderWidth = 0.0
            self.layer.borderColor = MessageTheme.Color.clear.cgColor
            self.textAlignment = .left
            self.layer.cornerRadius = 0.0
        }
        else if self.tag == 309{
            self.backgroundColor = MessageTheme.Color.white
            self.tintColor = MessageTheme.Color.black
            self.textColor = MessageTheme.Color.black
            self.layer.cornerRadius = 8.0
            self.textAlignment = .left
            
            let attributes = [
                NSAttributedString.Key.foregroundColor: MessageTheme.Color.lightGray,
                NSAttributedString.Key.font :  UIFont(name: MessageTheme.Font.avenirMedium, size:  MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_18 : MessageTheme.Size.Size_23)
            ]
            
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes:attributes as [NSAttributedString.Key : Any])
        }
        else if self.tag == 310{
            self.backgroundColor = MessageTheme.Color.white
            self.tintColor = MessageTheme.Color.white
            self.textColor = MessageTheme.Color.white
            self.layer.cornerRadius = 0
            self.textAlignment = .left
            
            let attributes = [
                NSAttributedString.Key.foregroundColor: MessageTheme.Color.white,
                NSAttributedString.Key.font :  UIFont(name: MessageTheme.Font.avenirMedium, size:  MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_18 : MessageTheme.Size.Size_23)
            ]
            
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes:attributes as [NSAttributedString.Key : Any])
        }
        else if self.tag == 311{
            self.backgroundColor = MessageTheme.Color.clear
            self.tintColor = MessageTheme.Color.white
            self.textColor = MessageTheme.Color.white
            self.font = UIFont(name: MessageTheme.Font.avenirMedium, size:  MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_18 : MessageTheme.Size.Size_23)
            self.layer.borderWidth = 0.0
            self.layer.borderColor = MessageTheme.Color.clear.cgColor
            self.textAlignment = .left
            self.layer.cornerRadius = self.height / 2.0
            let attributes = [
                NSAttributedString.Key.foregroundColor: MessageTheme.Color.white,
                NSAttributedString.Key.font : UIFont(name: MessageTheme.Font.avenirMedium, size:  MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_18 : MessageTheme.Size.Size_23)
            ]
            
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes:attributes as [NSAttributedString.Key : Any])
        }
        else if self.tag == 312{
            self.font = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_20 : MessageTheme.Size.Size_23)
            
            self.backgroundColor = MessageTheme.Color.clear
            self.tintColor = MessageTheme.Color.black
            self.textColor = MessageTheme.Color.black
            self.layer.borderWidth = 1.0
            self.layer.borderColor = MessageTheme.Color.black.cgColor
            self.textAlignment = .left
            self.layer.cornerRadius = 8.0
        }
        else if self.tag == 313{
            self.backgroundColor = MessageTheme.Color.clear
            self.tintColor = MessageTheme.Color.primaryTheme
            self.textColor = MessageTheme.Color.primaryTheme
            self.layer.cornerRadius = 0
            self.textAlignment = .left
            
            let attributes = [
                NSAttributedString.Key.foregroundColor: MessageTheme.Color.lightGray,
                NSAttributedString.Key.font :  UIFont(name: MessageTheme.Font.avenirMedium, size:  MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_18 : MessageTheme.Size.Size_23)
            ]
            
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes:attributes as [NSAttributedString.Key : Any])
        }
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        if self.tag == 301 || self.tag == 303 || self.tag == 309 || self.tag == 310{
            return bounds.inset(by: padding)
        }
        else if self.tag == 305{
            return bounds.inset(by: padding3)
        }
        else if self.tag == 312{
            return bounds.inset(by: padding4)
        }
        else{
            return bounds.inset(by: padding2)
        }
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        if self.tag == 301 || self.tag == 303 || self.tag == 309 || self.tag == 310{
            return bounds.inset(by: padding)
        }
        else if self.tag == 305{
            return bounds.inset(by: padding3)
        }
        else if self.tag == 312{
            return bounds.inset(by: padding4)
        }
        else{
            return bounds.inset(by: padding2)
        }
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        if self.tag == 301 || self.tag == 303 || self.tag == 309 || self.tag == 310{
            return bounds.inset(by: padding)
        }
        else if self.tag == 305{
            return bounds.inset(by: padding3)
        }
        else if self.tag == 312{
            return bounds.inset(by: padding4)
        }
        else{
            return bounds.inset(by: padding2)
        }
    }
    
    func autoscalingSizeOflable (){
        self.font = self.font!.withSize(((UIScreen.main.bounds.size.width) * self.font!.pointSize) / 320)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
