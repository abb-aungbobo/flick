//
//  VideosReponse.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import Foundation

struct VideosResponse: Codable {
    let results: [VideoResponse]
}

extension VideosResponse {
    func toVideos() -> Videos {
        return Videos(results: results.toVideos())
    }
}
