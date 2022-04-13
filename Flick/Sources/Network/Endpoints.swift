//
//  Endpoints.swift
//  Flick
//
//  Created by Aung Bo Bo on 10/04/2022.
//

import Foundation

enum Endpoints {
    static func getPosterImage(size: String = "/w500", posterPath: String) -> Endpoint {
        let path = "/t/p" + size + posterPath
        return .imageTMDB(path: path)
    }
    
    static func getNowPlaying() -> Endpoint {
        return .apiTMDB(path: "/movie/now_playing")
    }
    
    static func getPopular() -> Endpoint {
        return .apiTMDB(path: "/movie/popular")
    }
    
    static func getTopRated() -> Endpoint {
        return .apiTMDB(path: "/movie/top_rated")
    }
    
    static func getUpcoming() -> Endpoint {
        return .apiTMDB(path: "/movie/upcoming")
    }
    
    static func getVideos(id: Int) -> Endpoint {
        let path = "/movie/\(id)/videos"
        return .apiTMDB(path: path)
    }
    
    static func getYouTubeVideo(key: String) -> Endpoint {
        let path = "/embed/\(key)" 
        return .youtube(path: path)
    }
    
    static func getMovieDetails(id: Int) -> Endpoint {
        let path = "/movie/\(id)"
        return .apiTMDB(path: path)
    }
    
    static func getCredits(id: Int) -> Endpoint {
        let path = "/movie/\(id)/credits"
        return .apiTMDB(path: path)
    }
    
    static func getSimilarMovies(id: Int) -> Endpoint {
        let path = "/movie/\(id)/similar"
        return .apiTMDB(path: path)
    }
    
    static func searchMovies(query: String) -> Endpoint {
        let path = "/search/movie"
        let query = URLQueryItem(name: "query", value: query)
        return .apiTMDB(path: path, queryItems: [query])
    }
}
