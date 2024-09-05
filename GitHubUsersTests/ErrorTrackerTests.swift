//
//  ErrorTrackerTests.swift
//  GitHubUsersTests
//
//  Created by Tram Nguyen on 04/09/2024.
//

import Combine
import XCTest
@testable import GitHubUsers

final class ErrorTrackerTests: XCTestCase {

    var errorTracker: ErrorTracker!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        errorTracker = ErrorTracker()
        cancellables = []
    }

    override func tearDownWithError() throws {
        errorTracker = nil
        cancellables = nil
    }

    func testErrorTracking() {
        // Arrange
        let expectedError = NSError(domain: "TestError", code: 1, userInfo: nil)
        let expectation = self.expectation(description: "Error should be tracked")

        // Act
        errorTracker.errorPublisher
            .sink(receiveValue: { error in
                // Assert
                XCTAssertEqual((error as NSError).domain, expectedError.domain)
                XCTAssertEqual((error as NSError).code, expectedError.code)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        errorTracker.track(expectedError)

        waitForExpectations(timeout: 3)
    }
}
