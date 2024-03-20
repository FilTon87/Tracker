//
//  WeekDays.swift
//  Tracker
//
//  Created by Anton Filipchuk on 06.02.2024.
//

import UIKit

enum WeekDays: Int, Codable {
    case monday = 1
    case tuesday
    case wednesday
    case thursday
    case frieday
    case saturday
    case sunday
    
    var weekDaysName: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .frieday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
}
