//
//  NewTrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Anton Filipchuk on 04.04.2024.
//

import UIKit

final class NewTrackerCollectionViewCell: UICollectionViewCell {
    
    private var indexPath: IndexPath?
    
    private lazy var cellView = UIView()
    private lazy var cellLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NewTrackerCollectionViewCell {
    func setupCell() {
        settingElements()
        addSubView()
        addLayout()
    }
    
    func settingElements() {
        cellView.layer.cornerRadius = 8
        cellView.layer.masksToBounds = true
        
        cellLabel.layer.cornerRadius = 8
        cellLabel.layer.masksToBounds = true
        cellLabel.font = .systemFont(ofSize: 32, weight: .bold)
        cellLabel.textAlignment = .center
    }
    
    func addSubView() {
        contentView.addSubview(cellView)
        cellView.addSubview(cellLabel)
    }
    
    func addLayout() {
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellView.widthAnchor.constraint(equalToConstant: 52),
            cellView.heightAnchor.constraint(equalToConstant: 52),
            cellView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cellView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            cellLabel.widthAnchor.constraint(equalToConstant: 40),
            cellLabel.heightAnchor.constraint(equalToConstant: 40),
            cellLabel.centerXAnchor.constraint(equalTo: cellView.centerXAnchor),
            cellLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor)
        ])
    }
}

extension NewTrackerCollectionViewCell {
    func fillCell(model: TrackerProperties, at indexPath: IndexPath) {
        self.indexPath = indexPath
        if model.trackerProperties[indexPath.section].name == Localization.emojiLabel {
            cellLabel.text = model.trackerProperties[0].properties[indexPath.row]
        } else {
            let color = model.trackerProperties[1].properties[indexPath.row]
            cellLabel.backgroundColor = UIColor(named: "\(color)")
        }
    }
    
    func selectCell(model: TrackerProperties,  at indexPath: IndexPath) {
        if indexPath.section.self == 0 {
            cellLabel.backgroundColor = .yLightGray
        } else {
            let colorName = model.trackerProperties[indexPath.section].properties[indexPath.row]
            let color = UIColor(named: "\(colorName)")?.withAlphaComponent(0.3)
            cellView.layer.borderWidth = 3
            cellView.layer.borderColor = color?.cgColor
        }
    }
    
    func deselectCell(at indexPath: IndexPath) {
        if indexPath.section.self == 0 {
            cellLabel.backgroundColor = .yWhite
        } else {
            cellView.layer.borderWidth = 0
        }        
    }
}
