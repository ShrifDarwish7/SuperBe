//
//  BranchCatsResponse.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 31/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

// MARK: - BranchCatsResponse
struct BranchCatsResponse: Codable {
    let status: Int?
    let data: [BranchCategory]?
    let message: String?
}

// MARK: - Datum
struct BranchCategory: Codable {
    let id: Int
    let branchID: Int
    let name, logo, description: Localized?
 //   let branchCategoryLanguage: [BranchCategoryLanguage]
    
    var selected: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case branchID = "branch_id"
        case name, logo, description
       // case branchCategoryLanguage = "branch_category_language"
    }
}

// MARK: - BranchCategoryLanguage
struct BranchCategoryLanguage: Codable {
    let id: Int
    let name, logo, language: String?
    let branchCategoryID: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case logo, language
        case branchCategoryID = "branch_category_id"
    }
}
