//
//  Member.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import Foundation

struct Member: Hashable {
    let name: String
    let characterOrJob: String
}

extension Member {
    func toMemberContentConfiguration() -> MemberContentConfiguration {
        return MemberContentConfiguration(name: name, characterOrJob: characterOrJob)
    }
}
