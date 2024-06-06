//
//  DateExtension.swift
//  Billiyo Clinical
//
//  Created by Billiyo Health on 17/08/21.
//

import Foundation

// MARK: - Date Extension

extension Date {
    

    var thirdWeekStartDateFromCurrentWeek : Int64 {
        
        let UTCDate = Calendar.current.date(byAdding: .day, value: 12, to: startOfWeek)!
        let strDate = MessageManager.shared.dateFormatterCurrentMMDDYYYY().string(from:UTCDate)
        
        let strFinalDateMax = "\(strDate) 11:59 PM +0000"
        let currentDateMax = MessageManager.shared.getTimeStampHHMM24hFrom(strDate: strFinalDateMax)
        
       return currentDateMax
    }
    
    //==== Start Week with SUNDAY ====
    var startOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .day, value: 1, to: sunday!)!
    }
    
    var secondsFromGMT: Int {
        return TimeZone.current.secondsFromGMT()
        
    }
    
    var miliSecondsFromGMT: Int64 {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int64(since1970 * 1000)
        
    }

    func currentTimeZoneDate(date : Date, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func TimeStempToCST(timestamp:Int64, toFormat: String) -> String {
        
        let unixTime = TimeInterval(timestamp) / 1000
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "CST")
        // dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toFormat
        let localDate = dateFormatter.string(from: date)
        return localDate
        
    }
    
    func TimeStempToCurrent(timestamp:Int64, toFormat: String) -> String {
        
        let unixTime = TimeInterval(timestamp) / 1000
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
         dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toFormat
        let localDate = dateFormatter.string(from: date)
        return localDate
        
    }
    
    func getUnixTimeForCurrentDate() -> Int64 {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a Z"
        let currentDateAndTime = dateFormatter.string(from: date)
        let unixDate = self.getUnixDateWithCSTTimeZone(strDate: currentDateAndTime)
        return unixDate
    }
    
    func UTCToCST(passedDate : Date, incomingFormat: String, outGoingFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = outGoingFormat

        return dateFormatter.string(from: passedDate)
      }
    
    func getUnixDateWithCSTTimeZone(strDate : String) -> Int64 {
        let arrCurrentDate = strDate.components(separatedBy: " ")
        
        let cstDateFormatter = DateFormatter()
        cstDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        cstDateFormatter.dateFormat = "MM/dd/yyyy hh:mm a Z"
        cstDateFormatter.timeZone = TimeZone.init(identifier: "CST")
        
        let date = cstDateFormatter.date(from: strDate)
        let cstDateString = cstDateFormatter.string(from: date!)
        let arrCSTDate = cstDateString.components(separatedBy: " ")
        var arrFinalDate = arrCurrentDate
        _ = arrFinalDate.remove(at: arrFinalDate.count - 1)
        arrFinalDate.append(arrCSTDate[arrCSTDate.count - 1])
        let strConvetedDate = arrFinalDate.joined(separator: " ")
        let dateFormatter2 = DateFormatter()
        dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter2.dateFormat = "MM/dd/yyyy hh:mm a Z"
        dateFormatter2.timeZone = .current
        let finalDate = dateFormatter2.date(from: strConvetedDate)
        return Int64(finalDate!.timeIntervalSince1970 * 1000)
    }
    
    func getUnixDateWithCSTTimeZoneWithMiliSeconds(strDate : String) -> Int64 {
        let arrCurrentDate = strDate.components(separatedBy: " ")
        
        let cstDateFormatter = DateFormatter()
        cstDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        cstDateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a Z"
        cstDateFormatter.timeZone = TimeZone.init(identifier: "CST")
        
        let date = cstDateFormatter.date(from: strDate)
        let cstDateString = cstDateFormatter.string(from: date!)
        let arrCSTDate = cstDateString.components(separatedBy: " ")
        var arrFinalDate = arrCurrentDate
        _ = arrFinalDate.remove(at: arrFinalDate.count - 1)
        arrFinalDate.append(arrCSTDate[arrCSTDate.count - 1])
        let strConvetedDate = arrFinalDate.joined(separator: " ")
        let dateFormatter2 = DateFormatter()
        dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter2.dateFormat = "MM/dd/yyyy hh:mm:ss a Z"
        dateFormatter2.timeZone = .current
        let finalDate = dateFormatter2.date(from: strConvetedDate)
        return Int64(finalDate!.timeIntervalSince1970 * 1000)
    }
    
    
    func getUnixDateWithCSTTimeZoneMMDDYYYY(strDate : String) -> Int64 {
        let arrCurrentDate = strDate.components(separatedBy: " ")
        
        let cstDateFormatter = DateFormatter()
        cstDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        cstDateFormatter.dateFormat = "MM/dd/yyyy Z"
        cstDateFormatter.timeZone = TimeZone.init(identifier: "CST")
        
        let date = cstDateFormatter.date(from: strDate)
        let cstDateString = cstDateFormatter.string(from: date!)
        let arrCSTDate = cstDateString.components(separatedBy: " ")
        var arrFinalDate = arrCurrentDate
        _ = arrFinalDate.remove(at: arrFinalDate.count - 1)
        arrFinalDate.append(arrCSTDate[arrCSTDate.count - 1])
        let strConvetedDate = arrFinalDate.joined(separator: " ")
        let dateFormatter2 = DateFormatter()
        dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter2.dateFormat = "MM/dd/yyyy Z"
        dateFormatter2.timeZone = .current
        let finalDate = dateFormatter2.date(from: strConvetedDate)
        return Int64(finalDate!.timeIntervalSince1970 * 1000)
    }
    
    func convertUTCToCurrent(date : Date, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = toFormat
        dateFormatter.timeZone = Calendar.current.timeZone
        let timeStamp = dateFormatter.string(from: date)
        return timeStamp
    }
    
    func getNextHoursTime(hours: Int, dateFormat: String, strDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = dateFormat
        let myDate = dateFormatter.date(from: strDate)!
        let nextHrsDate = Calendar.current.date(byAdding: .hour, value: hours, to: myDate)
        let dateString = dateFormatter.string(from: nextHrsDate!)
        let resultDate = dateFormatter.date(from: dateString)
        return resultDate!
    }
    
    func getNextMinutesTime(minutes: Int, dateFormat: String, strDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = dateFormat
        let myDate = dateFormatter.date(from: strDate)!
        let nextMinutsDate = Calendar.current.date(byAdding: .minute, value: minutes, to: myDate)
        let dateString = dateFormatter.string(from: nextMinutsDate!)
        let resultDate = dateFormatter.date(from: dateString)
        return resultDate!
    }
    
    func getNextOrPreviousThirtyDays(days: Int, dateFormat: String, myDate: Date)-> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = dateFormat
        //let myDate = dateFormatter.date(from: strDate)!
        let nextMinutsDate = Calendar.current.date(byAdding: .day, value: days, to: myDate)
        let dateString = dateFormatter.string(from: nextMinutsDate!)
        let resultDate = dateFormatter.date(from: dateString)
        return resultDate!
    }
    
    
    func getTimeDifferanceBetweenDates(dateFormat: String, strStartDate : String, strEndDate: String ) -> Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //dateFormatter.timeZone = TimeZone(abbreviation: "CST")
        // dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = dateFormat
        
        let startDate = dateFormatter.date(from: strStartDate)!
        let endDate = dateFormatter.date(from: strEndDate)!
        
        let elapsedTime = startDate.timeIntervalSince(endDate)
        // convert from seconds to hours, rounding down to the nearest hour
        let hours = floor(elapsedTime / 60 / 60)
        // we have to subtract the number of seconds in hours from minutes to get
        // the remaining minutes, rounding down to the nearest minute (in case you
        // want to get seconds down the road)
        //let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
        
        let minutes = floor(elapsedTime / 60 )
        print("\(Int(hours)) hr and \(Int(minutes)) min")
        
        return Int(minutes)
    }
    
    func startOfHour() -> Date?{
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.minute = 0
        components.second = 0
        return calendar.date(from: components)
    }
}


extension Date {
    
    static func today() -> Date {
        return Date()
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.next, weekday, considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
        nextDateComponent.weekday = searchWeekdayIndex
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
}

extension Date {
    
    func getUnixDateWithCSTMMDDYYYYTimeZone(strDate : String) -> Int64 {
        
        let arrCurrentDate = strDate.components(separatedBy: " ")
        
        let cstDateFormatter = DateFormatter()
        cstDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        cstDateFormatter.dateFormat = "MM/dd/yyyy"
        cstDateFormatter.timeZone = TimeZone.init(identifier: "CST")
        
        let date = cstDateFormatter.date(from: strDate)
        let cstDateString = cstDateFormatter.string(from: date!)
        let arrCSTDate = cstDateString.components(separatedBy: " ")
        var arrFinalDate = arrCurrentDate
        _ = arrFinalDate.remove(at: arrFinalDate.count - 1)
        arrFinalDate.append(arrCSTDate[arrCSTDate.count - 1])
        let strConvetedDate = arrFinalDate.joined(separator: " ")
        let dateFormatter2 = DateFormatter()
        dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter2.dateFormat = "MM/dd/yyyy"
        dateFormatter2.timeZone = .current
        let finalDate = dateFormatter2.date(from: strConvetedDate)
        return Int64(finalDate!.timeIntervalSince1970 * 1000)
    }
    
    func getUnixDateWithCurrentMMDDYYYYTimeZone(strDate : String) -> Int64 {
        let dateFormatter2 = DateFormatter()
        dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter2.dateFormat = "MM/dd/yyyy"
        dateFormatter2.timeZone = .current
        let finalDate = dateFormatter2.date(from: strDate)
        return Int64(finalDate!.timeIntervalSince1970 * 1000)
    }
    
    func getTimeDifferenceBetweenDates(dateFormat: String, strStartDate : String, strEndDate: String ) -> Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //dateFormatter.timeZone = TimeZone(abbreviation: "CST")
        // dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = dateFormat
        
        let startDate = dateFormatter.date(from: strStartDate)!
        let endDate = dateFormatter.date(from: strEndDate)!
        
        let elapsedTime = startDate.timeIntervalSince(endDate)
            // convert from seconds to hours, rounding down to the nearest hour
            let hours = floor(elapsedTime / 60 / 60)
            // we have to subtract the number of seconds in hours from minutes to get
            // the remaining minutes, rounding down to the nearest minute (in case you
            // want to get seconds down the road)
            //let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
        
            let minutes = floor(elapsedTime / 60 )
            print("\(Int(hours)) hr and \(Int(minutes)) min")
        
        return Int(minutes)
    }
}

public extension Date {
    
    /// Day name format.
    ///
    /// - threeLetters: 3 letter day abbreviation of day name.
    /// - oneLetter: 1 letter day abbreviation of day name.
    /// - full: Full day name.
    enum DayNameStyle {
        case threeLetters
        case oneLetter
        case full
    }
    
    /// Month name format.
    ///
    /// - threeLetters: 3 letter month abbreviation of month name.
    /// - oneLetter: 1 letter month abbreviation of month name.
    /// - full: Full month name.
    enum MonthNameStyle {
        case threeLetters
        case oneLetter
        case full
    }
    
}

// MARK :-Properties
public extension Date {
    
    /// User’s current calendar.
    var calendar: Calendar {
        return Calendar.current
    }
    
    /// Era.
    ///
    ///        Date().era -> 1
    ///
    var era: Int {
        return Calendar.current.component(.era, from: self)
    }
    
    /// Quarter.
    var quarter: Int {
        return Calendar.current.component(.quarter, from: self)
    }
    
    /// Week of year.
    ///
    ///        Date().weekOfYear -> 2 // second week in the current year.
    ///
    var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }
    
    /// Week of month.
    ///
    ///        Date().weekOfMonth -> 2 // second week in the current month.
    ///
    var weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: self)
    }
    
    /// Year.
    ///
    ///        Date().year -> 2017
    ///
    ///        var someDate = Date()
    ///        someDate.year = 2000 // sets someDate's year to 2000
    ///
    var year: Int {
        get {
            return Calendar.current.component(.year, from: self)
        }
        set {
            let currentYear = Calendar.current.component(.year, from: self)
            let yearsToAdd = newValue - currentYear
            if let date = Calendar.current.date(byAdding: .year, value: yearsToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// Month.
    ///
    ///     Date().month -> 1
    ///
    ///     var someDate = Date()
    ///     someDate.year = 10 // sets someDate's month to 10.
    ///
    var month: Int {
        get {
            return Calendar.current.component(.month, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .month, value: newValue, of: self) {
                self = date
            }
        }
    }
    
    /// Day.
    ///
    ///     Date().day -> 12
    ///
    ///     var someDate = Date()
    ///     someDate.day = 1 // sets someDate's day of month to 1.
    ///
    var day: Int {
        get {
            return Calendar.current.component(.day, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .day, value: newValue, of: self) {
                self = date
            }
        }
    }
    
    /// Weekday.
    ///
    ///     Date().weekOfMonth -> 5 // fifth day in the current week.
    ///
    var weekday: Int {
        get {
            return Calendar.current.component(.weekday, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .weekday, value: newValue, of: self) {
                self = date
            }
        }
    }
    
    /// Hour.
    ///
    ///     Date().hour -> 17 // 5 pm
    ///
    ///     var someDate = Date()
    ///     someDate.day = 13 // sets someDate's hour to 1 pm.
    ///
    var hour: Int {
        get {
            return Calendar.current.component(.hour, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .hour, value: newValue, of: self) {
                self = date
            }
        }
    }
    
    /// Minutes.
    ///
    ///     Date().minute -> 39
    ///
    ///     var someDate = Date()
    ///     someDate.minute = 10 // sets someDate's minutes to 10.
    ///
    var minute: Int {
        get {
            return Calendar.current.component(.minute, from: self)
        }
        set {
            guard newValue >= 0 && newValue < 60 else { return }
            let currentMinutes = Calendar.current.component(.minute, from: self)
            let minutesToAdd = newValue - currentMinutes
            if let date = Calendar.current.date(byAdding: .minute, value: minutesToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// Seconds.
    ///
    ///     Date().second -> 55
    ///
    ///     var someDate = Date()
    ///     someDate. second = 15 // sets someDate's seconds to 15.
    ///
    var second: Int {
        get {
            return Calendar.current.component(.second, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .second, value: newValue, of: self) {
                self = date
            }
        }
    }
    
    /// Nanoseconds.
    ///
    ///     Date().nanosecond -> 981379985
    ///
    var nanosecond: Int {
        get {
            return Calendar.current.component(.nanosecond, from: self)
        }
        set {
            if let date = Calendar.current.date(bySetting: .nanosecond, value: newValue, of: self) {
                self = date
            }
        }
    }
    
    /// Milliseconds.
    var millisecond: Int {
        get {
            return Calendar.current.component(.nanosecond, from: self) / 1000000
        }
        set {
            let ns = newValue * 1000000
            if let date = Calendar.current.date(bySetting: .nanosecond, value: ns, of: self) {
                self = date
            }
        }
    }
    
    /// Check if date is in future.
    ///
    ///     Date(timeInterval: 100, since: Date()).isInFuture -> true
    ///
    var isInFuture: Bool {
        return self > Date()
    }
    
    /// Check if date is in past.
    ///
    ///     Date(timeInterval: -100, since: Date()).isInPast -> true
    ///
    var isInPast: Bool {
        return self < Date()
    }
    
    /// Check if date is in today.
    ///
    ///     Date().isInToday -> true
    ///
    var isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// Check if date is within yesterday.
    ///
    ///     Date().isInYesterday -> false
    ///
    var isInYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    /// Check if date is within tomorrow.
    ///
    ///     Date().isInTomorrow -> false
    ///
    var isInTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    /// Check if date is within a weekend period.
    var isInWeekend: Bool {
        return Calendar.current.isDateInWeekend(self)
    }
    
    /// Check if date is within a weekday period.
    var isInWeekday: Bool {
        return !Calendar.current.isDateInWeekend(self)
    }
    
    /// Check if date is within the current week.
    var isInThisWeek: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    /// Check if date is within the current month.
    var isInThisMonth: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
    /// Check if date is within the current year.
    var isInThisYear: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }
    
    /// ISO8601 string of format (yyyy-MM-dd'T'HH:mm:ss.SSS) from date.
    ///
    ///     Date().iso8601String -> "2017-01-12T14:51:29.574Z"
    ///
    var iso8601String: String {
        // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return dateFormatter.string(from: self).appending("Z")
    }
    
    /// Nearest five minutes to date.
    ///
    ///     var date = Date() // "5:54 PM"
    ///     date.minute = 32 // "5:32 PM"
    ///     date.nearestFiveMinutes // "5:30 PM"
    ///
    ///     date.minute = 44 // "5:44 PM"
    ///     date.nearestFiveMinutes // "5:45 PM"
    ///
    var nearestFiveMinutes: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let min = components.minute!
        components.minute! = min % 5 < 3 ? min - min % 5 : min + 5 - (min % 5)
        components.second = 0
        return Calendar.current.date(from: components)!
    }
    
    /// Nearest ten minutes to date.
    ///
    ///     var date = Date() // "5:57 PM"
    ///     date.minute = 34 // "5:34 PM"
    ///     date.nearestTenMinutes // "5:30 PM"
    ///
    ///     date.minute = 48 // "5:48 PM"
    ///     date.nearestTenMinutes // "5:50 PM"
    ///
    var nearestTenMinutes: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let min = components.minute!
        components.minute? = min % 10 < 6 ? min - min % 10 : min + 10 - (min % 10)
        components.second = 0
        return Calendar.current.date(from: components)!
    }
    
    /// Nearest quarter hour to date.
    ///
    ///     var date = Date() // "5:57 PM"
    ///     date.minute = 34 // "5:34 PM"
    ///     date.nearestQuarterHour // "5:30 PM"
    ///
    ///     date.minute = 40 // "5:40 PM"
    ///     date.nearestQuarterHour // "5:45 PM"
    ///
    var nearestQuarterHour: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let min = components.minute!
        components.minute! = min % 15 < 8 ? min - min % 15 : min + 15 - (min % 15)
        components.second = 0
        return Calendar.current.date(from: components)!
    }
    
    /// Nearest half hour to date.
    ///
    ///     var date = Date() // "6:07 PM"
    ///     date.minute = 41 // "6:41 PM"
    ///     date.nearestHalfHour // "6:30 PM"
    ///
    ///     date.minute = 51 // "6:51 PM"
    ///     date.nearestHalfHour // "7:00 PM"
    ///
    var nearestHalfHour: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let min = components.minute!
        components.minute! = min % 30 < 15 ? min - min % 30 : min + 30 - (min % 30)
        components.second = 0
        return Calendar.current.date(from: components)!
    }
    
    /// Nearest hour to date.
    ///
    ///     var date = Date() // "6:17 PM"
    ///     date.nearestHour // "6:00 PM"
    ///
    ///     date.minute = 36 // "6:36 PM"
    ///     date.nearestHour // "7:00 PM"
    ///
    var nearestHour: Date {
        if minute >= 30 {
            return beginning(of: .hour)!.adding(.hour, value: 1)
        }
        return beginning(of: .hour)!
    }
    
    /// Time zone used by system.
    ///
    ///        Date().timeZone -> Europe/Istanbul (current)
    ///
    var timeZone: TimeZone {
        return Calendar.current.timeZone
    }
    
    /// UNIX timestamp from date.
    ///
    ///        Date().unixTimestamp -> 1484233862.826291
    ///
    var unixTimestamp: Double {
        return timeIntervalSince1970
    }
    
}

// MARK :-Methods
public extension Date {
    
    /// Date by adding multiples of calendar component.
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     let date2 = date.adding(.minute, value: -10) // "Jan 12, 2017, 6:57 PM"
    ///     let date3 = date.adding(.day, value: 4) // "Jan 16, 2017, 7:07 PM"
    ///     let date4 = date.adding(.month, value: 2) // "Mar 12, 2017, 7:07 PM"
    ///     let date5 = date.adding(.year, value: 13) // "Jan 12, 2030, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: multiples of components to add.
    /// - Returns: original date + multiples of component added.
    func adding(_ component: Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self)!
    }
    
    /// Add calendar component to date.
    ///
    ///     var date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     date.add(.minute, value: -10) // "Jan 12, 2017, 6:57 PM"
    ///     date.add(.day, value: 4) // "Jan 16, 2017, 7:07 PM"
    ///     date.add(.month, value: 2) // "Mar 12, 2017, 7:07 PM"
    ///     date.add(.year, value: 13) // "Jan 12, 2030, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: multiples of compnenet to add.
    mutating func add(_ component: Calendar.Component, value: Int) {
        self = adding(component, value: value)
    }
    
    /// Date by changing value of calendar component.
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     let date2 = date.changing(.minute, value: 10) // "Jan 12, 2017, 6:10 PM"
    ///     let date3 = date.changing(.day, value: 4) // "Jan 4, 2017, 7:07 PM"
    ///     let date4 = date.changing(.month, value: 2) // "Feb 12, 2017, 7:07 PM"
    ///     let date5 = date.changing(.year, value: 2000) // "Jan 12, 2000, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: new value of compnenet to change.
    /// - Returns: original date after changing given component to given value.
    func changing(_ component: Calendar.Component, value: Int) -> Date? {
        return Calendar.current.date(bySetting: component, value: value, of: self)
    }
    
    /// Data at the beginning of calendar component.
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:14 PM"
    ///     let date2 = date.beginning(of: .hour) // "Jan 12, 2017, 7:00 PM"
    ///     let date3 = date.beginning(of: .month) // "Jan 1, 2017, 12:00 AM"
    ///     let date4 = date.beginning(of: .year) // "Jan 1, 2017, 12:00 AM"
    ///
    /// - Parameter component: calendar component to get date at the beginning of.
    /// - Returns: date at the beginning of calendar component (if applicable).
    func beginning(of component: Calendar.Component) -> Date? {
        switch component {
        case .second:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self))
            
        case .minute:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self))
            
        case .hour:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour], from: self))
            
        case .day:
            return Calendar.current.startOfDay(for: self)
            
        case .weekOfYear, .weekOfMonth:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
            
        case .month:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month], from: self))
            
        case .year:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.year], from: self))
            
        default:
            return nil
        }
    }
    
    /// Date at the end of calendar component.
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:27 PM"
    ///     let date2 = date.end(of: .day) // "Jan 12, 2017, 11:59 PM"
    ///     let date3 = date.end(of: .month) // "Jan 31, 2017, 11:59 PM"
    ///     let date4 = date.end(of: .year) // "Dec 31, 2017, 11:59 PM"
    ///
    /// - Parameter component: calendar component to get date at the end of.
    /// - Returns: date at the end of calendar component (if applicable).
    func end(of component: Calendar.Component) -> Date? {
        switch component {
        case .second:
            var date = adding(.second, value: 1)
            date = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date))!
            date.add(.second, value: -1)
            return date
            
        case .minute:
            var date = adding(.minute, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date))!
            date = after.adding(.second, value: -1)
            return date
            
        case .hour:
            var date = adding(.hour, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour], from: date))!
            date = after.adding(.second, value: -1)
            return date
            
        case .day:
            var date = adding(.day, value: 1)
            date = Calendar.current.startOfDay(for: date)
            date.add(.second, value: -1)
            return date
            
        case .weekOfYear, .weekOfMonth:
            var date = self
            let beginningOfWeek = Calendar.current.date(from:
                Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            date = beginningOfWeek.adding(.day, value: 7).adding(.second, value: -1)
            return date
            
        case .month:
            var date = adding(.month, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month], from: date))!
            date = after.adding(.second, value: -1)
            return date
            
        case .year:
            var date = adding(.year, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year], from: date))!
            date = after.adding(.second, value: -1)
            return date
            
        default:
            return nil
        }
    }
    
    /// Date string from date.
    ///
    ///     Date().dateString(ofStyle: .short) -> "1/12/17"
    ///     Date().dateString(ofStyle: .medium) -> "Jan 12, 2017"
    ///     Date().dateString(ofStyle: .long) -> "January 12, 2017"
    ///     Date().dateString(ofStyle: .full) -> "Thursday, January 12, 2017"
    ///
    /// - Parameter style: DateFormatter style (default is .medium).
    /// - Returns: date string.
    func dateString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
    
    /// Date and time string from date.
    ///
    ///     Date().dateTimeString(ofStyle: .short) -> "1/12/17, 7:32 PM"
    ///     Date().dateTimeString(ofStyle: .medium) -> "Jan 12, 2017, 7:32:00 PM"
    ///     Date().dateTimeString(ofStyle: .long) -> "January 12, 2017 at 7:32:00 PM GMT+3"
    ///     Date().dateTimeString(ofStyle: .full) -> "Thursday, January 12, 2017 at 7:32:00 PM GMT+03:00"
    ///
    /// - Parameter style: DateFormatter style (default is .medium).
    /// - Returns: date and time string.
    func dateTimeString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
    
    /// Date and time string from date.
    ///
    ///     Date().dateTimeString(ofStyle: .short) -> "1/12/17, 7:32 PM"
    ///     Date().dateTimeString(ofStyle: .medium) -> "Jan 12, 2017, 7:32:00 PM"
    ///     Date().dateTimeString(ofStyle: .long) -> "January 12, 2017 at 7:32:00 PM GMT+3"
    ///     Date().dateTimeString(ofStyle: .full) -> "Thursday, January 12, 2017 at 7:32:00 PM GMT+03:00"
    ///
    /// - Parameter style: DateFormatter style (default is .medium).
    /// - Returns: date and time string.
    func dateTimeString(withFormate:String) -> String{
        if withFormate.isEmpty {
            return ""
        }else{
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = withFormate
            if dateFormater.string(from: self).isEmpty {
                 return ""
            }else {
                return dateFormater.string(from: self)
            }
        }
    }
    
    /// Check if date is in current given calendar component.
    ///
    ///     Date().isInCurrent(.day) -> true
    ///     Date().isInCurrent(.year) -> true
    ///
    /// - Parameter component: calendar component to check.
    /// - Returns: true if date is in current given calendar component.
    func isInCurrent(_ component: Calendar.Component) -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: component)
    }
    
    /// Time string from date
    ///
    ///     Date().timeString(ofStyle: .short) -> "7:37 PM"
    ///     Date().timeString(ofStyle: .medium) -> "7:37:02 PM"
    ///     Date().timeString(ofStyle: .long) -> "7:37:02 PM GMT+3"
    ///     Date().timeString(ofStyle: .full) -> "7:37:02 PM GMT+03:00"
    ///
    /// - Parameter style: DateFormatter style (default is .medium).
    /// - Returns: time string.
    func timeString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: self)
    }
    
    /// Day name from date.
    ///
    ///     Date().dayName(ofStyle: .oneLetter) -> "T"
    ///     Date().dayName(ofStyle: .threeLetters) -> "Thu"
    ///     Date().dayName(ofStyle: .full) -> "Thursday"
    ///
    /// - Parameter Style: style of day name (default is DayNameStyle.full).
    /// - Returns: day name string (example: W, Wed, Wednesday).
    func dayName(ofStyle style: DayNameStyle = .full) -> String {
        // http://www.codingexplorer.com/swiftly-getting-human-readable-date-nsdateformatter/
        let dateFormatter = DateFormatter()
        var format: String {
            switch style {
            case .oneLetter:
                return "EEEEE"
            case .threeLetters:
                return "EEE"
            case .full:
                return "EEEE"
            }
        }
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }
    
    /// Month name from date.
    ///
    ///     Date().monthName(ofStyle: .oneLetter) -> "J"
    ///     Date().monthName(ofStyle: .threeLetters) -> "Jan"
    ///     Date().monthName(ofStyle: .full) -> "January"
    ///
    /// - Parameter Style: style of month name (default is MonthNameStyle.full).
    /// - Returns: month name string (example: D, Dec, December).
    func monthName(ofStyle style: MonthNameStyle = .full) -> String {
        // http://www.codingexplorer.com/swiftly-getting-human-readable-date-nsdateformatter/
        let dateFormatter = DateFormatter()
        var format: String {
            switch style {
            case .oneLetter:
                return "MMMMM"
            case .threeLetters:
                return "MMM"
            case .full:
                return "MMMM"
            }
        }
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }
    
    /// get number of seconds between two date
    ///
    /// - Parameter date: date to compate self to.
    /// - Returns: number of seconds between self and given date.
    func secondsSince(_ date: Date) -> Double {
        return self.timeIntervalSince(date)
    }
    
    /// get number of minutes between two date
    ///
    /// - Parameter date: date to compate self to.
    /// - Returns: number of minutes between self and given date.
    func minutesSince(_ date: Date) -> Double {
        return self.timeIntervalSince(date)/60
    }
    
    /// get number of hours between two date
    ///
    /// - Parameter date: date to compate self to.
    /// - Returns: number of hours between self and given date.
    func hoursSince(_ date: Date) -> Double {
        return self.timeIntervalSince(date)/3600
    }
    
    /// get number of days between two date
    ///
    /// - Parameter date: date to compate self to.
    /// - Returns: number of days between self and given date.
    func daysSince(_ date: Date) -> Double {
        return self.timeIntervalSince(date)/(3600*24)
    }
    
    /// check if a date is between two other dates
    ///
    /// - Parameters:
    ///   - startDate: start date to compare self to.
    ///   - endDate: endDate date to compare self to.
    ///   - includeBounds: true if the start and end date should be included (default is false)
    /// - Returns: true if the date is between the two given dates.
    func isBetween(_ startDate: Date, _ endDate: Date, includeBounds: Bool = false) -> Bool {
        if includeBounds {
            return startDate.compare(self).rawValue * self.compare(endDate).rawValue >= 0
        } else {
            return startDate.compare(self).rawValue * self.compare(endDate).rawValue > 0
        }
    }
    
    /// check if a date is a number of date components of another date
    ///
    /// - Parameters:
    ///   - value: number of times component is used in creating range
    ///   - component: Calendar.Component to use.
    ///   - date: Date to compare self to.
    /// - Returns: true if the date is within a number of components of another date
    
    func isWithin(_ value: UInt, _ component: Calendar.Component, of date: Date) -> Bool {
        return calendar
            .dateComponents([component], from: self, to: date)
            .value(for: component)
            .map { abs($0) <= value } ?? false
    }
}

// MARK :-Initializers
public extension Date {
    
    /// Create a new date form calendar components.
    ///
    ///     let date = Date(year: 2010, month: 1, day: 12) // "Jan 12, 2010, 7:45 PM"
    ///
    /// - Parameters:
    ///   - calendar: Calendar (default is current).
    ///   - timeZone: TimeZone (default is current).
    ///   - era: Era (default is current era).
    ///   - year: Year (default is current year).
    ///   - month: Month (default is current month).
    ///   - day: Day (default is today).
    ///   - hour: Hour (default is current hour).
    ///   - minute: Minute (default is current minute).
    ///   - second: Second (default is current second).
    ///   - nanosecond: Nanosecond (default is current nanosecond).
    init?(
        calendar: Calendar? = Calendar.current,
        timeZone: TimeZone? = TimeZone.current,
        era: Int? = Date().era,
        year: Int? = Date().year,
        month: Int? = Date().month,
        day: Int? = Date().day,
        hour: Int? = Date().hour,
        minute: Int? = Date().minute,
        second: Int? = Date().second,
        nanosecond: Int? = Date().nanosecond) {
        
        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = timeZone
        components.era = era
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        components.nanosecond = nanosecond
        
        if let date = calendar?.date(from: components) {
            self = date
        } else {
            return nil
        }
    }
    
    /// Create date object from ISO8601 string.
    ///
    ///     let date = Date(iso8601String: "2017-01-12T16:48:00.959Z") // "Jan 12, 2017, 7:48 PM"
    ///
    /// - Parameter iso8601String: ISO8601 string of format (yyyy-MM-dd'T'HH:mm:ss.SSSZ).
    init?(iso8601String: String) {
        // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: iso8601String) {
            self = date
        } else {
            return nil
        }
    }
    
    /// Create new date object from UNIX timestamp.
    ///
    ///     let date = Date(unixTimestamp: 1484239783.922743) // "Jan 12, 2017, 7:49 PM"
    ///
    /// - Parameter unixTimestamp: UNIX timestamp.
    init(unixTimestamp: Double) {
        self.init(timeIntervalSince1970: unixTimestamp)
    }
    
    func add(years: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .year, value: years, to: self)!
    }
    
    func add(months: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .month, value: months, to: self)!
    }
    
    func add(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func add(minutes: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func ageNow() -> Int {
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: self, to: now, options: [])
        let age = calcAge.year
        return age ?? 0
    }
    
    func subtract(years: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .year, value: -years, to: self)!
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var startOfMonth: Date {

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components)!
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }

    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
}

// MARK: Helper methods
extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case next
        case previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .next:
                return .forward
            case .previous:
                return .backward
            }
        }
    }
}

