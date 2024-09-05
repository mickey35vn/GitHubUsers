//
//  ListUserViewModel.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 29/08/2024.
//

import Foundation
import SwiftUI
import Combine
import Factory
import Stinsen

class ListUserViewModel: ObservableObject {
    
    @RouterObject var router: ListUserCoordinator.Router?

    @LazyInjected(\.githubUseCase) var useCase
    private var injectedUseCase: GithubUserUseCaseType?
    
    @Published private(set) var state = State()
    private var subscriptions = Set<AnyCancellable>()
    
    var canLoadNextPage: Bool {
        return state.canLoadNextPage
    }
    
    /// Checks if the given user is the last user in the current list.
    /// - Parameter user: The user to check.
    /// - Returns: A Boolean indicating if the user is the last in the list.
    func isLast(user: GithubUserModel) -> Bool {
        return state.users.last == user
    }
    
    /// Fetches the next page of users if possible.
    func fetchNextPageIfPossible() {
        guard state.canLoadNextPage else { return }
        
        (injectedUseCase ?? useCase).listUser(since: state.since)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: onReceiveCompletion, receiveValue: onReceiveValue)
                    .store(in: &subscriptions)
    }
    
    /// Handles the completion of the user fetch request.
    /// - Parameter completion: The completion event from the publisher.
    private func onReceiveCompletion(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            Common.showError(error)
            state.canLoadNextPage = false
        }
    }

    /// Handles the received batch of users.
    /// - Parameter batch: The array of fetched GitHub users.
    private func onReceiveValue(_ batch: [GithubUserModel]) {
        guard let lastId = batch.last?.id else { return }
        
        state.users += batch
        state.since = lastId
        state.canLoadNextPage = batch.count == UserAPI.pageSize
    }
    
    /// Navigates to the detail view for the specified user.
    /// - Parameter user: The user to view details for.
    func pushToDetail(user: GithubUserModel) {
        router?.route(to: \.pushToDetail, user)
    }
    
    /// Injects a GithubUseCaseType for testing purposes.
    /// - Parameter useCase: The useCase object to be injected into the ViewModel.
    /// - Note: This method should only be used in unit tests.
    func inject(useCase: GithubUserUseCaseType) {
        self.injectedUseCase = useCase
    }
    
    struct State {
        var users = [GithubUserModel]()
        var since: Int = 0
        var canLoadNextPage = true
    }
}
