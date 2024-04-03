//
//  ScheduleTabelViewCell.swift
//  Tracker
//
//  Created by Anton Filipchuk on 06.02.2024.
//

import UIKit

protocol ScheduleTabelViewCellDelegate: AnyObject {    
    func selectWeekDay(isON: Bool, weekDay: WeekDays)
}

final class ScheduleTabelViewCell: UITableViewCell {
    
    weak var delegate: ScheduleTabelViewCellDelegate?
    
    private let weekDayLabel = UILabel()
    private let weekDaySwitch = UISwitch()
    private var weekDay: WeekDays?
    
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
        backgroundColor = .yBackground
        weekDaySwitch.onTintColor = .yBlue
        weekDaySwitch.addTarget(self, action: #selector(changeSwitch), for: .valueChanged)
    }
    
    @objc func changeSwitch() {
        guard let weekDay = weekDay else {
            assertionFailure("No weekDay")
            return
        }
        delegate?.selectWeekDay(isON: weekDaySwitch.isOn, weekDay: weekDay)
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
    func configCell(indexPath: IndexPath) {
        weekDay = WeekDays.allCases[indexPath.row]
        weekDayLabel.text = WeekDays.allCases[indexPath.row].longWeekDaysName
    }
}
