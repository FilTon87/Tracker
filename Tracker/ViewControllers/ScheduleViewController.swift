//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Anton Filipchuk on 03.02.2024.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    var weekDaysDataSource: Array<WeekDays> = []
    
    //MARK: - Private property
    private let doneButton = BlackButton(title: "Готово")
    private let tabelView = UITableView()
    
    
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
//        addTarget()
        addTabelView()
        configCell()
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
            
            doneButton.topAnchor.constraint(equalTo: tabelView.bottomAnchor, constant: 47),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
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
    
    func configCell() {
        weekDaysDataSource.append(contentsOf: [
            WeekDays(weekDayName: "Понедельник", weekDayOn: false),
            WeekDays(weekDayName: "Вторник", weekDayOn: false),
            WeekDays(weekDayName: "Среда", weekDayOn: false),
            WeekDays(weekDayName: "Четверг", weekDayOn: false),
            WeekDays(weekDayName: "Пятница", weekDayOn: false),
            WeekDays(weekDayName: "Суббота", weekDayOn: false),
            WeekDays(weekDayName: "Воскресенье", weekDayOn: false)
        ])
    }
}
    
    
    
extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekDaysDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTabelViewCell.reuseIdentifier) as! ScheduleTabelViewCell
        
        cell.configCell(with: weekDaysDataSource[indexPath.row])
        
        return cell
    }
}
