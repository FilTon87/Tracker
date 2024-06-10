//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Anton Filipchuk on 05.12.2023.
//

import Foundation

struct TrackerCategory: Equatable {
    static func == (lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        lhs.categoryTitle == rhs.categoryTitle
    }
    
    let categoryTitle: String
    let trackers: [Tracker]
}
