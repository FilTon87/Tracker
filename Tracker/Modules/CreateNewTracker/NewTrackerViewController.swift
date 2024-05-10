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
    var createHabit: Bool = true
    weak var delegate: NewTrackerViewControllerDelegate?
    
    //MARK: - Private property
    private let textField = TextField(placeholder: "Введите название трекера")
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let params = GeometricParams(cellCount: 18, leftInset: 19, rightInset: 18, cellSpacing: 5)
    private let cancelButton = CancelButton()
    private let createButton = CreateButton()
    private let tabelView = UITableView()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 24
        return stackView
    }()
    
    private let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textColor = .yRed
        label.isHidden = true
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
            try dataProvider = TrackerDataProvider(trackerStore, delegate: self)
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
}

//MARK: - View Settings
private extension NewTrackerViewController {
    func setupViewController() {
        view.backgroundColor = .white
        textField.delegate = self
        addViewLabel()
        configCell()
        addSubView()
        addLayout()
        addTarget()
        addTabelView()
        addCollectionView()
    }
    
    func addViewLabel() {
        navigationItem.title = createHabit ? Constants.newHabbit : Constants.newEvent
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

        [textField,
         label].forEach {
            textFieldStackView.addArrangedSubview($0)
        }

        [textFieldStackView,
         tabelView,
         collectionView].forEach {
            mainStackView.addArrangedSubview($0)
        }
    }
    
    func addTarget() {
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
    }
    
    @objc func didTapCancelButton() {
        dismiss(animated: false)
        delegate?.cancelTrackerCreation()
    }
    
    @objc func didTapCreateButton() {
        guard let categoryTitle = tabelView.cellForRow(at: IndexPath(row: 0, section: 0))?.detailTextLabel?.text else {
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
            trackerEmoji: trackerEmoji,
            schedule: schedule,
            isHabit: createHabit)
        
        try? dataProvider?.addTracker(track, categoryTitle)
        
        dismiss(animated: false)
        delegate?.updateTrackers()
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
         tabelView,
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

            tabelView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 24),
            tabelView.heightAnchor.constraint(equalToConstant: heightOfTableView()),
            tabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tabelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: tabelView.bottomAnchor, constant: 32),
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
    private func addTabelView() {
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.rowHeight = 75
        tabelView.register(NewTrackerTabelViewCell.self, forCellReuseIdentifier: NewTrackerTabelViewCell.reuseIdentifier)
        tabelView.layer.masksToBounds = true
        tabelView.layer.cornerRadius = 16
        tabelView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner]
    }
    
    private func configCell() {
        if createHabit {
            addCategory()
            addShedule()
        } else {
            addCategory()
        }
    }
    
    private func addCategory() {
        settings.append( NewTracker(
            name: "Категория",
            handler: { [weak self] in
                guard let self = self else { return }
                self.selectСategory()
            }))
    }
    
    private func addShedule() {
        settings.append(
            NewTracker(
                name: "Расписание",
                handler: { [weak self] in
                    guard let self = self else { return }
                    self.selectShedule()
                }))
    }
    
    private func heightOfTableView() -> CGFloat {
        if settings.count == 2 { return CGFloat(150) } else { return CGFloat(75) }
    }
    
    private func updateCell(subText: String, indexPath: IndexPath) {
        guard let cell = tabelView.cellForRow(at: indexPath) as? NewTrackerTabelViewCell else {
            assertionFailure("No cell as NewTrackerTabelViewCell")
            return
        }
        cell.detailTextLabel?.text = subText
        tabelView.reloadData()
    }
    
    private func showLabel() {
        UIView.animate(withDuration: 0.25) {
            self.label.isHidden = false
        }
    }
    
    private func hideLabel() {
        UIView.animate(withDuration: 0.25) {
            self.label.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewTrackerTabelViewCell.reuseIdentifier) as! NewTrackerTabelViewCell
        cell.textLabel?.text = settings[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        settings[indexPath.row].handler()
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


private extension NewTrackerViewController {
    
    func selectСategory() {
        let categoryViewController = CategoryViewController()
        categoryViewController.delegate = self
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

extension NewTrackerViewController: ScheduleViewControllerDelegate {
    
    func configSchedule(schedule: [Schedule]) {
        selectedSchedule = schedule
        let subText: String
        if schedule.count == WeekDays.allCases.count {
            subText = "Каждый день"
        } else {
            subText = schedule.map { $0.weekDay.shortWeekDaysName}.joined(separator: ", ")
        }
        updateCell(subText: subText, indexPath: IndexPath(row: 1, section: 0))
        scheduleSelected = true
        checkTracker()
    }
}

extension NewTrackerViewController: CategoryViewControllerDelegate {
    func configCategory(selectedCategory: String) {
        let subText = selectedCategory
        updateCell(subText: subText, indexPath: IndexPath(row: 0, section: 0))
        categorySelected = true
        checkTracker()
    }
}

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
        if newLimit <= 38 { hideLabel() } else { showLabel() }
        return newLimit <= 38
    }

}

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

extension NewTrackerViewController: TrackerDataProviderDelegate {

}
