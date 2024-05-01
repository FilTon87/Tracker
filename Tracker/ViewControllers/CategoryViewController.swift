//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Anton Filipchuk on 06.02.2024.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func configCategory(selectedCategory: String)
}

final class CategoryViewController: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: CategoryViewControllerDelegate?
    
    //MARK: - Private property
    private let addCategoryButton = BlackButton(title: "Добавить категорию")
    private let placeholder = TrackersPlaceholder(title: "Привычки и события можно\nобъединять по смыслу", image: "Start")
    private let tabelView = UITableView()
    
    private lazy var dataProvider: TrackerCategoryProtocol? = {
        let trackerCategoryStore = TrackerCategoryStore.shared
        do {
            try dataProvider = CategoryDataProvider(trackerCategoryStore, delegate: self)
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

private extension CategoryViewController {
    func setupViewController() {
        view.backgroundColor = .white
        addViewLabel()
        addSubView()
        addLayout()
        checkPlaceholder()
        addTarget()
        addTabelView()
    }
    
    func addViewLabel() {
        navigationItem.title = "Категория"
    }
    
    func addSubView() {
        [placeholder,
         tabelView,
         addCategoryButton].forEach {
            view.addSubview($0)
        }
    }
    
    func addLayout() {
        [placeholder,
         tabelView,
         addCategoryButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            placeholder.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            placeholder.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            tabelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tabelView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 16),
            tabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tabelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func checkPlaceholder() {
        if dataProvider?.numbersOfRowsInSection(0) != 0 {
            tabelView.isHidden = false
            placeholder.isHidden = true
        } else {
            tabelView.isHidden = true
            placeholder.isHidden = false
        }
    }
    
    func addTarget() {
        addCategoryButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    }
    
    func addTabelView() {
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.rowHeight = 75
        tabelView.register(CategoryTabelViewCell.self, forCellReuseIdentifier: CategoryTabelViewCell.reuseIdentifier)
        tabelView.layer.masksToBounds = true
        tabelView.layer.cornerRadius = 16
        tabelView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }
    
    @objc func didTapAddButton() {
        let viewController = AddCategoryViewController()
        viewController.delegate = self
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider?.numbersOfRowsInSection(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let record = dataProvider?.object(at: indexPath) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTabelViewCell.reuseIdentifier) as! CategoryTabelViewCell
        cell.textLabel?.text = record.categoryTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let record  = dataProvider?.object(at: indexPath)
        guard let selectedCategory = record?.categoryTitle else { return }
        delegate?.configCategory(selectedCategory: selectedCategory)
        dismiss(animated: true)
    }
}

extension CategoryViewController: AddCategoryViewControllerDelegate {
    func addCategory(_ newCategory: TrackerCategory) {
        try? dataProvider?.addCategory(newCategory)
        checkPlaceholder()
    }
}

extension CategoryViewController: DataProviderDelegate {
    func update(_ update: CategoryUpdate) {
        tabelView.performBatchUpdates {
            let insertIndexPath = update.insertedIndexes.map { IndexPath(item: $0, section: 0) }
            let deletedIndexPath = update.deleteIndexes.map { IndexPath(item: $0, section: 0) }
            tabelView.insertRows(at: insertIndexPath, with: .automatic)
            tabelView.deleteRows(at: deletedIndexPath, with: .fade)
        }
    }
}
