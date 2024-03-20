//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Anton Filipchuk on 07.02.2024.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    let colorView = UIView()
    let emojiView = UIView()
    let emojiLabel = UILabel()
    let trackerNameLabel = UILabel()
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
        colorView.layer.cornerRadius = 16
        colorView.layer.masksToBounds = true
        
        emojiView.layer.cornerRadius = 12
        emojiView.layer.masksToBounds = true
        emojiView.backgroundColor = .yBackground
        
        emojiLabel.font = .systemFont(ofSize: 16)
        
        trackerNameLabel.textColor = .yWhite
        trackerNameLabel.font = .systemFont(ofSize: 12)
        trackerNameLabel.numberOfLines = 2
        
        dayLabel.textColor = .yBlack
        dayLabel.font = .systemFont(ofSize: 12)
        
        doneTrackerButton.setImage(UIImage(named: "Plus"), for: .normal)
        doneTrackerButton.tintColor = .yWhite
        doneTrackerButton.layer.cornerRadius = 17
        doneTrackerButton.layer.masksToBounds = true
        doneTrackerButton.backgroundColor = colorView.backgroundColor
    }
    
    func addSubView() {
        contentView.addSubview(colorView)
        colorView.addSubview(emojiView)
        emojiView.addSubview(emojiLabel)
        colorView.addSubview(trackerNameLabel)
        contentView.addSubview(dayLabel)
        contentView.addSubview(doneTrackerButton)
    }
    
    func addLayout() {
        colorView.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        trackerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        doneTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -58),
            
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            emojiView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            
            trackerNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            trackerNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            trackerNameLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12),
            
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

extension TrackerCollectionViewCell {
    func fillCell(with model: Track, at indexPath: IndexPath) {
        colorView.backgroundColor = model.trackerColor
        trackerNameLabel.text = model.trackerName
        emojiLabel.text = model.trackerEmoji
        doneTrackerButton.backgroundColor = model.trackerColor
    }
}

extension UICollectionViewCell {
    static var cellReuseIdentifier: String {
        return String(describing: self)
    }
}
