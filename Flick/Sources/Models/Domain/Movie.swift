//
//  Movie.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import Foundation

struct Movie: Hashable {
    let id: Int
    let posterPath: String?
    let title: String
    let voteAverage: Double
    let overview: String?
}

extension Movie {
    func toMovieContentConfiguration() -> MovieContentConfiguration {
        var posterURL: URL?
        if let posterPath {
            posterURL = Endpoints.getPosterImage(posterPath: posterPath).url
        }
        return MovieContentConfiguration(title: title, posterURL: posterURL)
    }
    
    func toMovieDetailsViewModelDependency() -> MovieDetailsViewModel.Dependency {
        return MovieDetailsViewModel.Dependency(id: id)
    }
    
    func toMovieEntity() -> MovieEntity {
        let entity = MovieEntity()
        entity.id = id
        entity.posterPath = posterPath
        entity.title = title
        entity.voteAverage = voteAverage
        entity.overview = overview
        return entity
    }
}
