//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Anton Filipchuk on 07.02.2024.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    let colorView = UIView()
    let trackerEmoji = UIImageView()
    let trackerLabel = UILabel()
    let dayLabel = UILabel()
    let doneTrackerButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TrackerCollectionViewCell {
    func setupCell() {
        settingElements()
        addSubView()
        addLayout()
    }
    
    func settingElements() {
        colorView.backgroundColor = .red
        
        trackerLabel.textColor = .yWhite
        trackerLabel.font = .systemFont(ofSize: 12)
        trackerLabel.numberOfLines = 2
        
        dayLabel.textColor = .yBlack
        dayLabel.font = .systemFont(ofSize: 12)
        
        doneTrackerButton.setImage(UIImage(named: "Plus"), for: .normal)
        doneTrackerButton.backgroundColor = colorView.backgroundColor
    }
    
    func addSubView() {
        contentView.addSubview(colorView)
        colorView.addSubview(trackerLabel)
        colorView.addSubview(trackerEmoji)
        contentView.addSubview(dayLabel)
        contentView.addSubview(doneTrackerButton)
    }
    
    func addLayout() {
        colorView.translatesAutoresizingMaskIntoConstraints = false
        trackerEmoji.translatesAutoresizingMaskIntoConstraints = false
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        doneTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -58),
            
            trackerEmoji.heightAnchor.constraint(equalToConstant: 24),
            trackerEmoji.widthAnchor.constraint(equalToConstant: 24),
            trackerEmoji.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            trackerEmoji.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            trackerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            trackerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            trackerLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12),
            
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            dayLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 16),
            dayLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            doneTrackerButton.heightAnchor.constraint(equalToConstant: 34),
            doneTrackerButton.widthAnchor.constraint(equalToConstant: 34),
            doneTrackerButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            doneTrackerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
}

extension UICollectionViewCell {
    static var cellReuseIdentifier: String {
        return String(describing: self)
    }
}
