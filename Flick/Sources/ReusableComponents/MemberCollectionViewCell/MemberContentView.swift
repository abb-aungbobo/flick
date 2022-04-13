//
//  MemberContentView.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import UIKit

class MemberContentView: UIView, UIContentView {
    private let stackView = UIStackView()
    private let nameLabel = UILabel()
    private let characterOrJobLabel = UILabel()
    
    private var appliedConfiguration: MemberContentConfiguration!
    
    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfig = newValue as? MemberContentConfiguration else { return }
            apply(configuration: newConfig)
        }
    }
    
    init(configuration: MemberContentConfiguration) {
        super.init(frame: .zero)
        addHierarchy()
        configureHierarchy()
        layoutHierarchy()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(characterOrJobLabel)
    }
    
    private func configureHierarchy() {
        configureStackView()
        configureNameLabel()
        configureCharacterOrJobLabel()
    }
    
    private func layoutHierarchy() {
        layoutStackView()
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.spacing = 8.0
    }
    
    private func layoutStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func configureNameLabel() {
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.font = .preferredFont(forTextStyle: .body)
    }
    
    private func configureCharacterOrJobLabel() {
        characterOrJobLabel.adjustsFontForContentSizeCategory = true
        characterOrJobLabel.font = .preferredFont(forTextStyle: .subheadline)
        characterOrJobLabel.textColor = .secondaryLabel
    }
    
    private func apply(configuration: MemberContentConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
        
        nameLabel.text = configuration.name
        characterOrJobLabel.text = configuration.characterOrJob
    }
}
