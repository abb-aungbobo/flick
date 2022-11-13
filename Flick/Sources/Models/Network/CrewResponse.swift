//
//  CrewResponse.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import Foundation

struct CrewResponse: Codable {
    let name: String
    let job: String
}

extension CrewResponse {
    func toMember() -> Member {
        return Member(name: name, characterOrJob: job)
    }
}

extension Array where Element == CrewResponse {
    func toMembers() -> [Member] {
        return map { response in
            return response.toMember()
        }
    }
}
