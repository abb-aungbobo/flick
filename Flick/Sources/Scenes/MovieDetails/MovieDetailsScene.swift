//
//  MovieDetailsScene.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import Foundation

enum MovieDetailsScene {
    static func create(dependency: MovieDetailsViewModel.Dependency) -> MovieDetailsViewController {
        let movieService = MovieServiceImpl()
        let favoriteService = FavoriteServiceImpl()
        let viewModel = MovieDetailsViewModel(dependency: dependency, movieService: movieService, favoriteService: favoriteService)
        let router = AppRouter()
        let viewController = MovieDetailsViewController(viewModel: viewModel, router: router)
        return viewController
    }
    
    static func mock(dependency: MovieDetailsViewModel.Dependency) -> MovieDetailsViewController {
        let movieService = MovieServiceMock()
        let favoriteService = FavoriteServiceMock()
        let viewModel = MovieDetailsViewModel(dependency: dependency, movieService: movieService, favoriteService: favoriteService)
        let router = AppRouter()
        let viewController = MovieDetailsViewController(viewModel: viewModel, router: router)
        return viewController
    }
}
