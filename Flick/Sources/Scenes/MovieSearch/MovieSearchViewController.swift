//
//  MovieSearchViewController.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import UIKit

class MovieSearchViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<MovieSearchViewModel.Section, Movie>
    typealias Snapshot = NSDiffableDataSourceSnapshot<MovieSearchViewModel.Section, Movie>
    typealias MovieCollectionViewCellRegistration = UICollectionView.CellRegistration<MovieCollectionViewCell, Movie>
    
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
    
    private func configureCollectionView() {
        let collectionViewLayout = CollectionViewLayoutFactory.create(view: view)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
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
    
    private func render(state: MovieSearchViewModel.State) {
        switch state {
        case .idle:
            snapshot.appendSections(MovieSearchViewModel.Section.allCases)
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = dataSource.itemIdentifier(for: indexPath) else { return }
        let dependency = movie.toMovieDetailsViewModelDependency()
        router.route(from: self, to: .movieDetails(dependency))
    }
}
