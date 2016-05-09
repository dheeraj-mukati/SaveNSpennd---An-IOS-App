//
//  DateUtils.swift
//  SaveNSpend
//
//  Created by Dheeraj Mukati on 5/8/16.
//  Copyright © 2016 Dheeraj Mukati. All rights reserved.
//

import Foundation

class DateUtils {
    
    func startOfMonth(currentDate:NSDate) -> NSDate? {
        let calendar = NSCalendar.currentCalendar()
        //calendar.components
        let currentDateComponents = calendar.components([NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: currentDate)
        let startOfMonth = calendar.dateFromComponents(currentDateComponents)
        
        return startOfMonth
    }
    
    func dateByAddingMonths(monthsToAdd: Int, currentDate:NSDate) -> NSDate? {
        
        let calendar = NSCalendar.currentCalendar()
        let months = NSDateComponents()
        months.month = monthsToAdd
        return calendar.dateByAddingComponents(months, toDate: currentDate, options: [])
    }
    
    func endOfMonth(currentDate:NSDate) -> NSDate? {
        
        let calendar = NSCalendar.currentCalendar()
        if let plusOneMonthDate = dateByAddingMonths(1, currentDate: currentDate) {
            let plusOneMonthDateComponents = calendar.components([NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: plusOneMonthDate)
            
            let endOfMonth = calendar.dateFromComponents(plusOneMonthDateComponents)?.dateByAddingTimeInterval(-1)
            
            return endOfMonth
        }
        
        return nil
    }
}