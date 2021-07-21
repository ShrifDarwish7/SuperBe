//
//  PointsResponse.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 22/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

// MARK: - PointsResponse
struct PointsResponse: Codable {
    let status: Int?
    let data: PointsData?
    let message: String?
}

struct PointsData: Codable {
    let total: Int?
    let transactions: [PointTransaction]?
}

// MARK: - Transaction
struct PointTransaction: Codable {
    let id, value, orderID, userID: Int?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, value
        case orderID = "order_id"
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
