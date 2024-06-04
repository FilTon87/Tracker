//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Anton Filipchuk on 04.06.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testMainViewController() {
        let vc = TrackersViewController()
        
        assertSnapshots(matching: vc, as: [.image(traits: UITraitCollection(userInterfaceStyle: .light))])
    }
    
    func testMainViewControllerDark() {
        let vc = TrackersViewController()
        
        assertSnapshots(matching: vc, as: [.image(traits: UITraitCollection(userInterfaceStyle: .dark))])
    }

}
