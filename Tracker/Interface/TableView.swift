//
//  TableView.swift
//  Tracker
//
//  Created by Anton Filipchuk on 12.05.2024.
//

import UIKit

final class TableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TableView {
    func setupTableView() {
        rowHeight = 75
        layer.masksToBounds = true
        layer.cornerRadius = 16
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
