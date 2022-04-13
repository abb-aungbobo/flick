//
//  MovieService.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import Foundation

protocol MovieService {
    func getMovies(endpoint: Endpoint) async throws -> Movies
    func getVideos(id: Int) async throws -> Videos
    func getMovieDetails(id: Int) async throws -> MovieDetails
    func getCredits(id: Int) async throws -> Credits
    func getSimilarMovies(id: Int) async throws -> Movies
}
