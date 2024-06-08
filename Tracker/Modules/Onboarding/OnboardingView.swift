//
//  OnboardingView.swift
//  Tracker
//
//  Created by Anton Filipchuk on 03.05.2024.
//

import UIKit

final class OnboardingView: UIViewController {
    
    private lazy var onboardingImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        return image
    }()
    
    private lazy var onboardingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .yBlack
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private lazy var onboardingButton = BlackButton(title: Localization.onboardingButton)
    
    private let defaults = UserDefaults.standard
    
    init(_ image: String,_ text: String) {
        super.init(nibName: nil, bundle: nil)
        setupOnboarding(image, text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension OnboardingView {
    func setupOnboarding(_ image: String, _ text: String) {
        addImage(image)
        addLabel(text)
        addSubView()
        addLayout()
        addTarget()
    }
    
    func addLabel(_ text: String) {
        onboardingLabel.text = text
        onboardingLabel.numberOfLines = 2
        onboardingLabel.textAlignment = .center
    }
    
    func addImage(_ image: String) {
        onboardingImage.image = UIImage(named: image)
    }
    
    func addSubView() {
        view.insertSubview(onboardingImage, at: 0)
        view.addSubview(onboardingLabel)
        view.addSubview(onboardingButton)
    }
    
    func addLayout() {
        onboardingLabel.translatesAutoresizingMaskIntoConstraints = false
        onboardingImage.translatesAutoresizingMaskIntoConstraints = false
        onboardingButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            onboardingImage.topAnchor.constraint(equalTo: view.topAnchor),
            onboardingImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            onboardingImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            onboardingImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            onboardingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 455),
            onboardingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            onboardingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            onboardingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            onboardingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            onboardingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func addTarget() {
        onboardingButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc func didTapButton() {
        defaults.setValue(true, forKey: "isSecondStart")
        let viewController = TabBarController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}
