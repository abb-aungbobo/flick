//
//  MovieSearchViewController.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import UIKit

class MovieSearchViewController: UIViewController {
    typealias DataSource =
    UICollectionViewDiffableDataSource<MovieSearchViewModel.Section, Movie>
    typealias Snapshot =
    NSDiffableDataSourceSnapshot<MovieSearchViewModel.Section, Movie>
    typealias MovieCollectionViewCellRegistration =
    UICollectionView.CellRegistration<MovieCollectionViewCell, Movie>
    
    private let searchBar = UISearchBar()
    private var collectionView: UICollectionView!
    
    private var dataSource: DataSource!
    private var snapshot = Snapshot()
    
    private let viewModel: MovieSearchViewModel
    private let router: AppRouter
    
    init(viewModel: MovieSearchViewModel, router: AppRouter) {
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
    
    private func addHierarchy() {
        view.addSubview(collectionView)
    }
    
    private func configureHierarchy() {
        configureView()
        configureNavigationItem()
        configureSearchBar()
        configureCollectionView()
    }
    
    private func layoutHierarchy() {
        layoutCollectionView()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationItem() {
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.titleView = searchBar
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        searchBar.placeholder = "Search"
        searchBar.autocapitalizationType = .none
        searchBar.returnKeyType = .default
        searchBar.becomeFirstResponder()
    }
    
    private func createLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let count: Int = 3
        let spacing: CGFloat = 8.0
        let inset: CGFloat = 16.0
        let width: CGFloat = (view.frame.width - (2 * inset) - (2 * spacing)) / CGFloat(count)
        let height: CGFloat = width * 3/2
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(height)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: count
        )
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: inset,
            leading: inset,
            bottom: inset,
            trailing: inset
        )
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
        collectionView.keyboardDismissMode = .onDrag
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
        
        snapshot.appendSections(MovieSearchViewModel.Section.allCases)
    }
    
    private func bind() {
        viewModel.state
            .sink { [weak self] state in
                self?.render(state: state)
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func render(state: MovieSearchViewModel.State) {
        switch state {
        case .idle:
            break
        case let .failed(error):
            showErrorAlert(error: error)
        case .succeeded:
            snapshot.deleteItems(snapshot.itemIdentifiers)
            snapshot.appendItems(viewModel.movies, toSection: .movieSearch)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

// MARK: - UISearchBarDelegate
extension MovieSearchViewController: UISearchBarDelegate {
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        viewModel.query.send(searchText)
    }
}

// MARK: - UISearchTextFieldDelegate
extension MovieSearchViewController: UISearchTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
}

// MARK: - UICollectionViewDelegate
extension MovieSearchViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let movie = dataSource.itemIdentifier(for: indexPath) else { return }
        let dependency = movie.toMovieDetailsViewModelDependency()
        router.route(from: self, to: .movieDetails(dependency))
    }
}
