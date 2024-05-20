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
        case .monday: return Constants.mondayLong
        case .tuesday: return Constants.tuesdayLong
        case .wednesday: return Constants.wednesdayLong
        case .thursday: return Constants.thursdayLong
        case .frieday: return Constants.friedayLong
        case .saturday: return Constants.saturdayLong
        case .sunday: return Constants.sundayLong
        }
    }
    
    var shortWeekDaysName: String {
        switch self {
        case .monday: return Constants.mondayShort
        case .tuesday: return Constants.tuesdayShort
        case .wednesday: return Constants.wednesdayShort
        case .thursday: return Constants.thursdayShort
        case .frieday: return Constants.friedayShort
        case .saturday: return Constants.saturdayShort
        case .sunday: return Constants.sundayShort
        }
    }
}
