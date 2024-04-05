//
//  TrackerProperties.swift
//  Tracker
//
//  Created by Anton Filipchuk on 04.04.2024.
//

import Foundation

struct Properties {
    let name: String
    let properties: [String]
}

final class TrackerProperties {
    static let shared = TrackerProperties()
    
    var trackerProperties: [Properties] = [
        Properties(name: "Emoji",
                   properties: ["🙂","😻","🌸","🐶","❤️","😱","😇","😡","🥶","🤔","🙌","🍔","🥦","🏓","🥇","🎸","🏝️","🥲"]),
        Properties(name: "Цвет",
                   properties: ["Color selection 1",
                                "Color selection 2",
                                "Color selection 3",
                                "Color selection 4",
                                "Color selection 5",
                                "Color selection 6",
                                "Color selection 7",
                                "Color selection 8",
                                "Color selection 9",
                                "Color selection 10",
                                "Color selection 11",
                                "Color selection 12",
                                "Color selection 13",
                                "Color selection 14",
                                "Color selection 15",
                                "Color selection 16",
                                "Color selection 17",
                                "Color selection 18"
                               ]
                  )
    ]
    private init() {}
}
