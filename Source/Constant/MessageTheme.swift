//
//  MessageTheme.swift
//  Billiyo Clinical
//
//  Created by Billiyo Health on 29/07/21.
//

import Foundation
import UIKit

// MARK: - Color Constant -

class MessageTheme {
    struct Color{
        
        static let primaryTheme     = #colorLiteral(red: 0.2588235294, green: 0.5921568627, blue: 0.9882352941, alpha: 1)   // 66,151,252
        static let alertText        = #colorLiteral(red: 0.2549019608, green: 0.3019607843, blue: 0.3960784314, alpha: 1)   // 65,77,101
        static let buttonBlue       = #colorLiteral(red: 0.2588235294, green: 0.5568627451, blue: 0.9843137255, alpha: 1)   // 66,142,251
        static let buttonRed        = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)   // 255,0,0
        static let cellBgBlue       = #colorLiteral(red: 0.09411764706, green: 0.6, blue: 0.8431372549, alpha: 1)   // 24,153,215
        static let cellBgDefault    = #colorLiteral(red: 0.7019607843, green: 0.8823529412, blue: 0.9490196078, alpha: 1)   // 179,225,242
        static let cellBgRed        = #colorLiteral(red: 0.9882352941, green: 0.05098039216, blue: 0.1058823529, alpha: 1)   // 252,13,27
        static let darkGray         = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)   // 102,102,102
        static let defaultBlue      = #colorLiteral(red: 0, green: 0.5960784314, blue: 0.8549019608, alpha: 1)   // 0,152,218
        static let darkBlue         = #colorLiteral(red: 0.03529411765, green: 0.1647058824, blue: 0.4431372549, alpha: 1)   // 9,42,113
        static let defaultRed       = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)   // 255,0,0
        static let defaultGreen     = #colorLiteral(red: 0.1294117647, green: 0.3490196078, blue: 0.06666666667, alpha: 1)   // 33,89,17
        static let bgGray           = #colorLiteral(red: 0.7921568627, green: 0.8039215686, blue: 0.8156862745, alpha: 1)   // 202,205,208
        static let lightGray        = #colorLiteral(red: 0.568627451, green: 0.568627451, blue: 0.568627451, alpha: 1)   // 145,145,145
        static let textFieldBg      = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9490196078, alpha: 1)   // 241,241,242
        static let white            = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)   // 255,255,255
        static let black            = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)   // 0,0,0
        static let offWhite         = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)   // 255,255,255
        static let titleText        = #colorLiteral(red: 0.2352941176, green: 0.4156862745, blue: 0.4549019608, alpha: 1)   // 60,106,116
        static let detailText       = #colorLiteral(red: 0.5843137255, green: 0.5960784314, blue: 0.6039215686, alpha: 1)   // 149,152,154
        static let timeText         = #colorLiteral(red: 0.1490196078, green: 0.4549019608, blue: 0.8549019608, alpha: 1)   // 38,116,218
        static let viewBg           = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)   // EEEEEE
        static let messageBorder    = #colorLiteral(red: 0.2588235294, green: 0.5882352941, blue: 0.9843137255, alpha: 1)   // 176,189,208
        static let orange           = #colorLiteral(red: 0.9176470588, green: 0.5019607843, blue: 0.1921568627, alpha: 1)   // EA8031
        static let clear            = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)   // 0,0,0 alpha-0
        static let green            = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)   // 34C759
        
        
        
        static let redSwipeStart    = #colorLiteral(red: 0.8666666667, green: 0.1411764706, blue: 0.462745098, alpha: 1)    //#dd2476
        static let redSwipeMiddle   = #colorLiteral(red: 0.9803921569, green: 0.4, blue: 0.2862745098, alpha: 1)    //#FA6649
        static let redSwipeEnd      = #colorLiteral(red: 1, green: 0.3176470588, blue: 0.1843137255, alpha: 1)    //#ff512f
        
        static let blueSwipeStart   = #colorLiteral(red: 0.6196078431, green: 0.8666666667, blue: 0.9568627451, alpha: 1)   //#9EDDF4
        static let blueSwipeMiddle  = #colorLiteral(red: 0.7607843137, green: 0.9098039216, blue: 0.9647058824, alpha: 1)   //#C2E8F6
        static let blueSwipeEnd     = #colorLiteral(red: 0.8196078431, green: 0.9176470588, blue: 0.9529411765, alpha: 1)   //#D1EAF3
        static let blueSwipeEnd2    = #colorLiteral(red: 0.8196078431, green: 0.9176470588, blue: 0.9529411765, alpha: 0.5)   //#D1EAF3 50%
        
        static let bluelight        = #colorLiteral(red: 0.8196078431, green: 0.9176470588, blue: 0.9529411765, alpha: 0.7505822592)   //#D1EAF3
        
        static let headerBgColor    = #colorLiteral(red: 0.9411764706, green: 0.9568627451, blue: 0.9647058824, alpha: 1)   //#F0F4F6
        
        //===== STATUS COLOR =======
        static let greenStatus      = #colorLiteral(red: 0.4666666667, green: 0.7647058824, blue: 0.2666666667, alpha: 1)   // #77C344
        static let yellowStatus     = #colorLiteral(red: 0.9725490196, green: 0.8, blue: 0.2745098039, alpha: 1)   // #F8CC46
        static let redStatus        = #colorLiteral(red: 0.9882352941, green: 0.05098039216, blue: 0.1058823529, alpha: 1)   // #FC0D1B
        static let defaultStatus    = #colorLiteral(red: 0.2588235294, green: 0.5882352941, blue: 0.9843137255, alpha: 1)   // #4296FB
        
        static let greenTimer       = #colorLiteral(red: 0.5058823529, green: 1, blue: 0.5137254902, alpha: 1)   // #81FF83
        
        static let lightGrayBgColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 0.4)   //#EEEEEE
     
        static let lightRed         = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.1018400887)     // 255,0,0 10%
    }
    
    // MARK: - Font Constant -
    struct Font {
        static let avenirBlack          = "Avenir-Black"
        static let avenirBook           = "Avenir-Book"
        static let avenirHeavy          = "Avenir-Heavy"
        static let avenirLight          = "Avenir-Light"
        static let avenir               = "Avenir"
        static let avenirMedium         = "Avenir-Medium"
        static let avenirRoman          = "Avenir-Roman"
        static let avenirLtstdBlack     = "AvenirLTStd-Black"
        static let avenirLtstdBook      = "AvenirLTStd-Book"
        static let avenirLtstdHeavy     = "AvenirLTStd-Heavy"
        static let avenirLtstdLight     = "AvenirLTStd-Light"
        static let avenirLtstdMedium    = "AvenirLTStd-Medium"
        static let avenirLtstdRoman     = "AvenirLTStd-Roman"
        static let avenirLtstdOblique   = "AvenirLTStd-Oblique"
        static let avenirNextBold       = "AvenirNext-Bold"
        static let avenirNextDemiBold    = "AvenirNext-DemiBold"
        static let avenirNextMedium      = "AvenirNext-Medium"
        
    }
    
    struct Size {
        
        static let Size_8:CGFloat = 8
        static let Size_10:CGFloat = 10
        static let Size_11:CGFloat = 11
        static let Size_12:CGFloat = 12
        static let Size_13:CGFloat = 13
        static let Size_14:CGFloat = 14
        static let Size_15:CGFloat = 15
        static let Size_16:CGFloat = 16
        static let Size_17:CGFloat = 17
        static let Size_18:CGFloat = 18
        static let Size_19:CGFloat = 19
        static let Size_20:CGFloat = 20
        static let Size_21:CGFloat = 21
        static let Size_22:CGFloat = 22
        static let Size_23:CGFloat = 23
        static let Size_24:CGFloat = 24
        static let Size_25:CGFloat = 25
        static let Size_26:CGFloat = 26
        static let Size_27:CGFloat = 27
        static let Size_28:CGFloat = 28
        static let Size_29:CGFloat = 29
        static let Size_30:CGFloat = 30
        static let Size_31:CGFloat = 31
        static let Size_32:CGFloat = 32
        static let Size_33:CGFloat = 33
        static let Size_34:CGFloat = 34
        static let Size_35:CGFloat = 35
        static let Size_36:CGFloat = 36
        static let Size_37:CGFloat = 37
        static let Size_38:CGFloat = 38
        static let Size_39:CGFloat = 39
        static let Size_40:CGFloat = 40
        static let Size_42:CGFloat = 42
        static let Size_45:CGFloat = 45
        static let Size_48:CGFloat = 48
        static let Size_50:CGFloat = 50
        static let Size_58:CGFloat = 58
        
    }
}




