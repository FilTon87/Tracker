//
//  ConvertSchedule.swift
//  Tracker
//
//  Created by Anton Filipchuk on 19.04.2024.
//

import UIKit

final class ConvertSchedule {
    
    func toInt32(_ schedule:[WeekDays]) -> Int32 {
        Int32(schedule.map { $0.rawValue }.reduce(0, {$0 * 10 + $1}))
     }
    
    func toWeekDays(_ value: Int32) -> [WeekDays] {
        var schedule: [WeekDays] = []
        let intArray = String(value).map({ Int(String($0))! })
        intArray.forEach {
            guard let weekDay = WeekDays(rawValue: $0) else { return }
            schedule.append(weekDay)
        }
        return schedule
    }
}
