//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Anton Filipchuk on 07.02.2024.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func completeTracker(id: UUID, indexPath: IndexPath)
    func uncompleteTracker(id: UUID, indexPath: IndexPath)
}

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: TrackerCellDelegate?
    
    private var isCompletedToday: Bool = false
    private var isPinned: Bool = false
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    
    private let colorView = UIView()
    private let emojiView = UIView()
    private let emojiLabel = UILabel()
    private let trackerNameLabel = UILabel()
    private let dayLabel = UILabel()
    private let doneTrackerButton = UIButton()
    private let pinIcon = UIImageView()
    private let analyticsService = YandexMobileMetrica()
    
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
        
        doneTrackerButton.tintColor = .yWhite
        doneTrackerButton.layer.cornerRadius = 17
        doneTrackerButton.layer.masksToBounds = true
        doneTrackerButton.backgroundColor = colorView.backgroundColor
        doneTrackerButton.addTarget(self, action: #selector(trackerButtonTapped), for: .touchUpInside)
        
        pinIcon.isHidden = true
        pinIcon.image = UIImage(named: "pinIcon")
    }
    
    func addSubView() {
        [colorView,
         dayLabel,
         pinIcon,
         doneTrackerButton].forEach {
            contentView.addSubview($0)
        }
        
        colorView.addSubview(emojiView)
        emojiView.addSubview(emojiLabel)
        colorView.addSubview(trackerNameLabel)
        
    }
    
    func addLayout() {
        [colorView,
         emojiLabel,
         emojiView,
         trackerNameLabel,
         dayLabel,
         pinIcon,
         doneTrackerButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
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
            doneTrackerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            pinIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            pinIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4)
        ])
    }
    
    @objc private func trackerButtonTapped() {
        guard let trackerId = trackerId, let indexPath = indexPath else {
            assertionFailure("No tracker ID or IndexPath")
            return
        }
        analyticsService.report(event: "completeTrackerButtonTapped", params: ["event":"click", "screen":"Main", "item":"track"])
        
        if isCompletedToday {
            delegate?.uncompleteTracker(id: trackerId, indexPath: indexPath)
        } else {
            delegate?.completeTracker(id: trackerId, indexPath: indexPath)
        }
    }
}

extension TrackerCollectionViewCell {
    func fillCell(with model: Tracker, isCompletedToday: Bool, completedDays: Int, at indexPath: IndexPath) {
        self.isCompletedToday = isCompletedToday
        self.isPinned = model.isPinned
        self.indexPath = indexPath
        trackerId = model.id
        configDaysLabel(with: completedDays)
        colorView.backgroundColor = model.trackerColor
        trackerNameLabel.text = model.trackerName
        emojiLabel.text = model.trackerEmoji
        doneTrackerButton.backgroundColor = model.trackerColor
        
        let doneButtonImage = isCompletedToday ? UIImage(systemName: "checkmark") : UIImage(systemName: "plus")
        doneTrackerButton.setImage(doneButtonImage, for: .normal)
        
        showPin()
    }
    
    private func configDaysLabel(with: Int) {
        let key = Constants.numberOfDays
        let localizedFormat = String.localizedStringWithFormat(
            NSLocalizedString(key, tableName: key, comment: ""),
            with)
        dayLabel.text = localizedFormat
    }
    
    private func showPin() {
        switch isPinned {
        case true: do { pinIcon.isHidden = false }
        case false: do { pinIcon.isHidden = true }
        }
    }
    
}

extension UICollectionViewCell {
    static var cellReuseIdentifier: String {
        return String(describing: self)
    }
}
