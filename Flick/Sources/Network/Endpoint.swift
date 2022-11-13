//
//  Endpoint.swift
//  Flick
//
//  Created by Aung Bo Bo on 10/04/2022.
//

import Foundation

struct Endpoint {
    let scheme: String
    let host: String
    let path: String
    let queryItems: [URLQueryItem]?
    let httpMethod: HTTPMethod
    
    var url: URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        return url
    }
    
    init(scheme: String = "https", host: String, path: String, queryItems: [URLQueryItem]? = nil, httpMethod: HTTPMethod) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.queryItems = queryItems
        self.httpMethod = httpMethod
    }
}

extension Endpoint {
    static func apiTMDB(path: String, queryItems: [URLQueryItem] = [], httpMethod: HTTPMethod = .get) -> Endpoint {
        let host = "api.themoviedb.org"
        let version = "/3"
        let path = version + path
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: Constants.apiKey)
        var urlQueryItems = [apiKeyQueryItem]
        urlQueryItems += queryItems
        return Endpoint(host: host, path: path, queryItems: urlQueryItems, httpMethod: httpMethod)
    }
    
    static func imageTMDB(path: String, httpMethod: HTTPMethod = .get) -> Endpoint {
        let host = "image.tmdb.org"
        return Endpoint(host: host, path: path, httpMethod: httpMethod)
    }
    
    static func youtube(path: String) -> Endpoint {
        let host = "www.youtube.com"
        let playsinlineQueryItem = URLQueryItem(name: "playsinline", value: "1")
        let urlQueryItems = [playsinlineQueryItem]
        return Endpoint(host: host, path: path, queryItems: urlQueryItems, httpMethod: .get)
    }
}
