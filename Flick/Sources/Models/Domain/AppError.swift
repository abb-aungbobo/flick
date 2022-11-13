//
//  AppError.swift
//  Flick
//
//  Created by Aung Bo Bo on 10/04/2022.
//

import Foundation

enum AppError: LocalizedError {
    case generic
    case networking
    case encoding
    case decoding
    case failure(Error)
    
    var errorDescription: String? {
        switch self {
        case .generic: return "Something went wrong"
        case .networking: return "Request to server failed"
        case .encoding: return "Failed parsing request to server"
        case .decoding: return "Failed parsing response from server"
        case let .failure(error): return error.localizedDescription
        }
    }
}
