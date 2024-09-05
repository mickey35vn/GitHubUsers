//
//  APIError.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 29/08/2024.
//

import Foundation

enum APIError: Error {
    case error(code: Int, message: String)
    case invalidResponseData(data: Any)
    case unknown
    
    public var displayText: String {
        switch self {
        case .invalidResponseData(let data):
            if let json = data as? [String: Any] {
                return GithubErrorModel(JSON: json)?.message ?? "Invalid response"
            }
            return "Invalid response"
        case .error(_, let message):
            //switch errorResponseCode
            return message
        case .unknown:
            return "Unknown error"
        }
    }
    
    public var code: Int {
        switch self {
        case .error(let code, _):
            return code
        default :
            return 0
        }
    }
}
