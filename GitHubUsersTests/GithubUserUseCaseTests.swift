//
//  GithubRepoRepositoryTests.swift
//  GitHubUsersTests
//
//  Created by Tram Nguyen on 04/09/2024.
//

import Combine
import XCTest
@testable import GitHubUsers

final class GithubUserUseCaseTests: XCTestCase {
    
    private var mockAPIService: MockAPIService!
    private var useCase: GithubUserUseCase!
    
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        cancellables = []
        mockAPIService = MockAPIService()
        useCase =  GithubUserUseCase(repository: GithubRepoRepository(apiService: mockAPIService))
    }

    override func tearDownWithError() throws {
        mockAPIService = nil
        useCase = nil
        cancellables = nil
    }

    func testListUserSuccess() {
        // Arrange
        mockAPIService.shouldReturnError = false
        
        // Set up an expectation
        let expectation = self.expectation(description: "Fetch users")

        // Act & Assert
        useCase.listUser(since: 1)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(_) = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { users in
                XCTAssertEqual(users.count, 2)
                XCTAssertEqual(users[0].login, "user1")
                XCTAssertEqual(users[1].login, "user2")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 3)
    }

    func testListUserFailure() {
        // Arrange
        mockAPIService.shouldReturnError = true
        
        // Set up an expectation
        let expectation = self.expectation(description: "Fetch users failure")

        // Act & Assert
        useCase.listUser(since: 1)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case .failure(_) = completion {
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure but got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected no value but got some")
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 3)
    }

    func testDetailUserSuccess() {
        // Arrange
        mockAPIService.shouldReturnError = false
        
        // Set up an expectation
        let expectation = self.expectation(description: "Fetch user details")

        // Act & Assert
        useCase.detailUser(login: "user1")
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case .failure(_) = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { user in
                XCTAssertEqual(user.login, "user1")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 3)
    }

    func testDetailUserFailure() {
        // Arrange
        mockAPIService.shouldReturnError = true
        
        // Set up an expectation
        let expectation = self.expectation(description: "Fetch user details failure")

        // Act & Assert
        useCase.detailUser(login: "user1")
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case .failure(_) = completion {
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure but got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected no value but got some")
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 3)
    }
}
