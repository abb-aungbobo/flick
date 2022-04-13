//
//  SearchService.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import Foundation

protocol SearchService {
    func searchMovies(query: String) async throws -> Movies
}
