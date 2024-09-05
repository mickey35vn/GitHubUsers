//
//  DetailUserViewModel.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 29/08/2024.
//

import Foundation
import SwiftUI
import Combine
import Factory
import Stinsen

class DetailUserViewModel: ObservableObject {

    let activityIndicator = ActivityIndicator()
    let errorTracker = ErrorTracker()
    
    @LazyInjected(\.githubUseCase) var useCase
    private var injectedUseCase: GithubUserUseCaseType?
    
    @Published var login = ""
    @Published var user = GithubUserModel()
    
    @RouterObject var router: ListUserCoordinator.Router?
    
    init() {
        $login
            .filter({!$0.isEmpty})
            .removeDuplicates()
            .debounce(for: .seconds(1.0), scheduler: DispatchQueue.main)
            .flatMap { [self] login in
                return (injectedUseCase ?? useCase).detailUser(login: login)
                    .receive(on: DispatchQueue.main)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
            }
            .assign(to: &$user)
    }
    
    /// Injects a GithubUseCaseType for testing purposes.
    /// - Parameter useCase: The useCase object to be injected into the ViewModel.
    /// - Note: This method should only be used in unit tests.
    func inject(useCase: GithubUserUseCaseType) {
        self.injectedUseCase = useCase
    }
    
    /// Navigates back to the previous view.
    func back() {
        router?.pop()
    }
}
