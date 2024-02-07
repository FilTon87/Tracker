//
//  CreateViewController.swift
//  Tracker
//
//  Created by Anton Filipchuk on 09.12.2023.
//

import UIKit

protocol AddTrackViewControllerDelegate: AnyObject {
    
}

final class AddTrackViewController: UIViewController {
    
    //MARK: - Private property
    private let label = UILabel()
    private let habitButton = BlackButton(title: "Привычка")
    private let eventButton = BlackButton(title: "Нерегулярное событие")
    
    weak var delegate: AddTrackViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeViewController()
    }
}


//MARK: - Setting Views
private extension AddTrackViewController {
    func makeViewController() {
        view.backgroundColor = .white
        makeViewLabel()
        addSubView()
        setupLayout()
        addTarget()
    }
    
    func makeViewLabel() {
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.text = "Создание трекера"
    }
}

//MARK: - Setting
private extension AddTrackViewController {
    func addSubView() {
        view.addSubview(label)
        view.addSubview(habitButton)
        view.addSubview(eventButton)
    }
    
    func addTarget() {
        habitButton.addTarget(self, action: #selector(selection), for: .touchUpInside)
        eventButton.addTarget(self, action: #selector(selection), for: .touchUpInside)
    }
    
    @objc private func selection(_ sender: UIButton) {
        if sender.titleLabel?.text == "Привычка" {
            let viewController = NewTrackViewController()
            viewController.isHabit = true
            viewController.modalPresentationStyle = .automatic
            present(viewController, animated: true)
        } else {
            let viewController = NewTrackViewController()
            viewController.isHabit = false
            viewController.modalPresentationStyle = .automatic
            present(viewController, animated: true)
        }
    }
}

//MARK: - Layout
private extension AddTrackViewController {
    func setupLayout() {
        label.translatesAutoresizingMaskIntoConstraints = false
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 13),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            habitButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 295),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            eventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            eventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16)
        ])
    }
}

