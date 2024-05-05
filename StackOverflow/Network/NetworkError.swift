//
//  NetworkError.swift
//  StackOverflow
//
//  Created by Emil Vaklinov on 03/05/2024.
//

import Foundation

enum NetworkError: Error {
    case noInternetConnection
    case noData
    case urlError
    case decodingError
    case serverError(statusCode: Int)
    case invalidHTTPResponse
    case HTTPError
    case unknownError
}
