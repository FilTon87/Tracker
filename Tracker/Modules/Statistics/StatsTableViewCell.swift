//
//  StatsTableViewCell.swift
//  Tracker
//
//  Created by Anton Filipchuk on 28.05.2024.
//

import UIKit

final class StatsTableViewCell: UITableViewCell {
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        gradientLayer.frame = gradientView.bounds
    }
    
    private lazy var statisticValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .yBlack
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private lazy var statisticNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .yBlack
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private let cellView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = .yWhite
        return view
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            CGColor(red: 0.992, green: 0.298, blue: 0.286, alpha: 100),
            CGColor(red: 0.275, green: 0.902, blue: 0.616, alpha: 100),
            CGColor(red: 0.0, green: 0.482, blue: 0.980, alpha: 100)
        ]
        gradient.cornerRadius = 16
        gradient.masksToBounds = true
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        return gradient
    }()
    
    private let gradientView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension StatsTableViewCell {
    func setupCell() {
        backgroundColor = .yWhite
        addLayout()
    }
    
    func addLayout() {
        [gradientView,
         cellView].forEach {
            contentView.addSubview($0)
        }
        
        gradientView.layer.addSublayer(gradientLayer)
        
        
        [statisticNameLabel,
         statisticValueLabel].forEach {
            cellView.addSubview($0)
        }
        
        [cellView,
         gradientView,
         statisticNameLabel,
         statisticValueLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            gradientView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: -1),
            gradientView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: -1),
            gradientView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: 1),
            gradientView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: 1),
            
            statisticValueLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 12),
            statisticValueLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 12),
            statisticValueLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -12),
            
            statisticNameLabel.topAnchor.constraint(equalTo: statisticValueLabel.bottomAnchor, constant: 7),
            statisticNameLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 12),
            statisticNameLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -12),
        ])
    }
}


extension StatsTableViewCell {
    func configCell(_ statistics: [Statistic], _ indexPath: IndexPath ) {
        statisticValueLabel.text = String(statistics[indexPath.row].statisticValue)
        statisticNameLabel.text = statistics[indexPath.row].statisticName
    }
}
