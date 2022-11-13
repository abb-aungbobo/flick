//
//  FavoritesScene.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import Foundation

enum FavoritesScene {
    static func create() -> FavoritesViewController {
        let favoriteService = FavoriteServiceImpl()
        let viewModel = FavoritesViewModel(favoriteService: favoriteService)
        let router = AppRouter()
        let viewController = FavoritesViewController(viewModel: viewModel, router: router)
        return viewController
    }
    
    static func mock() -> FavoritesViewController {
        let favoriteService = FavoriteServiceMock()
        let viewModel = FavoritesViewModel(favoriteService: favoriteService)
        let router = AppRouter()
        let viewController = FavoritesViewController(viewModel: viewModel, router: router)
        return viewController
    }
}
