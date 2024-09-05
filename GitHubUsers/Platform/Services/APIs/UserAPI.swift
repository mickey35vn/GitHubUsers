//
//  ListUserAPIRouter.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 29/08/2024.
//

import Foundation
import UIKit
import Alamofire

enum UserAPI {
    case listUser(param: [String: Any])
    case detailUser(login: String)
}

extension UserAPI: APIInputBase {
    
    static let pageSize = 20
    
    var headers: HTTPHeaders {
        var header = HTTPHeaders()
        //if requireToken {
        //   Get token and assign to header
        //}
        header.add(.accept("application/json"))
        return header
    }
    
    var url: URL {
        let baseURL = URL.init(string: "https://api.github.com/users" + path)!
        return baseURL
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var encoding: ParameterEncoding {
        return method == .get ? URLEncoding.default : JSONEncoding.default
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .listUser(let param):
            return param
        case .detailUser:
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .listUser:
            return ""
        case .detailUser(let login):
            return "/" + login
        }
    }
    
    var requireToken: Bool {
        return false
    }
}
