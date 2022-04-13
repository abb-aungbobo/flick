//
//  MovieDetails.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import Foundation

struct MovieDetails {
    let genres: [Genre]
    let id: Int
    let overview: String?
    let posterPath: String?
    let title: String
    let voteAverage: Double
}

extension MovieDetails {
    func toMovieDetailsContentConfiguration() -> MovieDetailsContentConfiguration {
        let genres = genres.map(\.name).joined(separator: " • ")
        let notRated = "Not Rated"
        let userScore = String(format: "%.0f%% User Score", voteAverage * 10)
        let voteAverage = voteAverage == .zero ? notRated : userScore
        return MovieDetailsContentConfiguration(
            genres: genres,
            id: id,
            overview: overview,
            title: title,
            voteAverage: voteAverage
        )
    }
    
    func toMovie() -> Movie {
        return Movie(
            id: id,
            posterPath: posterPath,
            title: title,
            voteAverage: voteAverage,
            overview: overview
        )
    }
}
