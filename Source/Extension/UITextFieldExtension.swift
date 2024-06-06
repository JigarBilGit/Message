//
//  UITextFieldExtension.swift
//  Billiyo Clinical
//
//  Created by Billiyo Health on 27/07/21.
//

import Foundation
import UIKit

extension UITextField{
    
    func setTextFieldProperty(keyboardType : UIKeyboardType,
                                   isSecure : Bool? = false,
                                   placeholder : String){
        
        self.borderStyle = .none
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecure ?? false
        self.font = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageTheme.Size.Size_20)
        self.textAlignment = .left
        
        
        self.placeholder = placeholder
        
        self.textColor = MessageTheme.Color.titleText
        self.backgroundColor = MessageTheme.Color.textFieldBg
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: MessageTheme.Color.titleText,
            NSAttributedString.Key.font : UIFont(name: "avenir_medium", size: 20) ?? UIFont.systemFont(ofSize: 20) // Note the !
        ]

        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes:attributes)

        
        self.roundCorners(radius: 10)
        self.setLeftPaddingPoints(10)
        self.setRightPaddingPoints(10)
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
           let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
           self.leftView = paddingView
           self.leftViewMode = .always
       }
       func setRightPaddingPoints(_ amount:CGFloat) {
           let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
           self.rightView = paddingView
           self.rightViewMode = .always
       }
    
    
}
