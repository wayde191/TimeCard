//
//  Date.swift
//  TimeCard
//
//  Created by Wei Wayde Sun on 7/12/16.
//  Copyright © 2016 iHakula. All rights reserved.
//

import Foundation

func getDayOfWeekString(weekDay:Int) -> String {
    switch weekDay {
    case 1:
        return "Sun"
    case 2:
        return "Mon"
    case 3:
        return "Tue"
    case 4:
        return "Wed"
    case 5:
        return "Thu"
    case 6:
        return "Fri"
    case 7:
        return "Sat"
    default:
        print("Error fetching days")
        return "Day"
    }
}

func getWeekDaysInEnglish() -> [String] {
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    calendar.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    return calendar.weekdaySymbols
}

enum SearchDirection {
    case Next
    case Previous
    
    var calendarOptions: NSCalendarOptions {
        switch self {
        case .Next:
            return .MatchNextTime
        case .Previous:
            return [.SearchBackwards, .MatchNextTime]
        }
    }
}


extension NSDate {
    class func get(direction: SearchDirection, _ dayName: String, considerToday consider: Bool = false) -> NSDate {
        let weekdaysName = getWeekDaysInEnglish()
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let nextWeekDayIndex = weekdaysName.indexOf(dayName)! + 1 // weekday is in form 1 ... 7 where as index is 0 ... 6
        
        let today = NSDate()
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierChinese)!
        calendar.timeZone = NSTimeZone(abbreviation: "CST")!
        
        if consider && calendar.component(.Weekday, fromDate: today) == nextWeekDayIndex {
            return today
        }
        
        let nextDateComponent = NSDateComponents()
        nextDateComponent.timeZone = NSTimeZone(abbreviation: "CST")
        nextDateComponent.weekday = nextWeekDayIndex
        
        
        let date = calendar.nextDateAfterDate(today, matchingComponents: nextDateComponent, options: direction.calendarOptions)
        return date!
    }
    
    class func getLastFridayStr() -> String {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-M-dd"
        let today = NSDate.get(.Previous, "Friday", considerToday:  true)
        return self.getDayOfWeek(formatter.stringFromDate(today))
    }
    
    class func getLastMondayStr() -> String {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-M-d"
        let today = NSDate.get(.Previous, "Monday", considerToday:  true)
        return formatter.stringFromDate(today)
    }
    
    class func getDayOfWeek(today:String) -> String {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.dateFromString(today)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
        let weekDay = myComponents.weekday
        let dayStr = getDayOfWeekString(weekDay)
        
        return dayStr
    }
    
    class func getTodayWeekStr() -> String {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = NSDate()
        return self.getDayOfWeek(formatter.stringFromDate(today))
    }
}