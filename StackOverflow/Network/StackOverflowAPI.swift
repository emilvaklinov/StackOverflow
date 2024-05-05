//
//  StackOverflowAPI.swift
//  StackOverflow
//
//  Created by Emil Vaklinov on 03/05/2024.
//

import Foundation

enum StackOverflowAPI: Endpoint {
    case users
    case userDetail(userID: Int)

    var baseURL: String {
        return "https://api.stackexchange.com"
    }

    var path: String {
        switch self {
        case .users:
            return "/2.2/users"
        case .userDetail(let userID):
            return "/2.2/users/\(userID)"
        }
    }

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.stackexchange.com"
        components.path = path

        switch self {
        case .users:
            components.queryItems = [
                URLQueryItem(name: "pagesize", value: "20"),
                URLQueryItem(name: "order", value: "desc"),
                URLQueryItem(name: "sort", value: "reputation"),
                URLQueryItem(name: "site", value: "stackoverflow")
            ]
        case .userDetail:
            components.queryItems = [
                URLQueryItem(name: "site", value: "stackoverflow")
            ]
        }

        return components.url
    }
}
