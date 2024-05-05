//
//  MockURLSessionDataTask.swift
//  StackOverflowTests
//
//  Created by Emil Vaklinov on 05/05/2024.
//

import Foundation
@testable import StackOverflow

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func resume() {
        // Mock implementation does nothing
    }
}

class MockURLSession: URLSessionProtocol {
    var nextDataTask: MockURLSessionDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextResponse: URLResponse?
    var nextError: Error?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        completionHandler(nextData, nextResponse, nextError)
        return nextDataTask
    }
}
