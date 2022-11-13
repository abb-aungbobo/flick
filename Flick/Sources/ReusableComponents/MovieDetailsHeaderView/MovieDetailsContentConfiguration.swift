//
//  MovieDetailsContentConfiguration.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import Foundation

struct MovieDetailsContentConfiguration {
    let genres: String
    let id: Int
    let overview: String?
    let title: String
    let voteAverage: String
    let hideTitleHeader: Bool
    
    var hideGenres: Bool {
        genres.isEmpty
    }
}
