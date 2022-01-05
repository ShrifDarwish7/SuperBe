//
//  FavouritesResponse.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 15/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

// MARK: - FavouritesResponse
struct FavouritesResponse: Codable {
    let status: Int?
    var data: FavouritesData?
    let message: String?
}

// MARK: - DataClass
struct FavouritesData: Codable {
    var favouritableBranches: [FavouritableBranch]?
    var favouritableProducts: [FavouritableProduct]?

    enum CodingKeys: String, CodingKey {
        case favouritableBranches = "favouritable_branches"
        case favouritableProducts = "favouritable_products"
    }
}

// MARK: - FavouritableBranch
struct FavouritableBranch: Codable {
    let id, favouritableID: Int
    let favouritableType: String
    let userID: Int
    var favouritable: Branch?

    enum CodingKeys: String, CodingKey {
        case id
        case favouritableID = "favouritable_id"
        case favouritableType = "favouritable_type"
        case userID = "user_id"
        case favouritable
    }
}

// MARK: - FavouritableProduct
struct FavouritableProduct: Codable {
    let id, favouritableID: Int
    let favouritableType: String
    let userID: Int
    var favouritable: Product?

    enum CodingKeys: String, CodingKey {
        case id
        case favouritableID = "favouritable_id"
        case favouritableType = "favouritable_type"
        case userID = "user_id"
        case favouritable
    }
}
