//
//
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2021 Billiyo Mac. All rights reserved.
//

import Foundation
import UIKit

class BMButton: UIButton {
    var intSection = 0
    var intRow = 0
    
    private var shadowLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setNeedsDisplay()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
//        self.autoscalingSizeOfButton()
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: FUNC SETUPVIEW.
    func setUpView() {
        if self.tag == 1014{
            self.backgroundColor = MessageTheme.Color.clear
            self.setTitleColor(MessageTheme.Color.darkBlue, for: .normal)
            self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirNextBold, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_14 : MessageTheme.Size.Size_22)
        }
        else if self.tag == 2014{
             self.backgroundColor = MessageTheme.Color.clear
             self.setTitleColor(MessageTheme.Color.buttonBlue, for: .normal)
             self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirHeavy, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_18 : MessageTheme.Size.Size_26)
        }
        else if self.tag == 3014{
             self.backgroundColor = MessageTheme.Color.primaryTheme
             self.setTitleColor(MessageTheme.Color.white, for: .normal)
             self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirHeavy, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_13 : MessageTheme.Size.Size_22)
        }
        else if self.tag == 1025{
            self.roundCorners(radius: 8.0)
            self.backgroundColor = MessageTheme.Color.primaryTheme
            self.setTitleColor(MessageTheme.Color.white, for: .normal)
            self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirNextBold, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_17 : MessageTheme.Size.Size_25)
        }
        else if self.tag == 3118{
            self.roundCorners(radius: 8.0)
            self.backgroundColor = MessageTheme.Color.primaryTheme
            self.setTitleColor(MessageTheme.Color.white, for: .normal)
            self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirBlack, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_18 : MessageTheme.Size.Size_22)
        }
        else if self.tag == 3218{
            self.roundCorners(radius: 8.0)
            self.backgroundColor = MessageTheme.Color.clear
            self.setTitleColor(MessageTheme.Color.black, for: .normal)
            self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirBlack, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_18 : MessageTheme.Size.Size_22)
        }
        else if self.tag == 1022{
             self.backgroundColor = MessageTheme.Color.clear
             self.setTitleColor(MessageTheme.Color.white, for: .normal)
             self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirHeavy, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_22 : MessageTheme.Size.Size_30)
        }
        else if self.tag == 1114{
             self.backgroundColor = MessageTheme.Color.clear
             self.setTitleColor(MessageTheme.Color.buttonRed, for: .normal)
             self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirHeavy, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_18 : MessageTheme.Size.Size_26)
        }
        else if self.tag == 1116{
             self.backgroundColor = MessageTheme.Color.clear
             self.setTitleColor(MessageTheme.Color.buttonRed, for: .normal)
             self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirHeavy, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_16 : MessageTheme.Size.Size_24)
        }
        else if self.tag == 1216{
             self.backgroundColor = MessageTheme.Color.clear
             self.setTitleColor(MessageTheme.Color.buttonBlue, for: .normal)
             self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirHeavy, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_16 : MessageTheme.Size.Size_24)
        }
        else if self.tag == 1016{
             self.backgroundColor = MessageTheme.Color.clear
             self.setTitleColor(MessageTheme.Color.white, for: .normal)
             self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirHeavy, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_16 : MessageTheme.Size.Size_24)
        }
        else if self.tag == 2016{
             self.backgroundColor = MessageTheme.Color.primaryTheme
             self.setTitleColor(MessageTheme.Color.white, for: .normal)
             self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirHeavy, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_16 : MessageTheme.Size.Size_24)
        }
        else if self.tag == 2116{
             self.backgroundColor = MessageTheme.Color.clear
             self.setTitleColor(MessageTheme.Color.primaryTheme, for: .normal)
             self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_16 : MessageTheme.Size.Size_18)
        }
        
        else if self.tag == 2018{
            self.backgroundColor = MessageTheme.Color.primaryTheme
            self.setTitleColor(MessageTheme.Color.white, for: .normal)
            self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirHeavy, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_18 : MessageTheme.Size.Size_26)
           
       }
        
        else if self.tag == 1018{
             self.backgroundColor = MessageTheme.Color.clear
             self.setTitleColor(MessageTheme.Color.white, for: .normal)
             self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_18 : MessageTheme.Size.Size_26)
        }
        else if self.tag == 1118{
            self.layer.cornerRadius = 8.0
            self.titleLabel?.textColor = MessageTheme.Color.buttonBlue
            self.backgroundColor = MessageTheme.Color.clear
            self.layer.borderWidth = 1.0
            self.layer.borderColor = MessageTheme.Color.buttonBlue.cgColor
            self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirBlack, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_18 : MessageTheme.Size.Size_22)
        }
        else if self.tag == 1218{
            self.layer.cornerRadius = 8.0
            self.titleLabel?.textColor = MessageTheme.Color.buttonRed
            self.backgroundColor = MessageTheme.Color.clear
            self.layer.borderWidth = 1.0
            self.layer.borderColor = MessageTheme.Color.buttonRed.cgColor
            self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirBlack, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_18 : MessageTheme.Size.Size_22)
        }
        else if self.tag == 1020{
            self.backgroundColor = MessageTheme.Color.primaryTheme
            self.setTitleColor(MessageTheme.Color.white, for: .normal)
            self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirHeavy, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_20 : MessageTheme.Size.Size_25)
        }
        else if self.tag == 2118{
             self.backgroundColor = MessageTheme.Color.clear
             self.setTitleColor(MessageTheme.Color.white, for: .normal)
             self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirHeavy, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_18 : MessageTheme.Size.Size_26)
        }
        else if self.tag == 2218{
             self.backgroundColor = MessageTheme.Color.clear
             self.setTitleColor(MessageTheme.Color.primaryTheme, for: .normal)
             self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_18 : MessageTheme.Size.Size_26)
        }
        
        else if self.tag == 200{
            self.backgroundColor = .clear
            self.tintColor = MessageTheme.Color.primaryTheme
        }
        else if self.tag == 201{
            self.roundCorners(radius: 15)
            //self.titleLabel?.textColor = MessageTheme.Color.white
            self.setTitleColor(MessageTheme.Color.white, for: .normal)
            self.backgroundColor = MessageTheme.Color.primaryTheme
            self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirNextBold, size: MessageTheme.Size.Size_25)
        }
        else if self.tag == 202{
           // self.titleLabel?.textColor = MessageTheme.Color.darkBlue
            self.backgroundColor = MessageTheme.Color.clear
            self.setTitleColor(MessageTheme.Color.darkBlue, for: .normal)
            self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirNextBold, size: MessageTheme.Size.Size_22)
        }
        
        else if self.tag == 203{
            
             self.backgroundColor = MessageTheme.Color.clear
             self.setTitleColor(MessageTheme.Color.buttonBlue, for: .normal)
             self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageTheme.Size.Size_22)
            
         }
        
        else if self.tag == 204{
            
             self.backgroundColor = MessageTheme.Color.clear
             self.setTitleColor(MessageTheme.Color.buttonRed, for: .normal)
             self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageTheme.Size.Size_22)
            
         }else if self.tag == 205{
            //-------- Navigation Button------
            
            self.backgroundColor = MessageTheme.Color.clear
            self.setTitleColor(MessageTheme.Color.white, for: .normal)
            self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirHeavy, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_20 : MessageTheme.Size.Size_25)

        }
        
         else if self.tag == 501{
              self.backgroundColor = MessageTheme.Color.clear
              self.setTitleColor(MessageTheme.Color.primaryTheme, for: .normal)
              self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageTheme.Size.Size_22)
         }
         else if self.tag == 502{
              self.backgroundColor = MessageTheme.Color.clear
              self.setTitleColor(MessageTheme.Color.white, for: .normal)
              self.titleLabel?.font = UIFont(name: MessageTheme.Font.avenirHeavy, size: MessageTheme.Size.Size_30)
         }
        
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    func autoscalingSizeOfButton (){
        self.titleLabel!.font = self.titleLabel!.font.withSize(((UIScreen.main.bounds.size.width) * self.titleLabel!.font.pointSize) / 320)
    }
}

