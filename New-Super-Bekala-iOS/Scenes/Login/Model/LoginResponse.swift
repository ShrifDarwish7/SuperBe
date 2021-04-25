//
//  LoginResponse.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 09/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let status: Int
    let data: LoginResult
    let message: String
}

struct LoginResult: Codable {
    let token: String
    let user: User
}

struct User: Codable {
    let id: Int
    let name, email: String
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
