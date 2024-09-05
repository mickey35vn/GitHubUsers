//
//  GithubErrorModel.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 04/09/2024.
//

import Foundation
import ObjectMapper

struct GithubErrorModel: Model {
    
    var id: UUID
    var message: String?
    var documentation: String?
    
    init?(map: Map) {
        self.id = UUID()
    }
    
    mutating func mapping(map: Map) {
        message <- map["message"]
        documentation <- map["documentation_url"]
    }
}
