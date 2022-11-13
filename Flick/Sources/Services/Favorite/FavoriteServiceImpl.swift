//
//  FavoriteServiceImpl.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import Foundation

class FavoriteServiceImpl: FavoriteService {
    func getFavorites() throws -> [Movie] {
        let entities: [MovieEntity] = try PersistenceController.shared.get()
        return entities.toMovies()
    }
    
    func favorite(movie: Movie) throws {
        let entity = movie.toMovieEntity()
        try PersistenceController.shared.add(entity: entity)
    }
    
    func unfavorite(movie: Movie) throws {
        let key = movie.id
        guard let entity = try PersistenceController.shared.get(ofType: MovieEntity.self, forPrimaryKey: key) else {
            throw AppError.generic
        }
        try PersistenceController.shared.delete(entity: entity)
    }
    
    func isFavorite(movie: Movie) throws -> Bool {
        let key = movie.id
        let entity = try PersistenceController.shared.get(ofType: MovieEntity.self, forPrimaryKey: key)
        return entity != nil
    }
}
