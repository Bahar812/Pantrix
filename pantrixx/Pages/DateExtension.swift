//
//  DateExtension.swift
//  pantrixx
//
//  Created by MacBook Pro on 25/11/24.
//

import SwiftUI

extension Date{
    func format(_ format: String)-> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    struct WeekDay: Identifiable{
        var id : UUID = .init()
        var date: Date
    }
    
    // checking wheter the date is today
    var isToday: Bool{
        return Calendar.current.isDateInToday(self)
    }
    // Fetching Week based on given date
    func fetchWeek(date: Date = .init()) -> [WeekDay] {
         let calendar = Calendar.current
         guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: date) else { return [] }
         let startOfWeek = weekInterval.start
         
         var week: [WeekDay] = []
         (0..<7).forEach { offset in
             if let weekday = calendar.date(byAdding: .day, value: offset, to: startOfWeek) {
                 week.append(WeekDay(date: weekday))
             }
         }
         return week
     }
}
