//
//  ListUserViewModelTests.swift
//  GitHubUsersTests
//
//  Created by Tram Nguyen on 04/09/2024.
//

import Combine
import XCTest
@testable import GitHubUsers

final class ListUserViewModelTests: XCTestCase {

    private var viewModel: ListUserViewModel!
    private var useCase: GithubUserUseCase!
    private var mockAPIService: MockAPIService!
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        viewModel = ListUserViewModel()
        mockAPIService = MockAPIService()
        useCase =  GithubUserUseCase(repository: GithubRepoRepository(apiService: mockAPIService))
        cancellables = []
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockAPIService = nil
        useCase = nil
        cancellables = nil
    }
    
    func testFetchNextPageSuccess() {
        // Arrange
        mockAPIService.shouldReturnError = false
        viewModel.inject(useCase: useCase)

        // Act
        viewModel.fetchNextPageIfPossible()

        // Set up an expectation
        let expectation = self.expectation(description: "Users should be fetched")
        var expectationFulfilled = false
        
        // Assert
        viewModel.$state
            .map { $0.users }
            .dropFirst()
            .sink { users in
                guard !expectationFulfilled else { return }
                XCTAssertEqual(users.count, 2)
                XCTAssertEqual(users[0].login, "user1")
                XCTAssertEqual(users[1].login, "user2")
                expectation.fulfill()
                expectationFulfilled = true
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 3)
    }

    func testFetchNextPageFailure() {
        // Arrange
        mockAPIService.shouldReturnError = true
        viewModel.inject(useCase: useCase)

        // Act
        viewModel.fetchNextPageIfPossible()

        // Set up an expectation
        let expectation = self.expectation(description: "Error should be handled")
        
        // Assert
        viewModel.$state
            .dropFirst()
            .sink { state in
                XCTAssertFalse(state.canLoadNextPage)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 3)
    }
}
