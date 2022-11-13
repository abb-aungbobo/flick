//
//  MovieServiceMock.swift
//  Flick
//
//  Created by Aung Bo Bo on 08/11/2022.
//

import Foundation

class MovieServiceMock: MovieService {
    func getMovies(endpoint: Endpoint) async throws -> Movies {
        let response: MoviesResponse = try JSON.decode(from: "movies")
        return response.toMovies()
    }
    
    func getVideos(id: Int) async throws -> Videos {
        let response: VideosResponse = try JSON.decode(from: "videos")
        return response.toVideos()
    }
    
    func getMovieDetails(id: Int) async throws -> MovieDetails {
        let response: MovieDetailsResponse = try JSON.decode(from: "details")
        return response.toMovieDetails()
    }
    
    func getCredits(id: Int) async throws -> Credits {
        let response: CreditsResponse = try JSON.decode(from: "credits")
        return response.toCredits()
    }
    
    func getSimilarMovies(id: Int) async throws -> Movies {
        let response: MoviesResponse = try JSON.decode(from: "similar")
        return response.toMovies()
    }
}
