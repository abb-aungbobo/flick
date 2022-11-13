//
//  Video.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import Foundation

struct Video {
    let key: String
    let site: String
    
    var isYouTubeVideo: Bool {
        site == "YouTube"
    }
    var isNotYouTubeVideo: Bool {
        !isYouTubeVideo
    }
    var url: URL {
        Endpoints.getYouTubeVideo(key: key).url
    }
}
