//
//  NavBarController.swift
//  Tracker
//
//  Created by Anton Filipchuk on 05.12.2023.
//

import UIKit

extension UIViewController {
    
    func createLabel() -> UIView {
        let view = UIView()
//        view.frame = CGRect(x: 0, y: 0, width: 375, height: 182)
//        view.backgroundColor = .orange
//        view.tintColor = .orange
        
//        let trackerLabel = UILabel()
//        trackerLabel.text = "Трекеры"
//        trackerLabel.textColor = .yBlack
//        trackerLabel.font = .boldSystemFont(ofSize: 34)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Трекеры"
//        trackerLabel.backgroundColor = .blue
//        view.addSubview(trackerLabel)
//
//        NSLayoutConstraint.activate([
//            trackerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
//            trackerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
//        ])
        
        let searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = TrackersViewController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        let searchBar = searchController.searchBar
        searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        definesPresentationContext = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
             //searchBar.topAnchor.constraint(equalTo: trackerLabel.bottomAnchor, constant: 0)
        ])
        
        return view
    }
    
    func makeDateButton() -> UIBarButtonItem {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 120),
            datePicker.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        let addDateButton = UIBarButtonItem(customView: datePicker)
        return addDateButton
    }
    
    func makeNavButton(imageName: String, selector: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate),
            for: .normal)
        button.tintColor = .yBlack
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            button.widthAnchor.constraint(equalToConstant: 42),
            button.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        let addTrackerButton = UIBarButtonItem(customView: button)
        return addTrackerButton
    }
}
