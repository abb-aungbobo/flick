//
//  CastResponse.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import Foundation

struct CastResponse: Codable {
    let name: String
    let character: String
}

extension CastResponse {
    func toMember() -> Member {
        return Member(name: name, characterOrJob: character)
    }
}

extension Array where Element == CastResponse {
    func toMembers() -> [Member] {
        return map { response in
            return response.toMember()
        }
    }
}
