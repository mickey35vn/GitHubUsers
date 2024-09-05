//
//  GithubUserModel.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 29/08/2024.
//

import ObjectMapper

typealias Model = Mappable & Identifiable & Equatable

struct GithubUserModel: Model {
    
    var id: Int?
    var login: String?
    var avatar: String?
    var landingPage: String?
    var blog: String?
    var location: String?
    var followers: Int?
    var following: Int?
    
    init() {
    
    }
    
    init(id: Int?, login: String?) {
        self.id = id
        self.login = login
    }
    
    init(login: String?, avatar: String?, landingPage: String?, location: String?) {
        self.login = login
        self.avatar = avatar
        self.landingPage = landingPage
        self.location = location
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        login <- map["login"]
        avatar <- map["avatar_url"]
        landingPage <- map["html_url"]
        blog <- map["blog"]
        location <- map["location"]
        followers <- map["followers"]
        following <- map["following"]
    }
}
