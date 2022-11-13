//
//  SearchServiceMock.swift
//  Flick
//
//  Created by Aung Bo Bo on 08/11/2022.
//

import Foundation

class SearchServiceMock: SearchService {
    func searchMovies(query: String) async throws -> Movies {
        let response: MoviesResponse = try JSON.decode(from: "search")
        return response.toMovies()
    }
}
