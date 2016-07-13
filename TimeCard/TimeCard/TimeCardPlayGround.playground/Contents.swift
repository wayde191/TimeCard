//: Playground - noun: a place where people can play

import UIKit

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

func get(direction: SearchDirection, _ dayName: String, considerToday consider: Bool = false) -> NSDate {
    let weekdaysName = getWeekDaysInEnglish()
    
    assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
    
    let nextWeekDayIndex = weekdaysName.indexOf(dayName)! + 1 // weekday is in form 1 ... 7 where as index is 0 ... 6
    
    let today = NSDate()
    
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    
    if consider && calendar.component(.Weekday, fromDate: today) == nextWeekDayIndex {
        return today
    }
    
    let nextDateComponent = NSDateComponents()
    nextDateComponent.weekday = nextWeekDayIndex
    
    
    let date = calendar.nextDateAfterDate(today, matchingComponents: nextDateComponent, options: direction.calendarOptions)
    return date!
}

get(.Next, "Monday") // Nov 2, 2015, 12:00 AM
get(.Next, "Sunday") // Nov 1, 2015, 12:00 AM

get(.Previous, "Sunday") // Oct 25, 2015, 12:00 AM
get(.Previous, "Monday") // Oct 26, 2015, 12:00 AM

get(.Previous, "Thursday") // Oct 22, 2015, 12:00 AM
get(.Next, "Thursday") // Nov 5, 2015, 12:00 AM
get(.Previous, "Thursday", considerToday:  true) // // Oct 29, 2015, 12:00 AM

// "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"









