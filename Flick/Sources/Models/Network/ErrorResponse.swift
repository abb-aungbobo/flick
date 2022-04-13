//
//  ErrorResponse.swift
//  Flick
//
//  Created by Aung Bo Bo on 10/04/2022.
//

import Foundation

struct ErrorResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? { statusMessage }
}
