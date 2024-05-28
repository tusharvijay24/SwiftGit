//
//  APIErrorModel.swift
//  SwiftyGit
//
//  Created by Tushar on 29/05/24.
//

import Foundation
import Foundation

struct ErrorResponseModel: Codable {
    let message: String
    let documentation_url: String?
}

struct APIError: Error {
    let errorResponse: ErrorResponseModel?
    let statusCode: Int?
    
    var localizedDescription: String {
        if let errorResponse = errorResponse {
            return errorResponse.message
        } else if let statusCode = statusCode {
            return "An error occurred with status code \(statusCode)."
        } else {
            return "An unknown error occurred."
        }
    }
}
