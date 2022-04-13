//
//  MoviesResponse.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import Foundation

struct MoviesResponse: Codable {
    let results: [MovieResponse]
}

extension MoviesResponse {
    func toMovies() -> Movies {
        return Movies(results: results.toMovies())
    }
}
