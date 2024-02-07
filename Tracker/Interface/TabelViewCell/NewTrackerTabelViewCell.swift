//
//  TabelViewCell.swift
//  Tracker
//
//  Created by Anton Filipchuk on 09.12.2023.
//

import UIKit

final class NewTrackTabelViewCell: UITableViewCell {
    
    private lazy var cellImage = UIImageView(image: UIImage(named: "Chevron"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NewTrackTabelViewCell {
    func setupCell() {
        makeCell()
        addSubView()
        setupLayout()
    }
    
    func makeCell() {
        self.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        self.detailTextLabel?.textColor = UIColor(named: "yGray")
        
    }
    
    func addSubView() {
        contentView.addSubview(cellImage)
        
    }
    
    func setupLayout() {
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
