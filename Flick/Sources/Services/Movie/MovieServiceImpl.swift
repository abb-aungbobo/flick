//
//  MovieServiceImpl.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import Foundation

class MovieServiceImpl: MovieService {
    func getMovies(endpoint: Endpoint) async throws -> Movies {
        let response: MoviesResponse = try await NetworkController.shared.get(endpoint: endpoint)
        return response.toMovies()
    }
    
    func getVideos(id: Int) async throws -> Videos {
        let endpoint = Endpoints.getVideos(id: id)
        let response: VideosResponse = try await NetworkController.shared.get(endpoint: endpoint)
        return response.toVideos()
    }
    
    func getMovieDetails(id: Int) async throws -> MovieDetails {
        let endpoint = Endpoints.getMovieDetails(id: id)
        let response: MovieDetailsResponse = try await NetworkController.shared.get(endpoint: endpoint)
        return response.toMovieDetails()
    }
    
    func getCredits(id: Int) async throws -> Credits {
        let endpoint = Endpoints.getCredits(id: id)
        let response: CreditsResponse = try await NetworkController.shared.get(endpoint: endpoint)
        return response.toCredits()
    }
    
    func getSimilarMovies(id: Int) async throws -> Movies {
        let endpoint = Endpoints.getSimilarMovies(id: id)
        let response: MoviesResponse = try await NetworkController.shared.get(endpoint: endpoint)
        return response.toMovies()
    }
}
