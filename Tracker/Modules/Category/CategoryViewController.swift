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
    var viewModel = CategoryViewModel()
    
    //MARK: - Private property
    private lazy var addCategoryButton = BlackButton(title: Constants.addCategoryButtonLabel)
    private lazy var placeholder = TrackersPlaceholder(title: Constants.categoryPlaceholderLabel, image: Constants.categoryPlaceholderImage)
    private lazy var tableView = TableView(frame: .zero, style: .plain)
        
    // MARK: - View Life Cycles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getCategories()
    }
    
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
        addTarget()
        addTabelView()
        bindViewModel()
    }
    
    func addViewLabel() {
        navigationItem.title = Constants.categoryViewControllerName
    }
    
    func addSubView() {
        [placeholder,
         tableView,
         addCategoryButton].forEach {
            view.addSubview($0)
        }
    }
    
    func addLayout() {
        [placeholder,
         tableView,
         addCategoryButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            placeholder.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            placeholder.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func bindViewModel() {
        viewModel.isData.bind { [weak self] isData in
            guard let self, let isData else { return }
            isData ? hidePlaceholder() : showPlaceholder()
        }   
    }
    
    func showPlaceholder() {
        tableView.isHidden = true
        placeholder.isHidden = false
    }
    
    func hidePlaceholder() {
        tableView.isHidden = false
        placeholder.isHidden = true
    }
    
    func addTarget() {
        addCategoryButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    }
    
    func addTabelView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryTabelViewCell.self, forCellReuseIdentifier: CategoryTabelViewCell.reuseIdentifier)
    }
    
    @objc func didTapAddButton() {
        let viewController = AddCategoryViewController()
        viewController.delegate = self
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numbersOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let record = viewModel.object(at: indexPath) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTabelViewCell.reuseIdentifier) as! CategoryTabelViewCell
        cell.textLabel?.text = record.categoryTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let record  = viewModel.object(at: indexPath)
        guard let selectedCategory = record?.categoryTitle else { return }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        delegate?.configCategory(selectedCategory: selectedCategory)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == viewModel.numbersOfRows - 1
        let defaultInset = tableView.separatorInset
        
        if isLastCell {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.width)
        } else {
            cell.separatorInset = defaultInset
        }
    }
}

extension CategoryViewController: AddCategoryViewControllerDelegate {
    func addCategory(_ newCategory: TrackerCategory) {
        try? viewModel.addCategory(newCategory)
        tableView.reloadData()
    }
}
