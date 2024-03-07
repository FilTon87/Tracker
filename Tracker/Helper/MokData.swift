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
            Track(id: UUID(),
                  trackerName: "Помыть посуду",
                  trackerColor: .yLightGray,
                  trackerEmoji: "🍽"),
            Track(id: UUID(),
                  trackerName: "Убрать комнату",
                  trackerColor: .yRed,
                  trackerEmoji: "🧹"),
            Track(id: UUID(),
                  trackerName: "Постирать одежду",
                  trackerColor: .yBlue,
                  trackerEmoji: "🧺"),
            Track(id: UUID(),
                  trackerName: "Помыть кота",
                  trackerColor: .yGray,
                  trackerEmoji: "🐈"),
        ]),
        TrackerCategory(categoryTitle: "Спорт", trackers: [
            Track(id: UUID(),
                  trackerName: "Гимнастика",
                  trackerColor: .yRed,
                  trackerEmoji: "🧘‍♀️"),
            Track(id: UUID(),
                  trackerName: "Бег",
                  trackerColor: .yBlack,
                  trackerEmoji: "🏃"),
            Track(id: UUID(),
                  trackerName: "Теннис",
                  trackerColor: .yBlue,
                  trackerEmoji: "🏓"),
        ])
    ]
    
    private init() {}
}
