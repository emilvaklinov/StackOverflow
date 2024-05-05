//
//  User.swift
//  StackOverflow
//
//  Created by Emil Vaklinov on 03/05/2024.
//

import Foundation

struct UsersResponse: Codable {
    let items: [User]
}

struct User: Codable {
    let badgeCounts: BadgeCounts
    let accountId: Int
    let isEmployee: Bool
    let lastModifiedDate: Int
    let lastAccessDate: Int
    let reputationChangeYear: Int
    let reputationChangeQuarter: Int
    let reputationChangeMonth: Int
    let reputationChangeWeek: Int
    let reputationChangeDay: Int
    let reputation: Int
    let creationDate: Int
    let userType: String
    let userId: Int
    let acceptRate: Int?
    let location: String?
    let websiteUrl: String?
    let link: String
    let profileImage: String
    let displayName: String
    var isFollowed: Bool = false

    enum CodingKeys: String, CodingKey {
        case badgeCounts = "badge_counts"
        case accountId = "account_id"
        case isEmployee = "is_employee"
        case lastModifiedDate = "last_modified_date"
        case lastAccessDate = "last_access_date"
        case reputationChangeYear = "reputation_change_year"
        case reputationChangeQuarter = "reputation_change_quarter"
        case reputationChangeMonth = "reputation_change_month"
        case reputationChangeWeek = "reputation_change_week"
        case reputationChangeDay = "reputation_change_day"
        case reputation
        case creationDate = "creation_date"
        case userType = "user_type"
        case userId = "user_id"
        case acceptRate = "accept_rate"
        case location
        case websiteUrl = "website_url"
        case link
        case profileImage = "profile_image"
        case displayName = "display_name"
    }
}

struct BadgeCounts: Codable {
    let bronze: Int
    let silver: Int
    let gold: Int
}
