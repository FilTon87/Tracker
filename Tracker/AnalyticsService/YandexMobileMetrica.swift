//
//  YandexMobileMetrica.swift
//  Tracker
//
//  Created by Anton Filipchuk on 05.06.2024.
//

import Foundation
import YandexMobileMetrica

struct YandexMobileMetrica {
    
    func report(event: String, params: [AnyHashable: Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("Report error: %@", error.localizedDescription)
        })
    }
}
