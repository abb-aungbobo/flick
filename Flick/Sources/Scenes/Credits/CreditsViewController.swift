//
//  CreditsViewController.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import UIKit
import WebKit

class CreditsViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<CreditsViewModel.Section, Member>
    typealias Snapshot = NSDiffableDataSourceSnapshot<CreditsViewModel.Section, Member>
    typealias MemberCollectionViewCellRegistration = UICollectionView.CellRegistration<MemberCollectionViewCell, Member>
    typealias TitleHeaderRegistration = UICollectionView.SupplementaryRegistration<TitleHeaderView>
    
    private var titleLabel = UILabel()
    private var collectionView: UICollectionView!
    
    private var dataSource: DataSource!
    private var snapshot = Snapshot()
    
    private let viewModel: CreditsViewModel
    private let router: AppRouter
    
    init(viewModel: CreditsViewModel, router: AppRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        addHierarchy()
        layoutHierarchy()
        configureDataSource()
        apply()
    }
    
    private func addHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
    }
    
    private func configureHierarchy() {
        configureView()
        configureTitleLabel()
        configureCollectionView()
    }
    
    private func layoutHierarchy() {
        layoutTitleLabel()
        layoutCollectionView()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureTitleLabel() {
        titleLabel.text = viewModel.movieDetails.title
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.font = .preferredFont(forTextStyle: .title1, weight: .bold)
        titleLabel.numberOfLines = 0
    }
    
    private func layoutTitleLabel() {
        let inset: CGFloat = 16.0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: inset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset)
        ])
    }
    
    private func configureCollectionView() {
        let collectionViewLayout = CollectionViewLayoutFactory.create()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    }
    
    private func layoutCollectionView() {
        let inset: CGFloat = 16.0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: inset),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureDataSource() {
        configureCell()
        configureSectionHeader()
    }
    
    private func configureCell() {
        let cellRegistration = MemberCollectionViewCellRegistration { (cell, indexPath, member) -> Void in
            cell.configuration = member.toMemberContentConfiguration()
        }
        dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
    
    private func configureSectionHeader() {
        let supplementaryRegistration = TitleHeaderRegistration(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak self] (supplementaryView, elementKind, indexPath) -> Void in
            guard let self else { return }
            let section = self.snapshot.sectionIdentifiers[indexPath.section]
            supplementaryView.title = section.rawValue
        }
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            return collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: indexPath)
        }
    }
    
    private func apply() {
        snapshot.appendSections(CreditsViewModel.Section.allCases)
        snapshot.appendItems(viewModel.cast, toSection: .cast)
        snapshot.appendItems(viewModel.crew, toSection: .crew)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
