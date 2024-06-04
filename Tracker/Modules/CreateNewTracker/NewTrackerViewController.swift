//
//  xzViewController.swift
//  Tracker
//
//  Created by Anton Filipchuk on 09.12.2023.
//

import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func cancelTrackerCreation()
    func updateTrackers()
}

final class NewTrackerViewController: UIViewController {
    
    // MARK: - Public Properties
    var createHabit: Bool = false
    var isEdit: Bool = false
    var editingTracker: Tracker?
    var editingCategory: TrackerCategory?
    var completedDays: Int?
    
    weak var delegate: NewTrackerViewControllerDelegate?
    
    //MARK: - Private property
    private lazy var textField = TextField(placeholder: Constants.textFieldLabel)
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let params = GeometricParams(cellCount: 18, leftInset: 19, rightInset: 18, cellSpacing: 5)
    private lazy var cancelButton = CancelButton()
    private lazy var createButton = CreateButton()
    private lazy var tableView = TableView(frame: .zero, style: .plain)
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 24
        return stackView
    }()
    
    private lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var limitLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.limitMessage
        label.textColor = .yRed
        label.isHidden = true
        return label
    }()
    
    private lazy var completedDaysLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .yBlack
        return label
    }()
    
    private let propertiesData = TrackerProperties.shared
    private let trackerStore = TrackerStore.shared
    
    private var trackerName: String?
    private var trackerEmoji: String?
    private var trackerColor: String?
    private var nameSelected = false
    private var scheduleSelected = false
    private var categorySelected = false
    private var emojiSelected = false
    private var colorSelected = false
    private var selectedEmoji: Int?
    private var selectedColor: Int?
    private var selectedSchedule: [Schedule] = []
    private var schedule: [WeekDays] = []
    private var settings: Array<NewTracker> = []
    
    private lazy var dataProvider: TrackerProtocol? = {
        let trackerStore = TrackerStore.shared
        do {
            try dataProvider = TrackerDataProvider(trackerStore)
            return dataProvider
        } catch {
            //            showError("Данные недоступны")
            return nil
        }
    }()
    
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isEdit { editTracker() }
    }
}

//MARK: - View Settings
private extension NewTrackerViewController {
    func setupViewController() {
        view.backgroundColor = .yWhite
        textField.delegate = self
        addViewLabel()
        configCell()
        addSubView()
        addLayout()
        addTarget()
        addTableView()
        addCollectionView()
        addDaysLabel()
    }
    
    func addViewLabel() {
        let textLabel = switch isEdit {
        case true: Constants.editingLabel
        case false: switch createHabit {
        case true: Constants.newHabbit
        case false: Constants.newEvent
        }
        }
        navigationItem.title = textLabel
    }
    
}


//MARK: - Setting
private extension NewTrackerViewController {
    func addSubView() {
        [scrollView,
         cancelButton,
         createButton].forEach {
            view.addSubview($0)
        }
        
        scrollView.addSubview(mainStackView)
        
        [completedDaysLabel,
         textField,
         limitLabel].forEach {
            textFieldStackView.addArrangedSubview($0)
        }
        
        [textFieldStackView,
         tableView,
         collectionView].forEach {
            mainStackView.addArrangedSubview($0)
        }
    }
    
    func addTarget() {
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }
    
    func showLabel() {
        UIView.animate(withDuration: 0.25) {
            self.limitLabel.isHidden = false
        }
    }
    
    func hideLabel() {
        UIView.animate(withDuration: 0.25) {
            self.limitLabel.isHidden = true
        }
    }
    
    @objc func didTapCancelButton() {
        dismiss(animated: false)
        delegate?.cancelTrackerCreation()
    }
    
    @objc func didTapCreateButton() {
        switch isEdit {
        case true: editTrackerSave()
        case false: createTracker()
        }
    }
    
    func createTracker() {
        guard let categoryTitle = tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.detailTextLabel?.text else {
            assertionFailure("No categoryTitle")
            return
        }
        
        guard let trackerName = textField.text else {
            assertionFailure("No trackerName")
            return
        }
        
        guard let trackerEmoji = trackerEmoji else {
            assertionFailure("No trackerEmoji")
            return
        }
        
        guard let trackerColor = trackerColor else {
            assertionFailure("No trackerColor")
            return
        }
        let color = UIColor(named: "\(trackerColor)")!
        
        
        if createHabit {
            selectedSchedule.forEach { schedule.append($0.weekDay.self)
            }
        } else {
            schedule = WeekDays.allCases.map { $0 }
        }
        
        let track = Tracker(
            id: UUID(),
            trackerName: trackerName,
            trackerColor: color,
            trackerColorStr: trackerColor,
            trackerEmoji: trackerEmoji,
            schedule: schedule,
            isHabit: createHabit,
            isPinned: false)
        
        try? dataProvider?.addTracker(track, categoryTitle)
        
        dismiss(animated: false)
        delegate?.updateTrackers()
    }
    
    func editTrackerSave() {
        guard let id = editingTracker?.id else { return }
        guard let isPinned = editingTracker?.isPinned else { return }
        
        guard let categoryTitle = tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.detailTextLabel?.text else {
            assertionFailure("No categoryTitle")
            return
        }
        
        guard let trackerName = textField.text else {
            assertionFailure("No trackerName")
            return
        }
        
        guard let trackerEmoji = trackerEmoji else {
            assertionFailure("No trackerEmoji")
            return
        }
        
        guard let trackerColor = trackerColor else {
            assertionFailure("No trackerColor")
            return
        }
        let color = UIColor(named: "\(trackerColor)")!
        
        switch createHabit {
        case true: do {
            selectedSchedule.forEach { schedule.append($0.weekDay.self)
            }
        }
        case false: do {
            schedule = WeekDays.allCases.map { $0 }
        }
        }
        
        let track = Tracker(
            id: id,
            trackerName: trackerName,
            trackerColor: color,
            trackerColorStr: trackerColor,
            trackerEmoji: trackerEmoji,
            schedule: schedule,
            isHabit: createHabit,
            isPinned: isPinned)
        
        dataProvider?.delTracker(id)
        try? dataProvider?.addTracker(track, categoryTitle)
        
        dismiss(animated: false)
        delegate?.updateTrackers()
    }
    
    func addDaysLabel() {
        switch isEdit {
        case true: do {
            completedDaysLabel.isHidden = false
            completedDaysLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                completedDaysLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                completedDaysLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
            ])
            if let completedDays = completedDays {
                configDaysLabel(with: completedDays)
            }
        }
        case false: break
        }
    }
    
    func configDaysLabel(with: Int) {
        let key = Constants.numberOfDays
        let localizedFormat = String.localizedStringWithFormat(
            NSLocalizedString(key, tableName: key, comment: ""),
            with)
        completedDaysLabel.text = localizedFormat
    }
}


//MARK: - Layout
private extension NewTrackerViewController {
    func addLayout() {
        [scrollView,
         mainStackView,
         textFieldStackView,
         textField,
         cancelButton,
         createButton,
         tableView,
         collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: createButton.topAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            textFieldStackView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            textFieldStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            textFieldStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: heightOfTableView()),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: createButton.topAnchor, constant: -16),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -2),
            
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -2)
        ])
    }
}

//MARK: - TabelView Settings
extension NewTrackerViewController: UITableViewDataSource, UITableViewDelegate {
    private func addTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewTrackerTableViewCell.self, forCellReuseIdentifier: NewTrackerTableViewCell.reuseIdentifier)
    }
    
    private func configCell() {
        switch createHabit {
        case true: do {
            addCategory()
            addShedule()
        }
        case false: do {
            addCategory()
        }
        }
    }
    
    private func addCategory() {
        settings.append( NewTracker(
            name: Constants.categoryLabel,
            handler: { [weak self] in
                guard let self = self else { return }
                self.selectСategory()
            }))
    }
    
    private func addShedule() {
        settings.append(
            NewTracker(
                name: Constants.scheduleLabel,
                handler: { [weak self] in
                    guard let self = self else { return }
                    self.selectShedule()
                }))
    }
    
    private func heightOfTableView() -> CGFloat {
        if settings.count == 2 { return CGFloat(150) } else { return CGFloat(75) }
    }
    
    private func updateCell(subText: String, indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NewTrackerTableViewCell else {
            assertionFailure("No cell as NewTrackerTableViewCell")
            return
        }
        cell.detailTextLabel?.text = subText
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewTrackerTableViewCell.reuseIdentifier) as! NewTrackerTableViewCell
        cell.textLabel?.text = settings[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        settings[indexPath.row].handler()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == settings.count - 1
        let defaultInset = tableView.separatorInset
        
        if isLastCell {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.width)
        } else {
            cell.separatorInset = defaultInset
        }
    }
}

//MARK: - CollectionView Settings
extension NewTrackerViewController: UICollectionViewDelegateFlowLayout {
    private func addCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(NewTrackerCollectionViewCell.self, forCellWithReuseIdentifier: NewTrackerCollectionViewCell.cellReuseIdentifier)
        collectionView.register(TrackerHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerHeaderCollectionView.headerReuseIdentifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: params.leftInset, bottom: 16, right: params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        let headerSize = CGSize(width: collectionView.bounds.width, height: 18)
        return headerView.systemLayoutSizeFitting(headerSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .required)
    }
}

//MARK: - UICollectionViewDataSource
extension NewTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return propertiesData.trackerProperties.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return propertiesData.trackerProperties[section].properties.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewTrackerCollectionViewCell.cellReuseIdentifier, for: indexPath) as? NewTrackerCollectionViewCell
        else {
            preconditionFailure("Failed to cast UICollectionViewCell as NewTrackerCollectionViewCell")
        }
        cell.fillCell(model: propertiesData, at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerHeaderCollectionView.headerReuseIdentifier, for: indexPath) as? TrackerHeaderCollectionView
        else {
            preconditionFailure("Failed to cast UICollectionViewCell as TrackerHeaderCollectionView")
        }
        header.fillHeader(with: propertiesData.trackerProperties[indexPath.section])
        return header
    }
}

//MARK: - UICollectionViewDelegate
extension NewTrackerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let selectedEmoji = selectedEmoji {
                let previousCell = IndexPath(row: selectedEmoji, section: 0)
                guard let cell = collectionView.cellForItem(at: previousCell) as? NewTrackerCollectionViewCell
                else {
                    preconditionFailure("Failed to cast UICollectionViewCell as NewTrackerCollectionViewCell")
                }
                cell.deselectCell(at: previousCell)
            }
            guard let cell = collectionView.cellForItem(at: indexPath) as? NewTrackerCollectionViewCell
            else {
                preconditionFailure("Failed to cast UICollectionViewCell as NewTrackerCollectionViewCell")
            }
            cell.selectCell(model: propertiesData, at: indexPath)
            selectedEmoji = indexPath.row
            trackerEmoji = propertiesData.trackerProperties[indexPath.section].properties[indexPath.row]
            emojiSelected = true
            
        } else if indexPath.section == 1 {
            if let selectedColor = selectedColor {
                let previousCell = IndexPath(row: selectedColor, section: 1)
                guard let cell = collectionView.cellForItem(at: previousCell) as? NewTrackerCollectionViewCell
                else {
                    preconditionFailure("Failed to cast UICollectionViewCell as NewTrackerCollectionViewCell")
                }
                cell.deselectCell(at: previousCell)
            }
            guard let cell = collectionView.cellForItem(at: indexPath) as? NewTrackerCollectionViewCell
            else {
                preconditionFailure("Failed to cast UICollectionViewCell as NewTrackerCollectionViewCell")
            }
            cell.selectCell(model: propertiesData, at: indexPath)
            selectedColor = indexPath.row
            trackerColor = propertiesData.trackerProperties[indexPath.section].properties[indexPath.row]
            colorSelected = true
        }
    }
}

private extension NewTrackerViewController {
    func selectСategory() {
        let categoryViewController = CategoryViewController()
        categoryViewController.delegate = self
        
        guard let cell = tableView.cellForRow(at: [0, 0]) as? NewTrackerTableViewCell else {
            assertionFailure("No cell as NewTrackerTableViewCell")
            return
        }
        if let searchigText = cell.detailTextLabel?.text {
            categoryViewController.selectCategory(searchigText)
        }
        
        
        categoryViewController.modalPresentationStyle = .automatic
        present(UINavigationController(rootViewController: categoryViewController), animated: true)
    }
    
    func selectShedule() {
        let scheduleViewController = ScheduleViewController()
        scheduleViewController.delegate = self
        scheduleViewController.modalPresentationStyle = .automatic
        present(UINavigationController(rootViewController: scheduleViewController), animated: true)
    }
    
    func checkTracker() {
        if (createHabit) && (nameSelected && categorySelected && scheduleSelected && emojiSelected && colorSelected) {
            createButton.isEnabled = true
            createButton.backgroundColor = .yBlack
        } else {
            if (!createHabit) && (nameSelected && categorySelected && emojiSelected && colorSelected) {
                createButton.isEnabled = true
                createButton.backgroundColor = .yBlack
            }
        }
    }
}

//MARK: - ScheduleViewControllerDelegate
extension NewTrackerViewController: ScheduleViewControllerDelegate {
    func configSchedule(schedule: [Schedule]) {
        selectedSchedule = schedule
        let subText: String
        if schedule.count == WeekDays.allCases.count {
            subText = Constants.everyDaySubtext
        } else {
            subText = schedule.map { $0.weekDay.shortWeekDaysName}.joined(separator: ", ")
        }
        updateCell(subText: subText, indexPath: IndexPath(row: 1, section: 0))
        scheduleSelected = true
        checkTracker()
    }
}

//MARK: - CategoryViewControllerDelegate
extension NewTrackerViewController: CategoryViewControllerDelegate {
    func configCategory(selectedCategory: String) {
        let subText = selectedCategory
        updateCell(subText: subText, indexPath: IndexPath(row: 0, section: 0))
        categorySelected = true
        checkTracker()
    }
}

//MARK: - UITextFieldDelegate
extension NewTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let enteredName = textField.text, !enteredName.isEmpty {
            nameSelected = true
            checkTracker()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text!.count
        if range.length + range.location > text {
            return false
        }
        let newLimit = text + string.count - range.length
        if newLimit >= Constants.limit { showLabel() } else { hideLabel() }
        return newLimit <= Constants.limit
    }
}

//MARK: - Editing Tracker
private extension NewTrackerViewController {
    func editTracker() {
        configCreateButton()
        setTrackerName()
        setCategory()
        setSchedule()
        setEmoji()
        setColor()
    }
    
    func configCreateButton() {
        createButton.setTitle(Constants.saveButtonLabel, for: .normal)
        createButton.isEnabled = true
        createButton.backgroundColor = .yBlack
    }
    
    func setTrackerName() {
        textField.text = editingTracker?.trackerName
        nameSelected = true
    }
    
    func setCategory() {
        if let categoryTitle = editingCategory?.categoryTitle {
            updateCell(subText: categoryTitle, indexPath: IndexPath(row: 0, section: 0))
            categorySelected = true
            checkTracker()
        }
    }
    
    func setSchedule() {
            switch createHabit {
            case true: do {
                if let schedule = editingTracker?.schedule {
                    let text = schedule.map { $0.shortWeekDaysName}.joined(separator: ", ")
                    updateCell(subText: text, indexPath: IndexPath(row: 1, section: 0))
                    schedule.forEach {
                        let selectedDay = Schedule(weekDay: $0, isOn: true)
                        selectedSchedule.append(selectedDay)
                    }
                    scheduleSelected = true
                    checkTracker()
                }
            }
            case false: break
            }
        }
    
    func setEmoji() {
        if let emoji = editingTracker?.trackerEmoji {
            guard let index = propertiesData.trackerProperties[0].properties.firstIndex(of: emoji) else { return }
            let indexPath = IndexPath(row: index, section: 0)
            guard let cell = collectionView.cellForItem(at: indexPath) as? NewTrackerCollectionViewCell
            else {
                preconditionFailure("Failed to cast UICollectionViewCell as NewTrackerCollectionViewCell")
            }
            cell.selectCell(model: propertiesData, at: indexPath)
            selectedEmoji = indexPath.row
            trackerEmoji = propertiesData.trackerProperties[indexPath.section].properties[indexPath.row]
            emojiSelected = true
        }
    }
    
    func setColor() {
        if let color = editingTracker?.trackerColorStr {
            guard let index = propertiesData.trackerProperties[1].properties.firstIndex(of: color) else { return }
            let indexPath = IndexPath(row: index, section: 1)
            guard let cell = collectionView.cellForItem(at: indexPath) as? NewTrackerCollectionViewCell
            else {
                preconditionFailure("Failed to cast UICollectionViewCell as NewTrackerCollectionViewCell")
            }
            cell.selectCell(model: propertiesData, at: indexPath)
            selectedColor = indexPath.row
            trackerColor = propertiesData.trackerProperties[indexPath.section].properties[indexPath.row]
            colorSelected = true
        }
    }
    
}

