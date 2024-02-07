//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Anton Filipchuk on 27.11.2023.
//

import UIKit

final class TrackersViewController: UIViewController, AddTrackerViewControllerDelegate {
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
//    private var currentDate: Date = UIDatePicker
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
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
            selector: #selector(switchToCreateViewController))
        navigationItem.leftBarButtonItem = addTrackerButton
        
        let dateButton = makeDateButton()
        navigationItem.rightBarButtonItem = dateButton
        
        createLabel()
        makeSearchBar()
        makeCollectionView()
    }
    
    @objc private func switchToCreateViewController() {
        let viewController = AddTrackerViewController()
//        viewController.modalPresentationStyle = .automatic
        viewController.delegate = self
//        self.present(viewController, animated: true)
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
    
    private func makeCollectionView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "сell")
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 182),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 84),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}


extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "сell", for: indexPath)
        cell.contentView.backgroundColor = .red
        return cell
    }
}
