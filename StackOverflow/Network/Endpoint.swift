//
//  Endpoint.swift
//  StackOverflow
//
//  Created by Emil Vaklinov on 03/05/2024.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var url: URL? { get }
}

extension Endpoint {
    var url: URL? {
        return URL(string: baseURL)?.appendingPathComponent(path)
    }
}
