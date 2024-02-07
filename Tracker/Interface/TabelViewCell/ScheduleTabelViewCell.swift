//
//  ScheduleTabelViewCell.swift
//  Tracker
//
//  Created by Anton Filipchuk on 06.02.2024.
//

import UIKit

final class ScheduleTabelViewCell: UITableViewCell {
    
    private let weekDayLabel = UILabel()
    private let weekDaySwitch = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ScheduleTabelViewCell {
    func setupCell() {
        cellProperties()
        addSubView()
        addLayout()
    }
    
    func cellProperties() {
        self.backgroundColor = .yBackground
        weekDaySwitch.onTintColor = .yBlue
    }
    
    func addSubView() {
        contentView.addSubview(weekDayLabel)
        contentView.addSubview(weekDaySwitch)
    }
    
    func addLayout() {
        weekDayLabel.translatesAutoresizingMaskIntoConstraints = false
        weekDaySwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weekDayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            weekDayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            weekDaySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            weekDaySwitch.centerYAnchor.constraint(equalTo: weekDayLabel.centerYAnchor)
        ])
    }
}

extension ScheduleTabelViewCell {
    func configCell(with options: WeekDays) {
        weekDayLabel.text = options.weekDayName
        weekDaySwitch.isOn = options.weekDayOn
    }
}
