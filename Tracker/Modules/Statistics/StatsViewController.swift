//
//  StatsViewController.swift
//  Tracker
//
//  Created by Anton Filipchuk on 29.11.2023.
//

import UIKit

final class StatsViewController: UIViewController {
    
    private let statsPlaceholder = TrackersPlaceholder(title: Constants.statsPlaceholderLabel, image: Constants.statsPlaceholderImage)
    private lazy var tableView = TableView(frame: .zero, style: .plain)
    
    private let recordStore = TrackerRecordStore.shared
    
    private var statistics: [Statistic] = [
        Statistic(statisticName: Constants.statsBestPeriod, statisticValue: 0),
        Statistic(statisticName: Constants.statsPerfectDays, statisticValue: 0),
        Statistic(statisticName: Constants.statsTrackersСompleted, statisticValue: 0),
        Statistic(statisticName: Constants.statsAverageValue, statisticValue: 0),
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
        navigationItem.title = Constants.statsViewControllerName
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
    
    func showPlaceholder() {
        statsPlaceholder.isHidden = false
        tableView.isHidden = true
    }
    
    func hidePlaceholder() {
        statsPlaceholder.isHidden = true
        tableView.isHidden = false
    }
    
    func addTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .yWhite
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.separatorColor = UIColor.clear
        tableView.register(StatsTableViewCell.self, forCellReuseIdentifier: StatsTableViewCell.reuseIdentifier)
        
        NSLayoutConstraint.activate([
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 408),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
    
    func getStatistics() {
        let trackersСompleted = recordStore.getCompletedTrackers()
        switch trackersСompleted > 0 {
        case true: hidePlaceholder()
        case false: showPlaceholder()
        }
        statistics[2] = Statistic(statisticName: Constants.statsTrackersСompleted, statisticValue: trackersСompleted)
        
        let average = recordStore.getAverage()
        statistics[3] = Statistic(statisticName: Constants.statsAverageValue, statisticValue: average)
        
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        102
    }
}

//MARK: - UITableViewDelegate
extension StatsViewController: UITableViewDelegate {
    
}
