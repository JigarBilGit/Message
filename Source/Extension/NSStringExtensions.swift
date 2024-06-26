//
//
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2021 Billiyo Mac. All rights reserved.
//

import UIKit
import Foundation

extension String {
    
    var appendLagKeyUrlstring : String {
        return ""
    }
    
    var localize : String {
        return LocalizeHelper.shared.localizedString(forKey:self)
    }
    
    func dateChangeformat(strFrom:String,strTo:String)-> String{
        if self.isEmpty {
            return ""
        }else{
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = strTo
            if let aDate = dateFormater.date(from: self){
                dateFormater.dateFormat = strFrom
                return dateFormater.string(from: aDate)
            }else{
                return ""
            }
        }        
    }
    
    func dateChangeformatWithZone(strTo:String,strFrom:String)-> String{
        if self.isEmpty {
            return ""
        }else{
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = strTo
            dateFormater.timeZone = TimeZone(abbreviation: "EST")
            
            if let aDate = dateFormater.date(from: self){
                dateFormater.dateFormat = strFrom
                dateFormater.timeZone = TimeZone.current
                return dateFormater.string(from: aDate)
            }else{
                return ""
            }
        }
    }
    
    func dateFromString(strTo:String)-> Date{
        if self.isEmpty {
            return Date()
        }else{
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = strTo
            if let aDate = dateFormater.date(from: self){
                return aDate
            }else{
                return Date()
            }
        }
    }
    
    
    
    /*func isValidString(_ string: String, _ type: Global.kStringType) -> Bool {
     var charSet: CharacterSet?
     if type == Global.kStringType.AlphaNumeric {
     charSet = self.regexForAlphaNumeric()
     }
     else if type == Global.kStringType.AlphabetOnly {
     charSet = self.regexForAlphabetsOnly()
     }
     else if type == Global.kStringType.NumberOnly {
     charSet = self.regexForNumbersOnly()
     }
     else if type == Global.kStringType.patientFullName {
     charSet = self.regexForFullnameOnly()
     }
     else if type == Global.kStringType.Username {
     charSet = self.regexForUsernameOnly()
     }
     else if type == Global.kStringType.Email {
     charSet = self.regexForEmail()
     }
     else if type == Global.kStringType.PhoneNumber {
     charSet = self.regexForPhoneNumber()
     }
     else {
     return true
     }
     
     let isValid: Bool = !(self.isValidStringForCharSet(string, charSet: charSet!).characters.count == 0)
     return isValid
     }*/
    
    func isValidStringForCharSet(_ string: String, charSet: CharacterSet) -> String {
        var strResult: String = ""
        let scanner = Scanner(string: string)
        var strScanResult : NSString?
        
        scanner.charactersToBeSkipped = nil
        
        while !scanner.isAtEnd {
            if scanner.scanUpToCharacters(from: charSet, into: &strScanResult) {
                strResult = strResult + (strScanResult! as String)
            }
            else {
                if !scanner.isAtEnd {
                    scanner.scanLocation = scanner.scanLocation + 1
                }
            }
        }
        return strResult
    }
    
    func regexForAlphabetsOnly() -> CharacterSet {
        let regex: CharacterSet = CharacterSet(charactersIn: "\n_!@#$%^&*()[]{}'\".,<>:;|\\/?+=\t~`-1234567890 ")
        return regex
    }
    
    func regexForNumbersOnly() -> CharacterSet {
        let regex: CharacterSet = CharacterSet(charactersIn: "1234567890").inverted
        return regex
    }
    
    func regexForAlphaNumeric() -> CharacterSet {
        let regex = CharacterSet(charactersIn: " \n_!@#$%^&*()[ ]{}'\".,<>:;|\\/?+=\t~`")
        return regex
    }
    
    func regexForFullnameOnly() -> CharacterSet {
        let regex: CharacterSet = CharacterSet(charactersIn: "\n_!@#$%^&*()[]{}'\".,<>:;|\\/?+=\t~`-1234567890")
        return regex
    }
    
    func regexForUsernameOnly() -> CharacterSet {
        let regex: CharacterSet = CharacterSet(charactersIn: "\n!@#$%^&*()[]{}'\".,<>:;|\\/?+=\t~` ")
        return regex
    }
    
    func regexForPhoneNumber() -> CharacterSet {
        let regex: CharacterSet = CharacterSet(charactersIn: "1234567890").inverted
        return regex
    }
    
    func regexForEmail() -> CharacterSet {
        let regex: CharacterSet = CharacterSet(charactersIn: "\n!#$^&*()[ ]{}'\",<>:;|\\/?=\t~`")
        return regex
    }
    
    
    /// Get digit
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    var keepNumericsOnly: String {
        return self.components(separatedBy: CharacterSet(charactersIn: "0123456789+-:")).joined(separator: "")
    }
    
    /// Check if string contains one or more letters.
    public var hasLetters: Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }
    
    /// Check if string contains one or more numbers.
    public var hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }
    
    /// Check if string contains only letters.
    public var isAlphabetic: Bool {
        return  hasLetters && !hasNumbers
    }
    
    /// Check if string contains at least one letter and one number.
    public var isAlphaNumeric: Bool {
        return components(separatedBy: CharacterSet.alphanumerics).joined(separator: "").count == 0 && hasLetters && hasNumbers
    }
    
    /// Check if string contains only numbers.
    public var isNumeric: Bool {
        return !hasLetters && hasNumbers
    }
    
    /// Check if string is valid Email address or not.
    public var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    func validatePassword() -> Bool {
        let regExPattern = "((?=.*\\d)(?=.*[a-zA-Z]).{8,})"
        let passwordValid = NSPredicate(format:"SELF MATCHES %@", regExPattern)
        let boolValidator = passwordValid.evaluate(with: self)
        return boolValidator
    }
    
    /// Check if string starts with substring.
    ///
    /// - Parameters:
    ///   - suffix: substring to search if string starts with.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string starts with substring.
    public func start(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasPrefix(prefix.lowercased())
        }
        return hasPrefix(prefix)
    }
    
    /// Check if string ends with substring.
    ///
    /// - Parameters:
    ///   - suffix: substring to search if string ends with.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string ends with substring.
    public func end(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasSuffix(suffix.lowercased())
        }
        return hasSuffix(suffix)
    }
    
    /// Check if string contains one or more instance of substring.
    ///
    /// - Parameters:
    ///   - string: substring to search for.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string contains one or more instance of substring.
    public func contain(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }
    
    /// Check if string is https URL.
    public var isHttpsUrl: Bool {
        guard start(with: "https://".lowercased()) else {
            return false
        }
        return URL(string: self) != nil
    }
    
    /// Check if string is http URL.
    public var isHttpUrl: Bool {
        guard start(with: "http://".lowercased()) else {
            return false
        }
        return URL(string: self) != nil
    }
}

extension String {
    
    func firstcharacter(_ str:String)->String{
        if(str.count >= 1){
            return str.substring(with: (str.index(str.startIndex, offsetBy: 0) ..< str.index(str.endIndex, offsetBy: 1-str.count))).capitalized
        }
        return str.capitalized
    }
    
    func toBool() -> Bool {
        switch self {
        case "True", "true", "yes", "1","success":
            return false
        case "False", "false", "no", "0","error":
            return true
        default:
            return false
        }
    }
    
    func toDouble() -> Double {
        if let unwrappedNum = Double(self) {
            return unwrappedNum
        } else {
            // Handle a bad number
            print("Error converting \"" + self + "\" to Double")
            return 0.0
        }
    }
    
    func toCurrencyString_$() -> String {
        if let unwrappedNum = Double(self) {
            return String(format: "$ %.2f",unwrappedNum)
        } else {
            print("Error converting \"" + self + "\" to Double")
            return String(format: "$ %.2f",0.0)
        }
    }
    
    func toCurrencyString_USD() -> String {
        if let unwrappedNum = Double(self) {
            return String(format: "%.2f USD",unwrappedNum)
        } else {
            print("Error converting \"" + self + "\" to Double")
            return String(format: "%.2f USD",0.0)
        }
    }
    
    func filter(_ pred: (Character) -> Bool) -> String {
        var res = String()
        for c in self {
            if pred(c) {
                res.append(c)
            }
        }
        return res
    }
    func replace(_ string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
        
    func isAlphanumeric() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil && self != ""
    }
    
    func isAlphanumeric(ignoreDiacritics: Bool = false) -> Bool {
        if ignoreDiacritics {
            return self.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil && self != ""
        }
        else {
            return self.isAlphanumeric()
        }
    }
    
    /**
     Title:-  (Password at least eight characters long, one special characters, one uppercase, one lower case letter and one digit)
     */
    var isValidateSocialPassword : Bool {
        if(self.count>=8){ // && self.count<=20
        }else{
            return false
        }
        let nonUpperCase = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
        let letters = self.components(separatedBy: nonUpperCase)
        let strUpper: String = letters.joined()
        
        let smallLetterRegEx  = ".*[a-z]+.*"
        let samlltest = NSPredicate(format:"SELF MATCHES %@", smallLetterRegEx)
        let smallresult = samlltest.evaluate(with: self)
        
        let numberRegEx  = ".*[0-9]+.*"
        let numbertest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = numbertest.evaluate(with: self)
        
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: NSRegularExpression.Options())
        var isSpecial :Bool = false
        if regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, self.count)) != nil {
            print("could not handle special characters")
            isSpecial = true
        }else{
            isSpecial = false
        }
        return (strUpper.count >= 1) && smallresult && numberresult && isSpecial
    }
    
    var isValidPassword: Bool {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?#&])[A-Za-z\\d$@$!%*?#&]{8,}"
        let isMatched = NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: self)
        if(isMatched  == true) {
            return true
        }  else {
            return false
        }
    }
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@","^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[-#$%^&*,+!@?=:/.();\\]\\'<>{\\[\\}_|~`])[A-Za-z0-9-#$%^&*,+!@?=:/.();\\]\\'<>{\\[\\}_|~`]{7,}")
        return passwordTest.evaluate(with: password)
        
    }
    
    var isAcceptedZeroDegitPhone: Bool {
        let str = self.replace("0", replacement:"")
        if str.count == 0 {
            return false
        }else{
            return true
        }
    }
    
    public var trimWhitespace: String {
        let trimmedString = self.trimmingCharacters(in: .whitespaces)
        return trimmedString
    }
    
    /// String with no spaces or new lines in beginning and end.
    public var trimmed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// String decoded from base64  (if applicable).
    public var base64Decoded: String? {
        // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
        guard let decodedData = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: decodedData, encoding: .utf8)
    }
    
    /// String encoded in base64 (if applicable).
    public var base64Encoded: String? {
        // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
        let plainData = self.data(using: .utf8)
        return plainData?.base64EncodedString()
    }
    
    /// This method will replace the string with other string.
    ///
    /// - Parameters:
    ///   - string: String which you wanted to replace.
    ///   - withString: String by which you want to replace 1st string.
    /// - Returns: Returns new string by replacing string
    public func replace(string: String, withString: String) -> String {
        return self.replacingOccurrences(of: string, with: withString)
    }
    
    /// Array with unicodes for all characters in a string.
    public var unicodeArray: [Int] {
        return unicodeScalars.map({$0.hashValue})
    }
    
    /// Readable string from a URL string.
    public var urlDecoded: String {
        return removingPercentEncoding ?? self
    }
    
    /// URL escaped string.
    public var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
    
    
    /// Float32 value from string (if applicable).
    public var float32: Float32? {
        let formatter = NumberFormatter()
        return formatter.number(from: self) as? Float32
    }
    
    /// Float64 value from string (if applicable).
    public var float64: Float64? {
        let formatter = NumberFormatter()
        return formatter.number(from: self) as? Float64
    }
    
    /// Integer value from string (if applicable).
    public var int: Int? {
        return Int(self)
    }
    
    /// Int16 value from string (if applicable).
    public var int16: Int16? {
        return Int16(self)
    }
    
    /// Int32 value from string (if applicable).
    public var int32: Int32? {
        return Int32(self)
    }
    
    /// Int64 value from string (if applicable).
    public var int64: Int64? {
        return Int64(self)
    }
    
    /// Int8 value from string (if applicable).
    public var int8: Int8? {
        return Int8(self)
    }
    
    /// URL from string (if applicable).
    public var url: URL? {
        return URL(string: self)
    }
    
    /// First character of string (if applicable).
    public var firstCharacter: String? {
        guard let aFirst = self.first else {
            return nil
        }
        return String(aFirst)
    }
    
    /// Last character of string (if applicable).
    public var lastCharacter: String? {
        guard let aLast = self.last else {
            return nil
        }
        return String(aLast)
    }
    
    /// This will remove all the other Characters except the numbers.
    public var removeExceptDigits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
}

extension String {
    func specialPriceAttributedStringWith(_ color: UIColor) -> NSMutableAttributedString {
        let attributes = [NSAttributedString.Key.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int), .foregroundColor: color, .font: fontForPrice()]
        return NSMutableAttributedString(attributedString: NSAttributedString(string: self, attributes: attributes))
    }
    
    func priceAttributedStringWith(_ color: UIColor) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.foregroundColor: color, .font: fontForPrice()]
        
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    func priceAttributedString(_ color: UIColor) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.foregroundColor: color]
        
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    fileprivate func fontForPrice() -> UIFont {
        return UIFont(name: "Helvetica-Neue", size: 13) ?? UIFont()
    }
}

extension String {
    public var replaceSpecialCharacter: String? {
        if self.contain("'") {
            return self.replace("'", replacement: "''")
        }
        return self
    }
}

extension String {
    var html2Attributed: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }

    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }

    func convertToAttributedString() -> NSAttributedString? {
        let modifiedFontString = "<span style=\"font-family: Avenir-Medium; font-size: 18\">" + self + "</span>"
        return modifiedFontString.htmlToAttributedString
    }
}

extension NSMutableAttributedString {
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}

extension String {
    func removeCharacters(from forbiddenChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }

    func removeCharacters(from: String) -> String {
        return removeCharacters(from: CharacterSet(charactersIn: from))
    }
}
