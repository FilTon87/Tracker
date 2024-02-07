//
//  TextField.swift
//  Tracker
//
//  Created by Anton Filipchuk on 14.12.2023.
//

import UIKit


final class TextField: UITextField {
    
    //MARK: - Private property
    private let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 41)
    
    //MARK: - Initializer
    init(placeholder: String) {
        super.init(frame: .zero)
        makeTextField(placeholder: placeholder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override Methods
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    //MARK: - Private properties
    private func makeTextField(placeholder: String) {
        layer.cornerRadius = 16
        attributedPlaceholder = NSAttributedString(string: placeholder)
        backgroundColor = .yBackground
        heightAnchor.constraint(equalToConstant: 75).isActive = true
    }
}
