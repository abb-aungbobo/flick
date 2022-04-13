//
//  MoviesScene.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import Foundation

enum MoviesScene {
    static func create() -> MoviesViewController {
        let movieService = MovieServiceImpl()
        let viewModel = MoviesViewModel(movieService: movieService)
        let router = AppRouter()
        let viewController = MoviesViewController(viewModel: viewModel, router: router)
        return viewController
    }
}
