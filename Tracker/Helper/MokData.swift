//
//  MokData.swift
//  Tracker
//
//  Created by Anton Filipchuk on 07.03.2024.
//

import Foundation

final class MokData {
    static let shared = MokData()
    
    var testCategories: [TrackerCategory] = [
        TrackerCategory(categoryTitle: "Уборка", trackers: [
            Tracker(id: UUID(),
                  trackerName: "Помыть посуду",
                  trackerColor: .yLightGray,
                  trackerEmoji: "🍽",
                  schedule: [WeekDays.monday, WeekDays.wednesday, WeekDays.frieday]),
            Tracker(id: UUID(),
                  trackerName: "Убрать комнату",
                  trackerColor: .yRed,
                  trackerEmoji: "🧹",
                  schedule: [WeekDays.saturday]),
            Tracker(id: UUID(),
                  trackerName: "Постирать одежду",
                  trackerColor: .yBlue,
                  trackerEmoji: "🧺",
                  schedule: [WeekDays.sunday]),
            Tracker(id: UUID(),
                  trackerName: "Помыть кота",
                  trackerColor: .yGray,
                  trackerEmoji: "🐈",
                  schedule: [WeekDays.sunday]),
        ]),
        TrackerCategory(categoryTitle: "Спорт", trackers: [
            Tracker(id: UUID(),
                  trackerName: "Гимнастика",
                  trackerColor: .yRed,
                  trackerEmoji: "🧘‍♀️",
                  schedule: [WeekDays.tuesday, WeekDays.saturday]),
            Tracker(id: UUID(),
                  trackerName: "Бег",
                  trackerColor: .yBlack,
                  trackerEmoji: "🏃",
                  schedule: [WeekDays.monday, WeekDays.wednesday, WeekDays.frieday]),
            Tracker(id: UUID(),
                  trackerName: "Теннис",
                  trackerColor: .yBlue,
                  trackerEmoji: "🏓",
                  schedule: [WeekDays.sunday]),
        ])
    ]
    
    private init() {}
}
