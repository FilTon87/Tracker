//
//  CancelButton.swift
//  Tracker
//
//  Created by Anton Filipchuk on 14.12.2023.
//

import UIKit

final class CancelButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCancelButton()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Properties
    private func setupCancelButton() {
        backgroundColor = .yWhite
        tintColor = .yRed
        setTitle(Localization.cancelButton, for: .normal)
        setTitleColor(.yRed, for: .normal)
        layer.borderWidth = 1
        layer.borderColor = (UIColor.yRed).cgColor
        titleLabel?.font = .systemFont(ofSize: 16)
        layer.cornerRadius = 16
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        widthAnchor.constraint(equalToConstant: 161).isActive = true        
    }
    
}
