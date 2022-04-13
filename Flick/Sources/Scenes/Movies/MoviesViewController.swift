//
//  MoviesViewController.swift
//  Flick
//
//  Created by Aung Bo Bo on 10/04/2022.
//

import UIKit

class MoviesViewController: UIViewController {
    typealias DataSource =
    UICollectionViewDiffableDataSource<MoviesViewModel.Section, Movie>
    typealias Snapshot =
    NSDiffableDataSourceSnapshot<MoviesViewModel.Section, Movie>
    typealias MovieCollectionViewCellRegistration =
    UICollectionView.CellRegistration<MovieCollectionViewCell, Movie>
    typealias TitleHeaderRegistration =
    UICollectionView.SupplementaryRegistration<TitleHeaderView>
    
    private var searchBarButtonItem: UIBarButtonItem!
    private var favoriteBarButtonItem: UIBarButtonItem!
    private var collectionView: UICollectionView!
    
    private var dataSource: DataSource!
    private var snapshot = Snapshot()
    
    private let viewModel: MoviesViewModel
    private let router: AppRouter
    
    init(viewModel: MoviesViewModel, router: AppRouter) {
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
        bind()
        
        Task {
            await viewModel.getMovies()
        }
    }
    
    private func addHierarchy() {
        view.addSubview(collectionView)
    }
    
    private func configureHierarchy() {
        configureView()
        configureSearchBarButtonItem()
        configureFavoriteBarButtonItem()
        configureNavigationItem()
        configureCollectionView()
    }
    
    private func layoutHierarchy() {
        layoutCollectionView()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureSearchBarButtonItem() {
        let searchImage = UIImage(systemName: "magnifyingglass")
        let searchAction = UIAction { [weak self] action in
            guard let self = self else { return }
            self.router.route(from: self, to: .movieSearch)
        }
        searchBarButtonItem = UIBarButtonItem(
            image: searchImage,
            primaryAction: searchAction
        )
    }
    
    private func configureFavoriteBarButtonItem() {
        let favoriteImage = UIImage(systemName: "heart")
        let favoriteAction = UIAction { [weak self] action in
            guard let self = self else { return }
            self.router.route(from: self, to: .favorites)
        }
        favoriteBarButtonItem = UIBarButtonItem(
            image: favoriteImage,
            primaryAction: favoriteAction
        )
    }
    
    private func configureNavigationItem() {
        navigationItem.title = viewModel.title
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.rightBarButtonItems = [searchBarButtonItem, favoriteBarButtonItem]
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40.0)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return sectionHeader
    }
    
    private func createLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let height: CGFloat = view.frame.height / 4
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(height * 2/3),
            heightDimension: .absolute(height)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let spacing: CGFloat = 8.0
        let inset: CGFloat = 16.0
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: inset,
            bottom: inset,
            trailing: inset
        )
        section.boundarySupplementaryItems = [createSectionHeader()]
        return section
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()

        let layout = UICollectionViewCompositionalLayout(
            section: createLayoutSection(),
            configuration: configuration
        )
        return layout
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
    }
    
    private func layoutCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureDataSource() {
        let movieCollectionViewCellRegistration = MovieCollectionViewCellRegistration {
            (cell, indexPath, movie) -> Void in
            cell.configuration = movie.toMovieContentConfiguration()
        }
        
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(
                using: movieCollectionViewCellRegistration,
                for: indexPath,
                item: item
            )
        }
        
        let titleHeaderRegistration = TitleHeaderRegistration(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak self] (supplementaryView, string, indexPath) -> Void in
            guard let self = self else { return }
            let section = self.snapshot.sectionIdentifiers[indexPath.section]
            supplementaryView.title = section.rawValue
        }
        
        dataSource.supplementaryViewProvider = {
            (collectionView, kind, indexPath) -> UICollectionReusableView? in
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: titleHeaderRegistration,
                for: indexPath
            )
        }
        
        snapshot.appendSections(MoviesViewModel.Section.allCases)
    }
    
    private func bind() {
        viewModel.state
            .sink { [weak self] state in
                self?.render(state: state)
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func render(state: MoviesViewModel.State) {
        switch state {
        case .idle:
            break
        case let .failed(error):
            showErrorAlert(error: error)
        case .succeeded:
            snapshot.appendItems(viewModel.nowPlayingMovies, toSection: .nowPlaying)
            snapshot.appendItems(viewModel.popularMovies, toSection: .popular)
            snapshot.appendItems(viewModel.topRatedMovies, toSection: .topRated)
            snapshot.appendItems(viewModel.upcomingMovies, toSection: .upcoming)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MoviesViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let movie = dataSource.itemIdentifier(for: indexPath) else { return }
        let dependency = movie.toMovieDetailsViewModelDependency()
        router.route(from: self, to: .movieDetails(dependency))
    }
}
