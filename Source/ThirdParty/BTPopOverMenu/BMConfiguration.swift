//
//  BMConfiguration.swift
//  BMPopOverMenu_Swift
//
//  Created by Jigar Patel.
//  Copyright (c) 2023 Billiyo Mac. All rights reserved.
//

import UIKit

public class BMConfiguration: NSObject {

    public var menuRowHeight = BM.DefaultMenuRowHeight
    public var menuWidth = BM.DefaultMenuWidth
    public var borderColor = BM.DefaultTintColor
    public var borderWidth = BM.DefaultBorderWidth
    public var backgoundTintColor = BM.DefaultTintColor
    public var cornerRadius = BM.DefaultCornerRadius
    public var menuSeparatorColor = UIColor.lightGray
    public var menuSeparatorInset = UIEdgeInsets(top: 0, left: BM.DefaultCellMargin, bottom: 0, right: BM.DefaultCellMargin)
    public var cellSelectionStyle = UITableViewCell.SelectionStyle.none
    /// v1
    public var globalShadow = false
    public var shadowAlpha: CGFloat = 0.6
    public var localShadow = false
    /// v2 shadow
    public var globalShadowAdapter: ((_ backgroundView: UIView) -> Void)?
    public var localShadowAdapter: ((_ backgroundLayer: CAShapeLayer) -> Void)?
    
    // cell configs
    public var textColor: UIColor = UIColor.white
    public var textFont: UIFont = UIFont.systemFont(ofSize: 14)
    public var textAlignment: NSTextAlignment = NSTextAlignment.left
    public var ignoreImageOriginalColor = false
    public var menuIconSize: CGFloat = BM.DefaultMenuIconSize
    
    public var selectedTextColor: UIColor = UIColor.darkText
    public var selectedCellBackgroundColor: UIColor = UIColor.red
    
    /// indexes that will not dismiss on selection
    public var noDismissalIndexes: [Int]?
    
}

