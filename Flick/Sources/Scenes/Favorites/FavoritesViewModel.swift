//
//  FavoritesViewModel.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import Combine

class FavoritesViewModel {
    enum State {
        case idle
        case failed(AppError)
        case succeeded
    }
    
    enum Section: CaseIterable {
        case favorites
    }
    
    let title = "Favorites"
    let state = CurrentValueSubject<State, Never>(.idle)
    var cancellables: Set<AnyCancellable> = []
    var movies: [Movie] = []
    
    private let favoriteService: FavoriteService
    
    init(favoriteService: FavoriteService) {
        self.favoriteService = favoriteService
    }
    
    func getFavorites() {
        do {
            let movies = try favoriteService.getFavorites()
            self.movies = movies
            state.send(.succeeded)
        } catch {
            state.send(.failed(error.toAppError()))
        }
    }
}
