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
    let status: Int
    let data: [BranchCategory]
    let message: String
}

// MARK: - Datum
struct BranchCategory: Codable {
    let id: Int
    let logo: String
    let branchID: Int
    let branchCategoryLanguage: [BranchCategoryLanguage]
    
    var selected: Bool?

    enum CodingKeys: String, CodingKey {
        case id, logo
        case branchID = "branch_id"
        case branchCategoryLanguage = "branch_category_language"
    }
}

// MARK: - BranchCategoryLanguage
struct BranchCategoryLanguage: Codable {
    let id: Int
    let name, branchCategoryLanguageDescription, logo, language: String?
    let branchCategoryID: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case branchCategoryLanguageDescription = "description"
        case logo, language
        case branchCategoryID = "branch_category_id"
    }
}
