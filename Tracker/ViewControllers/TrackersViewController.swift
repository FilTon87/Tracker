//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Anton Filipchuk on 27.11.2023.
//

import UIKit

final class TrackersViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    // MARK: - Private Properties
    private var categories: [TrackerCategory] = []
    private var filteredCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var selectedDate = Date()
    private lazy var searchField = UISearchBar()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let dataPlaceholder = TrackersPlaceholder(title: "Что будем отслеживать?", image: "Start")
    private let searchPlaceholder = TrackersPlaceholder(title: "Ничего не найдено", image: "Error")
    private let params = GeometricParams(cellCount: 4, leftInset: 16, rightInset: 16, cellSpacing: 9)
    private let mokData = MokData.shared
    private let categoryStore = TrackerCategoryStore.shared
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return datePicker
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        reloadData()
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellPerRow = 2
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(cellPerRow)
        return CGSize(width: cellWidth, height: 148)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: params.leftInset, bottom: 0, right: params.rightInset)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        let headerSize = CGSize(width: collectionView.bounds.width, height: 18)
        return headerView.systemLayoutSizeFitting(headerSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .required)
    }
}

private extension TrackersViewController {
    
    private func setupViewController() {
        view.backgroundColor = .white
        datePicker.date = Date()
        addNavBar()
        addCollectionView()
        addPlaceholder()
    }
    
    private func addNavBar() {
        navigationItem.leftBarButtonItem = addTrackerButton()
        navigationItem.rightBarButtonItem = addDateButton()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Трекеры"
        addSearchField()
    }
    
    private func addDateButton() -> UIBarButtonItem {
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 120),
            datePicker.heightAnchor.constraint(equalToConstant: 34)
        ])
        let addDateButton = UIBarButtonItem(customView: datePicker)
        return addDateButton
    }
    
    private func addTrackerButton() -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(named: "Plus")?.withRenderingMode(.alwaysTemplate),
            for: .normal)
        button.tintColor = .yBlack
        button.addTarget(self, action: #selector(switchToCreateViewController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 42),
            button.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        let addTrackerButton = UIBarButtonItem(customView: button)
        return addTrackerButton
    }
    
    private func addSearchField() {
        view.addSubview(searchField)
        searchField.delegate = self
        searchField.placeholder = "Поиск"
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.searchBarStyle = .minimal
        
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchField.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private func addPlaceholder() {
        view.addSubview(dataPlaceholder)
        view.addSubview(searchPlaceholder)
        
        dataPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        searchPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dataPlaceholder.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            dataPlaceholder.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            searchPlaceholder.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            searchPlaceholder.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
        ])
    }
    
    @objc private func switchToCreateViewController() {
        let viewController = AddTrackerViewController()
        viewController.delegate = self
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
    
    private func addCollectionView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.cellReuseIdentifier)
        collectionView.register(TrackerHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerHeaderCollectionView.headerReuseIdentifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 7),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func reloadPlaceholder() {
        searchPlaceholder.isHidden = true
        dataPlaceholder.isHidden = true
        
        if !categories.isEmpty && filteredCategories.isEmpty {
            searchPlaceholder.isHidden = false
        }
        
        if categories.isEmpty {
            dataPlaceholder.isHidden = false
        }
    }
    
    private func reloadData() {
//        categories = mokData.testCategories
        try! categories = categoryStore.fetchCategory()
        dateChanged()
    }
    
    private func updateFilteredCategories() {
        let calendar = Calendar.current
        let selectedWeekDay = calendar.component(.weekday, from: datePicker.date)
        let searchText = (searchField.text ?? "").lowercased()
        
        filteredCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let textCondition = searchText.isEmpty ||
                tracker.trackerName.lowercased().contains(searchText)
                let dateCondition = tracker.schedule?.contains { weekDay in
                    weekDay.rawValue == selectedWeekDay
                } == true
                return textCondition && dateCondition
            }
            
            if  trackers.isEmpty {
                return nil
            }
            
            return TrackerCategory(
                categoryTitle: category.categoryTitle,
                trackers: trackers
            )
        }
        collectionView.reloadData()
        reloadPlaceholder()
    }
    
    @objc private func dateChanged() {
        updateFilteredCategories()
    }
    
    private func isTrackerCompletedToday(id:UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            compareTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
    }
    
    private func compareTrackerRecord(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.trackerDoneDate, inSameDayAs: datePicker.date)
        return trackerRecord.trackerID == id && isSameDay
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.cellReuseIdentifier, for: indexPath) as? TrackerCollectionViewCell
        else {
            preconditionFailure("Failed to cast UICollectionViewCell as TrackerCollectionViewCell")
        }
        let data = filteredCategories[indexPath.section].trackers[indexPath.item]
        cell.delegate = self
        
        let isCompletedToday = isTrackerCompletedToday(id: data.id)
        let completedDays = completedTrackers.filter{$0.trackerID == data.id}.count
        
        cell.fillCell(
            with: data,
            isCompletedToday: isCompletedToday,
            completedDays: completedDays,
            at: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerHeaderCollectionView.headerReuseIdentifier, for: indexPath) as? TrackerHeaderCollectionView
        else {
            preconditionFailure("Failed to cast UICollectionViewCell as TrackerHeaderCollectionView")
        }
        header.fillHeader(with: filteredCategories[indexPath.section])
        return header
    }
}

extension TrackersViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateFilteredCategories()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateFilteredCategories()
    }
}

extension TrackersViewController: TrackerCellDelegate {
    func completeTracker(id: UUID, indexPath: IndexPath) {
        let currentDate = Date()
        if currentDate > datePicker.date {
            let trackerRecord = TrackerRecord(trackerID: id, trackerDoneDate: datePicker.date)
            completedTrackers.append(trackerRecord)
            collectionView.reloadItems(at: [indexPath])
        } else {
            return
        }
    }
    
    func uncompleteTracker(id: UUID, indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            compareTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
        collectionView.reloadItems(at: [indexPath])
    }
}

extension TrackersViewController: AddTrackerViewControllerDelegate {    
    func updateTrackers() {
        try! categories = categoryStore.fetchCategory()
        reloadData()
    }
}
