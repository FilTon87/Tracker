//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Anton Filipchuk on 03.02.2024.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func configSchedule(schedule: [Schedule])
}

final class ScheduleViewController: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: ScheduleViewControllerDelegate?
    
    
    //MARK: - Private property
    private lazy var doneButton = BlackButton(title: Constants.doneButtonLabel)
    private lazy var tableView = TableView(frame: .zero, style: .plain)
    private var schedule: [Schedule] = []
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
}

private extension ScheduleViewController {
    func setupViewController() {
        view.backgroundColor = .white
        addViewLabel()
        addSubView()
        addLayout()
        addTarget()
        addTabelView()
    }
    
    func addViewLabel() {
        navigationItem.title = Constants.scheduleViewControllerName
    }
    
    func addSubView() {
        view.addSubview(tableView)
        view.addSubview(doneButton)
    }
    
    func addLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func addTarget() {
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
    }
    
    func addTabelView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ScheduleTabelViewCell.self, forCellReuseIdentifier: ScheduleTabelViewCell.reuseIdentifier)
    }
    
    @objc func didTapDoneButton() {
        schedule = schedule.sorted(by: {$0.weekDay.rawValue < $1.weekDay.rawValue})
        delegate?.configSchedule(schedule: schedule)
        dismiss(animated: true)
    }
}

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDays.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTabelViewCell.reuseIdentifier) as! ScheduleTabelViewCell
        cell.delegate = self
        cell.configCell(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == WeekDays.allCases.count - 1
        let defaultInset = tableView.separatorInset
        
        if isLastCell {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.width)
        } else {
            cell.separatorInset = defaultInset
        }
    }
}

extension ScheduleViewController: ScheduleTabelViewCellDelegate {
    func selectWeekDay(isON: Bool, weekDay: WeekDays) {
        let selectedDay = Schedule(weekDay: weekDay, isOn: isON)
        if isON {
            schedule.append(selectedDay)
        } else {
            schedule.removeAll { selectedDay in
                selectedDay.weekDay == weekDay
            }
        }
    }
}

extension ScheduleViewController: NewTrackerViewControllerCallback {
    func updateTableView(_ schedule: [Schedule]) {
    }

}
