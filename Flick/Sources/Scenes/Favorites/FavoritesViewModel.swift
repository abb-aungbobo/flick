//
//  FavoritesViewModel.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import Combine

class FavoritesViewModel {
    enum State: Equatable {
        case idle
        case failed(AppError)
        case succeeded
        
        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle): return true
            case (.failed, .failed): return true
            case (.succeeded, .succeeded): return true
            default: return false
            }
        }
    }
    
    enum Section: CaseIterable {
        case favorites
    }
    
    let title = "Favorites"
    let state = CurrentValueSubject<State, Never>(.idle)
    var cancellables: Set<AnyCancellable> = []
    
    private(set) var movies: [Movie] = []
    
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
