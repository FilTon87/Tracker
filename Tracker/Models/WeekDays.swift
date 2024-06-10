//
//  WeekDays.swift
//  Tracker
//
//  Created by Anton Filipchuk on 06.02.2024.
//

import UIKit

enum WeekDays: Int, CaseIterable {
    case monday = 2
    case tuesday
    case wednesday
    case thursday
    case frieday
    case saturday
    case sunday = 1
    
    var longWeekDaysName: String {
        switch self {
        case .monday: return Localization.mondayLong
        case .tuesday: return Localization.tuesdayLong
        case .wednesday: return Localization.wednesdayLong
        case .thursday: return Localization.thursdayLong
        case .frieday: return Localization.friedayLong
        case .saturday: return Localization.saturdayLong
        case .sunday: return Localization.sundayLong
        }
    }
    
    var shortWeekDaysName: String {
        switch self {
        case .monday: return Localization.mondayShort
        case .tuesday: return Localization.tuesdayShort
        case .wednesday: return Localization.wednesdayShort
        case .thursday: return Localization.thursdayShort
        case .frieday: return Localization.friedayShort
        case .saturday: return Localization.saturdayShort
        case .sunday: return Localization.sundayShort
        }
    }
}
