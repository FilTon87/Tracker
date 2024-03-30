//
//  xzViewController.swift
//  Tracker
//
//  Created by Anton Filipchuk on 09.12.2023.
//

import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func cancelTrackerCreation()
    func createTracker(categoryName: String, track: Track)
}

final class NewTrackerViewController: UIViewController {
    
    var isHabit: Bool = true
    weak var delegate: NewTrackerViewControllerDelegate?
    
    //MARK: - Private property
    private let textField = TextField(placeholder: "Введите название трекера")
    private let label = UILabel()
    private let cancelButton = CancelButton()
    private let createButton = CreateButton()
    private let tabelView = UITableView()
    private var trackerName: String = ""
    private var isScheduleSelected = false
    private var selectedSchedule: [Schedule] = []
    private var schedule: [WeekDays] = []
    private var isCategorySelected = false
    private var settings: Array<NewTracker> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
}

//MARK: - Setting Views
private extension NewTrackerViewController {
    func setupViewController() {
        view.backgroundColor = .white
        addViewLabel()
        addSubView()
        addLayout()
        addTarget()
        addTabelView()
        configCell()
    }
    
    func addViewLabel() {
        navigationItem.title = isHabit ? "Новая привычка" : "Новое нерегулярное событие"
    }
}


//MARK: - Setting
private extension NewTrackerViewController {
    func addSubView() {
        view.addSubview(textField)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        view.addSubview(tabelView)
    }
    
    func addTarget() {
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
    }
    
    @objc func didTapCancelButton() {
        dismiss(animated: true)
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
        
        let trackerColor = UIColor.yRed
        let trackerEmoji = "❌"
        
        selectedSchedule.forEach { schedule.append($0.weekDay.self) }
        
        let track = Track(
            id: UUID(),
            trackerName: trackerName,
            trackerColor: trackerColor,
            trackerEmoji: trackerEmoji,
            schedule: schedule)
        
        dismiss(animated: true)
        delegate?.createTracker(categoryName: categoryTitle, track: track)
    }
}


//MARK: - Layout
private extension NewTrackerViewController {
    func addLayout() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        tabelView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            
            tabelView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tabelView.heightAnchor.constraint(equalToConstant: 150),
            tabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tabelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
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
        tabelView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }
    
    private func configCell() {
        settings.append(
            NewTracker(
                name: "Категория",
                handler: { [weak self] in
                    guard let self = self else { return }
                    self.selectСategory()
                }))
        if isHabit {
            settings.append(
                NewTracker(
                    name: "Расписание",
                    handler: { [weak self] in
                        guard let self = self else { return }
                        self.selectShedule()
                    }))
        }
    }
    
    private func updateCell(subText: String, indexPath: IndexPath) {
        guard let cell = tabelView.cellForRow(at: indexPath) as? NewTrackerTabelViewCell else {
            assertionFailure("No cell as NewTrackerTabelViewCell")
            return
        }
        cell.detailTextLabel?.text = subText
        tabelView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewTrackerTabelViewCell.reuseIdentifier) as! NewTrackerTabelViewCell
        cell.textLabel?.text = settings[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        settings[indexPath.row].handler()
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
        let emojiSelected = true
        let colorSelected = true
        guard let trackerName = textField.text else {
            assertionFailure("no tracker name")
            return
        }
        
        if !trackerName.isEmpty && isCategorySelected && isScheduleSelected && emojiSelected && colorSelected {
            createButton.isEnabled = true
            createButton.backgroundColor = .yBlack
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
        isScheduleSelected = true
        checkTracker()
    }
}

extension NewTrackerViewController: CategoryViewControllerDelegate {
    func configCategory(selectedCategory: String) {
        let subText = selectedCategory
        updateCell(subText: subText, indexPath: IndexPath(row: 0, section: 0))
        isCategorySelected = true
        checkTracker()
    }
}

extension NewTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let enteredName = textField.text, !enteredName.isEmpty {
            checkTracker()
        }
        return true
    }
}
