//
//  CategoryTabelViewCell.swift
//  Tracker
//
//  Created by Anton Filipchuk on 26.03.2024.
//

import UIKit

final class CategoryTabelViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CategoryTabelViewCell {
    func setupCell() {
        backgroundColor = .yBackground
    }
}

extension CategoryTabelViewCell {
    func configCell(indexPath: IndexPath) {
        
    }
}

