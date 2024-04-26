//
//  AddCategoryViewController.swift
//  Tracker
//
//  Created by Anton Filipchuk on 26.03.2024.
//

import UIKit

protocol AddCategoryViewControllerDelegate: AnyObject {
    func addCategory(_ newCategory: TrackerCategory)
}

final class AddCategoryViewController: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: AddCategoryViewControllerDelegate?
    
    //MARK: - Private property
    private let doneButton = BlackButton(title: "Готово")
    private let textField = TextField(placeholder: "Введите название категории")
    private let categoryStore = TrackerCategoryStore.shared
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
}

private extension AddCategoryViewController {
    func setupViewController() {
        view.backgroundColor = .white
        textField.delegate = self
        turnOffDoneButton()
        addViewLabel()
        addSubView()
        addLayout()
        addTarget()
    }
    
    func turnOffDoneButton() {
        doneButton.isEnabled = false
        doneButton.backgroundColor = .yGray
    }
    
    func addViewLabel() {
        navigationItem.title = "Новая категория"
    }
    
    func addSubView() {
        view.addSubview(doneButton)
        view.addSubview(textField)
    }
    
    func addLayout() {
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func addTarget() {
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
    }
    
    @objc func didTapDoneButton() {
        guard let categoryName = textField.text else {
            assertionFailure("No text in textField")
            return
        }
        let newCategory = TrackerCategory(categoryTitle: categoryName, trackers: [])
        delegate?.addCategory(newCategory)
        dismiss(animated: true)
    }
}

extension AddCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let categoryName = textField.text, !categoryName.isEmpty {
            doneButton.isEnabled = true
            doneButton.backgroundColor = .yBlack
        } else {
            turnOffDoneButton()
        }
        return true
    }
}
