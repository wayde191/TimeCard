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

extension NSDate {
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