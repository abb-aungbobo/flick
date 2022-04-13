//
//  Error.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import Foundation

extension Error {
    func toAppError() -> AppError {
        switch self {
        case is URLError: return .networking
        case is EncodingError: return .encoding
        case is DecodingError: return .decoding
        default: return .failure(self)
        }
    }
}
