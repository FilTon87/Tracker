//
//  Tracker.swift
//  Tracker
//
//  Created by Anton Filipchuk on 05.12.2023.
//

import UIKit

struct Tracker {
    let id: UUID
    let trackerName: String
    let trackerColor: UIColor
    let trackerColorStr: String
    let trackerEmoji: String
    let schedule: [WeekDays]?
    let isHabit: Bool
    let isPinned: Bool
}
