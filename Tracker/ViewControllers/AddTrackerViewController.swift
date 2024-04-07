//
//  CreateViewController.swift
//  Tracker
//
//  Created by Anton Filipchuk on 09.12.2023.
//

import UIKit

protocol AddTrackerViewControllerDelegate: AnyObject {
    func addTracker(categoryTitle: String, tracker: Tracker)
}

final class AddTrackerViewController: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: AddTrackerViewControllerDelegate?
    
    
    //MARK: - Private property
    private let label = UILabel()
    private let habitButton = BlackButton(title: "Привычка")
    private let eventButton = BlackButton(title: "Нерегулярное событие")
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
}


//MARK: - View Settings
private extension AddTrackerViewController {
    func setupViewController() {
        view.backgroundColor = .white
        addViewLabel()
        addSubView()
        addLayout()
        addTarget()
    }
    
    func addViewLabel() {
        navigationItem.title = "Создание трекера"
    }
}

//MARK: - Setting
private extension AddTrackerViewController {
    func addSubView() {
        view.addSubview(habitButton)
        view.addSubview(eventButton)
    }
    
    func addTarget() {
        habitButton.addTarget(self, action: #selector(selection), for: .touchUpInside)
        eventButton.addTarget(self, action: #selector(selection), for: .touchUpInside)
    }
    
    @objc private func selection(_ sender: UIButton) {
        if sender.titleLabel?.text == "Привычка" {
            let viewController = NewTrackerViewController()
            viewController.isHabit = true
            viewController.delegate = self
            viewController.modalPresentationStyle = .automatic
            present(UINavigationController(rootViewController: viewController), animated: true)
        } else {
            let viewController = NewTrackerViewController()
            viewController.isHabit = false
            viewController.delegate = self
            viewController.modalPresentationStyle = .automatic
            present(UINavigationController(rootViewController: viewController), animated: true)
        }
    }
}

//MARK: - Layout
private extension AddTrackerViewController {
    func addLayout() {
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            habitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -357),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            eventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            eventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16)
        ])
    }
}

extension AddTrackerViewController: NewTrackerViewControllerDelegate {
    func createTracker(categoryName: String, track: Tracker) {
        delegate?.addTracker(categoryTitle: categoryName, tracker: track)
        dismiss(animated: true)
    }
    
    func cancelTrackerCreation() {
        dismiss(animated: true)
    }
}
