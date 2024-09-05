//
//  GithubUserUseCase.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 29/08/2024.
//

import Foundation
import Factory
import Combine

protocol GithubUserUseCaseType {
    
    /// Fetches a list of GitHub users starting from a specified index.
    /// - Parameter since: The index to start fetching users from.
    /// - Returns: A publisher that emits an array of `GithubUserModel` or an error.
    func listUser(since: Int) -> AnyPublisher<[GithubUserModel], Error>
    
    /// Fetches detailed information for a specific GitHub user.
    /// - Parameter login: The login name of the user whose details are to be fetched.
    /// - Returns: A publisher that emits a `GithubUserModel` or an error.
    func detailUser(login: String) -> AnyPublisher<GithubUserModel, Error>
}

class GithubUserUseCase: GithubUserUseCaseType {
    
    var repository: GithubRepositoryType
    
    init(repository: GithubRepositoryType) {
        self.repository = repository
    }
    
    func listUser(since: Int) -> AnyPublisher<[GithubUserModel], Error>  {
        repository.listUser(since: since)
    }
    
    func detailUser(login: String) -> AnyPublisher<GithubUserModel, Error> {
        repository.detailUser(login: login)
    }
}
