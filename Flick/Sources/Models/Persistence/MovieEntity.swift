//
//  MovieEntity.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import RealmSwift

class MovieEntity: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var posterPath: String?
    @Persisted var title: String
    @Persisted var voteAverage: Double
    @Persisted var overview: String?
}

extension MovieEntity {
    func toMovie() -> Movie {
        return Movie(id: id, posterPath: posterPath, title: title, voteAverage: voteAverage, overview: overview)
    }
}

extension Array where Element == MovieEntity {
    func toMovies() -> [Movie] {
        return map { entity in
            return entity.toMovie()
        }
    }
}
