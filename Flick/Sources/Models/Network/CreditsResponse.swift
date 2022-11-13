//
//  CreditsResponse.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import Foundation

struct CreditsResponse: Codable {
    let cast: [CastResponse]
    let crew: [CrewResponse]
}

extension CreditsResponse {
    func toCredits() -> Credits {
        return Credits(cast: cast.toMembers(), crew: crew.toMembers())
    }
}
