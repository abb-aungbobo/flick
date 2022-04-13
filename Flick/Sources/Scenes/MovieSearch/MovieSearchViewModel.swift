//
//  MovieSearchViewModel.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import Combine
import Foundation

class MovieSearchViewModel {
    enum State {
        case idle
        case failed(AppError)
        case succeeded
    }
    
    enum Section: CaseIterable {
        case movieSearch
    }
        
    let query = PassthroughSubject<String, Never>()
    let state = CurrentValueSubject<State, Never>(.idle)
    var cancellables: Set<AnyCancellable> = []
    var movies: [Movie] = []
    
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
                guard let self = self else { return }
                
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
    
    @MainActor private func searchMovies(query: String) async {
        do {
            let movies = try await searchService.searchMovies(query: query)
            self.movies = movies.results
            state.send(.succeeded)
        } catch {
            state.send(.failed(error.toAppError()))
        }
    }
}
