//
//  StrinfExtension.swift
//  Billiyo Clinical
//
//  Created by Billiyo Health on 27/07/21.
//

import Foundation
import UIKit


extension String{
    var length: Int {
        return self.count
    }
    
    
    func checkStringEmpty(string:String) -> String{
        let checkString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        return checkString
    }
    
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0", "":
            return false
        default:
            return nil
        }
    }
    
    func toIntBool() -> Int?{
        switch self {
        case "True", "true", "yes", "1":
            return 1
        case "False", "false", "no", "0", "":
            return 0
        default:
            return nil
        }
    }
    
    func stringToInt64() -> Int64{
        if let number = Int64(self) {
            return number
        }else{
            /* string isn't an Int64, handle error here */
            return 0
        }
    }
    
    func stringToInt() -> Int{
        if let number = Int(self) {
            return number
        }else{
            /* string isn't an Int64, handle error here */
            return 0
        }
    }
    
    func stringToDouble() -> Double {
        if let number = Double(self){
            return number
        }else{
            return 0.0
        }
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    func height(withWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func setRequiredText(setRequiredString colorToString: String) -> NSMutableAttributedString{
        let range = (self as NSString).range(of: colorToString)
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
        return attributedString
    }
    
    func slice(from: String, to: String) -> String? {
        guard let rangeFrom = range(of: from)?.upperBound else { return nil }
        guard let rangeTo = self[rangeFrom...].range(of: to)?.lowerBound else { return nil }
        return String(self[rangeFrom..<rangeTo])
    }
    
    func sliceMultipleTimes(from: String, to: String) -> [String] {
        components(separatedBy: from).dropFirst().compactMap { sub in
            (sub.range(of: to)?.lowerBound).flatMap { endRange in
                String(sub[sub.startIndex ..< endRange])
            }
        }
    }
        
    func replaceDefineCharacter(string:String) -> String{
        let finalString = string.replacingOccurrences(of: "\\n", with: "\n")
        return finalString
    }
    
    func htmlAttributedString(size: CGFloat) -> NSAttributedString? {
        // Below link for refrence
        // https://github.com/malcommac/SwiftRichString
        
        let boldStyle = Style {
            $0.font = UIFont(name: MessageTheme.Font.avenirNextDemiBold, size: size)!
            if #available(iOS 11.0, *) {
                $0.dynamicText = DynamicText {
                    $0.style = .body
                    $0.maximumSize = 35.0
                    $0.traitCollection = UITraitCollection(userInterfaceIdiom: .phone)
                }
            }
        }
        
        let spanStyle = Style {
            $0.font = UIFont(name: MessageTheme.Font.avenirMedium, size: size)!
            $0.color = MessageTheme.Color.primaryTheme
        }
        
        let italicStyle = Style {
            $0.font = UIFont(name: MessageTheme.Font.avenirLtstdOblique, size: size)!
        }
        
        let italicBlueStyle = Style {
            $0.font = UIFont(name: MessageTheme.Font.avenirLtstdOblique, size: size)!
            $0.color = MessageTheme.Color.primaryTheme
        }
        
        let supStyle = Style {
            $0.font = UIFont(name: MessageTheme.Font.avenirMedium, size: size / 1.2)
            $0.baselineOffset = Float(size) / 3.5
        }
        
        let subStyle = Style {
            $0.font = UIFont(name: MessageTheme.Font.avenirMedium, size: size / 1.2)
            $0.baselineOffset = -(Float(size) / 3.5)
        }
        
        let requiredStyle = Style {
            $0.color = MessageTheme.Color.defaultRed
        }
        
        let disableStyle = boldStyle.byAdding {
            $0.font = UIFont(name: MessageTheme.Font.avenirMedium, size: size)!
            $0.color = MessageTheme.Color.lightGray
        }
        
        let strikeStyle = boldStyle.byAdding {
            //$0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            $0.font = UIFont(name: MessageTheme.Font.avenirMedium, size: size)!
            $0.color = self.color
            $0.strikethrough = (.single, self.color)
            $0.baselineOffset = 0
        }
        
        let smartOptionValueStyle = boldStyle.byAdding {
            $0.font = UIFont(name: MessageTheme.Font.avenirMedium, size: size)!
            $0.color = MessageTheme.Color.primaryTheme
        }
        
        let smartOptionKeyStyle = boldStyle.byAdding {
            $0.font = UIFont(name: MessageTheme.Font.avenirMedium, size: size)!
            $0.color = MessageTheme.Color.primaryTheme
        }
        
        let smartOptionRequiredKeyStyle = boldStyle.byAdding {
            $0.font = UIFont(name: MessageTheme.Font.avenirMedium, size: size)!
            $0.color = MessageTheme.Color.defaultRed
        }
        

        let underLineStyle = Style {
            $0.font = UIFont(name: MessageTheme.Font.avenirMedium, size: size)!
            $0.color = MessageTheme.Color.black
            $0.underline = (.single, MessageTheme.Color.black)
            $0.alignment = .center
            $0.baselineOffset = 2.0
        }
                
        // And a group of them
        let styleGroup = StyleGroup(base: Style {
            $0.font = UIFont(name: MessageTheme.Font.avenirMedium, size: size)!
            }, [
                "b": boldStyle,
                "i": italicStyle,
                "iBlue": italicBlueStyle,
                "sup": supStyle,
                "sub": subStyle,
                "required":requiredStyle,
                "strike": strikeStyle,
                "smartOptionValue" : smartOptionValueStyle,
                "smartOptionKey" : smartOptionKeyStyle,
                "smartOptionRequiredKey" : smartOptionRequiredKeyStyle,
                "span" : spanStyle,
                "disable" : disableStyle,
                "u" : underLineStyle,])
        
        return self.set(style: styleGroup)

    }
    
    func stripFileExtension ( _ filename: String ) -> String {
        var components = filename.components(separatedBy: ".")
        guard components.count > 1 else { return filename }
        components.removeLast()
        return components.joined(separator: ".")
    }
    
        
}


extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}


extension UIColor {
    var hexString:String? {
        if let components = self.cgColor.components {
            let r = components[0]
            let g = components[1]
            let b = components[2]
            return  String(format: "#%02x%02x%02x", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
        }
        return nil
    }
}



extension NSAttributedString {

    func height(containerWidth: CGFloat) -> CGFloat {

        let rect = self.boundingRect(with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude),
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     context: nil)
        return ceil(rect.size.height)
    }

    func width(containerHeight: CGFloat) -> CGFloat {

        let rect = self.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: containerHeight),
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     context: nil)
        return ceil(rect.size.width)
    }
}
