//
//  MovieSearchViewModel.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import Combine
import Foundation

class MovieSearchViewModel {
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
        case movieSearch
    }
        
    let query = PassthroughSubject<String, Never>()
    let state = CurrentValueSubject<State, Never>(.idle)
    var cancellables: Set<AnyCancellable> = []
    
    private(set) var movies: [Movie] = []
    
    private let searchService: SearchService
    
    init(searchService: SearchService) {
        self.searchService = searchService
        
        bind()
    }
    
    private func bind() {
        query
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self else { return }
                
                let query = text.trimmingCharacters(in: .whitespaces)
                guard !query.isEmpty else {
                    self.movies = []
                    self.state.send(.succeeded)
                    return
                }
                
                Task {
                    await self.searchMovies(query: query)
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor func searchMovies(query: String) async {
        do {
            let movies = try await searchService.searchMovies(query: query)
            self.movies = movies.results
            state.send(.succeeded)
        } catch {
            state.send(.failed(error.toAppError()))
        }
    }
}
