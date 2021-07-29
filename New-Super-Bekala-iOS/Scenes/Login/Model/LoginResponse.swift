//
//  LoginResponse.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 09/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

// MARK: - PointsResponse
struct LoginResponse: Codable {
    let status: Int?
    let data: User?
    let meta: [String]?
    let message: String?
}

// MARK: - DataClass
struct User: Codable {
    let id: Int?
    let name, email: String?
    let phone: String?
    let token: String?
    let birthdate: String?
    let avatar: String?
    let uid: String?
    let gender: String?
    let isBlocked: Int?
    
    enum CodingKeys: String, CodingKey{
        case id, name, email, phone, token, birthdate, avatar, uid, gender
        case isBlocked = "is_blocked"
    }
    //let orders, wallet, points, addresses: [String]?
}
