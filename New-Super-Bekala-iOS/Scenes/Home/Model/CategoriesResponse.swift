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
    let regionsCount: Int?
   // let categoryLanguage: [CategoryLanguage]?
    let name, description, logo: Localized?
    
    var selected: Bool?

    enum CodingKeys: String, CodingKey {
        case id, logo, name, description
        case regionsCount = "regions_count"
       // case categoryLanguage = "category_language"
    }
}

//// MARK: - CategoryLanguage
//struct CategoryLanguage: Codable {
//    let id: Int?
//    let name, categoryLanguageDescription, language: String?
//    let categoryID: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case categoryLanguageDescription = "description"
//        case language
//        case categoryID = "category_id"
//    }
//}
