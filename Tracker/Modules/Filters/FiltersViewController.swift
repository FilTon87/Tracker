//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Anton Filipchuk on 27.05.2024.
//

import UIKit


final class FiltersViewController: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: TrackersViewControllerDelegate?
    
    //MARK: - Private property
    private let defaults = UserDefaults.standard
    private lazy var tableView = TableView(frame: .zero, style: .plain)
    private let filters: [String] = [Localization.filterAllTrackers, Localization.filterTodayTrackers, Localization.filterCompletedTrackers, Localization.filterNotCompletedTrackers]
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addCheckmark()
    }
}

// MARK: - Config View
private extension FiltersViewController {
    func setupViewController() {
        view.backgroundColor = .yWhite
        addViewLabel()
        addSubView()
        addLayout()
        addTableView()
    }
    
    func addCheckmark() {
        var row: Int = 0
        row = defaults.integer(forKey: "selectedFilter")
        let indexPath = IndexPath(row: row, section: 0)
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func addViewLabel() {
        navigationItem.title = Localization.filtersViewControllerName
    }
    
    func addSubView() {
        view.addSubview(tableView)
    }
    
    func addLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.heightAnchor.constraint(equalToConstant: 300),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    func addTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.register(CategoryTabelViewCell.self, forCellReuseIdentifier: CategoryTabelViewCell.reuseIdentifier)
        addCheckmark()
    }
}

// MARK: - UITableViewDataSource
extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTabelViewCell.reuseIdentifier) as! CategoryTabelViewCell
        cell.textLabel?.text = filters[indexPath.row]
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        delegate?.applyFilter(indexPath.row)
        defaults.setValue(indexPath.row, forKey: "selectedFilter")
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == filters.count - 1
        let defaultInset = tableView.separatorInset
        
        if isLastCell {
            cell.separatorInset = UIEdgeInsets(top: cell.bounds.width, left: 0, bottom: 0, right: cell.bounds.width)
        } else {
            cell.separatorInset = defaultInset
        }
    }
    
}
