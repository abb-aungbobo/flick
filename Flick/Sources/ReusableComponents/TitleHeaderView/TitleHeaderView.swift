//
//  TitleHeaderView.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import UIKit

class TitleHeaderView: UICollectionReusableView {
    private let titleLabel = UILabel()
    
    var title: String! {
        didSet {
            titleLabel.text = title
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
        addSubview(titleLabel)
    }
    
    private func configureHierarchy() {
        configureView()
        configureTitleLabel()
    }
    
    private func layoutHierarchy() {
        layoutTitleLabel()
    }
    
    private func configureView() {
        backgroundColor = .systemBackground
    }
    
    private func configureTitleLabel() {
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.font = .preferredFont(forTextStyle: .headline)
    }
    
    private func layoutTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
