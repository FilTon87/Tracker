//
//  StatsViewController.swift
//  Tracker
//
//  Created by Anton Filipchuk on 29.11.2023.
//

import UIKit

final class StatsViewController: UIViewController {
    
    private let statsPlaceholder = TrackersPlaceholder(title: Localization.statsPlaceholderLabel, image: Images.statsPlaceholderImage)
    private lazy var tableView = TableView(frame: .zero, style: .plain)
    
    private let recordStore = TrackerRecordStore.shared
    
    private var statistics: [Statistic] = [
        Statistic(statisticName: Localization.statsBestPeriod, statisticValue: 0),
        Statistic(statisticName: Localization.statsPerfectDays, statisticValue: 0),
        Statistic(statisticName: Localization.statsTrackersСompleted, statisticValue: 0),
        Statistic(statisticName: Localization.statsAverageValue, statisticValue: 0),
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStatistics()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        addPlaceholder()
        addTableView()
    }
}

//MARK: - Setup View
private extension StatsViewController {
    
    func setupViewController() {
        view.backgroundColor = .yWhite
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .yWhite
        navigationItem.title = Localization.statsViewControllerName
    }
    
    func addPlaceholder() {
        view.addSubview(statsPlaceholder)
        statsPlaceholder.isHidden = true
        
        statsPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            statsPlaceholder.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            statsPlaceholder.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    func changeStatePlaceholder(isHidden: Bool) {
        statsPlaceholder.isHidden = isHidden
        tableView.isHidden = !isHidden
    }
    
    func addTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.backgroundColor = .yWhite
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.separatorColor = UIColor.clear
        tableView.rowHeight = 97
        tableView.register(StatsTableViewCell.self, forCellReuseIdentifier: StatsTableViewCell.reuseIdentifier)
        
        NSLayoutConstraint.activate([
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 388),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
    
    func getStatistics() {
        let trackersСompleted = recordStore.getCompletedTrackers()
        switch trackersСompleted > 0 {
        case true: changeStatePlaceholder(isHidden: true)
        case false: changeStatePlaceholder(isHidden: false)
        }
        statistics[2] = Statistic(statisticName: Localization.statsTrackersСompleted, statisticValue: trackersСompleted)
        
        let average = recordStore.getAverage()
        statistics[3] = Statistic(statisticName: Localization.statsAverageValue, statisticValue: average)
        
        tableView.reloadData()
    }
    
}

//MARK: - UITableViewDataSource
extension StatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        statistics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatsTableViewCell.reuseIdentifier) as! StatsTableViewCell
        cell.configCell(statistics, indexPath)
        return cell
    }
    
}
