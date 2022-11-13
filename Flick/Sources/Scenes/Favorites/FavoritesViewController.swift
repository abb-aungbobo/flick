//
//  FavoritesViewController.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import UIKit

class FavoritesViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<FavoritesViewModel.Section, Movie>
    typealias Snapshot = NSDiffableDataSourceSnapshot<FavoritesViewModel.Section, Movie>
    typealias MovieCollectionViewCellRegistration = UICollectionView.CellRegistration<MovieCollectionViewCell, Movie>
    
    private var collectionView: UICollectionView!
    
    private var dataSource: DataSource!
    private var snapshot = Snapshot()
    
    private let viewModel: FavoritesViewModel
    private let router: AppRouter
    
    init(viewModel: FavoritesViewModel, router: AppRouter) {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFavorites()
    }
    
    private func addHierarchy() {
        view.addSubview(collectionView)
    }
    
    private func configureHierarchy() {
        configureView()
        configureNavigationItem()
        configureCollectionView()
    }
    
    private func layoutHierarchy() {
        layoutCollectionView()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationItem() {
        navigationItem.title = viewModel.title
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    private func configureCollectionView() {
        let collectionViewLayout = CollectionViewLayoutFactory.create(view: view)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
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
        configureCell()
    }
    
    private func configureCell() {
        let cellRegistration = MovieCollectionViewCellRegistration { (cell, indexPath, movie) -> Void in
            cell.configuration = movie.toMovieContentConfiguration()
        }
        dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
    
    private func bind() {
        viewModel.state
            .sink { [weak self] state in
                self?.render(state: state)
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func render(state: FavoritesViewModel.State) {
        switch state {
        case .idle:
            snapshot.appendSections(FavoritesViewModel.Section.allCases)
        case let .failed(error):
            showErrorAlert(error: error)
        case .succeeded:
            snapshot.deleteItems(snapshot.itemIdentifiers)
            snapshot.appendItems(viewModel.movies, toSection: .favorites)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = dataSource.itemIdentifier(for: indexPath) else { return }
        let dependency = movie.toMovieDetailsViewModelDependency()
        router.route(from: self, to: .movieDetails(dependency))
    }
}
