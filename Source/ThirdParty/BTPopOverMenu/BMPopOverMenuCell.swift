//
//  BMPopOverMenuCell.swift
//  BMPopOverMenu_Swift
//
//  Created by Jigar Patel.
//  Copyright (c) 2023 Billiyo Mac. All rights reserved.
//

import UIKit

class BMPopOverMenuCell: UITableViewCell {

    fileprivate lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.contentView.addSubview(imageView)
        return imageView
    }()

    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.backgroundColor = UIColor.clear
        self.contentView.addSubview(label)
        return label
    }()

    func setupCellWith(menuName: BMMenuObject, menuImage: Imageable?, configuration: BMConfiguration) {
        self.backgroundColor = UIColor.clear
        
        // configure cell text
        nameLabel.font = configuration.textFont
        nameLabel.textColor = configuration.textColor
        nameLabel.textAlignment = configuration.textAlignment
        nameLabel.frame = CGRect(x: BM.DefaultCellMargin, y: 0, width: configuration.menuWidth - BM.DefaultCellMargin*2, height: configuration.menuRowHeight)
        
        // configure cell image
        var iconImage: UIImage? = nil
        if menuName is String {
            nameLabel.text = menuName as? String
            iconImage = menuImage?.getImage()
        } else if menuName is BMPopOverMenuModel {
            nameLabel.text = (menuName as! BMPopOverMenuModel).title
            iconImage = (menuName as! BMPopOverMenuModel).image?.getImage()
            if ((menuName as! BMPopOverMenuModel).selected == true) {
                nameLabel.textColor = configuration.selectedTextColor
                self.backgroundColor = configuration.selectedCellBackgroundColor
            }
        }
        
        // configure cell icon if available
        if iconImage != nil {
            if  configuration.ignoreImageOriginalColor {
                iconImage = iconImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            }
            iconImageView.tintColor = configuration.textColor
            iconImageView.frame =  CGRect(x: BM.DefaultCellMargin, y: (configuration.menuRowHeight - configuration.menuIconSize)/2, width: configuration.menuIconSize, height: configuration.menuIconSize)
            iconImageView.image = iconImage
            nameLabel.frame = CGRect(x: BM.DefaultCellMargin*2 + configuration.menuIconSize, y: (configuration.menuRowHeight - configuration.menuIconSize)/2, width: (configuration.menuWidth - configuration.menuIconSize - BM.DefaultCellMargin*3), height: configuration.menuIconSize)
        }
    }
    
}
