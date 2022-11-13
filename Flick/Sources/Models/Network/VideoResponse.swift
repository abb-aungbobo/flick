//
//  VideoResponse.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import Foundation

struct VideoResponse: Codable {
    let key: String
    let site: String
}

extension VideoResponse {
    func toVideo() -> Video {
        return Video(key: key, site: site)
    }
}

extension Array where Element == VideoResponse {
    func toVideos() -> [Video] {
        return map { response in
            return response.toVideo()
        }
    }
}
