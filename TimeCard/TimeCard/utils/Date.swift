//
//  Date.swift
//  TimeCard
//
//  Created by Wei Wayde Sun on 7/12/16.
//  Copyright © 2016 iHakula. All rights reserved.
//

import Foundation

func getDayOfWeekString(_ weekDay:Int) -> String {
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
    var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    calendar.locale = Locale(identifier: "en_US_POSIX")
    return calendar.weekdaySymbols
}

enum SearchDirection {
    case next
    case previous
    
    var calendarOptions: NSCalendar.Options {
        switch self {
        case .next:
            return .matchNextTime
        case .previous:
            return [.searchBackwards, .matchNextTime]
        }
    }
}


extension Date {
    static func get(_ direction: SearchDirection, _ dayName: String, considerToday consider: Bool = false) -> Date {
        let weekdaysName = getWeekDaysInEnglish()
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let nextWeekDayIndex = weekdaysName.index(of: dayName)! + 1 // weekday is in form 1 ... 7 where as index is 0 ... 6
        
        let today = Date()
        
        var calendar = Calendar(identifier: Calendar.Identifier.chinese)
        calendar.timeZone = TimeZone(abbreviation: "CST")!
        
        if consider && (calendar as NSCalendar).component(.weekday, from: today) == nextWeekDayIndex {
            return today
        }
        
        var nextDateComponent = DateComponents()
        (nextDateComponent as NSDateComponents).timeZone = TimeZone(abbreviation: "CST")
        nextDateComponent.weekday = nextWeekDayIndex
        
        
        let date = (calendar as NSCalendar).nextDate(after: today, matching: nextDateComponent, options: direction.calendarOptions)
        return date!
    }
    
    static func getLastFridayStr() -> String {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-M-dd"
        let today = Date.get(.previous, "Friday", considerToday:  true)
        return self.getDayOfWeek(formatter.string(from: today))
    }
    
    static func getLastMondayStr() -> String {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-M-d"
        let today = Date.get(.previous, "Monday", considerToday:  true)
        return formatter.string(from: today)
    }
    
    static func getDayOfWeek(_ today:String) -> String {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.date(from: today)!
        let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let myComponents = (myCalendar as NSCalendar).components(.weekday, from: todayDate)
        let weekDay = myComponents.weekday
        let dayStr = getDayOfWeekString(weekDay!)
        
        return dayStr
    }
    
    static func getTodayWeekStr() -> String {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = Date()
        return self.getDayOfWeek(formatter.string(from: today))
    }
}
