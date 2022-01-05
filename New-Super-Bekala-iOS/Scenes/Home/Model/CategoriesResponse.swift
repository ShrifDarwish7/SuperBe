//
//  CategoriesResponse.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 16/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

// MARK: - CategoriesResponse
struct CategoriesResponse: Codable {
    let status: Int?
    let data: [Category]?
    let message: String?
}

// MARK: - Datum
struct Category: Codable {
    let id: Int?
    let logo: Localized?
    let regionsCount: Int?
    let name, description: Localized?
    
    var selected: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, description, logo
        case regionsCount = "regions_count"
    }
}
