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
    let coordinates, postalCode: String?
    let cityID: Int?
    let regionLanguage: [Language]?
    let subregions: [Subregion]?
    let city: City?
    
    var expanded: Bool?

    enum CodingKeys: String, CodingKey {
        case id, coordinates
        case postalCode = "postal_code"
        case cityID = "city_id"
        case regionLanguage = "region_language"
        case subregions, city
    }
}

//// MARK: - City
//struct City: Codable {
//    let id, countryID: Int
//    let phoneCode: String
//    let cityLanguage: [Language]
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case countryID = "country_id"
//        case phoneCode = "phone_code"
//        case cityLanguage = "city_language"
//    }
//}

// MARK: - Language
struct Language: Codable {
    let id: Int
    let name: String
    let language: String?
    let cityID: Int?
    let regionID, subregionID: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, language
        case cityID = "city_id"
        case regionID = "region_id"
        case subregionID = "subregion_id"
    }
}


// MARK: - Subregion
struct Subregion: Codable {
    let id: Int
    let coordinates, postalCode: String?
    let regionID: Int?
    let subregionLanguage: [Language]?

    enum CodingKeys: String, CodingKey {
        case id, coordinates
        case postalCode = "postal_code"
        case regionID = "region_id"
        case subregionLanguage = "subregion_language"
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
