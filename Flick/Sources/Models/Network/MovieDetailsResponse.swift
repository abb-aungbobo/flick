//
//  MovieDetailsResponse.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import Foundation

struct MovieDetailsResponse: Codable {
    let genres: [GenreResponse]
    let id: Int
    let overview: String?
    let posterPath: String?
    let title: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case genres
        case id
        case overview
        case posterPath = "poster_path"
        case title
        case voteAverage = "vote_average"
    }
}

extension MovieDetailsResponse {
    func toMovieDetails() -> MovieDetails {
        return MovieDetails(
            genres: genres.toGenres(),
            id: id,
            overview: overview,
            posterPath: posterPath,
            title: title,
            voteAverage: voteAverage
        )
    }
}
