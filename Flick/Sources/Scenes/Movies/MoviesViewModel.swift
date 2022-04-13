//
//  MoviesViewModel.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import Combine

class MoviesViewModel {
    enum State {
        case idle
        case failed(AppError)
        case succeeded
    }
    
    enum Section: String, CaseIterable {
        case nowPlaying = "Now Playing"
        case popular = "Popular"
        case topRated = "Top Rated"
        case upcoming = "Upcoming"
    }
    
    let title = "Flick"
    let state = CurrentValueSubject<State, Never>(.idle)
    var cancellables: Set<AnyCancellable> = []
    var nowPlayingMovies: [Movie] = []
    var popularMovies: [Movie] = []
    var topRatedMovies: [Movie] = []
    var upcomingMovies: [Movie] = []
    
    private let movieService: MovieService
    
    init(movieService: MovieService) {
        self.movieService = movieService
    }
    
    @MainActor func getMovies() async {
        do {
            async let nowPlaying = try movieService.getMovies(endpoint: Endpoints.getNowPlaying())
            async let popular = try movieService.getMovies(endpoint: Endpoints.getPopular())
            async let topRated = try movieService.getMovies(endpoint: Endpoints.getTopRated())
            async let upcoming = try movieService.getMovies(endpoint: Endpoints.getUpcoming())
            
            let (nowPlayingResult, popularResult, topRatedResult, upcomingResult) =
            try await (nowPlaying, popular, topRated, upcoming)
            
            self.nowPlayingMovies = nowPlayingResult.results
            self.popularMovies = popularResult.results
            self.topRatedMovies = topRatedResult.results
            self.upcomingMovies = upcomingResult.results
            state.send(.succeeded)
        } catch {
            state.send(.failed(error.toAppError()))
        }
    }
}
