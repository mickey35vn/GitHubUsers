//
//  APIInputBase.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 29/08/2024.
//

import Foundation
import Alamofire

protocol APIInputBase {
    var headers: HTTPHeaders { get }
    var url: URL { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var parameters: [String: Any]? { get }
    var requireToken: Bool { get }
}
