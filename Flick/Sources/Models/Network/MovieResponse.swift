//
//  MovieResponse.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import Foundation

struct MovieResponse: Codable {
    let id: Int
    let posterPath: String?
    let title: String
    let voteAverage: Double
    let overview: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title
        case voteAverage = "vote_average"
        case overview
    }
}

extension MovieResponse {
    func toMovie() -> Movie {
        return Movie(id: id, posterPath: posterPath, title: title, voteAverage: voteAverage, overview: overview)
    }
}

extension Array where Element == MovieResponse {
    func toMovies() -> [Movie] {
        return map { response in
            return response.toMovie()
        }
    }
}
