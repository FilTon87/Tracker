//
//  Button.swift
//  Tracker
//
//  Created by Anton Filipchuk on 14.12.2023.
//

import UIKit

final class BlackButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        makeButton(title: title)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Properties
    private func makeButton(title: String) {
        backgroundColor = .yBlack
        tintColor = .yWhite
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16)
        layer.cornerRadius = 16
        heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
}
