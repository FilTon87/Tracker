//
//  xzViewController.swift
//  Tracker
//
//  Created by Anton Filipchuk on 09.12.2023.
//

import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func cancelTrackerCreation()
}

final class NewTrackerViewController: UIViewController, ScheduleViewControllerDelegate {
    
    var isHabit: Bool = true
    weak var delegate: NewTrackerViewControllerDelegate?
    
    //MARK: - Private property
    private let textField = TextField(placeholder: "Введите название трекера")
    private let label = UILabel()
    private let cancelButton = CancelButton()
    private let createButton = CreateButton()
    private let tabelView = UITableView()
    private var settings: Array<NewTracker> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
}

//MARK: - Setting Views
private extension NewTrackerViewController {
    func setupViewController() {
        view.backgroundColor = .white
        addViewLabel()
        addSubView()
        addLayout()
        addTarget()
        addTabelView()
        configCell()
    }
    
    func addViewLabel() {
        navigationItem.title = isHabit ? "Новая привычка" : "Новое нерегулярное событие"
    }
}


//MARK: - Setting
private extension NewTrackerViewController {
    func addSubView() {
        view.addSubview(textField)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        view.addSubview(tabelView)
    }
    
    func addTarget() {
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }
    
    @objc func didTapCancelButton() {
        dismiss(animated: true)
        delegate?.cancelTrackerCreation()   
    }
}


//MARK: - Layout
private extension NewTrackerViewController {
    func addLayout() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        tabelView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([            
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            
            tabelView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tabelView.heightAnchor.constraint(equalToConstant: 150),
            tabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tabelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -2),
            
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -2)
        ])
    }
}


//MARK: - TabelView Settings
extension NewTrackerViewController: UITableViewDataSource, UITableViewDelegate {
    private func addTabelView() {
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.rowHeight = 75
        tabelView.register(NewTrackerTabelViewCell.self, forCellReuseIdentifier: NewTrackerTabelViewCell.reuseIdentifier)
        tabelView.layer.masksToBounds = true
        tabelView.layer.cornerRadius = 16
        tabelView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }
    
    private func configCell() {
        settings.append(
            NewTracker(
                name: "Категория",
                handler: { [weak self] in
                    guard let self = self else { return }
                    self.selectСategory()
                }))
        if isHabit {
            settings.append(
                NewTracker(
                    name: "Расписание",
                    handler: { [weak self] in
                        guard let self = self else { return }
                        self.selectShedule()
                    }))
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewTrackerTabelViewCell.reuseIdentifier) as! NewTrackerTabelViewCell
        
        cell.textLabel?.text = settings[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        settings[indexPath.row].handler()
    }
}

private extension NewTrackerViewController {
    
    func selectСategory() {
        let categoryViewController = CategoryViewController()
        categoryViewController.modalPresentationStyle = .automatic
        present(UINavigationController(rootViewController: categoryViewController), animated: true)
    }
    
    func selectShedule() {
        let scheduleViewController = ScheduleViewController()
        scheduleViewController.delegate = self
        scheduleViewController.modalPresentationStyle = .automatic
        present(UINavigationController(rootViewController: scheduleViewController), animated: true)
    }
}
