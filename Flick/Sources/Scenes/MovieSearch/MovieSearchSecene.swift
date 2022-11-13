//
//  MovieSearchSecene.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import Foundation

enum MovieSearchSecene {
    static func create() -> MovieSearchViewController {
        let searchService = SearchServiceImpl()
        let viewModel = MovieSearchViewModel(searchService: searchService)
        let router = AppRouter()
        let viewController = MovieSearchViewController(viewModel: viewModel, router: router)
        return viewController
    }
    
    static func mock() -> MovieSearchViewController {
        let searchService = SearchServiceMock()
        let viewModel = MovieSearchViewModel(searchService: searchService)
        let router = AppRouter()
        let viewController = MovieSearchViewController(viewModel: viewModel, router: router)
        return viewController
    }
}
