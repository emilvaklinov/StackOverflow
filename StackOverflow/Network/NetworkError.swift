//
//  NetworkError.swift
//  StackOverflow
//
//  Created by Emil Vaklinov on 03/05/2024.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case decodingError
    case serverError(statusCode: Int)
    case unknownError
}
