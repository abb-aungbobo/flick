//
//  GenreResponse.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import Foundation

struct GenreResponse: Codable {
    let name: String
}

extension GenreResponse {
    func toGenre() -> Genre {
        return Genre(name: name)
    }
}

extension Array where Element == GenreResponse {
    func toGenres() -> [Genre] {
        return map { response in
            return response.toGenre()
        }
    }
}
