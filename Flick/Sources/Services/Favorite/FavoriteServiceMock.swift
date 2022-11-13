//
//  FavoriteServiceMock.swift
//  Flick
//
//  Created by Aung Bo Bo on 08/11/2022.
//

import Foundation

class FavoriteServiceMock: FavoriteService {
    private var favorites: [Movie] = []
    
    init() {
        let response: MoviesResponse = try! JSON.decode(from: "movies")
        let movies = response.toMovies()
        favorites = movies.results
    }
    
    func getFavorites() throws -> [Movie] {
        return favorites
    }
    
    func favorite(movie: Movie) throws {
        favorites.append(movie)
    }
    
    func unfavorite(movie: Movie) throws {
        let key = movie.id
        guard let entity = favorites.first(where: { $0.id == key }), let index = favorites.firstIndex(of: entity) else {
            throw AppError.generic
        }
        favorites.remove(at: index)
    }
    
    func isFavorite(movie: Movie) throws -> Bool {
        let key = movie.id
        let entity = favorites.first(where: { $0.id == key })
        return entity != nil
    }
}
