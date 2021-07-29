//
//  RatesResponse.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 25/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

// MARK: - Rating
struct Rating: Codable {
    let id: Int?
    let rate, comment: String?
    let ratableID: Int?
    let ratableType: String?
    let userID: Int?
    var createdAt, updatedAt: String?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case id, rate, comment
        case ratableID = "ratable_id"
        case ratableType = "ratable_type"
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case user
    }
}

