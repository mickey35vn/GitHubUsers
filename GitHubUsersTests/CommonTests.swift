//
//  CommonTests.swift
//  GitHubUsersTests
//
//  Created by Tram Nguyen on 04/09/2024.
//

import XCTest
@testable import GitHubUsers

final class CommonTests: XCTestCase {

    func testFormatNumberBelowTen() {
        XCTAssertEqual(Common.formatNumber(5), "5")
    }

    func testFormatNumberBetweenTenAndHundred() {
        XCTAssertEqual(Common.formatNumber(15), "10+")
        XCTAssertEqual(Common.formatNumber(99), "90+")
    }

    func testFormatNumberAboveHundred() {
        XCTAssertEqual(Common.formatNumber(105), "100+")
        XCTAssertEqual(Common.formatNumber(250), "200+")
    }
}
