//
//  CreateButton.swift
//  Tracker
//
//  Created by Anton Filipchuk on 15.12.2023.
//

import UIKit

final class CreateButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCreateButton()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Properties
    private func setupCreateButton() {
        backgroundColor = .yGray
        tintColor = .yGray
        setTitle("Создать", for: .normal)
        setTitleColor(.yWhite, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16)
        layer.cornerRadius = 16
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        widthAnchor.constraint(equalToConstant: 161).isActive = true
        isEnabled = false
    }
    
}

