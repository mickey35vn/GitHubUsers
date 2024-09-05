//
//  MockAPIService.swift
//  GitHubUsersTests
//
//  Created by Tram Nguyen on 04/09/2024.
//

import Combine
import XCTest
import ObjectMapper
@testable import GitHubUsers

final class MockAPIService: APIServiceType {
    var shouldReturnError: Bool = false
    
    var expectedError: NSError {
        return NSError(domain: "TestError", code: 1, userInfo: nil)
    }
    
    func requestArray<T: Mappable>(nonBaseResponse input: APIInputBase) -> Future<[T], Error> {
        print("MockAPIService Request Array")
        return Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                if self.shouldReturnError {
                    promise(.failure(APIError.invalidResponseData(data: self.expectedError)))
                } else {
                    let jsonResponse: [[String: Any]] = [
                        ["id": 1, "login": "user1"],
                        ["id": 2, "login": "user2"]
                    ]
                    let result = jsonResponse.compactMap { T(JSON: $0) }
                    promise(.success(result))
                }
            }
        }
    }
    
    func requestObject<T: Mappable>(nonBaseResponse input: APIInputBase) -> Future<T, Error> {
        print("MockAPIService Request Object")
        return Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                if self.shouldReturnError {
                    promise(.failure(self.expectedError))
                } else {
                    let jsonResponse: [String: Any] = ["id": 1, "login": "user1"]
                    if let object = T(JSON: jsonResponse) {
                        promise(.success(object))
                    } else {
                        promise(.failure(APIError.invalidResponseData(data: jsonResponse)))
                    }
                }
            }
        }
    }
}
