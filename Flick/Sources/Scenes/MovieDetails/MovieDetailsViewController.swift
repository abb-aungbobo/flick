//
//  MovieDetailsViewController.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import UIKit
import WebKit

class MovieDetailsViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<MovieDetailsViewModel.Section, Movie>
    typealias Snapshot = NSDiffableDataSourceSnapshot<MovieDetailsViewModel.Section, Movie>
    typealias MovieCollectionViewCellRegistration = UICollectionView.CellRegistration<MovieCollectionViewCell, Movie>
    typealias MovieDetailsHeaderRegistration = UICollectionView.SupplementaryRegistration<MovieDetailsHeaderView>
    
    private var favoriteBarButtonItem: UIBarButtonItem!
    private let stackView = UIStackView()
    private var webView: WKWebView!
    private var collectionView: UICollectionView!
    
    private var dataSource: DataSource!
    private var snapshot = Snapshot()
    
    private let viewModel: MovieDetailsViewModel
    private let router: AppRouter
    
    init(viewModel: MovieDetailsViewModel, router: AppRouter) {
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
            await viewModel.getMovieDetails()
        }
    }
    
    private func addHierarchy() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(webView)
        stackView.addArrangedSubview(collectionView)
    }
    
    private func configureHierarchy() {
        configureView()
        configureFavoriteBarButtonItem()
        configureNavigationItem()
        configureStackView()
        configureWebView()
        configureCollectionView()
    }
    
    private func layoutHierarchy() {
        layoutStackView()
        layoutWebView()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureFavoriteBarButtonItem() {
        let favoriteAction = UIAction { [weak self] action in
            guard let self else { return }
            if self.viewModel.isFavorite {
                self.viewModel.unfavorite()
            } else {
                self.viewModel.favorite()
            }
        }
        favoriteBarButtonItem = UIBarButtonItem(primaryAction: favoriteAction)
    }
    
    private func configureNavigationItem() {
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
    }
    
    private func layoutStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureWebView() {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        webView = WKWebView(frame: .zero, configuration: configuration)
    }
    
    private func layoutWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.widthAnchor.constraint(equalTo: view.widthAnchor),
            webView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9/16)
        ])
    }
    
    private func configureCollectionView() {
        let sectionHeader = CollectionLayoutBoundarySupplementaryItemFactory.create(heightDimension: .estimated(0.0))
        let collectionViewLayout = CollectionViewLayoutFactory.create(view: view, boundarySupplementaryItems: [sectionHeader])
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
    }
    
    private func configureDataSource() {
        configureCell()
        configureSectionHeader()
    }
    
    private func configureCell() {
        let cellRegistration = MovieCollectionViewCellRegistration { (cell, indexPath, movie) -> Void in
            cell.configuration = movie.toMovieContentConfiguration()
        }
        dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
    
    private func configureSectionHeader() {
        let supplementaryRegistration = MovieDetailsHeaderRegistration(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak self] (supplementaryView, elementKind, indexPath) -> Void in
            guard let self, let configuration = self.viewModel.toMovieDetailsContentConfiguration() else { return }
            supplementaryView.delegate = self
            supplementaryView.configuration = configuration
        }
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            return collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: indexPath)
        }
    }
    
    private func bind() {
        viewModel.state
            .sink { [weak self] state in
                self?.render(state: state)
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func render(state: MovieDetailsViewModel.State) {
        switch state {
        case .idle:
            snapshot.appendSections(MovieDetailsViewModel.Section.allCases)
        case let .failed(error):
            showErrorAlert(error: error)
        case .succeeded:
            favoriteBarButtonItem.image = viewModel.favoriteImage
            navigationItem.rightBarButtonItem = favoriteBarButtonItem
            
            webView.isHidden = viewModel.hideVideo
            if let url = viewModel.video?.url {
                webView.load(URLRequest(url: url))
            }
            
            snapshot.appendItems(viewModel.similarMovies, toSection: .movieDetails)
            dataSource.apply(snapshot, animatingDifferences: true)
        case .favorite, .unfavorite:
            favoriteBarButtonItem.image = viewModel.favoriteImage
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MovieDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = dataSource.itemIdentifier(for: indexPath) else { return }
        let dependency = movie.toMovieDetailsViewModelDependency()
        router.route(from: self, to: .movieDetails(dependency))
    }
}

// MARK: - MovieDetailsHeaderViewDelegate
extension MovieDetailsViewController: MovieDetailsHeaderViewDelegate {
    func didPressSeeCreditsButton(_ view: MovieDetailsHeaderView) {
        guard let dependency = viewModel.toCreditsViewModelDependency() else { return }
        router.route(from: self, to: .credits(dependency))
    }
}
