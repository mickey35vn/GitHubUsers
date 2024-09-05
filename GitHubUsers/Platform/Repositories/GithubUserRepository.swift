//
//  GithubUserRepository.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 29/08/2024.
//

import Foundation
import Combine

protocol GithubRepositoryType {
    
    /// Fetches a list of GitHub users starting from a specified index.
    /// - Parameter since: The index to start fetching users from.
    /// - Returns: A publisher that emits an array of `GithubUserModel` or an error.
    func listUser(since: Int) -> AnyPublisher<[GithubUserModel], Error>
    
    /// Fetches detailed information for a specific GitHub user.
    /// - Parameter login: The login name of the user whose details are to be fetched.
    /// - Returns: A publisher that emits a `GithubUserModel` or an error.
    func detailUser(login: String) -> AnyPublisher<GithubUserModel, Error>
}

class GithubRepoRepository: GithubRepositoryType {
    
    private var apiService: APIServiceType
    
    init(apiService: APIServiceType) {
        self.apiService = apiService
    }
    
    func listUser(since: Int) -> AnyPublisher<[GithubUserModel], Error> {
        let param: [String: Any] = [
            "per_page": UserAPI.pageSize,
            "since": since
        ]
        
        return apiService
            .requestArray(nonBaseResponse: UserAPI.listUser(param: param))
            .eraseToAnyPublisher()
    }
    
    func detailUser(login: String) -> AnyPublisher<GithubUserModel, Error> {
        return apiService
            .requestObject(nonBaseResponse: UserAPI.detailUser(login: login))
            .eraseToAnyPublisher()
    }
}
