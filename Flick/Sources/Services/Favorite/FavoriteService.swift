//
//  FavoriteService.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import Foundation

protocol FavoriteService {
    func getFavorites() throws -> [Movie]
    func favorite(movie: Movie) throws
    func unfavorite(movie: Movie) throws
    func isFavorite(movie: Movie) throws -> Bool
}
