//
//
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2021 Billiyo Mac. All rights reserved.
//

import UIKit

class BMLabel: UILabel {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    func setUpView() {
        self.layer.masksToBounds = true
        if self.tag == 1212{
            self.textColor = MessageTheme.Color.black
            self.font = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_12 : MessageTheme.Size.Size_16)
        }
        else if self.tag == 1016{
            self.textColor = MessageTheme.Color.black
            self.font = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_16 : MessageTheme.Size.Size_22)
        }
        else if self.tag == 1718{
            self.textColor = MessageTheme.Color.darkGray
            self.font = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_18 : MessageTheme.Size.Size_26)
        }
        else if self.tag == 2115{
            self.textColor = MessageTheme.Color.black
            self.font = UIFont(name: MessageTheme.Font.avenirHeavy, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_15 : MessageTheme.Size.Size_22)
        }
        else if self.tag == 2216{
            self.textColor = MessageTheme.Color.white
            self.font = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_16 : MessageTheme.Size.Size_22)
        }
        else if self.tag == 3012{
            self.textColor = MessageTheme.Color.primaryTheme
            self.font = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_12 : MessageTheme.Size.Size_15)
        }
        else if self.tag == 3112{
            self.textColor = MessageTheme.Color.detailText
            self.font = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_12 : MessageTheme.Size.Size_15)
        }
        else if self.tag == 3412{
            self.textColor = MessageTheme.Color.white
            self.font = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_12 : MessageTheme.Size.Size_16)
        }
        else if self.tag == 3514{
            self.textColor = MessageTheme.Color.black
            self.font = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_14 : MessageTheme.Size.Size_18)
        }
        else if self.tag == 3018{
            self.textColor = MessageTheme.Color.black
            self.font = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_18 : MessageTheme.Size.Size_26)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func autoscalingSizeOflable (){
        self.font = self.font.withSize(((UIScreen.main.bounds.size.width) * self.font.pointSize) / 320)
    }
}
