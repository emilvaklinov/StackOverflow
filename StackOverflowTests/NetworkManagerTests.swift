//
//  NetworkManagerTests.swift
//  StackOverflowTests
//
//  Created by Emil Vaklinov on 05/05/2024.
//

import XCTest
@testable import StackOverflow

class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager!
    var mockSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        networkManager = NetworkManager(session: mockSession)
    }
    
    func testFetchDataSuccess() {
        let expectedData = "{}".data(using: .utf8)
        mockSession.nextData = expectedData
        mockSession.nextResponse = HTTPURLResponse(url: URL(string: "https://api.example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let expectation = self.expectation(description: "FetchDataSuccess")
        networkManager.fetchData(from: StackOverflowAPI.users) { result in
            if case .success(let data) = result {
                XCTAssertEqual(data, expectedData)
            } else {
                XCTFail("Expected successful response")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
}
