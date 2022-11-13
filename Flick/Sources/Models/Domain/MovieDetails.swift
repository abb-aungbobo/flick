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
    func toMovieDetailsContentConfiguration(hideTitleHeader: Bool = false) -> MovieDetailsContentConfiguration {
        let genres = genres.map(\.name).joined(separator: " • ")
        let notRated = "Not Rated"
        let userScore = String(format: "%.0f%% User Score", voteAverage * 10)
        let voteAverage = voteAverage == .zero ? notRated : userScore
        return MovieDetailsContentConfiguration(
            genres: genres,
            id: id,
            overview: overview,
            title: title,
            voteAverage: voteAverage,
            hideTitleHeader: hideTitleHeader
        )
    }
    
    func toMovie() -> Movie {
        return Movie(id: id, posterPath: posterPath, title: title, voteAverage: voteAverage, overview: overview)
    }
}

extension MovieDetails {
    static let fake1 = MovieDetails(genres: [], id: 1, overview: nil, posterPath: nil, title: "Movie 1", voteAverage: 0.0)
    static let fake2 = MovieDetails(genres: [], id: 2, overview: nil, posterPath: nil, title: "Movie 2", voteAverage: 9.7)
}
