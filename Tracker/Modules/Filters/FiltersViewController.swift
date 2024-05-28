//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Anton Filipchuk on 27.05.2024.
//

import UIKit


final class FiltersViewController: UIViewController {
    
    // MARK: - Public Properties
//    weak var delegate: CategoryViewControllerDelegate?
    
    //MARK: - Private property
    private lazy var tableView = TableView(frame: .zero, style: .plain)
    private let filters: [String] = [Constants.filterAllTrackers, Constants.filterTodayTrackers, Constants.filterCompletedTrackers, Constants.filterNotCompletedTrackers]
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
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
    
    func addViewLabel() {
        navigationItem.title = Constants.filtersViewControllerName
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
//        delegate?.configCategory(selectedCategory: selectedCategory)
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
