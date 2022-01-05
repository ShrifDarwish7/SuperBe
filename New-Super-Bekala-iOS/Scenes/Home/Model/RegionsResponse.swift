//
//  RegionsResponse.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 11/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

struct RegionsResponse: Codable {
    let status: Int
    let data: [Region]
    let message: String
}

// MARK: - Datum
struct Region: Codable {
    let id: Int
    let postalCode: String?
    let coordinates: [String]?
    let name: Localized?
    let cityID: Int?
    let subregions: [Subregion]?
    let city: City?
    
    var expanded: Bool?

    enum CodingKeys: String, CodingKey {
        case id, coordinates, name
        case postalCode = "postal_code"
        case cityID = "city_id"
        case subregions, city
    }
}

// MARK: - Subregion
struct Subregion: Codable {
    let id: Int
    let name: Localized?
    let postalCode: String?
    let coordinates: [String]?
    let regionID: Int?

    enum CodingKeys: String, CodingKey {
        case id, coordinates, name
        case postalCode = "postal_code"
        case regionID = "region_id"
    }
}

struct SelectedArea: Codable {
    var regionsID: Int?
    var regionsNameEn: String?
    var regionNameAr: String?
    var subregionID: Int?
    var subregionEn: String?
    var subregionAr: String?
}
