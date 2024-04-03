//
//  Placeholder.swift
//  Tracker
//
//  Created by Anton Filipchuk on 20.02.2024.
//

import UIKit

final class TrackersPlaceholder: UIView {
    
    private lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.textColor = .yBlack
        placeholderLabel.font = .systemFont(ofSize: 12)
        return placeholderLabel
    }()
    
    private lazy var placeholderImage: UIImageView = {
        let placeholderImage = UIImageView()
        return placeholderImage
    }()

    init(title: String, image: String) {
        super.init(frame: .zero)
        setupPlaceholder(title: title, image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TrackersPlaceholder {
    
    func setupPlaceholder(title: String, image: String) {
        addPlaceholderLabel(title: title)
        addPlaceholderImage(image: image)
        addSubView()
        addLayout()
    }
    
    func addPlaceholderLabel(title: String) {
        placeholderLabel.text = title
        placeholderLabel.numberOfLines = 2
        placeholderLabel.textAlignment = .center
    }
    
    func addPlaceholderImage(image: String) {
        placeholderImage.image = UIImage(named: image)
    }
    
   func addSubView() {
       addSubview(placeholderLabel)
       addSubview(placeholderImage)
    }
    
    func addLayout() {
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8)
        ])
    }
}
