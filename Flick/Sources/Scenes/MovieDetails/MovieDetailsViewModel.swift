//
//  MovieDetailsViewModel.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import Combine
import UIKit

class MovieDetailsViewModel {
    struct Dependency {
        let id: Int
    }
    
    enum State: Equatable {
        case idle
        case failed(AppError)
        case succeeded
        case favorite
        case unfavorite
        
        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle): return true
            case (.failed, .failed): return true
            case (.succeeded, .succeeded): return true
            case (.favorite, .favorite): return true
            case (.unfavorite, .unfavorite): return true
            default: return false
            }
        }
    }
    
    enum Section: CaseIterable {
        case movieDetails
    }
    
    let state = CurrentValueSubject<State, Never>(.idle)
    var cancellables: Set<AnyCancellable> = []
    
    private(set) var video: Video?
    private(set) var movieDetails: MovieDetails?
    private(set) var credits: Credits?
    private(set) var similarMovies: [Movie] = []
    
    private var movie: Movie? {
        movieDetails?.toMovie()
    }
    var isFavorite: Bool {
        guard let movie else { return false }
        do {
            return try favoriteService.isFavorite(movie: movie)
        } catch {
            return false
        }
    }
    var favoriteImage: UIImage? {
        isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    var hideVideo: Bool {
        guard let video else { return true }
        return video.isNotYouTubeVideo
    }
    
    private let dependency: Dependency
    private let movieService: MovieService
    private let favoriteService: FavoriteService
    
    init(dependency: Dependency, movieService: MovieService, favoriteService: FavoriteService) {
        self.dependency = dependency
        self.movieService = movieService
        self.favoriteService = favoriteService
    }
    
    @MainActor func getMovieDetails() async {
        do {
            async let videos = try movieService.getVideos(id: dependency.id)
            async let movieDetails = try movieService.getMovieDetails(id: dependency.id)
            async let similarMovies = try movieService.getSimilarMovies(id: dependency.id)
            async let credits = try movieService.getCredits(id: dependency.id)

            let (videosResult, movieDetailsResult, creditsResult, similarMoviesResult) = try await (videos, movieDetails, credits, similarMovies)
            
            self.video = videosResult.results.first
            self.movieDetails = movieDetailsResult
            self.credits = creditsResult
            self.similarMovies = similarMoviesResult.results
            state.send(.succeeded)
        } catch {
            state.send(.failed(error.toAppError()))
        }
    }
    
    func favorite() {
        guard let movie else { return }
        do {
            try favoriteService.favorite(movie: movie)
            state.send(.favorite)
        } catch {
            state.send(.failed(error.toAppError()))
        }
    }
    
    func unfavorite() {
        guard let movie else { return }
        do {
            try favoriteService.unfavorite(movie: movie)
            state.send(.unfavorite)
        } catch {
            state.send(.failed(error.toAppError()))
        }
    }
}

extension MovieDetailsViewModel {
    func toMovieDetailsContentConfiguration() -> MovieDetailsContentConfiguration? {
        guard let movieDetails else { return nil }
        return movieDetails.toMovieDetailsContentConfiguration(hideTitleHeader: similarMovies.isEmpty)
    }
    
    func toCreditsViewModelDependency() -> CreditsViewModel.Dependency? {
        guard let movieDetails, let credits else { return nil }
        return CreditsViewModel.Dependency(movieDetails: movieDetails, credits: credits)
    }
}
