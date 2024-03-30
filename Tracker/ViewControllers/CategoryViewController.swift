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
    
    weak var delegate: CategoryViewControllerDelegate?
    
    
    //MARK: - Private property
    private let addCategoryButton = BlackButton(title: "Добавить категорию")
    private let placeholder = TrackersPlaceholder(title: "Привычки и события можно\nобъединять по смыслу", image: "Start")
    private let tabelView = UITableView()
    private var category: [TrackerCategory] = []
    
    
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
        addPlaceholder()
        addTarget()
        addTabelView()
    }
    
    func addViewLabel() {
        navigationItem.title = "Категория"
    }
    
    func addSubView() {
        view.addSubview(placeholder)
        view.addSubview(tabelView)
        view.addSubview(addCategoryButton)
    }
    
    func addLayout() {
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        tabelView.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    func addPlaceholder() {
        if !category.isEmpty {
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
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTabelViewCell.reuseIdentifier) as! CategoryTabelViewCell
 //       cell.delegate = self
        cell.textLabel?.text = category[indexPath.row].categoryTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = category[indexPath.row].categoryTitle
        delegate?.configCategory(selectedCategory: selectedCategory)
        dismiss(animated: true)
    }
}

extension CategoryViewController: AddCategoryViewControllerDelegate {
    func addCategory(categoryName: String) {
        category.append(TrackerCategory(categoryTitle: "\(categoryName)", trackers: []))
        tabelView.reloadData()
        addPlaceholder()
    }
}
