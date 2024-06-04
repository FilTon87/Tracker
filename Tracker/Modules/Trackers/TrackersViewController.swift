//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Anton Filipchuk on 27.11.2023.
//

import UIKit

protocol TrackersViewControllerDelegate: AnyObject {
    func applyFilter(_ filterNumber: Int)
}

final class TrackersViewController: UIViewController, UICollectionViewDelegateFlowLayout, NewTrackerViewControllerDelegate {
    func cancelTrackerCreation() {
        dismiss(animated: true)
    }
    
    // MARK: - Private Properties
    private let defaults = UserDefaults.standard
    private var categories: [TrackerCategory] = []
    private var filteredCategories: [TrackerCategory] = []
    private var pinnedTrackers: [Tracker] = []
    private lazy var searchField = UISearchBar()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let dataPlaceholder = TrackersPlaceholder(title: Constants.dataPlaceholderLabel, image: Constants.dataPlaceholderImage)
    private let searchPlaceholder = TrackersPlaceholder(title: Constants.searchPlaceholderLabel, image: Constants.searchPlaceholderImage)
    private let params = GeometricParams(cellCount: 4, leftInset: 16, rightInset: 16, cellSpacing: 9)
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale.current
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var filtersButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.filtersButton, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.backgroundColor = .yBlue
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapFiltersButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var categoryViewModel = CategoryViewModel()
    
    private lazy var trackerDataProvider: TrackerProtocol? = {
        let trackerStore = TrackerStore.shared
        do {
            try trackerDataProvider = TrackerDataProvider(trackerStore)
            return trackerDataProvider
        } catch {
            //            showError("Данные недоступны")
            return nil
        }
    }()
    
    private lazy var recordDataProvider: RecordProtocol? = {
        let trackerRecordStore = TrackerRecordStore.shared
        do {
            try recordDataProvider = RecordDataProvider(trackerRecordStore, delegate: self)
            return recordDataProvider
        } catch {
            //            showError("Данные недоступны")
            return nil
        }
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

// MARK: - Setup View
private extension TrackersViewController {
    
    private func setupViewController() {
        view.backgroundColor = .yWhite
        datePicker.date = Date()
        addNavBar()
        addCollectionView()
        addPlaceholder()
        addFiltersButton()
    }
    
    private func addNavBar() {
        navigationItem.leftBarButtonItem = addTrackerButton()
        navigationItem.rightBarButtonItem = addDateButton()
        navigationController?.navigationBar.backgroundColor = .yWhite
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Constants.trackersViewControllerName
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
        searchField.placeholder = Constants.searchFieldPlaceholder
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
    
    private func addFiltersButton() {
        view.addSubview(filtersButton)
        filtersButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            filtersButton.heightAnchor.constraint(equalToConstant: 50),
            filtersButton.widthAnchor.constraint(equalToConstant: 114),
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
        collectionView.backgroundColor = .yWhite
        collectionView.allowsMultipleSelection = false
        
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
        categories = categoryViewModel.getCategories()
        searchPinTrackers(categories)
        dateChanged()
    }
    
    private func updateFilteredCategories() {
        let filter = defaults.integer(forKey: "selectedFilter")
        applyFilter(filter)
    }
    
    private func filterCategories() {
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
                let pinCondition = tracker.isPinned != true
                return textCondition && dateCondition && pinCondition
            }
            
            if  trackers.isEmpty {
                return nil
            }
            
            return TrackerCategory(
                categoryTitle: category.categoryTitle,
                trackers: trackers
            )
        }
        
        switch pinnedTrackers.isEmpty {
        case true: break
        case false: do {
            let pinnedCategory = TrackerCategory(categoryTitle: Constants.pinnedCategory, trackers: pinnedTrackers)
            filteredCategories.insert(pinnedCategory, at: 0)
        }
        }
        
        collectionView.reloadData()
        reloadPlaceholder()
        
        switch filteredCategories.isEmpty {
        case true: filtersButton.isHidden = true
        case false: filtersButton.isHidden = false
        }
    }
    
    @objc private func dateChanged() {
        updateFilteredCategories()
    }
    
    private func isTrackerCompletedToday(id:UUID) -> Bool {
        let isSameDay = datePicker.date
        return recordDataProvider?.isTrackerCompletedToday(id, isSameDay) ?? false
    }
    
    private func editTracker(_ indexPath: IndexPath) {
        let viewController = NewTrackerViewController()
        viewController.delegate = self
        viewController.isEdit = true
        viewController.createHabit = filteredCategories[indexPath.section].trackers[indexPath.row].isHabit
        viewController.editingTracker = Tracker(
            id: filteredCategories[indexPath.section].trackers[indexPath.row].id,
            trackerName: filteredCategories[indexPath.section].trackers[indexPath.row].trackerName,
            trackerColor: filteredCategories[indexPath.section].trackers[indexPath.row].trackerColor,
            trackerColorStr: filteredCategories[indexPath.section].trackers[indexPath.row].trackerColorStr,
            trackerEmoji: filteredCategories[indexPath.section].trackers[indexPath.row].trackerEmoji,
            schedule: filteredCategories[indexPath.section].trackers[indexPath.row].schedule,
            isHabit: filteredCategories[indexPath.section].trackers[indexPath.row].isHabit,
            isPinned: filteredCategories[indexPath.section].trackers[indexPath.row].isPinned)
        viewController.editingCategory = TrackerCategory(
            categoryTitle: filteredCategories[indexPath.section].categoryTitle,
            trackers: filteredCategories[indexPath.section].trackers) 
        let id = filteredCategories[indexPath.section].trackers[indexPath.row].id
        viewController.completedDays = recordDataProvider?.getCompletedRecordsForTracker(id)
        viewController.modalPresentationStyle = .automatic
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
    
    private func pinTracker(_ indexPath: IndexPath) {
        let pinedTracker = filteredCategories[indexPath.section].trackers[indexPath.item]
        switch isPinned(indexPath) {
        case true: do {
            pinnedTrackers.removeAll { tracker in
                tracker.id == pinedTracker.id
            }
            savePinTracker(pinedTracker.id)
        }
        case false: do {
            trackerDataProvider?.pinTracker(pinedTracker.id)
            reloadData()
            updateFilteredCategories()
        }
        }
    }
    
    private func isPinned(_ indexPath: IndexPath) -> Bool {
        let pinedTracker = filteredCategories[indexPath.section].trackers[indexPath.item].id
        return pinnedTrackers.contains { tracker in
            pinedTracker == tracker.id
        }
    }
    
    private func savePinTracker(_ id: UUID) {
        trackerDataProvider?.pinTracker(id)
        reloadData()
        updateFilteredCategories()
    }
    
    private func searchPinTrackers (_ categories: [TrackerCategory]) {
        for category in categories {
            category.trackers.forEach {
                switch $0.isPinned {
                case true: do {
                    pinnedTrackers.append($0)
                    }
                case false: break
                }
            }
        }
    }
    

    
    private func delTracker(_ indexPath: IndexPath) {
        let delTracker = filteredCategories[indexPath.section].trackers[indexPath.item].id
        let alert = UIAlertController(
            title: "",
            message: Constants.deleteAlertMessage,
            preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: Constants.contextMenuDelLabel, style: .destructive, handler: { [weak self] action in
            guard let self = self else { return }
            self.trackerDataProvider?.delTracker(delTracker)
            self.recordDataProvider?.delTrackerRecords(delTracker)
            reloadData()
        }))
        alert.addAction(UIAlertAction(title: Constants.cancelButton, style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    @objc private func didTapFiltersButton() {
        let viewController = FiltersViewController()
        viewController.delegate = self
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
}

// MARK: - UICollectionViewDataSource
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
        let completedDays = try? recordDataProvider?.fetchTrackerRecord().filter { $0.trackerID == data.id }.count
        
        cell.fillCell(
            with: data,
            isCompletedToday: isCompletedToday,
            completedDays: completedDays!,
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
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else { return nil }
        
        guard let indexPath = indexPaths.first else { return nil }
        
        return UIContextMenuConfiguration(actionProvider: { [weak self] action in
            guard let self = self else { return nil }
            return UIMenu(children: [
                UIAction(title: self.isPinned(indexPath) ? Constants.contextMenuUnpinLabel: Constants.contextMenuPinLabel) { [weak self] _ in
                    guard let self = self else { return }
                    self.pinTracker(indexPath)
                },
                UIAction(title: Constants.contextMenuEditLabel) { [weak self] _ in
                    guard let self = self else { return }
                    self.editTracker(indexPath)
                },
                UIAction(title: Constants.contextMenuDelLabel, attributes: .destructive) { [weak self] _ in
                    guard let self = self else { return }
                    self.delTracker(indexPath)
                },
            ])
        })
    }
}

// MARK: - UISearchBarDelegate
extension TrackersViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateFilteredCategories()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateFilteredCategories()
    }
}

// MARK: - TrackerCellDelegate
extension TrackersViewController: TrackerCellDelegate {
    func completeTracker(id: UUID, indexPath: IndexPath) {
        let currentDate = Date()
        if currentDate > datePicker.date {
            let trackerRecord = TrackerRecord(trackerID: id, trackerDoneDate: datePicker.date)
            try? recordDataProvider?.addRecord(trackerRecord)
            collectionView.reloadItems(at: [indexPath])
        } else {
            return
        }
    }
    
    func uncompleteTracker(id: UUID, indexPath: IndexPath) {
        let delRecord = TrackerRecord(trackerID: id, trackerDoneDate: datePicker.date)
        recordDataProvider?.delRecord(delRecord)
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - AddTrackerViewControllerDelegate
extension TrackersViewController: AddTrackerViewControllerDelegate {
    func updateTrackers() {
        reloadData()
    }
}

// MARK: - RecordDataProviderDelegate
extension TrackersViewController: RecordDataProviderDelegate {
    func update(_ update: RecordUpdate) {
        collectionView.performBatchUpdates {
            
            let insertIndexPath = update.insertedIndexes.map { IndexPath(item: $0, section: 0) }
            let deletedIndexPath = update.deleteIndexes.map { IndexPath(item: $0, section: 0) }
            collectionView.insertItems(at: insertIndexPath)
            collectionView.deleteItems(at: deletedIndexPath)
        }
    }
}

// MARK: - TrackersViewControllerDelegate
extension TrackersViewController: TrackersViewControllerDelegate {
    func applyFilter(_ filterNumber: Int) {
        switch filterNumber {
        case 0: filterAllTrackers()
        case 1: filterTodayTrackers()
        case 2: filterCompletedTrackers()
        case 3: filterNotCompletedTrackers()
        default: filterAllTrackers()
        }
    }
}

// MARK: - Filtration
private extension TrackersViewController {
    func filterAllTrackers() {
        filterCategories()
    }
    
    func filterTodayTrackers() {
        datePicker.date = Date()
        filterCategories()
    }
    
    func filterCompletedTrackers() {
        filteredCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let completedToday = isTrackerCompletedToday(id: tracker.id)
                return completedToday
            }
            if trackers.isEmpty { return nil }
            
            return TrackerCategory(
                categoryTitle: category.categoryTitle,
                trackers: trackers
            )
        }
        collectionView.reloadData()
        reloadPlaceholder()
    }
    
    
    func filterNotCompletedTrackers() {
        filteredCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let completedToday = !isTrackerCompletedToday(id: tracker.id)
                return completedToday
            }
            if trackers.isEmpty { return nil }
            
            return TrackerCategory(
                categoryTitle: category.categoryTitle,
                trackers: trackers
            )
        }
        collectionView.reloadData()
        reloadPlaceholder()
    }
    
}
