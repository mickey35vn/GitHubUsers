//
//  DetailUserViewModelTests.swift
//  GitHubUsersTests
//
//  Created by Tram Nguyen on 04/09/2024.
//

import Combine
import XCTest
@testable import GitHubUsers

final class DetailUserViewModelTests: XCTestCase {

    private var viewModel: DetailUserViewModel!
    private var useCase: GithubUserUseCase!
    private var mockAPIService: MockAPIService!
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        viewModel = DetailUserViewModel()
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

    func testUpdateUserSuccess() {
        // Arrange
        mockAPIService.shouldReturnError = false
        viewModel.inject(useCase: useCase)
        
        // Act
        viewModel.login = "user1"

        // Set up an expectation
        let expectation = self.expectation(description: "User should be updated")
        
        // Assert
        viewModel.$user
            .dropFirst()
            .sink { user in
                XCTAssertEqual(user.login, "user1")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 3)
    }
    
    func testUpdateUserFailure() {
        // Arrange
        mockAPIService.shouldReturnError = true
        viewModel.inject(useCase: useCase)
        
        // Act
        viewModel.login = "invalid_user"
        
        // Set up an expectation
        let expectation = self.expectation(description: "Error tracker should catch an error")
        
        // Assert
        viewModel.errorTracker.errorPublisher
            .sink(receiveValue: { [self] error in
                XCTAssertEqual((error as NSError).domain, mockAPIService.expectedError.domain)
                XCTAssertEqual((error as NSError).code, mockAPIService.expectedError.code)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 3)
    }
}
