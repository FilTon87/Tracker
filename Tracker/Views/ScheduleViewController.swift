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
    private let doneButton = BlackButton(title: "Готово")
    private let tabelView = UITableView()
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
        navigationItem.title = "Расписание"
    }
    
    func addSubView() {
        view.addSubview(tabelView)
        view.addSubview(doneButton)
    }
    
    func addLayout() {
        tabelView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tabelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tabelView.heightAnchor.constraint(equalToConstant: 525),
            tabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tabelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func addTarget() {
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
    }
    
    func addTabelView() {
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.rowHeight = 75
        tabelView.register(ScheduleTabelViewCell.self, forCellReuseIdentifier: ScheduleTabelViewCell.reuseIdentifier)
        tabelView.layer.masksToBounds = true
        tabelView.layer.cornerRadius = 16
        tabelView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
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
