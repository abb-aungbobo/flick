//
//  SearchServiceImpl.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import Foundation

class SearchServiceImpl: SearchService {
    func searchMovies(query: String) async throws -> Movies {
        let endpoint = Endpoints.searchMovies(query: query)
        let response: MoviesResponse = try await NetworkController.shared.get(endpoint: endpoint)
        return response.toMovies()
    }
}
