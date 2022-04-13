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
    
    enum State {
        case idle
        case failed(AppError)
        case succeeded
        case favorite
        case unfavorite
    }
    
    enum Section: CaseIterable {
        case movieDetails
    }
    
    let state = CurrentValueSubject<State, Never>(.idle)
    var cancellables: Set<AnyCancellable> = []
    var video: Video?
    var movieDetails: MovieDetails?
    var credits: Credits?
    var similarMovies: [Movie] = []
    
    var movie: Movie? {
        movieDetails?.toMovie()
    }
    var isFavorite: Bool {
        guard let movie = movie else { return false }
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
        guard let video = video else { return true }
        return video.isNotYouTubeVideo
    }
    
    private let dependency: Dependency
    private let movieService: MovieService
    private let favoriteService: FavoriteService
    
    init(
        dependency: Dependency,
        movieService: MovieService,
        favoriteService: FavoriteService
    ) {
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

            let (videosResult, movieDetailsResult, creditsResult, similarMoviesResult) =
            try await (videos, movieDetails, credits, similarMovies)
            
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
        guard let movie = movie else { return }
        do {
            try favoriteService.favorite(movie: movie)
            state.send(.favorite)
        } catch {
            state.send(.failed(error.toAppError()))
        }
    }
    
    func unfavorite() {
        guard let movie = movie else { return }
        do {
            try favoriteService.unfavorite(movie: movie)
            state.send(.unfavorite)
        } catch {
            state.send(.failed(error.toAppError()))
        }
    }
}

extension MovieDetailsViewModel {
    func toCreditsViewModelDependency() -> CreditsViewModel.Dependency? {
        guard let movieDetails = movieDetails, let credits = credits else { return nil }
        return CreditsViewModel.Dependency(
            movieDetails: movieDetails,
            credits: credits
        )
    }
}
