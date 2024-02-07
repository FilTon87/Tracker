//
//  xzViewController.swift
//  Tracker
//
//  Created by Anton Filipchuk on 09.12.2023.
//

import UIKit

final class NewTrackViewController: UIViewController {
    
    var isHabit: Bool = true
    
    //MARK: - Private property
    private let textField = TextField(placeholder: "Введите название трекера")
    private let label = UILabel()
    private let cancelButton = CancelButton()
    private let createButton = CreateButton()
    private let tabelView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeViewController()
    }
}

//MARK: - Setting Views
private extension NewTrackViewController {
    func makeViewController() {
        view.backgroundColor = .white
        makeViewLabel()
        addSubView()
        setupLayout()
        addTarget()
        makeTabelView()
    }
    
    func makeViewLabel() {
        label.font = .systemFont(ofSize: 16)
        label.text = isHabit ? "Новая привычка" : "Новое нерегулярное событие"
    }
}


//MARK: - Setting
private extension NewTrackViewController {
    func addSubView() {
        view.addSubview(textField)
        view.addSubview(label)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        view.addSubview(tabelView)
    }
    
    func addTarget() {
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    }
    
    @objc private func cancel() {
       dismiss(animated: true)
    }
}


//MARK: - Layout
private extension NewTrackViewController {
    func setupLayout() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        tabelView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 13),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
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
extension NewTrackViewController: UITableViewDataSource, UITableViewDelegate {
    private func makeTabelView() {
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.rowHeight = 75
        tabelView.register(NewTrackTabelViewCell.self, forCellReuseIdentifier: NewTrackTabelViewCell.reuseIdentifier)
        tabelView.layer.masksToBounds = true
        tabelView.layer.cornerRadius = 16
        tabelView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewTrackTabelViewCell.reuseIdentifier) as! NewTrackTabelViewCell
        
//        if cell == nil {
//            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle,
//                                   reuseIdentifier: cellID)
//        }
        
//        cell!.backgroundColor = .yBackground
//        
//        cell!.textLabel?.text = "Main text"
//        cell!.detailTextLabel?.text = "some text"

        
        return cell

    }

}
