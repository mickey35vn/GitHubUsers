//
//  AppDelegate+Injected.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 29/08/2024.
//

import SwiftUI
import Foundation
import Factory

extension Container {
    
    var githubUseCase: Factory<GithubUserUseCaseType> {
        self {
            GithubUserUseCase(repository: GithubRepoRepository(apiService: APIService.shared))
        }
    }
}
