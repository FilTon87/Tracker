//
//  TrackerHeaderCollectionView.swift
//  Tracker
//
//  Created by Anton Filipchuk on 08.02.2024.
//

import UIKit

final class TrackerHeaderCollectionView: UICollectionReusableView {
    let categoryLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeader()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TrackerHeaderCollectionView {
    func setupHeader() {
        settingElements()
        addSubView()
        addLayout()
    }
    
    func settingElements() {
        
    }
    
    func addSubView() {
        addSubview(categoryLabel)
    }
    
    func addLayout() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            categoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 206)
        ])
    }
}

extension UICollectionReusableView {
    static var headerReuseIdentifier: String {
        return String(describing: self)
    }
}
