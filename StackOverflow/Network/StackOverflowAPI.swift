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
            return "/2.2/users?pagesize=20&order=desc&sort=reputation&site=stackoverflow"
        case .userDetail(let userID):
            return "/2.2/users/\(userID)?site=stackoverflow"
        }
    }
}
