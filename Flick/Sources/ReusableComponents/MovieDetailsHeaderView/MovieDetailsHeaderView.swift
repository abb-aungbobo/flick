//
//  MovieDetailsHeaderView.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import UIKit

protocol MovieDetailsHeaderViewDelegate: AnyObject {
    func didPressSeeCreditsButton(_ view: MovieDetailsHeaderView)
}

class MovieDetailsHeaderView: UICollectionReusableView {
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let voteAverageLabel = UILabel()
    private let genresLabel = UILabel()
    private let overviewLabel = UILabel()
    private let seeCreditsButton = UIButton()
    private let titleHeaderView = TitleHeaderView()
    
    weak var delegate: MovieDetailsHeaderViewDelegate?
    
    var configuration: MovieDetailsContentConfiguration! {
        didSet {
            apply(configuration: configuration)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addHierarchy()
        configureHierarchy()
        layoutHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(voteAverageLabel)
        stackView.addArrangedSubview(genresLabel)
        stackView.addArrangedSubview(overviewLabel)
        stackView.addArrangedSubview(seeCreditsButton)
        stackView.addArrangedSubview(titleHeaderView)
    }
    
    private func configureHierarchy() {
        configureStackView()
        configureTitleLabel()
        configureVoteAverageLabel()
        configureGenresLabel()
        configureOverviewLabel()
        configureSeeCreditsButton()
        configureTitleHeaderView()
    }
    
    private func layoutHierarchy() {
        layoutStackView()
        layoutSeeCreditsButton()
        layoutTitleHeaderView()
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.alignment = .leading
        stackView.setCustomSpacing(16.0, after: seeCreditsButton)
    }
    
    private func layoutStackView() {
        let inset: CGFloat = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func configureTitleLabel() {
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.font = .preferredFont(forTextStyle: .title1, weight: .bold)
        titleLabel.numberOfLines = 0
    }
    
    private func configureVoteAverageLabel() {
        voteAverageLabel.adjustsFontForContentSizeCategory = true
        voteAverageLabel.font = .preferredFont(forTextStyle: .headline)
        voteAverageLabel.numberOfLines = 0
        voteAverageLabel.textColor = .secondaryLabel
    }
    
    private func configureGenresLabel() {
        genresLabel.adjustsFontForContentSizeCategory = true
        genresLabel.font = .preferredFont(forTextStyle: .body)
        genresLabel.numberOfLines = 0
        genresLabel.textColor = .secondaryLabel
    }
    
    private func configureOverviewLabel() {
        overviewLabel.adjustsFontForContentSizeCategory = true
        overviewLabel.font = .preferredFont(forTextStyle: .subheadline)
        overviewLabel.numberOfLines = 0
    }
    
    private func configureSeeCreditsButton() {
        var configuration = UIButton.Configuration.gray()
        configuration.title = "See Credits"
        configuration.baseForegroundColor = .label
        seeCreditsButton.configuration = configuration
        seeCreditsButton.addTarget(self, action: #selector(seeCredits(_:)), for: .touchUpInside)
    }
    
    @objc private func seeCredits(_ button: UIButton) {
        delegate?.didPressSeeCreditsButton(self)
    }
    
    private func layoutSeeCreditsButton() {
        seeCreditsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seeCreditsButton.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }
    
    private func configureTitleHeaderView() {
        titleHeaderView.title = "More Like This"
    }
    
    private func layoutTitleHeaderView() {
        titleHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleHeaderView.heightAnchor.constraint(equalToConstant: 40.0)
        ])
    }
    
    private func apply(configuration: MovieDetailsContentConfiguration) {
        titleLabel.text = configuration.title
        voteAverageLabel.text = configuration.voteAverage
        genresLabel.text = configuration.genres
        overviewLabel.text = configuration.overview
        
        genresLabel.isHidden = configuration.hideGenres
        titleHeaderView.isHidden = configuration.hideTitleHeader
    }
}
