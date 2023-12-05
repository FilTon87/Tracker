//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Anton Filipchuk on 27.11.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
}

private extension TrackersViewController {
    
    private func setupViewController() {
        view.backgroundColor = .white
        
        let addTrackerButton = makeNavButton(
            imageName: "Add tracker",
            selector: #selector(close)
        )
        
        let dateButton = makeDateButton()
        
        let customTitelView = createLabel()
        
        navigationItem.leftBarButtonItem = addTrackerButton
        navigationItem.rightBarButtonItem = dateButton
        navigationItem.titleView = customTitelView
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
}

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
