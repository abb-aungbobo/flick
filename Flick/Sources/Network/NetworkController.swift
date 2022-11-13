//
//  NetworkController.swift
//  Flick
//
//  Created by Aung Bo Bo on 10/04/2022.
//

import Foundation

class NetworkController {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    static let shared = NetworkController()
    
    private init() {}
    
    private func request<T: Codable>(for request: URLRequest) async throws -> T {
        let (data, response)  = try await URLSession.shared.data(for: request)
        if let response = response as? HTTPURLResponse, response.statusCode == 401 || response.statusCode == 404 {
            let response = try decoder.decode(ErrorResponse.self, from: data)
            let error = response.toAppError()
            throw error
        } else {
            let response = try decoder.decode(T.self, from: data)
            return response
        }
    }
    
    func get<ResponseType: Codable>(endpoint: Endpoint) async throws -> ResponseType {
        var urlRequest = URLRequest(url: endpoint.url)
        urlRequest.httpMethod = endpoint.httpMethod.rawValue
        return try await request(for: urlRequest)
    }
}
