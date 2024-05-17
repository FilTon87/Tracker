//
//  TabelViewCell.swift
//  Tracker
//
//  Created by Anton Filipchuk on 09.12.2023.
//

import UIKit

final class NewTrackerTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NewTrackerTableViewCell {
    func setupCell() {
        configCell()
    }
    
    func configCell() {
        textLabel?.numberOfLines = 2
        detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        detailTextLabel?.textColor = .yGray
        backgroundColor = .yBackground
        accessoryType = .disclosureIndicator
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
