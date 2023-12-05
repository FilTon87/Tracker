//
//  TabBarController.swift
//  Tracker
//
//  Created by Anton Filipchuk on 29.11.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
    }
}

private extension TabBarController {
    private enum TabBarItem: Int {
        case trackers
        case stats
        
        var title: String {
            switch self {
            case .trackers: return "Трекеры"
            case .stats: return "Статистика"
            }
        }
        
        var iconName: String {
            switch self {
            case .trackers: return "trackers"
            case .stats: return "stats"
            }
        }
    }
    
    private func generateTabBar() {
        let dataSource: [TabBarItem] = [.trackers, .stats]
        self.viewControllers = dataSource.map {
            switch $0 {
            case .trackers:
                let trackersViewController = TrackersViewController()
                return self.wrappedInNavigationControllr(with: trackersViewController, title: $0.title)
            case .stats:
                let statsViewController = StatsViewController()
                return statsViewController
            }
        }
        self.viewControllers?.enumerated().forEach {
            $1.tabBarItem.title = dataSource[$0].title
            $1.tabBarItem.image = UIImage(named: dataSource[$0].iconName)
        }
    }
    
    private func wrappedInNavigationControllr(with: UIViewController, title: Any?) -> UINavigationController {
            return UINavigationController(rootViewController: with)
        }
}
