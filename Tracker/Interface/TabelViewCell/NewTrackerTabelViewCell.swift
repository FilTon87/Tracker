//
//  TabelViewCell.swift
//  Tracker
//
//  Created by Anton Filipchuk on 09.12.2023.
//

import UIKit

final class NewTrackerTabelViewCell: UITableViewCell {
    
    private lazy var cellImage = UIImageView(image: UIImage(named: "Chevron"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NewTrackerTabelViewCell {
    func setupCell() {
        configCell()
        addSubView()
        addLayout()
    }
    
    func configCell() {
        self.textLabel?.numberOfLines = 2
        self.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        self.detailTextLabel?.textColor = .yGray
        self.backgroundColor = .yBackground
    }
    
    func addSubView() {
        contentView.addSubview(cellImage)
    }
    
    func addLayout() {
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
