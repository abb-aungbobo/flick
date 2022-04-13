//
//  MovieContentView.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import UIKit

class MovieContentView: UIView, UIContentView {
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    
    private var appliedConfiguration: MovieContentConfiguration!
    
    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfig = newValue as? MovieContentConfiguration else { return }
            apply(configuration: newConfig)
        }
    }
    
    init(configuration: MovieContentConfiguration) {
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
        addSubview(titleLabel)
        addSubview(imageView)
    }
    
    private func configureHierarchy() {
        configureView()
        configureTitleLabel()
        configureImageView()
    }
    
    private func layoutHierarchy() {
        layoutTitleLabel()
        layoutImageView()
    }
    
    private func configureView() {
        layer.masksToBounds = true
        layer.cornerCurve = .continuous
        layer.cornerRadius = 8.0
        backgroundColor = .secondarySystemBackground
    }
    
    private func configureTitleLabel() {
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
    }

    private func layoutTitleLabel() {
        let inset: CGFloat = 16.0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset)
        ])
    }
    
    private func configureImageView() {
        imageView.contentMode = .scaleAspectFill
    }
    
    private func layoutImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func apply(configuration: MovieContentConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
        
        titleLabel.text = configuration.title
        imageView.setImage(with: configuration.posterURL)
    }
}
