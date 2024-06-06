//
//  UIButton.swift
//  Billiyo Clinical
//
//  Created by Billiyo Health on 27/07/21.
//

import Foundation
import UIKit

extension UIButton{
    
    func setTextButtonProperty(title : String){
        let customButtonTitle = NSMutableAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: UIFont(name: MessageTheme.Font.avenirHeavy, size: 60) ?? UIFont.boldSystemFont(ofSize: 25),
            NSAttributedString.Key.backgroundColor: UIColor.clear,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        self.setAttributedTitle(customButtonTitle, for: .normal)
        self.backgroundColor = MessageTheme.Color.buttonBlue
        self.roundCorners(radius: 15)

    }
    
  
    
}
